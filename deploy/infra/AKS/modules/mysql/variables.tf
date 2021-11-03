variable "location" {
  description = "Azure location where the mysql Server will be deployed"
}

variable "resource_group_name" {
  description = "Name of the resource group in which the mysql Server will be assigned"
}

variable "name" {
  description = "Name of the Azure-mysql deployment"
  default     = "az-psql"
}

variable "administrator_login" {
  description = "Login to authenticate to mysql Server"
  default     = "ecosystem"
}

variable "mysql_version" {
  description = "mysql Server version to deploy"
  default     = "11"
}

variable "sku_name" {
  description = "mysql SKU Name"
  default     = "B_Gen5_1"
}

variable "storage_mb" {
  description = "mysql Storage in MB"
  default     = "5120"
}

variable "databases" {
  description = "List of databases to be created on the mysql Server"
}
