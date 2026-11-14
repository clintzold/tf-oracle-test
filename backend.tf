terraform {
  backend "s3" {
    bucket                      = "tfstate"
    key                         = "prod/terraform.tfstate"
    region                      = "ca-toronto-1"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    use_path_style              = true
    use_lockfile                = true

    endpoints = {
      s3 = "https://yzbdohe7open.compat.objectstorage.ca-toronto-1.oraclecloud.com"
    }
  }
}
