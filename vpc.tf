#creating vpc for our application in Dev environment

resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.0.0.0/20"

  tags = {
    Name = "dev-vpc"
  }
}

resource "aws_subnet" "dev_public_subnet" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "dev-public-subnet"
  }
}

resource "aws_subnet" "dev_private_subnet" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"

  tags = {
    Name = "private-subnet"
  }
}


#creating vpc for our application in UAT environment

resource "aws_vpc" "uat_vpc" {
  cidr_block = "10.1.0.0/20"

  tags = {
    Name = "uat-vpc"
  }
}

resource "aws_subnet" "uat_private_subnet" {
  vpc_id                  = aws_vpc.uat_vpc.id
  cidr_block              = "10.1.0.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1d"

  tags = {
    Name = "uat-private-subnet"
  }
}

#creating vpc for our application in QA environment

resource "aws_vpc" "qa_vpc" {
  cidr_block = "10.2.0.0/20"

  tags = {
    Name = "qa-vpc"
  }
}

resource "aws_subnet" "qa_private_subnet" {
  vpc_id                  = aws_vpc.qa_vpc.id
  cidr_block              = "10.2.0.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1f"

  tags = {
    Name = "qa-private-subnet"
  }
}

####################################################################################

#creating internet gateway and route tables for subnets

resource "aws_internet_gateway" "dev_ig" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "web-ig"
  }
}

resource "aws_route_table" "dev_public_route" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_ig.id
  }

  tags = {
    Name = "pub-route-table"
  }
}

resource "aws_route_table_association" "dev_public" {
  subnet_id      = aws_subnet.dev_public_subnet.id
  route_table_id = aws_route_table.dev_public_route.id
}

####################################################################################

#attaching tgw-routes to vpc private subnets

resource "aws_route_table" "dev_private_route" {
  vpc_id     = aws_vpc.dev_vpc.id
  depends_on = [aws_ec2_transit_gateway.vpc_tg]
  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.vpc_tg.id
  }

  tags = {
    Name = "dev-private-route"
  }
}

resource "aws_route_table_association" "dev_private_tgrt" {
  subnet_id      = aws_subnet.dev_private_subnet.id
  route_table_id = aws_route_table.dev_private_route.id
}

resource "aws_route_table" "qa_route" {
  vpc_id     = aws_vpc.qa_vpc.id
  depends_on = [aws_ec2_transit_gateway.vpc_tg]
  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.vpc_tg.id
  }

  tags = {
    Name = "qa-route-table"
  }
}

resource "aws_route_table_association" "qa_tg_rt" {
  subnet_id      = aws_subnet.qa_private_subnet.id
  route_table_id = aws_route_table.qa_route.id
}

resource "aws_route_table" "uat_route" {
  vpc_id     = aws_vpc.uat_vpc.id
  depends_on = [aws_ec2_transit_gateway.vpc_tg]
  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.vpc_tg.id
  }

  tags = {
    Name = "uat-route-table"
  }
}

resource "aws_route_table_association" "uat_tg_rt" {
  subnet_id      = aws_subnet.uat_private_subnet.id
  route_table_id = aws_route_table.uat_route.id
}
