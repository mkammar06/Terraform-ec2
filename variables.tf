variable "ami_id" {
    default = "ami-01e7ca2ef94a0ae86"
    type = string
    description = "AMI ID for EC2Instance Ubuntu"
}
variable "instance_count" {
    default = 2
    type = number
    description = "No. of instance"
}
variable "instance_name_Lst" {
    default = ["ManjunathEc2-Web1","ManjunathEc2-Web2"]
}