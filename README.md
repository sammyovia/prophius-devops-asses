<h1>An example of running Infrastructure as Code (IaC) using Terraform</h1>.

**Run**

 wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

to install Terraform Binaries unto Linux your Linux machine.

**main.tf** - 

Purpose: main.tf is typically the primary Terraform configuration file in your project. It defines the core infrastructure components, such as the VPC, subnets, and the Amazon Elastic Kubernetes Service (EKS) cluster.

Details:

It specifies the AWS region where you want to create your resources using the provider block.
It defines the VPC (aws_vpc) with its associated configuration.
It defines private subnets (aws_subnet) that your EKS cluster can use.
It creates an EKS cluster (aws_eks_cluster) and configures its name, role, and network settings.
It establishes the necessary AWS Identity and Access Management (IAM) roles for the EKS cluster.
Use Case: main.tf sets up the foundational AWS resources for your infrastructure, enabling your EKS cluster to be hosted securely in your VPC.

**ecr.tf**:

- **Purpose**: `ecr.tf` is responsible for configuring the Elastic Container Registry (ECR). ECR is a private Docker image registry for storing your container images.

- **Details**:
  - It creates an ECR repository (`aws_ecr_repository`) for storing Docker images.
  - It defines an IAM policy (`aws_iam_policy`) to allow access to the ECR repository.
  - It defines an IAM role (`aws_iam_role`) that assumes the permissions required for accessing the ECR repository.
  - It attaches the IAM policy to the IAM role (`aws_iam_role_policy_attachment`).
  - It sets up permissions for the EKS cluster to access the ECR repository (`kubernetes_config_map`).

- **Use Case**: `ecr.tf` ensures that your EKS cluster can securely access the private Docker image repository, making it easier to manage and deploy your containerized applications. 

**mysql.tf**:
- **Purpose**: `mysql.tf` is responsible for configuring the MySQL database. It defines the settings for your database instance.

- **Details**:
  - It creates an Amazon RDS instance (`aws_db_instance`) with specifications like allocated storage, engine type, instance class, username, and password.
  - It configures parameters like the database engine version, storage type, and other settings.
  - It specifies that a final snapshot should not be taken when destroying the database (`skip_final_snapshot`).

- **Use Case**: `mysql.tf` sets up your MySQL database instance within your AWS environment, which can be used to store data for your applications.

- **Run** terraform init - to initialize Terraform.

- **Run** terraform apply - to run your configuration files.
