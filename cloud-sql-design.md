# Cloud SQL Architecture Design — CloudNotes

## Database Instance
- Engine: Cloud SQL for PostgreSQL (matches the local Postgres already in use, no query rewrites needed)
- Instance tier: db-custom-1-3840 (1 vCPU / 3.75GB) — sufficient for CloudNotes' light read/write load; scalable later
- Region: us-central1 (or nearest to primary users) — chosen to minimize latency to the Compute Engine VM running the app

## Connectivity
- Private IP only — the instance has no public IP, reachable only from within the VPC
- The CloudNotes VM connects over the internal VPC network
- Cloud SQL Auth Proxy used for local developer connections, so no IP allowlisting is needed and connections are automatically encrypted

## Security
- Database credentials stored in Secret Manager, not in code or committed config — the app reads DATABASE_URL from a secret at startup instead of a plain .env file
- IAM database authentication controls which service accounts/users can connect
- No public IP on the instance — direct internet access to the database is impossible, matching the local ufw rule blocking 5432 externally

## Reliability
- Automated daily backups enabled, with point-in-time recovery
- Backup retention: 7 days (adjustable based on compliance needs)
- Maintenance window scheduled during low-traffic hours (e.g. Sunday 3-4am) to avoid disrupting users

## High Availability
- Regional (HA) configuration: a standby replica in a second zone within the same region
- Automatic failover to the standby if the primary zone fails, with minimal downtime
- Disaster recovery: cross-region backup replication for recovery from a full regional outage

## Cost Considerations
- Single-zone deployment: lower cost, no automatic failover — acceptable for early development/staging
- Regional HA deployment: roughly 2x the cost of single-zone (standby replica is billed), but eliminates single-zone downtime risk
- **Recommendation for CloudNotes:** start with single-zone for development/staging to control cost; move to regional HA once the app has real users, since note data loss or downtime would directly affect user trust

## Why this beats the local deployment
Compared to the local WSL2 + PostgreSQL setup, Cloud SQL adds: automated backups (local setup has none), high availability via failover (local setup is a single point of failure), IAM + Secret Manager-based access control (local setup uses a static .env password), and elimination of any public exposure risk to the database (enforced by GCP's private IP model rather than manually-configured ufw rules).
