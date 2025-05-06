# About !t

webserver-docker-arm64 is a web server application that run using docker containers tools and has ability of sharing project directory under localhost domain, like xampp htdocs does. this version work only for arm64 CPU.

`Main goals of using container`

- keep your development machine clean of unnecessary libraries 😎
- keep development dependencies consistent on all machine 😏
- easy to upgrade / downgrade libraries version ✌️
- learning docker container help you to understand basic linux operation 😍
- easy install to run development project 🥳

`Current stacks`

- Nginx latest
- PHP 7.1
  - Wkhtmltopdf 0.12.6
  - Composer 2.2
  - DB connect
    - Oracle 11.2 / 19
    - PostgreSQL
    - MySQL
    - PDO
- PHP 8.3.20
  - Wkhtmltopdf 0.12.6.1-r3
  - Composer 2.8.8
  - DB connect
    - Oracle 11.2 / 19
    - PostgreSQL
    - MySQL
    - PDO

`Requirements` **important**

- Machine that using amd64 architecture
- Pre-installed docker engine / desktop
  - if you'r using docker engine you need to install _colima_ lightweight vm, you can follow this good medium post [click here!](https://devcracker.medium.com/how-to-add-a-link-or-hyperlink-in-readme-md-file-68752bb6499e)
- Internet Access (to download and build images)
- Clone / Download this repo

## Guides (how to setup)

- Goto repo root directory

  ```bash
  cd to/your/downloaded/repo
  ```

- Install Docker Images nginx

  ```bash
  docker build -t nginx:latest-dev -f ./dockerfiles/Dockerfile.nginx .
  ```

- Install Docker Images PHP 7.1

  ```bash
  docker build -t php71:latest-dev -f ./dockerfiles/Dockerfile.php71 .
  ```

- Install Docker Images PHP 8.3.2

  ```bash
  docker build -t php83:latest-dev -f ./dockerfiles/Dockerfile.php83 .
  ```

- Run Web Server using docker-compose.yml (important: dont forget to change YOUR_SHARED_PROJECTS_DIRECTORY with your own sharing project folder directory in docker-compose.yml)

  ```bash
  docker-compose up -d
  ```

- Stop Web Server using docker-compose.yml

  ```bash
  docker-compose stop
  ```

- Remove/Delete Web Server using docker-compose.yml (optional)

  ```bash
  docker-compose down
  ```

- How to run **php83** console script from outside container

  ```bash
  check php modules
  - docker exec -it php83 sh -c "php -m"

  yii2 console
  - docker exec -it php83 sh -c "php yii some/controller-script"

  composer
  - docker exec -it php83 sh -c "cd your_project && composer --version"

  install project with composer
  - docker exec -it php83 sh -c "composer create-project --prefer-dist yiisoft/yii2-app-basic basic"
  ```

- After Install some project try to access it with this url
  ```
  http://localhost/your_yii2_project/web
  ```

## Directory & Files Structure

```
/ --- root folder
/config --- custom configuration
/config/nginx --- custom configuration for nginx container
/config/nginx/nginx.conf --- default or entry point nginx config
/config/php --- custom configuration for php
/config/php/v7/zz-docker.conf --- config for php-fpm 7.*
/config/php/v8/zz-docker.conf --- config for php-fpm 8.*
/dockerfiles --- docker files config
/projects --- all development projects inside this dir
/docker-compose.yml ---- docker compose configuration
/.gitignore --- :x

```

## Notes

- Some projects may need some adjustment in the configuration.
- We still maintain & update this repo for flexibility, patch and security update.
- If you found any error/bug/improvement, please raise in issues.
- any help/contribution will be appreciated.

## Next Update Goals

- Node.js runtime
- Making Stable in WSL2 system
- Updating docker build deprecated version in macos
