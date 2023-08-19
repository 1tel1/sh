#!/bin/bash
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list && sudo apt update && sudo apt install ngrok
ngrok config add-authtoken 2SQRTIZp7Vd0gkGgW7smx9R83Da_63TjZJYokgEjuZpXCP2tL
ngrok http 3000
ngrok by @inconshreveable
