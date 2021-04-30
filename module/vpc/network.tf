// New VPC
resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "manju_vpc"
  }
}
resource "aws_subnet" "mysubnet" {
  count = 2
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.${count.index+1}.0/28"
  # availability_zone = aws_vpc.aws_availability_zones.aliazs.names[count.index]
  tags = {
    Name = "manju_subnet_10.0.${count.index+1}.0/28"
  }
}
# //Existing  VPC
# data "aws_vpc" "anishvpc"{
#     # id ="vpc-0fc666121270d4dfb"
#     id = var.vpc_id
# }
# data "aws_availability_zones" "aliazs"{


# }
# output "aliazs" {
#   value = data.aws_availability_zones.aliazs
# }
# resource "aws_subnet" "mysubnet" {
#     count = length(data.aws_availability_zones.aliazs.names)
#   vpc_id     = data.aws_vpc.anishvpc.id
#   cidr_block = "10.0.${20+count.index+1}.0/28"
#   availability_zone = data.aws_availability_zones.aliazs.names[count.index]
#   tags = {
#     # Name = "manju_subnet_.10.0.${20+count.index+1}.0/28"
#     Name ="${var.subnet_prefix}.10.0.${20+count.index+1}.0/28"
#   }
# }