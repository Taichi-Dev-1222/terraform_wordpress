terraform {
  backend "s3" {
    bucket         = "tfstate-bucket-vpc-202506"
    key            = "prd/vpc/terraform.tfstate"
    region         = "ap-northeast-1"   
    encrypt        = true                   
  }
}