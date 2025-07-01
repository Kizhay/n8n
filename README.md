## 🚀 Deploying the Workflow on Server (Production)

To run the `reels-autopilot.json` workflow on your server (e.g. `kizhay.ru`), follow these steps:

### 1. **Install Docker and Docker Compose**  
Make sure your server has Docker and Docker Compose installed.  
For Ubuntu/Debian:
```sh
apt update && apt install -y docker.io docker-compose
```

### 2. **Ensure `ffmpeg` is available inside the container**  
The Dockerfile includes ffmpeg. Example:
```Dockerfile
FROM n8nio/n8n:latest

USER root
RUN apk add --no-cache ffmpeg
USER node
```

This ensures ffmpeg is installed in the container.

### 3. **Build and run n8n with Docker Compose**  
Inside your project directory:
```sh
docker-compose up --build -d
```

> The provided `docker-compose.yml` will launch the n8n instance with ffmpeg support.

### 4. **Access the n8n UI**  
Open your browser and navigate to:  
👉 [http://your-server-ip:5678](http://your-server-ip:5678)

### 5. **Import the Workflow**  
In the n8n UI:
- Click **“Create Workflow”**
- Choose **“Import from File”**
- Select `reels-autopilot.json`

### 6. **Set up Credentials and Environment Variables**  
Make sure all nodes (e.g., Google Drive, Telegram) have the proper credentials configured.  
Adjust any variables like file paths, tokens, or webhook URLs if needed.

---

✅ Once done, your server-hosted n8n instance will be ready to run the `reels-autopilot` workflow with all dependencies.
