# resume.jesseislam.terraform

This repository contains all of the Terraform code and CI/CD configuration to provision and manage the **backend** infrastructure for [resume.jesseislam.com](https://resume.jesseislam.com).  Everything—from state storage to API Gateway, Firestore, and Cloud Run—is defined here as code.

<img width="3840" height="1716" alt="Image" src="https://github.com/user-attachments/assets/8677f884-1e78-476f-ad30-61b3c000fe63" />
---

## What’s in here

- **CI/CD pipeline** via Cloud Build  
  - Runs unit tests (pytest)  
  - Applies Terraform  
  - Builds, pushes, and deploys your Docker image to Cloud Run  
- **Remote state** stored in a GCS bucket  
- **Secrets**  
  - Secure GitHub PAT in Secret Manager  
  - IAM binding so Cloud Build can read it  
- **Artifact Registry** Docker repository  
- **Firestore** (Native mode) database for page view counts  
- **API Gateway** (with `openapi.yaml`) to front the Cloud Run service  
- **Cloud Run** service hosting your Flask endpoint  
- **Service account** with the right IAM roles  

---

##  Prerequisites

1. **Google Cloud SDK** installed and authenticated.  
2. **Terraform** >= 1.1.0.  
3. A GCP project (e.g. `double-genius-466920-b8`) with billing enabled.  
4. A **GitHub App** installation on your resume repo, and a **PAT** with `repo` scope.  
5. A GCS bucket for Terraform state (e.g. `gs://double-genius-terraform-state`).  

