FROM docker.n8n.io/n8nio/n8n:1.99.1

USER root
RUN apt-get update && apt-get install -y ffmpeg
USER node
