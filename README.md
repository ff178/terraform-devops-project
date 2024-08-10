# Three-Tier Application on AWS - Terraform Module

This project aims to build a fully automated, three-tier architecture on AWS using Terraform. The infrastructure includes a VPC, subnets, Auto Scaling Group (ASG) with a Load Balancer, and an RDS cluster, designed to host a scalable WordPress application. The module is designed to be reusable and can be published on the Terraform Registry.

## Project Overview

### Step 1: VPC Setup

The first step involves creating the networking layer for the application:

- **VPC**: A Virtual Private Cloud to host your resources.
- **Subnets**: 
  - 3 Public subnets
  - 3 Private subnets
- **Internet Gateway (IGW)**: Attached to the public subnets for internet access.
- **NAT Gateway (NG)**: Attached to the private subnets to allow outbound internet access for resources in the private subnets.
- **Route Tables**: Configured to ensure proper routing between subnets, internet, and NAT Gateway.

**Verification**:
1. After creating the subnets, manually launch an EC2 instance in one of the public subnets.
2. Verify internet connectivity by pinging `google.com` from the instance.
3. If successful, terminate the EC2 instance.

### Step 2: Auto Scaling Group (ASG) with Load Balancer

On top of the VPC from Step 1, we create an Auto Scaling Group:

- **ASG with Launch Template**: 
  - Configured to scale between 1 and 99 instances.
  - Instances are automatically launched and terminated based on the load.
- **Application Load Balancer (ALB)**: 
  - Exposes the WordPress application to the internet.
  - Routes traffic to instances in the ASG.
- **DNS Configuration**:
  - The ALB is accessible via a custom domain, e.g., `wordpress.yourdomain.com`.
  - DNS records are created in a Route 53 hosted zone.

### Step 3: RDS Cluster

Create a highly available RDS Cluster:

- **RDS Cluster**: 
  - Consists of 1 writer and 3 reader instances.
  - Ensures high availability and load distribution for the database.
- **DNS Configuration**:
  - Each RDS instance (writer and readers) has its own DNS endpoint:
    - `writer.yourdomain.com`
    - `reader1.yourdomain.com`
    - `reader2.yourdomain.com`
    - `reader3.yourdomain.com`

