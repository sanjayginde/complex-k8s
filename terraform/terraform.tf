terraform {
  backend "gcs" {
    bucket  = "complex-k8s.sanjayginde.dev"
    prefix  = "terraform/state"
  }
}

provider "google" {
  credentials = file("~/.gcloud/complex-k8s.json")
  project     = "complex-k8s-271222"
  region      = "us-east1"
}

variable "region" {
  default = "us-east1"
}

variable "project" {
  default = "complex-k8s"
}

output "cluster_region" {
  value = var.region
}
