## Running the workflow locally

To run the `reels-autopilot.json` workflow locally:

1. **Install Docker and Docker Compose**  
   Make sure you have Docker and Docker Compose installed on your system.

2. **Install `ffmpeg`** inside the container  
   If you're using an Alpine-based Docker image (like the default `n8nio/n8n`), install `ffmpeg` with:
   ```sh
   apk add --no-cache ffmpeg
   ```

3. **Start n8n using Docker Compose**  
   In the project directory, run:
   ```sh
   docker-compose up --build
   ```

4. **Import the workflow**  
   - Open n8n in your browser: [http://localhost:5678](http://localhost:5678)  
   - Click **“Create Workflow”** → **“Import from file”**  
   - Select the file `reels-autopilot.json`

5. **Configure any required credentials or variables**  
   - Ensure all nodes (e.g., Drive, Telegram, etc.) have the correct credentials configured.  
   - If needed, adjust paths or parameters.

This will allow you to run and test the workflow locally with all dependencies.
