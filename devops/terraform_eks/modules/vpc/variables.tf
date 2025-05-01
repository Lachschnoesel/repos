variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "availability_zone" {
  description = "List of the availibililty zones"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Cidr block of the first private Subnet"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Cidr block of the first public subnet"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name for the EKS cluster "
  type        = string
}
