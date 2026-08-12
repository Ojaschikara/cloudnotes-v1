# CloudNotes Deployment

## Environment
WSL2 Ubuntu on Windows, with systemd enabled (`/etc/wsl.conf` -> `[boot] systemd=true`).

## Setup commands
sudo apt update
sudo apt install -y python3 python3-venv python3-pip build-essential libpq-dev postgresql postgresql-contrib ufw
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
sudo systemctl enable postgresql
sudo systemctl start postgresql
# create DB/user (see deploy/cloudnotes.service for the app's DATABASE_URL)
sudo systemctl daemon-reload
sudo systemctl enable cloudnotes
sudo systemctl start cloudnotes
sudo ufw allow 5000/tcp

## Access path
Browser -> WSL2 localhost port forwarding -> ufw (open port 5000) -> Ubuntu (WSL2) -> gunicorn on 0.0.0.0:5000 -> Flask app -> PostgreSQL
