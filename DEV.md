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

To build the Docker images from the `Dockerfile` located in each service folder (`srcs/nginx`, `srcs/wordpress`, `srcs/mariadb`):

```bash
make build
```

> *Or simply run `make` to build and start immediately.* ✅

### 🚀 Launching the Stack

To start the containers in detached mode:

```bash
make up
```

This creates the Docker network and volumes (if they don't exist) and starts the services.

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
| `make re` | Stop, clean, and rebuild everything from scratch |

### 📋 Docker Compose Directives

You can also use standard Docker Compose commands if the Makefile targets are insufficient:

```bash
docker compose ps
docker compose logs -f [service_name]
docker compose exec [service_name] sh
```

---

## 4️⃣ Data Persistence

Understanding where data is stored is crucial for debugging and backups.

### 💾 Storage Mechanism

The project uses **Docker Volumes** (and possibly bind mounts depending on the specific implementation) to persist data so it survives container restarts. ✅

### 📍 Locations

| Data Type | Volume Name | Alternative Path |
|-----------|-------------|------------------|
| **Database Data** | `db_data` | `$HOME/data/mysql` |
| **Website Files** | `wp_data` | `$HOME/data/wordpress` |

WordPress files (uploads, plugins) and MariaDB data persist across container updates.

### 🔍 How to Inspect Data

To inspect the contents of a volume (e.g., to see database files):

#### 1. Identify the volume

```bash
docker volume ls
```

#### 2. Run a temporary container mounting that volume

```bash
docker run -it --rm -v <volume_name>:/data alpine sh
```

#### 3. Navigate to view files

Inside the shell, navigate to `/data` to view the files:

```sh
ls /data
```