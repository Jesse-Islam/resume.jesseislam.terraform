data "google_project" "current" {}

resource "google_cloud_run_service_iam_member" "gateway_invoker" {
  project  = var.project_id
  location = var.region
  service  = google_cloud_run_service.python_service.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:service-${data.google_project.current.number}@gcp-sa-apigateway.iam.gserviceaccount.com"
}
