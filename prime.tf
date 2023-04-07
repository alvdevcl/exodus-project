locals {
  user_data = <<-EOT
  #!/bin/bash
  sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
  sudo systemctl restart sshd
  sudo yum update -y
  sudo yum install -y nfs-utils
  systemctl start nfs-server rpcbind
  systemctl enable nfs-server rpcbind
  sudo yum install java-1.8.0-openjdk-headless-y
  sudo yum install wget -y
  wget https://downloads.apache.org/cassandra/3.11.11/apache-cassandra-3.11.11-bin.tar.gz
  tar -xvf apache-cassandra-3.11.11-bin.tar.gz
  sudo mv apache-cassandra-3.11.11-bin /usr/local/apache-cassandra
  sudo yum groupinstall -y development
  sudo yum install -y zlib-devel openssl-devel libffi-devel
  wget https://www.python.org/ftp/python/3.10.2/Python-3.10.2.tgz
  tar -xf Python-3.10.2.tgz
  cd Python-3.10.2
  ./configure --enable-optimizations
  make altinstall
  EOT
}

# Generate a secure private key and encode it as PEM
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create the Key Pair
resource "aws_key_pair" "acx_key_pair" {
  key_name   = var.environment_name
  public_key = tls_private_key.key_pair.public_key_openssh
}

# Save file
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.acx_key_pair.key_name}.pem"
  content  = tls_private_key.key_pair.private_key_pem
}

# resource "aws_key_pair" "ac_server_key_pair" {
#   key_name   = "acx_key_pair"
#   public_key = file("~/.ssh/id_rsa.pub")
# }




resource "aws_security_group" "ac_server_security_group" {
  name        = "ac_server_security_group"
  description = "Allow incoming connections"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming ICMP connections"
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming Postgres connections (Windows)"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.42.10.0/24"]
    description = "Allow incoming SSH connections (Linux)"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 7
    to_port     = 7
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming Java connections"
  }

  # Allow incoming NFS traffic from the EKS cluster nodegroup
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming connections"
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming connections"
  }


  ingress {
    from_port   = 20000
    to_port     = 20005
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming connections"
  }

  ingress {
    from_port   = 111
    to_port     = 111
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming connections"
  }

  ingress {
    from_port   = 111
    to_port     = 111
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming connections"
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "prime-sg"
  }
}



# Create the Prime Server

# module "prime_server" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "4.3.0"
#   name                        = var.environment_name
#   ami                         = var.ami
#   subnet_id                   = var.subnet_id
#   instance_type               = var.instance_type
#   associate_public_ip_address = true
#   key_name                    = aws_key_pair.acx_key_pair.key_name
#   vpc_security_group_ids      = [aws_security_group.ac_server_security_group.id]

#   user_data_base64 = base64encode(local.user_data)


#   # provisioner "remote-exec" {
#   #   command = file("${path.module}/scripts/bootstrap.sh")
#   # }

#   tags = {
#     Name = "ACXerver"
#   }
# }


resource "aws_instance" "prime-server" {
  ami                         = var.ami
  instance_type               = "t3.2xlarge"
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.acx_key_pair.key_name

  # provisioner "remote-exec" {
  #   script = file("${path.module}/scripts/bootstrap.sh")
  # }

  # connection {
  #   type = "ssh"
  #   user = "acdba"
  #   private_key = file("${path.root}/eks-ops360-demo.pem")
  #   host = self.private_ip
  # }

  user_data = <<-EOF
              #!/bin/bash
              sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
              sudo systemctl restart sshd
              yum install -y nfs-utils
              mkdir /mnt/nfs
              echo "/mnt/nfs *(rw,sync,no_subtree_check)" >> /etc/exports
              echo "/home/acdba/ac/workflowengine/conf *(rw,sync,no_subtree_check,all_squash,no_root_squash)" >> /etc/exports
              echo "/home/acdba/data/log/lineage/queue *(rw,sync,no_subtree_check,all_squash,no_root_squash)" >> /etc/exports
              echo "/home/acdba/data/log/lineage/fails *(rw,sync,no_subtree_check,all_squash,no_root_squash)" >> /etc/exports
              echo "/home/acdba/ac/interfaces *(rw,sync,no_subtree_check,all_squash,no_root_squash)" >> /etc/exports
              echo "/home/acdba/data/ac-select-fetcher *(rw,sync,no_subtree_check,all_squash,no_root_squash)" >> /etc/exports
              echo "/home/acdba/data/batch-publisher *(rw,sync,no_subtree_check,all_squash,no_root_squash)" >> /etc/exports
              systemctl enable nfs-server
              systemctl start nfs-server
              sudo yum update -y
              sudo yum install java-1.8.0-openjdk-headless -y
              sudo yum install wget -y
              wget https://downloads.apache.org/cassandra/3.11.11/apache-cassandra-3.11.11-bin.tar.gz
              tar -xvf apache-cassandra-3.11.11-bin.tar.gz
              sudo mv apache-cassandra-3.11.11 /usr/local/apache-cassandra
              sudo yum groupinstall -y development
              sudo yum install -y zlib-devel openssl-devel libffi-devel
              wget https://www.python.org/ftp/python/3.10.2/Python-3.10.2.tgz
              tar -xf Python-3.10.2.tgz
              cd Python-3.10.2
              ./configure --enable-optimizations
              make altinstall
              pip install --upgrade six
              EOF

  vpc_security_group_ids = [aws_security_group.ac_server_security_group.id]


  tags = {
    Name = "ACXServer"
  }

}
