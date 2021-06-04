variable "prefix" {
  description = "The prefix used for all resources in this example"
}

variable "location" {
  description = "The Azure location where all resources in this example should be created"
}

variable "dbadmin" {
  description = "input Postgresql dbadmin user name"
}

variable "dbpassword" {
  description = "input Postgresql dbadmin user password"
}
