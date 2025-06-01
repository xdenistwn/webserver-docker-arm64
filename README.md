# About !t

webserver-docker-arm64 is a web server application that run using docker containers tools and has ability of sharing project directory under localhost domain, like xampp htdocs does. this version work only for arm64 CPU.

`Main goals of using container`

- keep your development machine clean of unnecessary libraries 😎
- keep development dependencies consistent on all machine 😏
- easy to upgrade / downgrade libraries✌️
- learning docker container help you to understand basic linux operation 😍
- experiments with open-source tools without worrying about dependencies error.

`Current stacks`

- Nginx latest
- PHP 7.1
  - Wkhtmltopdf 0.12.6
  - Composer 1.1
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
- docker-engine
- Internet Access (to download and build images)

## Guides (how to run webserver)
- in terminal (wsl/colima) Goto repo root directory

  ```
  cd to/your/web_server_docker
  ```

- Build docker images

  ```
  docker compose -f docker-compose.build.yml build
  ```

- Setup projects directory

  ```
  copy .env.example and rename it as .env
  ---
  cp .env.example .env

  open up .env file and change the project path (must be in linux path format)
  ---
  PROJECTS_PATH=/mnt/c/Users/my_working_project/projects
  ```

- Run Web Server using docker-compose.yml

  ```
  docker compose up -d
  ```

- Stop Web Server using docker-compose.yml

  ```
  docker compose stop
  ```

- Remove/Delete Web Server using docker-compose.yml (optional)

  ```
  docker-compose down
  ```

- How to run **php83** console script from outside container

  ```
  check php modules
  - docker compose exec php83 sh -c "php -m"

  yii2 console
  - docker compose exec php83 sh -c "cd your_yii2_project && php yii some/controller-script"

  composer (check up version)
  - docker compose run --rm composer_php8 sh -c "cd your_yii2_project && composer --version"

  install project with composer
  - docker compose run --rm composer_php8 sh -c "composer create-project --prefer-dist yiisoft/yii2-app-basic your_yii2_project"
  ```

- After Install some project try to access it with this url
  ```
  http://localhost/your_yii2_project/web
  http://localhost/your_laravel_project/web
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