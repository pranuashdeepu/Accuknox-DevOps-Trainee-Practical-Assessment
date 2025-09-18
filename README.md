# Accuknox DevOps Trainee Practical Assessment - Wisecow

This repository is a submission-ready project for the Accuknox DevOps practical assessment.
It contains:

- A small Wisecow HTTP app (app/server.py) that returns a cowsay fortune.
- Dockerfile to build the image.
- Kubernetes manifests (deployment + NodePort service) in k8s/.
- GitHub Actions workflow (.github/workflows/ci.yml) to build & push image to GHCR.
- Two helper scripts in scripts/: system health monitor and app health checker.
- Optional KubeArmor policy in ksp/ for extra credit.

## How to use (quick)

1. Unzip this folder into your local clone or create a new repo and copy files.
2. Commit and push to GitHub:
   ```
   git add .
   git commit -m "Initial commit - Wisecow DevOps Project"
   git branch -M main
   git push origin main
   ```
3. Add GitHub Secret: `GHCR_PAT` (Personal Access Token with `write:packages` permission).
   - Go to Settings → Secrets → Actions → New repository secret.
4. The GitHub Actions workflow will build the image and push to:
   `ghcr.io/pranuashdeepu/wisecow:latest`

## Run locally with Docker
```
docker build -t wisecow:local .
docker run -p 4499:4499 wisecow:local
curl http://localhost:4499/
```

## Deploy to Kubernetes (Minikube / Kind / cluster)
1. Update k8s/deployment.yaml image if you prefer a different tag.
2. Apply manifests:
   ```
   kubectl apply -f k8s/deployment.yaml
   kubectl apply -f k8s/service.yaml
   ```
3. Check pods and service:
   ```
   kubectl get pods -l app=wisecow
   kubectl get svc wisecow-service
   ```
4. If using Minikube, access via:
   ```
   minikube service wisecow-service --url
   # or use NodePort on node IP: http://<node-ip>:30099
   ```

## Scripts
- `scripts/system_health_monitor.sh` - checks CPU/memory/disk and logs alerts.
- `scripts/app_health_checker.sh` - checks HTTP status of an endpoint.

## Notes
- Do NOT commit GHCR_PAT or any kubeconfigs.
- This is a CI-only workflow (build & push). Deployment is manual to keep things simple and robust.

Good luck with your submission! If you want, I can:
- Push these files directly to your GitHub repo (requires that you add me as collaborator or give permission).
- Or guide you step-by-step to push them yourself.
