
terraform {

backend "gcs" {

bucket = "fdreu-prod-terraform-state"

prefix = "terraform/Bigquery"

}

}




