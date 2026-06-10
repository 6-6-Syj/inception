# 📘 User Documentation

> Welcome to the **Inception** project. This guide is intended for end-users and administrators who need to operate the WordPress infrastructure deployed via Docker.

---

## 1️⃣ Services Provided

This infrastructure hosts a complete **WordPress** website. The stack consists of three main services working together in the background:

| Service | Role |
|---------|------|
| **🌐 NGINX** | Web server that handles incoming traffic, secures connections via HTTPS, and forwards requests to WordPress |
| **📝 WordPress** | Content Management System (CMS) where you can write posts, manage media, and design your site |
| **🗄️ MariaDB** | Database that stores all website content, user accounts, and settings |

---

## 2️⃣ Starting and Stopping the Project

The project is managed using a `Makefile` for simplicity.

### 🔌 To Start the Services

Open a terminal in the project root directory and run:

```bash
make
```

> *This will download the necessary images, build the containers, and start the stack in the background.* ✅

### 🛑 To Stop the Services

To pause the services without deleting your data:

```bash
make down
```

---

## 3️⃣ Accessing the Website

Once the `make` command has finished:

1. 🌍 Open your web browser (Chrome, Firefox, Safari, etc.)
2. 🔗 Navigate to the URL defined in the project configuration (typically `https://<your_domain_name>`)
3. ⚠️ **Note**: Since this project uses a self-signed SSL certificate for security, your browser might show a warning ("Connection is not private"). You will need to click **"Advanced"** and then **"Proceed to..."** (or "Accept the risk") to continue.

---

## 4️⃣ Accessing the Administration Panel

To manage your WordPress site (create posts, change themes, add users):

1. 📍 Go to: `https://<your_domain_name>/wp-admin`
2. 📄 You will see a login page
3. 🔑 Enter the credentials provided to you by the administrator (or defined during the setup)

---

## 5️⃣ Managing Credentials

For security reasons, credentials are not hardcoded into the images.

### 🔍 Where are they?

Credentials (Database password, WordPress Admin user/password) are usually defined in:
- A `.env` file
- Specific secret files located in the project directory

### ⚠️ Important

> **Do not share these files publicly.** If you need to change a password, contact the system administrator to update the secret files and restart the containers.

---

## 6️⃣ Checking Service Status

If you want to verify that the website is running correctly, you can:

### 👁 Visual Check
Simply refresh the website in your browser. If it loads, the services are up. ✅

### 🛠 Administrator Check
Run the following command in the terminal to see if the containers are running:

```bash
make ps
```

You should see a list where the status of `nginx`, `wordpress`, and `mariadb` is **"Up"** ✅
