terraform {

backend "gcs" {

bucket = "fdreu-dev-terraform-state"

prefix = "terraform/GCS"

}




