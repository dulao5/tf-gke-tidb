variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "gcp-jp-tech-team"
}

variable "region" {
  description = "Region for deployment"
  default     = "asia-northeast1"
}

variable "network" {
  description = "VPC network name"
  default     = "tidb-vpc"
}

variable "subnetwork" {
  description = "Subnet name"
  default     = "tidb-subnet"
}

variable "node_type" {
  description = "GCE instance type for nodes"
  default     = "e2-standard-4"
}