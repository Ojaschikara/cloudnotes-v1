# GCP Firewall Mapping

| Local Rule | Direction | Source | Port | GCP Equivalent Rule |
|---|---|---|---|---|
| Allow CloudNotes | Ingress | 0.0.0.0/0 | 5000 | Allow tcp:5000 |
| Block PostgreSQL | Ingress | Public Internet | 5432 | Deny tcp:5432 (no rule = implicit deny) |
| Restrict SSH | Ingress | Rate-limited via ufw limit | 22 | Allow tcp:22 from trusted source IP only |

- **Allow CloudNotes (5000):** protects nothing by itself — it's the intended public entry point, so this rule is what makes the app reachable.
- **Block PostgreSQL (5432):** protects the database tier from direct public access; only the app (on localhost) should reach it.
- **Restrict SSH (22):** protects administrative access from brute-force/unrestricted login attempts; ufw's `limit` throttles repeated connection attempts from the same IP.

## Security Posture Summary

**Allowed traffic:** Only port 5000 (CloudNotes web app) is open to all sources — this is the single public entry point.

**Denied traffic:** Port 5432 (PostgreSQL) is blocked from external access; the database is only reachable by the app itself on localhost, never directly from the internet.

**Database protection:** PostgreSQL has no public-facing firewall rule allowing it, so any external connection attempt is refused. Only the CloudNotes process (running on the same machine) can reach it over localhost.

**Administrative access control:** SSH (port 22) is rate-limited via `ufw limit`, which blocks repeated connection attempts from the same IP within 30 seconds — mitigating brute-force login attempts even though direct SSH isn't fully open to the public.

**Cloud translation:** In GCP, this same posture is achieved with VPC firewall rules: an ingress rule allowing tcp:5000 from 0.0.0.0/0 (public web tier), no rule for tcp:5432 (implicit deny — GCP denies by default unless explicitly allowed), and an ingress rule for tcp:22 restricted to a trusted source IP range instead of 0.0.0.0/0. This mirrors the least-privilege principle: only the minimum necessary ports are open, and only to the minimum necessary sources.
