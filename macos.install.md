## Installing docker, docker compose, docker buildx, docker-credential-helper for macos using colima
1. brew install colima
2. brew install docker
3. brew install docker-compose docker-buildx docker-credentials-helper
4. change the plugins path for docker-compose so its run using "docker compose" instead.
```bash
mkdir -p ~/.docker/cli-plugins
ln -sfn $(brew --prefix)/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose
```
5. change docker-buildx plugins path
```bash
mkdir -p ~/.docker/cli-plugins
ln -sfn $(brew --prefix)/opt/docker-buildx/bin/docker-buildx ~/.docker/cli-plugins/docker-buildx
```