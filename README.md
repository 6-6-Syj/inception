> *This project has been created as part of the 42 curriculum by **jmagand***

# 🌪️ Inception

## 📋 Description

**Inception** is a system administration project focused on building a small Docker-based infrastructure from scratch. The goal is to deploy a secure and reproducible stack composed of multiple isolated containers that work together to host a **WordPress** website backed by **MariaDB**, with **NGINX** acting as the entry point.

This project is meant to teach how to design, build, and manage a containerized environment while respecting strict security and architecture rules. It also introduces key concepts such as:

- 🌐 Docker networking
- 💾 Persistent storage
- 🔧 Environment variables
- 🔐 Secrets management

---

## 🛠 Docker & Sources

The project utilizes **Docker** and **Docker Compose** to orchestrate the infrastructure. The source code is organized within the `srcs/` directory, which contains the configuration files and Dockerfiles for each service.

### Main Design Choices

| Component | Choice | Reason |
|-----------|--------|--------|
| **Base Image** | Alpine Linux | Minimize image size and attack surface |
| **Orchestration** | Docker Compose | Simplify linking of services (NGINX, WordPress, MariaDB) |
| **Security** | TLS/SSL | NGINX handles HTTPS traffic using self-signed certificates generated at startup |

---

## ⚖ Technology Comparisons

The following architectural decisions were made based on the comparison of core technologies:

### Virtual Machines vs Docker

| Aspect | Virtual Machines (VMs) | Docker |
|--------|----------------------|--------|
| **Virtualization** | Hardware (complete Guest OS) | OS (sharing host kernel) |
| **Isolation** | Strong | Good |
| **Resources** | Heavy | Lightweight |
| **Boot Time** | Slow | Instant |

Docker was chosen to maximize resource efficiency and facilitate rapid deployment and iteration, which fits the project's educational goals of service orchestration.

---

### Secrets vs Environment Variables

| Aspect | Environment Variables | Docker Secrets |
|--------|---------------------|----------------|
| **Storage** | Configuration files / process lists | Mounted files in container RAM |
| **Security** | Less secure (can leak via logs) | Never exposed in env variable list |
| **Exposure** | Logs, inspection commands | RAM-only, file-based |

For this project, sensitive data (like DB passwords) is handled via specific secrets files or `.env` protection strategies to simulate best security practices, avoiding hardcoding credentials in Dockerfiles.

---

### Docker Network vs Host Network

| Aspect | Host Network | Docker Network (Bridge) |
|--------|-------------|------------------------|
| **Isolation** | None (direct host interface) | Isolated layer |
| **Ports** | Port conflicts possible | Private via service names |
| **Security** | Security risks | Services communicate privately |

A custom Docker Bridge network is used to ensure services (like WordPress and MariaDB) can communicate privately, while only NGINX exposes specific ports to the outside world.

---

### Docker Volumes vs Bind Mounts

| Aspect | Bind Mounts | Docker Volumes |
|--------|------------|----------------|
| **Mapping** | Host file/directory direct | Docker managed |
| **Portability** | Depends on host OS structure | OS-agnostic |
| **Backup** | Complex | Easy (`/var/lib/docker/volumes`) |

Docker Volumes are used for database and website data to ensure data persists across container updates and remains portable across different host machines.

---

## 📖 Instructions

### Prerequisites

Before running the project, ensure you have:

```bash
✅ Docker Engine installed
✅ Docker Compose plugin installed
✅ Linux environment
✅ Repository cloned locally
✅ Valid .env file + required secrets configured correctly
```

### Installation & Compilation

The Docker images must be built:

**Build and start the full stack:**

```bash
make
```

This command executes the necessary `docker compose build` and `docker compose up` commands defined in the Makefile.

### Execution

1. **Start the project:**

   ```bash
   make
   ```

2. **Verify it is running:**
   Open your browser and navigate to the domain specified in your `.env` file (e.g., `https://jmagand.42.fr`). You should see the WordPress setup page (or the site if already initialized). ✅

3. **Stop the project:**

   ```bash
   make down
   ```

---

## 📚 Resources

### Documentation & References

| Resource | Link |
|----------|------|
| 📘 Docker Official Documentation | [docs.docker.com](https://docs.docker.com/) |
| 📗 Docker Compose Reference | [docs.docker.com/compose/](https://docs.docker.com/compose/) |
| 🌐 WordPress Administration | [wordpress.org/documentation](https://wordpress.org/documentation/article/administer-your-wordpress-site/) |
| 🗄 MariaDB Knowledge Base | [mariadb.com/kb/](https://mariadb.com/kb/) |

---

### 🤖 Artificial Intelligence Usage

AI tools (**ChatGPT**, **GitHub Copilot**) were utilized during the development of this project for the following specific tasks:

| Task | AI Usage |
|------|----------|
| 📝 **Drafting Documentation** | Assisted in structuring `README.md`, `USER_DOC.md`, and `DEV_DOC.md` for clarity and completeness |
| 🔧 **Debugging Configuration** | Helped troubleshoot NGINX configuration syntax and SSL certificate generation errors |
| 📋 **Docker Compose Syntax** | Provided examples for volume definitions and network aliases to ensure correct service discovery |
| 💻 **Bash Scripting** | Assisted in writing setup scripts used in Dockerfiles to automate dependency installation |
