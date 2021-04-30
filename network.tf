module "vpcmodule" {
  source = "./module/vpc"
  vpc_id = "vpc-0fc666121270d4dfb"
  subnet_prefix = "manju_subnet_"
}