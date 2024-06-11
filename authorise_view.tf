locals {
  list_of_ds = jsondecode(file("datasets.auto.tfvars.json"))
}
locals {
  bq_ds_roles = jsondecode(file("dataset_role_access.auto.tfvars.json"))
}
 
resource "google_bigquery_dataset" "main" {
  for_each                   = toset(local.list_of_ds.datasets)
  project                    = var.project
  dataset_id                 = each.value
  location                   = "europe-west2"
  delete_contents_on_destroy = true
  
  default_encryption_configuration {
    kms_key_name = "projects/hsbc-6320774-kms-prod/locations/europe-west2/keyRings/bigQuery/cryptoKeys/HSMbqSharedKey"
  }
  
  dynamic "access" {
    for_each = local.bq_ds_roles.roles
    content {
      role          = access.value.role
      user_by_email = access.value.user_by_email
      group_by_email = access.value.group_by_email
    }
  }
dynamic "access" {
    for_each = jsondecode(file("${each.value}.auto.tfvars.json")).roles
    content {
      role           = access.value.role
      user_by_email  = access.value.user_by_email
      group_by_email = access.value.group_by_email
    }
  }
 
  dynamic "access" {
    for_each = jsondecode(file("${each.value}.auto.tfvars.json")).views
    content {
      view {
        dataset_id = access.value.dataset_id
        project_id = access.value.project_id
        table_id   = access.value.table_id
      }
    }
  }
}
