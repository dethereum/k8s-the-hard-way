variable "project_id" {
  type        = string
  description = "The id of the google project in GCP"
}

variable "controller_names" {
  type    = set(string)
  default = ["alpha", "beta", "gamma"]
}

variable "worker_names" {
  type    = set(string)
  default = ["alpha", "beta", "gamma"]
}