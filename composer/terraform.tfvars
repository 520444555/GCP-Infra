name          = "fdreu-dev-c1"

project       = "hsbc-10534429-fdreu-dev"

region        = "europe-west2"

zone          = "europe-west2-b"

network       = "hsbc-10534429-fdreu-dev-cinternal-vpc1"

subnetwork    = "cinternal-vpc1-europe-west2-cmp"

kms_project   = "hsbc-6320774-kms-dev"

kms_key       = "fdrcmpSharedKey"

sa_user       = "terraform-jenkins-usr"

repo_name     = "composer-pypi"

kms_repo_key  = "arSharedKey"

pypi_packages = []

env_variables = ["AIRFLOW_VAR_ENV=dev", "PROXY_IP=192.168.127.197"]




