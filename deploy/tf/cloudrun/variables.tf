variable "project_id" {
  type        = string
  default     = "ibcwe-event-layer-f3ccf6d9"
  description = "The Google Cloud Project ID to use"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "The Google Cloud compute region to use"
}

variable "service_name" {
  description = "Cloud Run service name"
  type        = string
}

variable "image_name" {
  description = "Image tag"
  type        = string
}

variable "sa" {
  description = "SA associated with the service"
  type        = string
}
variable "sub_name" {
  description = "push subscription"
  type        = string
}
variable "push_path" {
  description = "Employee API path to push message"
  type        = string
}
