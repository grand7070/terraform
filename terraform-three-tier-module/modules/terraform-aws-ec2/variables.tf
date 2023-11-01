variable "web_security_group_id" {
    type = string
}

variable "app_security_group_id" {
    type = string
}

variable "web_public_subnet_ids" {
    type = list(string)
}

variable "app_private_subnet_ids" {
    type = list(string)
}

variable "web_target_group_arn" {
    type = string
}

variable "app_target_group_arn" {
    type = string
}

variable "internal_alb_dns_name" {
    type = string
}

variable "db_address" {
    type = string
}

variable "db_name" {
    type = string
}

variable "db_username" {
    type = string
}

variable "db_password" {
    type = string
}