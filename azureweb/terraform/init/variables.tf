##### 作成するAzure上のリソースの名前の先頭の値 #####
variable "prefix" {
  description = "The prefix used for all resources in this example"
}
##### 作成するAzure上のリソースのリージョン #####
variable "location" {
  description = "The Azure location where all resources in this example should be created"
}
##### Azure Database for PostgreSQLの管理者ユーザー名 #####
variable "dbadmin" {
  description = "input Postgresql dbadmin user name"
}
##### Azure Database for PostgreSQLの管理者ユーザーパスワード #####
variable "dbpassword" {
  description = "input Postgresql dbadmin user password"
}
