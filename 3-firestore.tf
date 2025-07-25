
resource "google_firestore_database" "default" {
  name        = "(default)"
  project     = var.project_id
  location_id = var.region
  type       = "FIRESTORE_NATIVE"

  depends_on = [
    google_project_service.enabled["firestore.googleapis.com"]
  ]
}
