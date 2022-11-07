variable "rds_db_name" {
  description = "RDS database for AppSync Demo"
  type = string
  default = "places"
}

variable "rds_user" {
  description = "RDS db username"
  type        = string
  default     = "admin"
}
