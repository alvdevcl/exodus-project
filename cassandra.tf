module "cassandra" {
  source        = "../modules/cassandra"
  instance_type = "t3.micro"

  subnet_ids = module.vpc.private_subnets.ids
  #add the private ips
  private_ips       = local.private_ips
  allowed_ranges    = [var.vpc_cidr]
  ssh-inbound-range = [var.vpc_cidr]
  ami               = local.ami
  vpc_id            = module.vpc.vpc_id

}



locals {
  private_ips = [cidrhost(data.aws_subnet.subnet1.cidr_block, 14), cidrhost(data.aws_subnet.subnet2.cidr_block, 15), cidrhost(data.aws_subnet.subnet3.cidr_block, 16)]
}


