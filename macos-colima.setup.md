# macOS Docker Setup with Colima

This guide walks you through installing Docker on macOS using Colima as the container runtime.

## What You Need

- macOS with [Homebrew](https://brew.sh) installed

## Steps

### 1. Install Colima

```bash
brew install colima
```

### 2. Install Docker

```bash
brew install docker
```

### 3. Install Docker plugins

```bash
brew install docker-compose docker-buildx docker-credential-helper
```

### 4. Register docker-compose as a Docker plugin

This lets you run `docker compose` (without the hyphen) as a subcommand.

```bash
mkdir -p ~/.docker/cli-plugins
ln -sfn $(brew --prefix)/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose
```

### 5. Register docker-buildx as a Docker plugin

```bash
mkdir -p ~/.docker/cli-plugins
ln -sfn $(brew --prefix)/opt/docker-buildx/bin/docker-buildx ~/.docker/cli-plugins/docker-buildx
```

### 6. Start Colima

```bash
colima start
```

You can verify everything works by running:

```bash
docker info
```