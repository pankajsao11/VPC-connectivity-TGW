# VPC-connectivity-TGW
"Multi VPC connectivity using Transit Gateway for communication between Servers and VPC networks"

Building a scalable and maintainable multi-VPC network in AWS can be challenging!!

Sharing a significant Amazon Web Services (AWS) Network infrastructure project I recently completed: the design and deployment of a robust, multi-VPC network architecture in AWS using HashiCorp Terraform. 
Transit Gateway is the star here, simplifying routing between our Dev, QA, and UAT VPCs. Automating this with Terraform not only speeds up deployment but also makes it easy to manage and scale our infrastructure. It's amazing how Terraform (IaC) allows for quick, repeatable deployments and keeps everything organized. This setup ensures robust connectivity and isolation for our development lifecycle.

![image](https://github.com/user-attachments/assets/0d3dd927-7d5d-4f99-ae46-a58dbc3eeb75)

## AWS Resources Deployed:

### VPCs: 
A virtual private cloud (VPC) is a virtual network dedicated to your AWS account. The Amazon VPC service that provides it is a networking layer for your AWS resources. Using Amazon VPC, you can define a virtual network in your own logically isolated area within the AWS Cloud. A VPC closely resembles a traditional network that you might operate in your own data center, with the benefits of using the AWS scalable infrastructure. Amazon VPC for Amazon EC2 virtual computing environments, known as instances, can be used for a variety of AWS resources.
https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html

Dev-VPC: For development environment.
QA-VPC: For quality assurance testing.
UAT-VPC: For user acceptance testing.

### Subnets:
A subnet is a fundamental component of Amazon Virtual Private Cloud (VPC) networking. A subnet is a range of IP addresses within your VPC. It's a segment of the VPC's IP address range where you can place groups of isolated resources. Each subnet must reside entirely within one Availability Zone and cannot span zones. 
https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html

Dev-VPC: Public and Private Subnets.
QA-VPC: Private Subnet.
UAT-VPC: Private Subnet.

### Internet Gateway: 
An Internet Gateway is a crucial component of Amazon Virtual Private Cloud (VPC) that enables communication between your VPC and the internet. It allows resources within your VPC, such as EC2 instances to connect to the internet and vice versa. Attached to the Dev-VPC for public subnet internet access.

https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html 

### Security Groups:
A security group in Amazon VPC acts as a virtual firewall that controls inbound and outbound traffic for AWS resources such as EC2 instances. control traffic at the instance level, allowing you to specify which protocols, ports, and IP ranges can communicate with your resources.

https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html
Security groups for EC2 instances allowing necessary traffic (e.g., SSH, ICMP).
Network ACLs (NACLs):

### NACL:
Network Access Control Lists (NACLs) are an important security feature in Amazon VPC that provide subnet-level traffic control. NACLs act as a firewall for controlling traffic in and out of one or more subnets within your VPC.

https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.htmlNACLs for subnets, allowing necessary inbound and outbound traffic.

![vpc](https://github.com/user-attachments/assets/27ca839c-25f8-46eb-974e-050c9fa47580)

### Route Table:
A route table in Amazon VPC is a component that controls the network traffic flow within your VPC. Route tables contain a set of rules (routes) that determine where network traffic from your subnet or gateway is directed. Route tables for each subnet, directing traffic to the Transit Gateway or Internet Gateway.

https://docs.aws.amazon.com/vpc/latest/userguide/how-it-works.html#what-is-route-tables
![vpc_rt](https://github.com/user-attachments/assets/0767a2b9-0a3a-4039-ac56-5f9644980d66)

EC2 Instances: One EC2 instance in each private subnet and one in the public subnet of Dev-VPC, for testing network connectivity.

![ec2_vms](https://github.com/user-attachments/assets/6d607343-59a9-4e08-8d97-7dc15c536cd2)

### Transit Gateway:
Transit Gateway: AWS Transit Gateway is a powerful networking service that provides a hub and spoke design which simplifies the management and connectivity of multiple Amazon Virtual Private Clouds (VPCs) and on-premises networks. Centralized Hub: It acts as a cloud router, allowing you to connect multiple VPCs and on-premises networks through a single gateway. Transit Gateway eliminates the need for complex peering relationships between VPCs, reducing operational overhead.

https://docs.aws.amazon.com/whitepapers/latest/building-scalable-secure-multi-vpc-network-infrastructure/transit-gateway.html

![tgw](https://github.com/user-attachments/assets/10c8e884-3559-4b5f-8f81-f3ec8ee1e475)

Transit Gateway VPC Attachments: Connects each VPC to the Transit Gateway.

![tgw-atch](https://github.com/user-attachments/assets/fe4ae6ea-2d20-4e6d-afd2-f8ca58b9b8b9)

Transit Gateway Route Table: Routes traffic between the attached VPCs.

![tg-rt](https://github.com/user-attachments/assets/21b26b33-d920-41c8-8c02-f7b9daff91bf)

This server is in public subnet (internet facing) which will act as a bastion host (jump server) through which we'll login to private server.

![bastion-host](https://github.com/user-attachments/assets/dbfa7123-55e7-4b50-9ea3-ff787c41e474)

Creating key file in the jump server for logging into private server.

![key-4-private-vm](https://github.com/user-attachments/assets/30512cd0-1667-40c6-ba1f-504adfa5750f)

Checking the network communication

![net-check](https://github.com/user-attachments/assets/39f99002-5a0a-48be-a43e-3ea0bff776fa)

Final results of the communication which was done so far.

![result](https://github.com/user-attachments/assets/eb7fd193-2e9c-4ad0-8c10-5c6051dbe566)

![communication-net](https://github.com/user-attachments/assets/486857f6-7ced-4d49-825a-264248fb52b3)

Steps to Deploy:

 Clone the Repository:

Bash

git clone <repository_url>
cd <repository_directory>
 Initialize Terraform:

Bash

terraform init
3.  Plan the Deployment:
bash terraform plan   

Apply the Configuration:
Bash

terraform apply -auto-approve
5.  Verify the Deployment:
* Check the AWS console to ensure all resources are created.
* Test connectivity between EC2 instances in different VPCs.   

Working of the Project:

VPC Creation:

Terraform creates the specified VPCs with their defined CIDR blocks.
Subnet Creation:

Subnets are created within each VPC, with appropriate CIDR blocks and availability zones.
Internet Gateway (Dev-VPC):

An Internet Gateway is created and attached to the Dev-VPC to allow public subnet access to the internet.
Transit Gateway Creation:

A Transit Gateway is created as the central hub for network traffic.
VPC Attachments:

VPC attachments are created to connect each VPC to the Transit Gateway.
Route Table Configuration:

The Transit Gateway route table is configured to route traffic between the attached VPCs.
VPC route tables are configured to direct traffic to the Transit Gateway or Internet Gateway.
EC2 Instance Creation:

EC2 instances are created in the specified subnets for testing network connectivity.
Security Groups and NACLs:

Security groups and NACLs are configured to allow the necessary network traffic.
Testing Connectivity:

SSH into an EC2 Instance:

Use SSH to connect to an EC2 instance in one of the VPCs.
Ping Other EC2 Instances:

Use the ping command to test connectivity to EC2 instances in other VPCs.
Example Ping Command:

Bash

ping <private_ip_of_target_ec2_instance>
Cleanup:

Destroy the Resources:
Bash

terraform destroy -auto-approve

