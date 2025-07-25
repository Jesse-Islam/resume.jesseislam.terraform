#resource "google_api_gateway_api" "app" {
#  provider = google-beta
#  api_id   = "app-api"
#}

#resource "google_api_gateway_api_config" "app" {
#  provider      = google-beta
#  api           = google_api_gateway_api.app.api_id
#  api_config_id = "v1"

#  openapi_documents {
#    document {
#      # This is just the "logical" name of the file in your Gateway.
#      path     = "openapi.yaml"
#
#      # These are the actual bytes of your spec, base‑64 encoded.
#      contents = filebase64("${path.module}/openapi.yaml")
#    }
#  }
#}


#resource "google_api_gateway_gateway" "app" {
#  provider   = google-beta
#  gateway_id = "app-gateway"
#  api_config = google_api_gateway_api_config.app.name
#}

output "run_url" {
  value = google_cloud_run_service.python_service.status[0].url
}

output "gateway_url" {
  value = google_api_gateway_gateway.app.default_hostname
}
