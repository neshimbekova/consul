terraform {
  backend "s3" {
    bucket = "acirrustech-iaac"
    region = "eu-west-1"
    key    = "consul/infra"
  }
}
