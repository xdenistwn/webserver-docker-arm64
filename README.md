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

`Requirements`
- Machine that using arm64 architecture
- Pre-installed docker engine / desktop
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

- Run Web Server using docker-compose.yml
    ```bash
    docker compose up -d
    ```

- Stop Web Server using docker-compose.yml
    ```bash
    docker compose stop
    ```

- Remove/Delete Web Server using docker-compose.yml (optional)
    ```bash
    docker compose down
    ```

- How to run **php71** console script from outside container
    ```bash
    check php modules
    - docker exec -it php71 sh -c "php -m"
    
    yii2 console 
    - docker exec -it php71 sh -c "php yii some/controller-script"
    
    composer console 
    - docker exec -it php71 sh -c "cd your_project && composer --version"
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
- any help will be appreciated.
- DO NOT update .gitignore especially /projects dir 😱

## Next Update Goals
- Ability to use PHP 8.1 and the other related libraries
- Node.js runtime