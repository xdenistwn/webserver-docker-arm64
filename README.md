# webserver-docker-arm64

A Docker-based local web server for PHP development on arm64 machines. It works like XAMPP -- you put your PHP projects in a shared folder and access them through `localhost` -- but everything runs inside containers so your machine stays clean.

## Why Use This

- Your machine stays free from PHP, database, and web server installs.
- Every developer on your team gets the same setup.
- Switching between PHP versions is just a matter of using a different port.
- Easy to add, remove, or upgrade services without breaking anything.

## What is Included

This setup runs the following services:

| Service      | Container Name | Port(s)         | Description                          |
|--------------|----------------|-----------------|--------------------------------------|
| Nginx        | nginx          | 80, 8074, 8071  | Web server that routes requests to the correct PHP version |
| PHP 8.4      | php84          | 9084 (internal) | Default PHP used on port 80          |
| PHP 7.4      | php74          | 9074 (internal) | PHP used on port 8074                |
| PHP 7.1      | php71          | 9071 (internal) | PHP used on port 8071                |
| PostgreSQL   | pgsql          | 5432            | Database server (Alpine-based)       |

### Port mapping summary

- `http://localhost` or `http://localhost:80` -- uses PHP 8.4
- `http://localhost:8074` -- uses PHP 7.4
- `http://localhost:8071` -- uses PHP 7.1

---

## Features by PHP Version

Each PHP container comes with different tools and libraries pre-installed. The table below shows what is available in each version.

### PHP Extensions

| Feature                    | PHP 8.4 | PHP 7.4 | PHP 7.1 |
|----------------------------|---------|---------|---------|
| PDO (base)                 | Yes     | Yes     | Yes     |
| MySQL (mysqli, pdo_mysql)  | Yes     | Yes     | Yes     |
| PostgreSQL (pdo_pgsql)     | Yes     | Yes     | Yes     |
| Oracle (oci8, pdo_oci)     | Yes     | Yes     | Yes     |
| Kafka (rdkafka)            | Yes     | No      | No      |
| Redis                      | Yes     | No      | No      |
| Mcrypt                     | No      | No      | Yes     |
| BCMath                     | Yes     | Yes     | Yes     |
| SOAP                       | Yes     | Yes     | Yes     |
| Sockets                    | Yes     | Yes     | Yes     |
| ZIP                        | Yes     | Yes     | Yes     |
| GD (image processing)      | Yes     | Yes     | Yes     |

### Tools

| Tool                 | PHP 8.4           | PHP 7.4           | PHP 7.1           |
|----------------------|-------------------|-------------------|-------------------|
| Composer             | 2.8.8             | 2.8.8             | 2.2.25            |
| Node.js (LTS)       | Yes               | No                | No                |
| wkhtmltopdf          | 0.12.6.1          | 0.12.6.1          | 0.12.6            |
| Git                  | Yes               | No                | No                |
| Oracle Instant Client| 19.6              | 19.6              | 19.6              |

### Nginx

- Based on `nginx:stable-alpine`
- Includes network troubleshooting tools (net-tools, ping, telnet)
- Auto-detects project entry points for common PHP frameworks (see "How Nginx Finds Your Project" below)
- Gzip compression enabled
- 60-second timeout for all connections

---

## Requirements

- A machine with **arm64 architecture** (most standard PCs and laptops)
- **Docker Engine** installed (see below for macOS or Windows setup)
- **Internet access** to download and build the images

---

## Setup for macOS Users

macOS users need Colima to run Docker. Follow the full guide at [macos-colima.setup.md](macos-colima.setup.md).

Quick summary:

1. Install Colima, Docker, and plugins via Homebrew.
2. Register the plugins so `docker compose` and `docker buildx` work as subcommands.
3. Start Colima with `colima start`.

---

## Setup for Windows Users

Windows users need WSL (Windows Subsystem for Linux) with Docker Engine. Follow these two steps.

### Step 1 -- Set up WSL

If you do not have WSL installed yet, follow the full guide at [windows-wsl.setup.md](windows-wsl.setup.md).

### Step 2 -- Configure WSL for better performance

