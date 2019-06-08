terraform {
  backend "s3" {
    bucket = "acirrustech-iaa"
    region = "eu-west-1"
    key    = "consul"
  }
}
