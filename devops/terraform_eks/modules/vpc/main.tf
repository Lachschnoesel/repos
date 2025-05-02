resource "aws_vpc" "main" {
  enable_dns_support = true

  tags = {
    Name                                        = "${var.cluster_name}-vpc"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "subnet_private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = {
    Name                                        = "${var.cluster_name}-private-${count.index + 1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

resource "aws_subnet" "subnet-public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zone[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name                                        = "${var.cluster_name}-private-${count.index + 1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

resource "aws_internet_gateway" "public_gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.cluster_name}-igw"
  }
}

resource "aws_route_table" "puplic_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_gateway.id
  }
  tags = {
    Name = "${var.cluster_name}-public"
  }
}

resource "aws_route_table_association" "pupblic_rta" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.subnet-public[count.index].id
  route_table_id = aws_route_table.puplic_rt.id
}

resource "aws_nat_gateway" "private_gateway" {
  count         = length(var.private_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.subnet_private[count.index].id

  tags = {
    Name = "${var.cluster_name}-nat_${count.index + 1}"
  }
}

resource "aws_route_table" "private_rt" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.private_gateway[count.index].id
  }

  tags = {
    Name = "${var.cluster_name}-private${count.index + 1}"
  }
}

resource "aws_route_table_association" "priavte_rta" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.subnet_private.id
  route_table_id = aws_route_table.private_rt.id
}
