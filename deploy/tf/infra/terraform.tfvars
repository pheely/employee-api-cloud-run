project_id         = "ibcwe-event-layer-f3ccf6d9"
region             = "us-central1"
services           = ["cloudbuild", "run", "secretmanager", "artifactregistry", "sqladmin", "sql-component", "pubsub", "redis", "vpcaccess"]
vpc_con            = "employee"
vpc_con_cidr       = "10.0.0.0/28"
redis_name         = "employee"
redis_tier         = "BASIC"
redis_size         = "1"
db_settings = {
  user_name        = "user"
  instance_name    = "sql-db"
  db_name          = "hr"
  database_tier    = "db-f1-micro"
  default_user     = "default"
  db_user          = "user"
  database_version = "MYSQL_8_0"
}
secret_root_pw     = "employee-db-root-pw"
secret_user_pw     = "employee-db-user-pw"
sa_name            = "employee-api-invoker"
sa_display_name    = "SA calling employee api"
roles	           = ["run/invoker"]
topic_name	   = "employee_creation"

