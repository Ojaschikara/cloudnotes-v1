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

## E08 (saved command output)
| ID | Path | Type | Description | Captured | Environment | Source commit | Expected | Observed | Limits | Checks supported |
|----|------|------|-------------|----------|-------------|---------------|----------|----------|--------|------------------|
| E08 | production-readiness/evidence/terraform-validate.txt | OUTPUT | Result of `terraform -chdir=infra validate` run after `init -backend=false` | 2026-11-02 17:04 | local, Windows PowerShell | b43cd700e4ebc10e93166dd5b1444d765cfa93ed (reviewed revision) | Configuration is valid | "Success! The configuration is valid." | Syntax and reference check only. Nothing deployed; no plan or apply; no cloud resources; no variables supplied | S2, C4 (definition validity only; no score change) |

## Evidence type (CONFIG = defines a control; OUTPUT = saved command or test result)
| ID | Type | What it can prove | What it cannot prove |
|----|------|-------------------|----------------------|
| E01-E05 | CONFIG | A control is defined in the repository | That it works |
| E06 | OUTPUT | Git state and tool versions at capture | That any control works |
| E07 | CONFIG (copy of E01-E03) | What the manifests contained at the reviewed commit | That it works |
| E08 | OUTPUT | Terraform syntax validity at the reviewed commit | That anything was deployed, secured or recovered |

## Per-check records for checks with no artifact (MISSING)
Capture date for all rows: 2026-11-02. Source commit: not applicable (no artifact exists). Environment: local.

| ID | Check | Path | Expected | Observed | Limits | Plan, command and pass condition |
|----|-------|------|----------|----------|--------|----------------------------------|
| M-R2 | R2 | NONE (absence shown in E02) | Probes defined and a deleted pod recovers | No probes defined; no failure test run | Recovery time cannot be assessed | Add readiness/liveness probes. Run `kubectl delete pod <name>` then `kubectl get pods -w`. Pass: replacement pod Ready and Service answers within the stated time |
| M-R4 | R4 | NONE | Rollout and rollback exercised | No rollout record | None | Run `kubectl rollout undo deployment/cloudnotes`, save `kubectl rollout history`. Pass: previous revision serving |
| M-O1 | O1 | NONE | Metrics collected from the app | Prometheus files are not in this repo | Earlier work not committed | Commit compose and prometheus.yml; save the targets page. Pass: app target UP |
| M-O2 | O2 | NONE | Dashboard shows golden signals; alert fires | No dashboard or alert artifact | Alerting cannot be assessed | Stop the app; capture the firing alert and dashboard. Pass: alert fires within its rule window |
| M-O3 | O3 | NONE | Logs retrievable | No log capture saved | None | Run `kubectl logs deployment/cloudnotes > logs.txt`, redact, commit. Pass: request lines present |
| M-O4 | O4 | NONE | Incident runbook tested once | No runbook in repo | None | Write the runbook and run it against a pod failure. Pass: steps restore service |
| M-S1 | S1 | NONE (partial control in E05) | Secret scan of full history is clean | No scan run | History not checked | Run a secret scanner over history, save output. Pass: zero findings |
| M-S2 | S2 | NONE (definition only in E04, E08) | Access boundary tested | IAM module never applied | Least privilege cannot be assessed | Review roles and test one denied action. Pass: denied as expected |
| M-S3 | S3 | NONE | Image scan report | None | None | Scan cloudnotes:v1, save report. Pass: no critical findings |
| M-D1 | D1 | NONE | Backup procedure runs | No backup ever run | SQLite file is untracked | Copy the database file to a timestamped backup. Pass: backup size equals source |
| M-D2 | D2 | NONE | Restore passes with data integrity | No restore ever run | Local restore is not regional recovery | Restore the backup to a clean copy; compare table row counts or checksums. Pass: counts match |
| M-D3 | D3 | NONE | Restore time and data loss within targets | Targets undefined; nothing measured | Cannot assess without targets | Agree RTO and RPO, time the restore, compare the newest record. Pass: time within RTO and loss within RPO |
| M-D4 | D4 | NONE | DR runbook | None | None | Write steps from the D1-D3 drill. Pass: another person can follow it |
| M-C1 | C1 | NONE | Estimate with assumptions and scope | No estimate | None | Write an estimate with assumptions, labelled as an estimate. Pass: assumptions stated |
| M-C2 | C2 | NONE | Right-sizing against observed use | No usage data | None | Compare limits with `kubectl top pod`. Pass: limits justified |
| M-C3 | C3 | NONE | Budget alert defined | None | None | Define a threshold in the estimate. Pass: threshold documented |
| M-C4 | C4 | NONE (partial in E04, E08) | Idle resources removed | Nothing deployed | Destroy path not tested | Run `terraform plan -destroy`, save output. Pass: plan lists the expected resources |
