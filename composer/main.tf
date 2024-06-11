locals {
  gcs_bucket = one(regex("(?://)([-\\w]*)(?:/)", google_composer_environment.one.config.0.dag_gcs_prefix))
  pkg_obj_list = [
    for p in var.pypi_packages :
    regex("^(?P<name>[a-zA-Z0-9-]+)(?P<ver>[0-9=><!~.,*\\s]+)$", p)
    ]
  pypi_pkgs = {
    for o in local.pkg_obj_list : o.name => o.ver
  }
  env_obj_list = [
    for v in var.env_variables :
    regex("^(?P<name>[A-Z0-9_]+)=(?P<ver>[\\w._-]+)$", v)
  ]
  env_vars = {
    for o in local.env_obj_list : o.name => o.ver
  }
}
resource "google_composer_environment" "one" {
  name    = var.name
  project = var.project
  region  = var.region
  config {
    node_config {
      network         = "projects/${var.project}/global/networks/${var.network}"
      subnetwork      = "projects/${var.project}/regions/${var.region}/subnetworks/${var.subnetwork}"
      service_account = "${var.sa_user}@${var.project}.iam.gserviceaccount.com"
      ip_allocation_policy {
        cluster_secondary_range_name  = "pod-ip-address-allocation"
        services_secondary_range_name = "service-ip-address-allocation"
      }
    }
    private_environment_config {
      enable_privately_used_public_ips = true
    }
    encryption_config {
      kms_key_name = "projects/${var.kms_project}/locations/${var.region}/keyRings/composer/cryptoKeys/${var.kms_key}"
    }
    software_config {
      image_version = "composer-2.5.3-airflow-2.6.3"
      env_variables = local.env_vars
      pypi_packages = local.pypi_pkgs
    }
  }
}
resource "google_storage_bucket_object" "pip_conf" {
  name    = "config/pip/pip.conf"
  content = templatefile("pip.tftpl", { loc = var.region, proj = var.project, repo = var.repo_name })
  bucket  = local.gcs_bucket
}
 
resource "google_artifact_registry_repository" "composer_pypi" {
  repository_id = var.repo_name
  location      = var.region
  project       = var.project
  format        = "PYTHON"
  mode          = "STANDARD_REPOSITORY"
  kms_key_name  = "projects/${var.kms_project}/locations/${var.region}/keyRings/ar/cryptoKeys/${var.kms_repo_key}"
}
