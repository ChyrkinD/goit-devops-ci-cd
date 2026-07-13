terraform {
  backend "s3" {
    bucket       = "terraform-state-bucket-chyrkin"
    key          = "lesson-7/terraform.tfstate"
    region       = "eu-north-1"
    encrypt      = true
    use_lockfile = true
  }
}

