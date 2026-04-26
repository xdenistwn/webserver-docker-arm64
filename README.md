# webserver-docker-arm64

A local web server for PHP development that runs entirely in Docker.
Drop your PHP projects into a folder, open `localhost`, and start coding — nothing gets installed on your machine.

## Table of Contents

- [Getting Started](#getting-started)
- [Platform Setup](#platform-setup)
- [Usage](#usage)
- [Available PHP Versions](#available-php-versions)
- [Running Commands](#running-commands)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

---

## Getting Started

You need an **arm64 machine** with **Docker** installed.
If you haven't set up Docker yet, see [Platform Setup](#platform-setup) first.

### 1. Clone and enter the project

```bash
git clone <repository-url>
cd webserver-docker-arm64
```

### 2. Create the Docker network (first time only)

```bash
make create-local-network
```

### 3. Build the images

This will take a few minutes the first time.

```bash
make build
```

### 4. Set up your environment file

```bash
cp .env.example .env
```

Open `.env` and set the path to your projects folder:

```dotenv
PROJECTS_PATH=/path/to/your/projects

POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=postgres
```

> **Windows users:** Your `C:\Users\John\Projects` folder becomes `/mnt/c/Users/John/Projects` inside WSL.

### 5. Start everything

```bash
make up
```

### 6. Open your browser

Put your PHP project folders inside the path you set above, then visit:

| Address | PHP Version |
|---------|-------------|
| `http://localhost/your-project` | 8.4 |
| `http://localhost:8074/your-project` | 7.4 |
| `http://localhost:8071/your-project` | 7.1 |

That's it. Your project should be running.

---

## Platform Setup

### macOS

You need Colima to run Docker on macOS. Follow the guide in [macos-colima.setup.md](macos-colima.setup.md).

### Windows

You need WSL (Windows Subsystem for Linux) with Docker installed inside it.

1. **Install WSL and Docker** — follow [windows-wsl.setup.md](windows-wsl.setup.md).

2. **Improve performance** — create a `.wslconfig` file in your Windows home folder (`C:\Users\YourName\`):

    ```ini
    [wsl2]
    memory=8589934592
    swap=0
    localhostForwarding=true

    [experimental]
    autoProxy=true
    dnsTunneling=true
    ```

    Then restart WSL: `wsl --shutdown`

3. **Fix file permissions** — inside WSL, add this to `/etc/wsl.conf`:

    ```ini
    [automount]
    options="metadata"
    ```

    Then restart WSL.

---

## Usage

### How projects are detected

When you visit `localhost/your-project`, Nginx looks for your project's entry point in this order:

1. `your-project/index.php`
2. `your-project/web/index.php` (Yii2)
3. `your-project/public/index.php` (Laravel)
4. `your-project/backend/web/index.php` (Yii2 advanced)

Most frameworks work without any extra setup.

### Stopping and removing

| What you want | Command |
|---------------|---------|
| Stop services, keep your data | `make stop` |
| Stop and remove containers | `make down` |
| Remove the Docker network | `make remove-local-network` |

---

## Available PHP Versions

Each PHP version comes with different extensions and tools pre-installed.

<details>
<summary>Extensions per version</summary>

| Extension | 8.4 | 7.4 | 7.1 |
|-----------|:---:|:---:|:---:|
| PDO, MySQL, PostgreSQL, Oracle | Yes | Yes | Yes |
| BCMath, SOAP, Sockets, ZIP, GD | Yes | Yes | Yes |
| Kafka, Redis | Yes | No | No |
| Mcrypt | No | No | Yes |

</details>

<details>
<summary>Tools per version</summary>

| Tool | 8.4 | 7.4 | 7.1 |
|------|-----|-----|-----|
| Composer | 2.8.8 | 2.8.8 | 2.2.25 |
| Node.js | Yes | No | No |
| Git | Yes | No | No |
| wkhtmltopdf | 0.12.6.1 | 0.12.6.1 | 0.12.6 |
| Oracle Instant Client | 19.6 | 19.6 | 19.6 |

</details>

---

## Running Commands

Use `docker compose exec` to run anything inside a container. Replace `php84` with `php74` or `php71` as needed.

```bash
# Check which PHP extensions are installed
docker compose exec php84 sh -c "php -m"

# Install a Laravel project
docker compose exec php84 sh -c "composer create-project --prefer-dist laravel/laravel my-app"

# Run Laravel migrations
docker compose exec php84 sh -c "cd your-project && php artisan migrate"

# Run Yii2 migrations
docker compose exec php84 sh -c "cd your-project && php yii migrate"

# Check Node.js version (PHP 8.4 only)
docker compose exec php84 sh -c "node --version"
```

---

## Configuration

<details>
<summary>Change PHP memory limit or timeout</summary>

Edit the config file for the version you need:
`config/php/v84/zz-docker.conf`, `config/php/v74/zz-docker.conf`, or `config/php/v71/zz-docker.conf`.

```ini
[www]
php_value[memory_limit] = 4096M
php_value[max_execution_time] = 60
```

Restart with `make down && make up`.

</details>

<details>
<summary>Change timezone</summary>

Default is `Asia/Jakarta`. Edit the `environment` section for each PHP service in `docker-compose.yml`:

```yaml
environment:
  - TZ=Your/Timezone
```

</details>

<details>
<summary>Change Nginx settings</summary>

- `config/nginx/nginx.conf` — main settings (timeouts, compression, logging)
- `config/nginx/default.conf` — which port maps to which PHP version
- `config/nginx/entrypoint-auto.conf` — project entry point detection rules

</details>

<details>
<summary>Add or remove a PHP version</summary>

1. Add or remove a Dockerfile in `dockerfiles/`.
2. Update `dockerfiles/docker-compose.build.yml` and `docker-compose.yml`.
3. Add a server block in `config/nginx/default.conf` with a new port.
4. Create a PHP config in `config/php/` with a matching listen port.
5. Run `make build && make up`.

</details>

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "network local-network not found" | Run `make create-local-network` before starting |
| Can't reach `localhost` from Windows | Make sure `localhostForwarding=true` is in `.wslconfig`, then run `wsl --shutdown` |
| File permission errors | Add `options="metadata"` under `[automount]` in `/etc/wsl.conf`, then restart WSL |
| Build fails on Oracle step | Place the Oracle Instant Client zip files in `dockerfiles/packages/oracle/` |

---

## Contributing

Found a bug or have a suggestion? [Open an issue](../../issues). Pull requests are welcome.