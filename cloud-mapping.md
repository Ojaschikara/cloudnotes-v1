# Local Deployment -> Compute Engine Mapping

| Local | Compute Engine equivalent | Why they match |
|---|---|---|
| WSL2 Ubuntu | Compute Engine VM (e2-medium, Ubuntu) | Both are a full Linux OS instance running the app continuously, independent of any client machine. |
| WSL terminal | gcloud compute ssh | Both are the remote-admin shell used to manage the server and run commands. |
| localhost:5000 | VM static external IP | Both are the network address a browser uses to reach the running app. |
| ufw allow 5000/tcp | GCP VPC firewall rule (tcp:5000) | Both are the gatekeeper that must explicitly allow inbound traffic before it reaches the app. |
| systemd unit (cloudnotes.service) | systemd on the VM | Identical mechanism -- auto-start and auto-restart a process -- just running on a cloud VM instead of locally. |
| PostgreSQL on WSL2 | Cloud SQL (managed Postgres) | Both are the persistent relational datastore the app connects to; Cloud SQL is the same engine, managed and off-box. |
| .env / environment variables | Instance metadata / Secret Manager | Both inject config and secrets into the app at runtime without hardcoding them in the repo. |