1. Open your Windows home folder (example: `C:\Users\YourName\`)
2. Create a file called `.wslconfig` (no file extension) with this content:

    ```ini
    [wsl2]
    memory=8589934592
    swap=0
    localhostForwarding=true

    [experimental]
    autoProxy=true
    dnsTunneling=true
    ```

3. Restart WSL by running this in a terminal:

    ```
    wsl --shutdown
    ```

### Step 3 -- Allow file permissions between Windows and WSL

This lets the containers read and write files from your Windows folders.

1. Open WSL and edit the config file:

    ```
    sudo vi /etc/wsl.conf
    ```

2. Add this at the bottom of the file:

    ```ini
    [automount]
    options="metadata"
    ```

3. Save and restart WSL.

---

## Getting Started

Run all commands below inside your WSL terminal (or any Linux/macOS terminal).

### 1. Clone the repository

```bash
git clone <repository-url>
cd webserver-docker-arm64
```

### 2. Create a Docker network

This is needed for the PostgreSQL service to work. You only need to do this once.

```bash
make create-local-network
```

Or without Make:

```bash
docker network create local-network
```

### 3. Build the images

This downloads and builds all the container images. It may take a while the first time.

```bash
make build
```

Or without Make:

```bash
docker compose -f dockerfiles/docker-compose.build.yml build
```

### 4. Set up environment variables

```bash
cp .env.example .env
```

Open the `.env` file and change the values:

```dotenv
# Path to your projects folder (must use Linux path format)
PROJECTS_PATH=/Users/YourName/your-projects-folder

# PostgreSQL settings
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=postgres
```

**Important:** On Windows with WSL, your `C:\` drive is mounted at `/mnt/c/`. So if your projects are at `C:\Users\John\Projects`, the path would be `/mnt/c/Users/John/Projects`.

### 5. Start the services

```bash
make up
```

Or without Make:

```bash
docker compose up -d
```

### 6. Open your project in a browser

Put your PHP project folders inside the `PROJECTS_PATH` directory, then visit:

- `http://localhost/your-project-name` -- runs on PHP 8.4
- `http://localhost:8074/your-project-name` -- runs on PHP 7.4
- `http://localhost:8071/your-project-name` -- runs on PHP 7.1

---

## How Nginx Finds Your Project

Nginx automatically looks for the entry point of your project. It checks these locations in order:

1. `/your-project/index.php`
2. `/your-project/web/index.php` (Yii2 style)
3. `/your-project/public/index.php` (Laravel style)
4. `/your-project/backend/web/index.php` (Yii2 advanced style)

This means most PHP frameworks will work out of the box without any extra setup.

---

## Running Commands Inside Containers

You can run commands inside any PHP container using `docker compose exec`. Replace `php84` with `php74` or `php71` to target a different PHP version.

**Check installed PHP modules:**

```bash
docker compose exec php84 sh -c "php -m"
```

**Check Composer version:**

```bash
docker compose exec php84 sh -c "composer --version"
```

**Install a new project with Composer:**

```bash
docker compose exec php84 sh -c "composer create-project --prefer-dist laravel/laravel my-laravel-app"
```

**Run a Yii2 console command:**

```bash
docker compose exec php84 sh -c "cd your-project && php yii migrate"
```

**Run an artisan command (Laravel):**

```bash
docker compose exec php84 sh -c "cd your-project && php artisan migrate"
```

**Run Node.js commands (PHP 8.4 and PHP 7.4 only):**

```bash
docker compose exec php84 sh -c "node --version"
docker compose exec php84 sh -c "npm install"
```

---

## Stopping and Removing Services

**Stop all services (keeps data):**

```bash
make stop
```

Or: `docker compose stop`

**Stop and remove all containers (keeps data volumes):**

```bash
make down
```

Or: `docker compose down`

**Remove the Docker network (if no longer needed):**

```bash
make remove-local-network
```

Or: `docker network rm local-network`

---

## Customization

### Change PHP memory limit or timeout

Edit the PHP-FPM config files inside the `config/php/` folder:

- `config/php/v84/zz-docker.conf` -- for PHP 8.4
- `config/php/v74/zz-docker.conf` -- for PHP 7.4
- `config/php/v71/zz-docker.conf` -- for PHP 7.1

Example content:

```ini
[global]
daemonize = no

[www]
listen = 9084
php_value[memory_limit] = 4096M
php_value[max_execution_time] = 60
```

Change `memory_limit` or `max_execution_time` to fit your needs. Then restart the services with `make down && make up`.

### Enable PHP-FPM logging

In the same config files above, uncomment the logging lines to turn on slow request logging and error logging:

```ini
pm.status_path = /fpm-status
request_slowlog_timeout = 10s
slowlog = /var/log/phpfpm-slow.log
php_admin_flag[log_errors] = on
php_admin_value[error_log] = /var/log/phpfpm-error.log
```

### Change Nginx settings

- `config/nginx/nginx.conf` -- Main Nginx config (timeouts, gzip, logging)
- `config/nginx/default.conf` -- Server blocks that route ports to PHP versions
- `config/nginx/entrypoint-auto.conf` -- Auto-detection rules for project entry points

### Change timezone

By default all PHP containers use `Asia/Jakarta`. To change it, edit the `environment` section for each PHP service in `docker-compose.yml`:

```yaml
environment:
  - TZ=Your/Timezone
```

### Add or remove PHP versions

1. Create or remove a Dockerfile in the `dockerfiles/` folder.
2. Add or remove the service in `dockerfiles/docker-compose.build.yml`.
3. Add or remove the service in `docker-compose.yml`.
4. Add a new server block in `config/nginx/default.conf` with a new port.
5. Create a new PHP-FPM config in `config/php/` with a matching listen port.
6. Rebuild with `make build` and restart with `make up`.

---

## Directory Structure

```
/
├── .env.example                          # Template for environment variables
├── .env                                  # Your local environment variables (not in git)
├── docker-compose.yml                    # Main file to run the services
├── Makefile                              # Shortcut commands (build, up, stop, down)
├── config/
│   ├── nginx/
│   │   ├── nginx.conf                    # Main Nginx config
│   │   ├── default.conf                  # Port-to-PHP routing rules
│   │   ├── entrypoint-auto.conf          # Auto-detect project entry points
│   │   └── fastcgi_params                # FastCGI parameters
│   ├── php/
│   │   ├── v84/zz-docker.conf            # PHP 8.4 FPM settings
│   │   ├── v74/zz-docker.conf            # PHP 7.4 FPM settings
│   │   └── v71/zz-docker.conf            # PHP 7.1 FPM settings
└── dockerfiles/
    ├── docker-compose.build.yml          # Build config (only for building images)
    ├── Dockerfile.nginx                  # Nginx image definition
    ├── Dockerfile.php84                  # PHP 8.4 image definition
    ├── Dockerfile.php74                  # PHP 7.4 image definition
    ├── Dockerfile.php71                  # PHP 7.1 image definition
    └── packages/
        └── oracle/                       # Oracle Instant Client files for builds
```

---

## Make Commands Reference

| Command                    | What it does                              |
|----------------------------|-------------------------------------------|
| `make create-local-network`| Creates the Docker network (run once)     |
| `make remove-local-network`| Removes the Docker network                |
| `make build`               | Builds all container images               |
| `make up`                  | Starts all services in the background     |
| `make stop`                | Stops all services (keeps containers)     |
| `make down`                | Stops and removes all containers          |

---

## Troubleshooting

**"network local-network not found" error:**
Run `make create-local-network` before starting the services.

**Cannot access localhost from Windows:**
Make sure `localhostForwarding=true` is set in your `.wslconfig` file and restart WSL.

**File permission errors:**
Make sure the `[automount] options="metadata"` setting is in your `/etc/wsl.conf` file.

**Build fails on Oracle step:**
The Oracle Instant Client zip files must be present in `dockerfiles/packages/oracle/`. These are not included in the repository due to licensing. Download them from the Oracle website.

---

## Notes

- Some projects may need extra adjustments in the Nginx or PHP config.
- This repository is maintained and updated for flexibility, security patches, and improvements.
- If you find any problems or have suggestions, please open an issue.
- Contributions are welcome.