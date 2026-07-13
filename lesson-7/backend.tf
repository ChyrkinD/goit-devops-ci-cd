# Bootstrap phase: Use local backend until S3 bucket is created
# After terraform apply, uncomment the S3 backend block below and run:
#   terraform init -migrate-state

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

# Production backend configuration (use after S3 bucket is created)
# terraform {
#   backend "s3" {
#     bucket         = "terraform-state-bucket-chyrkin"
#     key            = "lesson-5/terraform.tfstate"
#     region         = "eu-north-1"
#     dynamodb_table = "terraform-locks-lesson-5-chyrkin"
#     encrypt        = true
#   }
# }

