# About !t (arm64 version)
webserver-docker-arm64 is a web server application that run using docker containers tools and has ability of sharing project directory under localhost domain, like xampp htdocs does. this version work only for arm64 CPU.

`Main goals of using container`
- keep your development machine clean of unnecessary libraries.
- keep development dependencies consistent a cross all machine.
- easy to upgrade / downgrade libraries.
- learning docker container help you to understand basic system design.
- experiments with open-source tools without worrying about dependencies error.

`Current stacks`
- Nginx latest
- PHP 7.1 || PHP 7.4 || PHP 8.4
    - Wkhtmltopdf 0.12.6
    - Composer 2.2.25 || Composer 2.8.8
    - DB connect
        - Oracle 11.2 / 19
        - PostgreSQL
        - MySQL
        - PDO

`Requirements` **important**
- Machine that using amd64 architecture
- for windows/mac OS you need to install docker engine
- Internet Access (to download and build images)

## Guide to start docker webserver
- in terminal (wsl/colima) Goto repo root directory

  ```
  cd to/your/web_server_docker
  ```

- Build docker images

  ```
  docker compose -f dockerfiles/docker-compose.build.yml build
  ```

- Copy .env.example and rename it as .env

  ```
  cp .env.example .env
  ```
- Change into your projects dir path (must using linux path format)

  ```
  PROJECTS_PATH=/mnt/c/my_working_project/my_projects
  ```

- Start container services
  ```
  docker compose up -d
  ```

- Stop container services
  ```
  docker compose stop
  ```

- Remove container services (optional)
  ```
  docker compose down
  ```

- How to run **php84** console script from outside container
  ```
  check php modules
  - docker compose exec php84 sh -c "php -m"

  yii2 console
  - docker compose exec php84 sh -c "cd your_yii2_project_name && php yii some/controller-script"

  composer (check up version)
  - docker compose exec php84 sh -c "cd your_yii2_project_name && composer --version"

  install project with composer
  - docker compose exec php84 sh -c "composer create-project --prefer-dist yiisoft/yii2-app-basic your_yii2_project_name"
  ```

- After Install some project try to access it with this url
  ```
  http://localhost/your_yii2_project/web
  http://localhost:8070/your_laravel_project/public
  http://localhost:8074/your_laravel_project/public
  ```

## Directory & Files Structure
```
/ --- root folder
/config --- custom configuration
/config/nginx --- custom configuration for nginx container
/config/nginx/nginx.conf --- default or entry point of nginx config
/config/php --- custom configuration for php
/config/php/v7*/zz-docker.conf --- config for php-fpm 7.*
/config/php/v8*/zz-docker.conf --- config for php-fpm 8.*
/dockerfiles --- docker files config
/dockerfiles/docker-compose.build.yml --- docker compose configuration to build the image
/docker-compose.yml ---- docker compose configuration
/.gitignore --- :x

```

## Notes
- Some projects may need some adjustment in the configuration.
- We still maintain & update this repo for flexibility, patch and security update.
- If you found any error/bug/improvement, please raise in issues.
- any help/contribution will be appreciated.

## Next Update Goals
- nothing yet