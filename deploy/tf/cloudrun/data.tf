data "terraform_remote_state" "infra" {
  backend = "gcs"
  config = {
    bucket = "ibcwe-event-layer-f3ccf6d9-tf-state"
    prefix = "run-poc/employee/infra"
  }
}
