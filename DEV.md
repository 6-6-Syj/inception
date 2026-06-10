# 🛠 Developer Documentation

> This document provides technical details for developers working on the Inception project. It covers environment setup, build processes, and data management.

---

## 1️⃣ Setting up the Environment

### Prerequisites

Ensure your development machine has the following installed:

```bash
✅ Docker (Engine version 20.10+)
✅ Docker Compose (v2.0+)
✅ Make (build automation tool)
✅ Git
```

### Initial Configuration

#### 1. 📦 Clone the repository

```bash
git clone <repository-url>
cd <repository-directory>
```

#### 2. 🔧 Create the `.env` file

The project relies on environment variables for configuration. Create a `.env` file at the root of the repository (or wherever specified by the `docker-compose.yml`).

**Required variables typically include:**

| Variable | Description | Example |
|----------|-------------|---------|
| `DOMAIN_NAME` | The domain for the site | `jmagand.42.fr` |
| `MYSQL_ROOT_PASSWORD` | Root password for MariaDB | `<your_password>` |
| `MYSQL_DATABASE` | Name of the WordPress database | `wordpress_db` |
| `MYSQL_USER` | WordPress database user | `wordpress_user` |
| `MYSQL_PASSWORD` | Password for the WordPress user | `<your_password>` |
| `WP_ADMIN` | WordPress admin username | `admin` |
| `WP_ADMIN_PASS` | WordPress admin password | `<your_password>` |
| `WP_TITLE` | Title of the website | `My WordPress Site` |

---

## 2️⃣ Building and Launching

The project uses a `Makefile` to abstract complex Docker commands.

### 🔨 Build Process

Simply run `make` to build and start immediately. ✅

It creates the Docker network and volumes, build images and containers (if they don't exist) and starts the services.

### 🔄 Development Cycle

If you change source code (e.g., modify `nginx.conf` or a PHP script):

1. 🛑 Stop the containers: `make down`
2. 🔨 Rebuild the specific service: `make build-nginx` (or `make build-wordpress`)
3. 🚀 Start again: `make up`

---

## 3️⃣ Managing Containers and Volumes

### 🛠 Useful Commands

| Command | Description |
|---------|-------------|
| `make logs` | View logs (follows logs for all services) |
| `make shell-nginx` | Enter NGINX container shell (debugging) |
| `make shell-wordpress` | Enter WordPress container shell (debugging) |
| `make shell-mariadb` | Enter MariaDB container shell (debugging) |
| `make fclean` | Remove containers, images, and **volumes** ⚠️ *Warning: This deletes all data* |
| `make re` | Stop containers, and rebuild if needed. |
| `make ps` | View running containers |
| `make status` | View running containers (less info than ps) |

## 4️⃣ Data Persistence

Understanding where data is stored is crucial for debugging and backups.

### 💾 Storage Mechanism

The project uses **Docker Volumes** to persist data so it survives container restarts. ✅

### 📍 Locations

| Data Type | Volume Name | Alternative Path |
|-----------|-------------|------------------|
| **Database Data** | `mariadb_data` | `$HOME/data/mysql` |
| **Website Files** | `wordpress_data` | `$HOME/data/wordpress` |

WordPress files (uploads, plugins) and MariaDB data persist across container updates.

### 🔍 How to Inspect Data

To inspect the contents of your persistent data (e.g., to see database files or WordPress uploads):

#### Option 1: From your host machine (simplest)

Since your project uses **named volumes with custom device paths**, data is stored directly in these directories on your host machine:

| Service | Data Path on Host |
|---------|-------------------|
| **MariaDB** | `$HOME/data/mysql` |
| **WordPress** | `$HOME/data/wordpress` |

```bash
# View MariaDB database files
ls $HOME/data/mysql

# View WordPress files (uploads, plugins, etc.)
ls $HOME/data/wordpress/wp-content/uploads
```

#### Option 2: Inside a container

Use the `make shell-<service>` command to enter any container directly:

```bash
make shell-mariadb    # Enter MariaDB container
make shell-wordpress  # Enter WordPress container
make shell-nginx      # Enter NGINX container
```

Inside the shell, navigate to the container's data paths:

| Service | Data Path in Container |
|---------|------------------------|
| **MariaDB** | `/var/lib/mysql` |
| **WordPress** | `/var/www/html` |

```sh
# Inside MariaDB container
ls /var/lib/mysql

# Inside WordPress container
ls /var/www/html/wp-content/uploads
```
