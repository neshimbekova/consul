instance_type = "t2.micro"

key_name = "app-rsa"

ami = "ami-0ff760d16d9497662" # Centos7  image

vpc_id = "vpc-908caaf6"

user = "centos"

ssh_key_location = "/ssh_keys/app_rsa" #Import pub key pair to aws as "terraform"

zone_id = "Z32OHGRMBVZ9LR" #Add hosted DNS zone ID here

domain = "acirrustech.com"

region = "eu-west-1"
