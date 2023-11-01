variable "env" {
    type = string
}
variable "availability_zones" {
    type = list(string)
}
variable "vpc_cidr" {
    type = string
}