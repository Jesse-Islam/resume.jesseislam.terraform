variable "project_id" {
  type    = string
  default = "double-genius-466920-b8"
}
variable "region" {
  type    = string
  default = "us-central1"
}
variable "github_pat" {
  description = "GitHub PAT for creating the secret version"
  type        = string
  sensitive   = true
}

variable "app_installation_id" {
  description = "GitHub App installation ID"
  type        = number
}