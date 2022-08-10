# ------ modules/networking/variables.tf
variable "vpc_cidr" {}

variable "private_sn_count" {}
variable "public_sn_count" {}
variable "public_cidrs" {
  type = list(any)
}
