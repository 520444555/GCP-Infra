# Create 1st Buckets 
resource "google_storage_bucket" "fdreu_gcs_01" {
  name = "fdreu-dev-imagefactory"
  project = "hsbc-10534429-fdreu-dev"
  location = "europe-west2"
  storage_class = "REGIONAL"
  force_destroy = true
  uniform_bucket_level_access = true
 
  versioning {
    enabled = "true"
  }
  
  lifecycle_rule {
  condition {
    age = 45
  }
  action {
    type = "SetStorageClass"
    storage_class = "NEARLINE"
  }
 }
encryption {
    default_kms_key_name = "projects/hsbc-6320774-kms-dev/locations/europe-west2/keyRings/cloudStorage/cryptoKeys/cloudStorage"
  }
 
  labels = {
    name        = "fdreu-dev-imagefactory"
    project     = "hsbc-10534429-fdreu-dev"
    environment = "dev"
    purpose     = "imagefactory"
    terraformed = "true"
  }
}
 
resource "google_storage_bucket_iam_member" "devops-admin-01" {
  bucket  = google_storage_bucket.fdreu_gcs_01.name
  role = "roles/storage.objectAdmin"  
  member = "group:gcp.hsbc-10534429-fdreu-dev.devops-team-priv@hsbc.com"
   
}
