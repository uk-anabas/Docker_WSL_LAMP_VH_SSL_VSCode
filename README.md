# Docker開発環境 VH版

Symfony や Laravel も動かすことができる構成。
なお、LaravelはSailを使う方が楽です。

VHを使えるので、複数の(サブ)ドメインなどを利用する開発に使えます。

http(s)://localhost/ で phpInfo() を見れます。

## 使い方

1. WSL上の任意のディレクトリに配置します。
1. 下記の設定などを編集します。
1. コマンドを叩きます。

```
docker-compose up -d --build
```

## PHPの構成
PHP 8.2 - 8.0
(build/Dockerfile の、FROM php:8.2-apache を変更すれば 8.0 || 8.1 環境も作れます。)

PHPの構成には以下を含みます。

* zip
* GD
* sysvsem （sem_get）
* Composer
* pdo
* pdo_mysql
* mysqli
* iconv
* intl

## php.ini

./build/php.ini を編集します。

## SSL接続

自己証明書でHTTPS接続ができるようにしてあります。
SSLの情報を変更したい場合は、./build/openssl.exp を編集します。

## phpMyAdmin
http://localhost:8080/ でログイン無しで接続できます。

# アプリケーションの設置

htdocs/app ディレクトリにアプリケーションの公開ディレクトリを作成し展開します。
例）htdocs/app で Git Clone して展開

Gitがネストする形になりますが、 ./app ディレクトリについては、gitignore してあります。

htdocs/hogehoge/ などのディレクトリを作成しても動きますが、その場合は gitignore を設定しておくと良いでしょう。

## VHの追加/削除

./build/httpd.conf を編集し、アプリケーションの公開ディレクトリを追加/削除します。

## VHへのルーティング

Windows の hostファイルを編集します。

C:\Windows\System32\drivers\etc

例）
```
127.0.0.1   hogehoge.local
127.0.0.1   fugafuga.local
```

## phpMyAdmin

http://localhost:8080/


## .env.localのDB接続の設定例

```
DATABASE_URL="mysql://root:root@mysql/my_database"

```

## MySQLWorkbenchなど外部ツールからDBに接続

127.0.0.1:3306 root:root で入れます。

## VSCode php.validate.executablePath

WSL上で設置したアプリケーションディレクトリに移動し、 code . で VSCode を新しく起動して作業を行います。
その際に、php.validate.executablePath を聞かれる場合があります。
app/アプリケーションディレクトリ/ に設置されている場合、以下の設定をすることで動きます。

```
"php.validate.executablePath": "../../var/php.sh",
"php.debug.executablePath": "../../var/php.sh",
```

./htdocs/var/php.sh を編集

```
#!/bin/sh
docker exec docker_wsl_lamp_vh_ssl_vscode-php-apache-1 php "$@"
return $?
```

```
chmod +x ./var/php.sh
```

なお、docker_wsl_lamp_vh_ssl_vscode-php-apache-1 部分は実際のコンテナ名を入れます。

コンテナ名の確認方法（WSL上で実行）

```
docker container ps
```
