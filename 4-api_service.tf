#cloud trigger that builds image
variable "project_id" {
  type    = string
  default = "double-genius-466920-b8"
}
variable "region" {
  type    = string
  default = "us-central1"
}

# Artifact Registry repo for your Python image
resource "google_artifact_registry_repository" "python_service" {
  repository_id = "python-service"
  format        = "DOCKER"
  location      = var.region
}

resource "google_secret_manager_secret" "github-token-secret" {
  secret_id = "github-token-secret"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "github-token-secret-version" {
  secret = google_secret_manager_secret.github-token-secret.id
  secret_data = file("../pat.txt")
}

data "google_iam_policy" "p4sa-secretAccessor" {
  binding {
    role = "roles/secretmanager.secretAccessor"
    // Here, 123456789 is the Google Cloud project number for the project that contains the connection.
    members = ["serviceAccount:service-${data.google_project.current.number}@gcp-sa-apigateway.iam.gserviceaccount.com"]
  }
}

resource "google_secret_manager_secret_iam_policy" "policy" {
  secret_id = google_secret_manager_secret.github-token-secret.secret_id
  policy_data = data.google_iam_policy.p4sa-secretAccessor.policy_data
}

resource "google_cloudbuildv2_connection" "my-connection" {
  location = "us-central1"
  name = "my-connection"

  github_config {
    app_installation_id = 123123
    authorizer_credential {
      oauth_token_secret_version = google_secret_manager_secret_version.github-token-secret-version.id
    }
  }
}

resource "google_cloudbuildv2_repository" "my-repository" {
  location = "us-central1"
  name = "resume.jesseislam.com.backend"
  parent_connection = google_cloudbuildv2_connection.my-connection.name
  remote_uri = "https://github.com/Jesse-Islam/resume.jesseislam.com.backend.git"
}

#set up service account for cloud runs
resource "google_service_account" "cloud_run_sa" {
  account_id   = "cloud-run-sa"
  display_name = "Cloud Run runtime SA"
}

resource "google_project_iam_member" "firestore_access" {
  project = var.project_id
  role    = "roles/datastore.user"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}

resource "google_project_iam_member" "run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}

#deploy cloud run
resource "google_cloud_run_service" "python_service" {
  name     = "python-service"
  location = var.region

  template {
    spec {
      service_account_name = google_service_account.cloud_run_sa.email

      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.python_service.repository_id}/python-service:latest"

        env {
          name  = "GOOGLE_CLOUD_PROJECT"
          value = var.project_id
        }
        # add any other env vars your main.py needs
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

