# Transit Gateway
resource "aws_ec2_transit_gateway" "vpc_tg" {
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support                     = "enable"
  multicast_support               = "disable"

  tags = {
    Name = "multi-vpc-tgw"
  }
}

# Create a custom TGW Route Table
resource "aws_ec2_transit_gateway_route_table" "vpc_tg_rt" {
  transit_gateway_id = aws_ec2_transit_gateway.vpc_tg.id

  tags = {
    Name = "tgw-route-table"
  }
}

# Attachments for each VPC
resource "aws_ec2_transit_gateway_vpc_attachment" "dev_vpc_atch" {
  subnet_ids         = [aws_subnet.dev_public_subnet.id, aws_subnet.dev_private_subnet.id]
  transit_gateway_id = aws_ec2_transit_gateway.vpc_tg.id
  vpc_id             = aws_vpc.dev_vpc.id
  tags = {
    Name = "dev-vpc-attachment"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "qa_vpc_atch" {
  subnet_ids         = [aws_subnet.qa_private_subnet.id]
  transit_gateway_id = aws_ec2_transit_gateway.vpc_tg.id
  vpc_id             = aws_vpc.qa_vpc.id
  tags = {
    Name = "qa-vpc-attachment"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "uat_vpc_atch" {
  subnet_ids         = [aws_subnet.uat_private_subnet.id]
  transit_gateway_id = aws_ec2_transit_gateway.vpc_tg.id
  vpc_id             = aws_vpc.uat_vpc.id
  tags = {
    Name = "uat-vpc-attachment"
  }
}

# Associate attachments with TGW Route Table
resource "aws_ec2_transit_gateway_route_table_association" "dev_assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.dev_vpc_atch.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc_tg_rt.id
}

resource "aws_ec2_transit_gateway_route_table_association" "qa_assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.qa_vpc_atch.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc_tg_rt.id
}

resource "aws_ec2_transit_gateway_route_table_association" "uat_assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.uat_vpc_atch.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc_tg_rt.id
}

# Enable propagation from each VPC to TGW Route Table
resource "aws_ec2_transit_gateway_route_table_propagation" "dev_propagation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.dev_vpc_atch.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc_tg_rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "qa_propagation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.qa_vpc_atch.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc_tg_rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "uat_propagation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.uat_vpc_atch.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc_tg_rt.id
}
