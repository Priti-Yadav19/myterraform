terraform {
    backend "s3-bucket" {
        bucket = "rudraawsbucket123"
        key    = "development/terraform_state"
        region = "us-east-1"
    }
}