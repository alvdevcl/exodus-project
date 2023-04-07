# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones#attributes-reference
data "aws_availability_zones" "zones" {}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids#attributes-reference
data "aws_subnet_ids" "subnets" {
  vpc_id = module.vpc.vpc_id

  depends_on = [
    module.vpc
  ]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc#attributes-reference
data "aws_vpc" "vpc" {
  id = module.vpc.vpc_id
}

data "http" "my_ip" {
  url = "https://ifconfig.me"
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name = "name"
    # Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type (first line of Amazon Linux AMI)
    values = ["amzn2-ami-kernel-5*-x86_64-gp2"]

    # Amazon Linux 2 AMI (HVM) - Kernel 4.14, SSD Volume Type (second line of Amazon Linux AMI)
    # values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Get latest Windows Server 2012R2 AMI
data "aws_ami" "windows-2012-r2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2012-R2_RTM-English-64Bit-Base-*"]
  }
}
# Get latest Windows Server 2016 AMI
data "aws_ami" "windows-2016" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2016-English-Full-Base*"]
  }
}
# Get latest Windows Server 2019 AMI
data "aws_ami" "windows-2019" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base*"]
  }
}
# Get latest Windows Server 2022 AMI
data "aws_ami" "windows-2022" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base*"]
  }
}


data "aws_subnet" "subnet1" {
  id = tolist(module.vpc.private_subnets.ids)[0]
}

data "aws_subnet" "subnet2" {
  id = tolist(module.vpc.private_subnets.ids)[1]
}

data "aws_subnet" "subnet3" {
  id = tolist(module.vpc.private_subnets.ids)[2]
}
