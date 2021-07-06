# Azure Machine Learning スタジオでKaggleコンベンションにも使える機械学習環境を構築してみる

----

ブログ「Azure Machine Learning スタジオでKaggleコンベンションにも使える機械学習環境を構築してみる」で使用している資材の説明ページです。

- 環境情報

Terraform実行環境のバージョン情報です。

>tfenv：2.2.2  
>terraform：0.15.4

- Terraform実行ファイル

実行に必要なファイル構成は以下の通りです。

>terraform   
> ┗init  
>   　┣[init.tfvars](terraform/init/init.tfvars)  
>   　┣[main.tf](terraform/init/main.tf)  
>   　┗[variables.tf](terraform/init/variables.tf)  
> ┗notebook  
>   　┗[creditcard.ipynb](notebook/creditcard.ipynb)
> >　readme.md  （このファイルです）
