# # data "aws_subnet_ids" "subs" {
# #   vpc_id = tolist(data.aws_vpc.main.ids)[0]
# # }

# data "aws_subnet_ids" "subs" {
#   vpc_id = var.vpc_id
# }

# data "aws_vpc" "main" {
#   id = var.vpc_id
# }

# data "aws_caller_identity" "current" {
# }

# data "aws_subnet" "a" {
#   id = tolist(data.aws_subnet_ids.subs.ids)[0]
# }


# variable "vpc_id" {
#   default = "vpc-05e6e69eff4a7d17e"
# }


# data "aws_subnet" "selected" {
#   filter {
#     name   = "tag:Name"
#     values = ["myawesomesubnet"]
#   }
# }

# # data "aws_subnets" "myawesomesubnets" {
# #   filter {
# #     name   = "vpc-id"
# #     values = [module.vpc.vpc_id]
# #   }

# #   tags = {
# #     Tier = "myawesomesubnet"
# #   }
# # }

# # data "aws_subnets" "example" {
# #   filter {
# #     name   = "vpc-id"
# #     values = [var.vpc_id]
# #   }
# # }


# # data "aws_subnet_ids" "example" {
# #   vpc_id = var.vpc_id
# # }

# # data "aws_subnet" "example" {
# #   for_each = data.aws_subnet_ids.example.ids
# #   id       = each.value
# # }

# # output "subnet_cidr_blocks" {
# #   value = [for s in data.aws_subnet.example : s.cidr_block]
# # }


# # data "aws_subnet" "b" {
# #   id = tolist(data.aws_subnet_ids.example.ids)[0]
# # }


# # data "aws_subnet" "c" {
# #   id = tolist(data.aws_subnets.myawesomesubnets.ids)[0]
# # }

# data "aws_subnet" "subnet1" {
#     id = tolist(module.vpc.private_subnets.ids)[0]
# }

# data "aws_subnet" "subnet2" {
#     id = tolist(module.vpc.private_subnets.ids)[1]
# }

# data "aws_subnet" "subnet3" {
#     id = tolist(module.vpc.private_subnets.ids)[2]
# }