# Evidence Index

Unknown metadata is marked UNKNOWN. A configuration file proves a control is defined, not that it works.

| ID | Path | Description | Date | Environment | Commit | Expected | Observed | Limits | Checks supported |
|----|------|-------------|------|-------------|--------|----------|----------|--------|------------------|
| E01 | `Dockerfile` | Container image build definition | 2026-09-28 | local | 816618f | Image builds and runs | Not re-run in this review | Definition only | R1 (indirect) |
| E02 | `k8s/deployment.yaml` | Kubernetes Deployment | 2026-09-28 | local Minikube | 04ade85 | Pods run, recover on failure | Not re-tested in this review | Definition only; no failure test | R1, R3 |
| E03 | `k8s/service.yaml` | Kubernetes Service | 2026-09-28 | local Minikube | ca75edd | Service routes to pods | Not re-tested in this review | Definition only | S4 |
| E04 | `infra/` (Terraform modules: compute, database, iam, network, storage) | Infrastructure as code | UNKNOWN | local, validate only | 4ee82e9 | `terraform validate` passes | Commit message states validated locally, zero cost; no output saved | Never applied; no real cloud resources | S2, C4 |
| E05 | `.gitignore` | Excludes tfvars, tfstate, .env, local DB | 2026-11-02 | local | 2a6e2e8, b43cd70 | Secrets/DB not tracked | Files untracked after commit | Does not prove history is clean | S1 |

## Evidence validity
No changes to Dockerfile or k8s/ between ca75edd (capture) and the reviewed commit b43cd70, so E01-E03 apply to the reviewed revision.

## Missing evidence (no artifact exists)
Probe/failover test, dashboards and alert, logs, rollout/rollback, runbooks, image scan, secret scan, backup, restore, RTO/RPO timing, cost estimate. Each stays UNVERIFIED with a plan in the checklist.


Note: database/cloudnotes.db was tracked from commit d52e916 (original assignment repository) and untracked in commit b43cd70. File size 12,288 bytes; row contents not reviewed; not used as restore evidence.




Observed in k8s/deployment.yaml (E02/E07): replicas: 2, image cloudnotes:v1 (imagePullPolicy IfNotPresent, local build), containerPort 5000. No readiness/liveness probes. No resource requests/limits.

## Additional captured evidence

| ID | Path | Description | Date | Environment | Commit | Expected | Observed | Limits | Checks supported |
|----|------|-------------|------|-------------|--------|----------|----------|--------|------------------|
| E06 | production-readiness/evidence/local-baseline.txt | Git state and local tool versions | 2026-11-02 | local | b43cd700e4ebc10e93166dd5b1444d765cfa93ed | Records reviewed revision | Captured | Shows state only, proves no control works | scope and targets |
| E07 | production-readiness/evidence/runtime-configuration.txt | Dockerfile and k8s manifests as reviewed | 2026-11-02 | local | b43cd700e4ebc10e93166dd5b1444d765cfa93ed | Controls defined | Captured: replicas 2, no probes, no resource limits | Definition only, no test run | R1, R2, R3, S4 |
