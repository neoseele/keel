variable "project_id" {
    description = "GCP Project id"
}

variable "zone" {
  description = "Zone where to deploy resources"
  default = "us-east1-a"
}

variable "cluster_name" {
    description = "Name of the cluster"
    default = "simple-zonal-cluster"
}