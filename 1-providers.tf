terraform {
  # Lock to a compatible Terraform version
  required_version = ">= 1.1.0"

  required_providers {
    # The stable Google provider (GA features)
    google = {
      source  = "hashicorp/google"
      # match any 5.x release; upgrade on minor bumps but avoid v6.0 breaking changes
      version = ">= 5.0.0"
    }

    # The Beta provider (beta-only features, like API Gateway)
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.0.0"
    }
  }
  backend "gcs" {
    # replace with a bucket name you control
    bucket = "double-genius-terraform-state"
    # any path prefix inside the bucket
    prefix = "resume-backend"
  }
}

# Default (GA) provider config
provider "google" {
  project = var.project_id
  region  = var.region
}

# Beta provider config—refer to this in any beta‐only resources
provider "google-beta" {
  project = var.project_id
  region  = var.region
}
