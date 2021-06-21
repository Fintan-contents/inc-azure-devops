# TerraformでAzureにウェブ開発環境を構築する  

----

ブログ「TerraformでAzureにウェブ開発環境を構築する」で使用している資材の説明ページです。  

- 環境情報

Terraform実行環境のバージョン情報です。

>tfenv：2.2.2  
>terraform：0.15.4  

- Terraform実行ファイル 

実行に必要なファイル構成は以下の通りです。

>terraform   
> ┗init  
>   　┣[init.tfvars](#init_tfvars)  
>   　┣[main.tf](#main_tf)  
>   　┣[variables.tf](#variables_tf)  
>   　┗[outputs.tf](#outputs_tf)  
> ┗cli  
>   　┣[example-chat-backend.json](#example-chat-backend_json)  
>   　┣[example-chat-frontend.json](#example-chat-frontend_json)  
>   　┗[example-chat-notifier.json](#example-chat-notifier_json)  
> >　readme.md  （このファイルです）

----

## init_tfvars

[main.tf](#main_tf)の実行時に使用する変数名を指定します。  
実行前に
[Azureリソースの名前付け規制と制限事項](https://docs.microsoft.com/ja-jp/azure/azure-resource-manager/management/resource-name-rules)
の内容をもとに、適切な値に変更してから実行します。

| 変数名 | サンプルの値 | 説明 |
| ------------- | ------------- | ------------- |
| prefix  | examplechat210611  |作成するAzure上のリソースの名前の先頭の値です。固有の名前になるよう指定します。 |
| location  | japaneast  | 作成するAzure上のリソースのリージョンを指定します。サンプルでは東日本リージョン"japaneast"を指定しています。 |
| dbadmin  | chatadmin  | [Azure Database for PostgreSQL](#PostgreSQLの作成)の管理者ユーザー名を指定します。  |
| dbpassword  | -Y=T-w!#MMfm@Y4%  |  [Azure Database for PostgreSQL](#PostgreSQLの作成)の管理者ユーザーパスワードを指定します。 |

----

## main_tf

terraform/main.tfファイルの簡単な解説です。  
このファイルでは以下の構成をしています。  
- [AzureRMプロバイダーを指定](#AzureRMプロバイダーを指定)  
- [リソースグループの作成](#リソースグループの作成)  
- [コンテナレジストリの作成](#コンテナレジストリの作成)  
- [ストレージアカウントとコンテナーの作成](#ストレージアカウントとコンテナーの作成)  
- [Azure Database for PostgreSQLの作成](#PostgreSQLの作成)  
- [Azure Cache for Redisの作成](#Redisの作成)  

### AzureRMプロバイダーを指定  

TerraformのAzureプロバイダーを指定します。  
※指定しているパラメータの詳細は
[AZURERM DOCUMENTATIONのAzure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
を参照します。
```
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.61.0"
    }
  }
}
```

### リソースグループの作成  

リソースグループの名前に[init.tfvars](#init_tfvars) の変数名「prefix」に文字列「-rg」を連結した値がセットされます。  
ロケーションに[init.tfvars](#init_tfvars) の変数名「location」の値がセットされます。
※指定しているパラメータの詳細は
[AZURERM DOCUMENTATIONのAazurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
を参照します。
```
##### リソースグループ #####
resource "azurerm_resource_group" "example" {
        name = "${var.prefix}-rg"
        location = var.location
}
```

### コンテナレジストリの作成  

コンテナレジストリの名前に[init.tfvars](#init_tfvars) の変数名「prefix」に文字列「cr」を連結した値がセットされます。  
※指定しているパラメータの詳細は
[AZURERM DOCUMENTATIONのazurerm_container_registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry)
を参照します。
```
##### コンテナレジストリ #####
resource "azurerm_container_registry" "example" {
        name = "${var.prefix}cr"
        resource_group_name = azurerm_resource_group.example.name
        location = azurerm_resource_group.example.location
        sku = "Basic"
        admin_enabled = true
}
```

### ストレージアカウントとコンテナーの作成  

ストレージアカウントの名前に[init.tfvars](#init_tfvars) の変数名「prefix」に文字列「sa」を連結した値がセットされます。  
ストレージコンテナの名前は「example-chat」を指定する必要があります。この名前は変更しないでください。  
※指定しているパラメータの詳細は
[AZURERM DOCUMENTATIONのazurerm_storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container)
を参照します。
```
##### ストレージアカウント #####
resource "azurerm_storage_account" "example" {
        name = "${var.prefix}sa"
        resource_group_name = azurerm_resource_group.example.name
        location = azurerm_resource_group.example.location
        account_tier = "Standard"
        account_replication_type = "LRS"
}

##### ストレージコンテナ #####
resource "azurerm_storage_container" "example-chat" {
        name = "example-chat"
        storage_account_name = azurerm_storage_account.example.name
        container_access_type = "private"
}
```

### PostgreSQLの作成  

Azure Database for PostgreSQLの名前に[init.tfvars](#init_tfvars) の変数名「prefix」に文字列「pg」を連結した値がセットされます。  
DBサーバー管理ユーザ名に[init.tfvars](#init_tfvars) の変数名「dbadmin」の値がセットされます。  
DBサーバー管理ユーザパスワードに[init.tfvars](#init_tfvars) の変数名「dbpassword」の値がセットされます。  
※指定しているパラメータの詳細は
[AZURERM DOCUMENTATIONのazurerm_postgresql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_database)
を参照します。
```
##### Azure Database for PostgreSQL #####
resource "azurerm_postgresql_server" "example" {
        name = "${var.prefix}pg"
        location = azurerm_resource_group.example.location
        resource_group_name = azurerm_resource_group.example.name

        sku_name = "B_Gen5_1"

        storage_mb = 5120
        backup_retention_days = 7
        geo_redundant_backup_enabled = false
        auto_grow_enabled = true

        administrator_login = var.dbadmin
        administrator_login_password = var.dbpassword
        version = "11"
        ssl_enforcement_enabled = true
        allow_access_to_azure_services =  true
}
```

### Redisの作成  

Azure Cache for Redisの名前に[init.tfvars](#init_tfvars) の変数名「prefix」に文字列「rd」を連結した値がセットされます。  
※指定しているパラメータの詳細は
[AZURERM DOCUMENTATIONのazurerm_redis_cache](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_cache)
参照します。
```
##### Azure Cache for Redis #####
resource "azurerm_redis_cache" "example" {
       name = "${var.prefix}rd"
       location = azurerm_resource_group.example.location
       resource_group_name = azurerm_resource_group.example.name
       capacity = 0
       family = "C"
       sku_name = "Basic"
       enable_non_ssl_port = false
       minimum_tls_version = "1.2"
       public_network_access_enabled = true

       redis_configuration {
       }
}
``` 

----

## variables_tf

このファイルは変更せずにそのまま使用します。  
[main.tf](#main_tf)の実行時に受け渡しする参照変数を定義しています。  
[init.tfvars](#init_tfvars) のファイルの変数名、サンプルの値を、このファイルの定義に沿って[main.tf](#main_tf)に渡します。
``` 
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
``` 

----

## outputs_tf  

このファイルは変更せずにそのまま使用します。  
[main.tf](#main_tf)の実行後に標準出力に出力される実行結果の値を定義しています。
``` 
##### コンテナレジストリの名前 #####
output "azure_container_registry_name" {
value = "${azurerm_container_registry.example.name}"
}
##### コンテナレジストリのドメイン #####
output "azure_container_registry_domain" {
value = "${azurerm_container_registry.example.name}.azurecr.io"
}
##### Azure Database for PostgreSQLのサーバー名 #####
output "azure_postgresql_server" {
value = "${azurerm_postgresql_server.example.name}"
}
##### Azure Cache for Redisのサーバー名 #####
output "azure_redis_cache" {
value = "${azurerm_redis_cache.example.name}"
}
``` 
----

## example-chat-backend_json  

「[環境変数を設定する](https://fintan.jp/?p=6634#set-environment-variables) 」のbackendのアプリケーション設定の構成をターミナルからAzure CLIで一括設定するために使用するファイルです。  
実行前に各々の環境の応じて変更する必要があります。

----

## example-chat-frontend_json  

「[環境変数を設定する](https://fintan.jp/?p=6634#set-environment-variables) 」のfrontendのアプリケーション設定の構成をターミナルからAzure CLIで一括設定するために使用するファイルです。  
実行前に各々の環境の応じて変更する必要があります。

----

## example-chat-notifier_json  

「[環境変数を設定する](https://fintan.jp/?p=6634#set-environment-variables) 」のnotifierのアプリケーション設定の構成をターミナルからAzure CLIで一括設定するために使用するファイルです。  
実行前に各々の環境の応じて変更する必要があります。
