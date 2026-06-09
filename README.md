*This project has been created as part of the 42 curriculum by **jmagand*** <hr>

# Inception

## Description

Inception is a system administration project focused on building a small Docker-based infrastructure from scratch. The goal is to deploy a secure and reproducible stack composed of multiple isolated containers that work together to host a WordPress website backed by MariaDB, with NGINX acting as the entry point.

This project is meant to teach how to design, build, and manage a containerized environment while respecting strict security and architecture rules. It also introduces key concepts such as Docker networking, persistent storage, environment variables, and secrets management.

### Main services

The stack usually includes:
- NGINX, used as the HTTPS reverse proxy and public entry point.
- WordPress, used as the website CMS.
- MariaDB, used as the database server.
- Optional additional services depending on the subject version, such as FTP or extra tools if required.

## Instructions

### Prerequisites

Before running the project, you need:
- Docker installed.
- Docker Compose installed.
- A Linux environment or compatible setup.
- The repository cloned locally.
- A valid `.env` file and any required secrets configured correctly.

### Build and launch

The Makefile uses the following Compose file:
```text
srcs/docker-compose.yaml
```

To build and start the full stack:
```bash
make
```

This runs:
- `make up`
- `make check`

The `up` target creates the required host directories and then launches the stack in detached mode with build enabled.

### Stop the project

To stop the containers:
```bash
make down
```

This stops the stack without deleting images or volumes.

### Full rebuild

To fully recreate the stack:
```bash
make re
```

This runs a full cleanup and then starts everything again.

### Full cleanup

To remove containers, images, volumes, and orphan containers:
```bash
make fclean
```

This also removes the host data directories used for persistence:
- `$$HOME/data/mysql`
- `$$HOME/data/wordpress`

### Useful commands

Show logs:
```bash
make logs
```

Show Compose status:
```bash
make ps
```

Show Docker container status:
```bash
make status
```

Run the NGINX check script:
```bash
make check
```

Rebuild a specific service:
```bash
make build-nginx
make build-wordpress
make build-mariadb
```

Open a shell inside a running container:
```bash
make shell-nginx
make shell-wordpress
make shell-mariadb
```

### Access the website

Once the stack is running, open the domain configured in your `.env` file.  
The website must be accessed through HTTPS, since NGINX is responsible for handling secure traffic and forwarding requests to the WordPress container.

### Access the administration panel

The WordPress administration panel is usually available at:
```text
https://your-domain/wp-admin
```
This is the standard WordPress admin path used to log in and manage the site content.

## Project design

### Docker architecture

Each service runs in its own container to keep the stack isolated, reproducible, and easy to manage. Docker Compose is used to orchestrate the services, define their network, and connect the required volumes.

This approach makes the project easier to rebuild and to move across environments without changing the application logic. It also matches the educational goal of understanding system administration through containerized services.

### Virtual Machines vs Docker

Virtual Machines emulate a full operating system, which makes them heavier and slower to start. Docker shares the host kernel and runs applications in isolated containers, which makes it lighter and faster for this kind of infrastructure project. For Inception, Docker is the better fit because the objective is to learn service isolation, orchestration, and deployment efficiency.

### Secrets vs Environment Variables

Environment variables are useful for non-sensitive configuration such as the domain name, database name, or site title. Secrets should be used for sensitive values such as passwords, tokens, certificates, and private keys. Docker docs explicitly warn against storing sensitive data in Dockerfiles or exposing it through environment variables when a secret mechanism is available.

### Docker Network vs Host Network

A dedicated Docker network allows containers to communicate privately with one another while keeping the services isolated from the host. The host network exposes containers directly on the host network namespace, which reduces isolation and is generally not the best choice for this project. In Inception, a dedicated Docker network is preferred for cleanliness and security.

### Docker Volumes vs Bind Mounts

Docker volumes are managed by Docker and are the standard choice for persistent data such as database files and WordPress content. Bind mounts directly map a host directory into the container, which can be useful for development but is less portable and more dependent on the host filesystem. For Inception, volumes are generally the best fit for persistent application data.

## Configuration

### `.env`

The `.env` file should contain the project configuration values required at runtime. Typical examples include:
- `DOMAIN_NAME`
- `MYSQL_DATABASE`
- `WP_TITLE`

Sensitive data such as passwords and tokens must not be committed to the repository and should be handled according to the project rules.

### Secrets

Any confidential information should be stored outside the codebase and exposed only to the services that need it. Docker Compose secrets are mounted inside the container and provide a safer way to handle sensitive values than plain environment variables.

## Runtime checks

To verify that the services are running:
```bash
docker ps
```

To inspect logs:
```bash
docker compose logs -f
```

To test the stack manually:
- Check that NGINX answers over HTTPS.
- Verify that WordPress loads correctly.
- Confirm that MariaDB is running.
- Restart the stack and ensure data persists.

## Resources

### Documentation
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Docker Networking](https://docs.docker.com/engine/network/drivers/)
- [Docker Volumes](https://docs.docker.com/reference/compose-file/volumes/)
- [WordPress Documentation](https://wordpress.org/documentation/)
- [Alpine Documentation](https://wiki.alpinelinux.org/wiki/MariaDB)

### AI usage
AI was used to help draft and structure this README, improve the English wording, and organize the technical comparisons required by the project. AI also helped me to understand clearlier this project.