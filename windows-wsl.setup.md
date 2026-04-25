# WSL and Docker Setup Guide for Windows

This guide will walk you through installing WSL (Windows Subsystem for Linux), setting up Docker inside it, and fixing file permissions so containers can work with your Windows files.

## Part 1 -- Install WSL

1. Open a terminal as Administrator (right-click the Terminal app and choose "Run as administrator").

2. Install WSL:

    ```
    wsl --install
    ```

3. Restart your computer.

4. Install Ubuntu. You can pick a different version if you prefer, but this guide uses Ubuntu 22.04:

    ```
    wsl --install -d Ubuntu-22.04
    ```

5. After it finishes, it will ask you to create a username and password. Fill those in.

6. (Optional) You can adjust how much CPU, memory, and disk space WSL is allowed to use. See the `.wslconfig` section in the main README for details.

---

## Part 2 -- Install Docker Inside WSL

All commands below should be run inside your WSL terminal. Log in as root first:

```
sudo su -
```

### Step 1 -- Remove old Docker packages

If you have any older Docker installs, remove them first. It is safe to run this even if nothing is installed:

```
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
```

### Step 2 -- Get the latest system updates

```
sudo apt-get update
```

### Step 3 -- Add the Docker download source

This tells Ubuntu where to download Docker from:

```bash
# Install required tools
sudo apt-get install ca-certificates curl

# Download Docker's signing key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the Docker download source
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Refresh the package list
sudo apt-get update
```

### Step 4 -- Install Docker

```
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### Step 5 -- Verify that Docker is working

Run the test command below. If you see a message that says "Hello from Docker!" then everything is set up correctly:

```
docker run hello-world
```

---

## Part 3 -- Fix File Permissions

By default, WSL cannot properly set file ownership on files stored in your Windows folders. This causes problems when containers try to read or write files. To fix this:

1. Open the WSL config file:

    ```
    sudo vi /etc/wsl.conf
    ```

2. Add this at the bottom of the file:

    ```ini
    [automount]
    options="metadata"
    ```

3. Save the file and exit the editor (in vi: press `Esc`, type `:wq`, then press `Enter`).

4. Restart WSL by opening a Windows terminal and running:

    ```
    wsl --shutdown
    ```

5. Open WSL again. File permissions should now work correctly.