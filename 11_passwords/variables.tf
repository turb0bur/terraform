variable "ssm_rds_password_key" {
  description = "SSM Parameter Store key for RDS db password"
  type        = string
  default     = "/dev/mysql"
}

variable "rds_user" {
  description = "RDS db username"
  type        = string
  default     = "admin"
}