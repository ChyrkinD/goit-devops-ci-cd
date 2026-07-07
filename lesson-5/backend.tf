terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-chyrkin"   # Назва S3-бакета
    key            = "lesson-5/terraform.tfstate"       # Шлях до файлу стейту
    region         = "eu-north-1"                       # Регіон AWS
    dynamodb_table = "terraform-locks-lesson-5-chyrkin" # Назва таблиці DynamoDB
    encrypt        = true                               # Шифрування файлу стейту
  }
}

