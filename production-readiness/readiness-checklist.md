# CloudNotes Production Readiness Checklist

## Review declaration
- Reviewed commit: b43cd700e4ebc10e93166dd5b1444d765cfa93ed
- Assessment date: 2026-11-02
- Environment: local developer machine (Windows, PowerShell); Minikube manifests; Terraform validated locally only (no cloud apply, zero cost)
- Intended release scope: local/simulated CloudNotes (Flask app, Docker image, Kubernetes Deployment + Service). Not a real production release.
- Workload/data assumptions: single developer, test notes only, no real user data, no real traffic.
- Targets: SLO = NOT DEFINED (gap). RTO = NOT DEFINED (gap). RPO = NOT DEFINED (gap). No target was agreed in the course material for this repo, so none is invented here.

## Scoring
PASS = 2, PARTIAL = 1, FAIL = 0, UNVERIFIED = 0. Gates: R2, O2, S1, S2, D2, D3.
NOTE: check titles below are my working wording. Align the wording with the Technical Aid checklist before submitting.

## Reliability
| ID | Check | Status | Evidence | Finding | Owner | Next action / retest |
|----|-------|--------|----------|---------|-------|----------------------|
| R1 | Multiple replicas / self-healing defined | PARTIAL | E02, E07 | replicas: 2 defined in deployment.yaml; recovery never tested; image is a local build (cloudnotes:v1, IfNotPresent) | Ojas | Inspect `k8s/deployment.yaml`, then run pod-delete test; retest passes if pod is recreated and Service answers |
| R2 (GATE) | Health probes and failure recovery tested | FAIL | E07 | No readiness or liveness probes defined in deployment.yaml; no pod-kill output | Ojas | Add readiness/liveness probes, delete a pod, capture `kubectl get pods -w` output and recovery time |
| R3 | Resource requests/limits set | FAIL | E07 | No resources.requests or limits in deployment.yaml | Ojas | Confirm fields exist; capture `kubectl describe pod` |
| R4 | Rollout/rollback strategy exercised | UNVERIFIED | MISSING | No rollout or rollback record | Ojas | Run `kubectl rollout undo`, save output |

## Observability
| ID | Check | Status | Evidence | Finding | Owner | Next action / retest |
|----|-------|--------|----------|---------|-------|----------------------|
| O1 | Metrics collected | UNVERIFIED | MISSING | Prometheus/Grafana files are not in the repo | Ojas | Commit compose + prometheus.yml, show targets UP |
| O2 (GATE) | Golden-signals dashboard and alert that fires | UNVERIFIED | MISSING | No dashboard/alert artifacts available | Ojas | Rebuild stack, trigger alert, save screenshots |
| O3 | Logs accessible | UNVERIFIED | MISSING | No log capture saved | Ojas | Save `kubectl logs` output |
| O4 | Incident response runbook | UNVERIFIED | MISSING | None in repo | Ojas | Write runbook, test it once |

## Security
| ID | Check | Status | Evidence | Finding | Owner | Next action / retest |
|----|-------|--------|----------|---------|-------|----------------------|
| S1 (GATE) | Secrets handled safely | UNVERIFIED | E05 (partial) | `.gitignore` now excludes tfvars/state/.env; no secret scan run | Ojas | Run a secret scan on full history, save output |
| S2 (GATE) | Access control / least privilege | UNVERIFIED | E04 (definition only) | IAM module defined in Terraform, never applied or tested | Ojas | Review IAM roles, test access boundary |
| S3 | Image/dependency scanning | UNVERIFIED | MISSING | No scan output | Ojas | Run image scan, save report |
| S4 | Network exposure reviewed | UNVERIFIED | E03 | Service type not assessed against threat model | Ojas | Document exposure, test from outside |

## Disaster recovery
| ID | Check | Status | Evidence | Finding | Owner | Next action / retest |
|----|-------|--------|----------|---------|-------|----------------------|
| D1 | Backup defined | UNVERIFIED | MISSING | No backup procedure committed (local SQLite file is untracked) | Ojas | Define and run backup |
| D2 (GATE) | Restore tested with data integrity | UNVERIFIED | MISSING | No restore ever performed | Ojas | Restore to a clean instance, compare row counts/checksums |
| D3 (GATE) | RTO/RPO measured against targets | UNVERIFIED | MISSING | Targets undefined, nothing measured | Ojas | Agree targets, time a restore |
| D4 | DR runbook | UNVERIFIED | MISSING | None | Ojas | Write runbook |

## Cost
| ID | Check | Status | Evidence | Finding | Owner | Next action / retest |
|----|-------|--------|----------|---------|-------|----------------------|
| C1 | Estimate with assumptions | UNVERIFIED | MISSING | No estimate in repo | Ojas | Write estimate with assumptions and scope, label as estimate |
| C2 | Right-sizing reviewed | UNVERIFIED | MISSING | None | Ojas | Compare limits to observed usage |
| C3 | Budget alert defined | UNVERIFIED | MISSING | None | Ojas | Define alert threshold |
| C4 | Idle resource cleanup | UNVERIFIED | E04 (partial) | Terraform has no live resources; destroy path not tested | Ojas | Run `terraform plan` and document |

Scores are in `readiness-verdict.md`. Before submitting, upgrade any row to PARTIAL/PASS only after you have attached real output.


