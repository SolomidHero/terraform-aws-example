variable "region" {
  default = "eu-central-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet" {
  type    = map(list(string))
  default = {
    cidr = ["10.0.1.0/24", "10.0.2.0/24"]
    availability_zone = ["eu-central-1a", "eu-central-1b"]
  }
}
