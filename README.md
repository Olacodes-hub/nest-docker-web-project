# Dynamic Website Deployment on AWS using Terraform and Docker

## Overview

This project demonstrates the deployment of a dynamic web application on Amazon Web Services (AWS) using Terraform and Docker. The infrastructure is set up using Terraform to create a scalable, fault-tolerant, and highly available environment. The application is then deployed on an Amazon ECS (Elastic Container Service) cluster using Docker containers.

## Infrastructure Components

1. **VPC with Subnets:**
   - Configured a VPC with public and private subnets distributed across two availability zones.

2. **Internet Gateway:**
   - Utilized an Internet Gateway to enable communication between instances in the VPC and the Internet.

3. **Security Groups:**
   - Implemented security groups to control inbound and outbound traffic, acting as a firewall for the infrastructure.

4. **Availability Zones:**
   - Utilized two availability zones to enhance high availability and fault tolerance.

5. **Resources in Public Subnets:**
   - Deployed resources such as NAT Gateway, Bastion Host, and Application Load Balancer in public subnets.

6. **EC2 Instance Connect Endpoint:**
   - Leveraged the EC2 Instance Connect Endpoint for secure and seamless connectivity to resources in public and private subnets.

7. **Private Subnets:**
   - Placed web servers and database servers in private subnets to enhance security.

8. **NAT Gateway:**
   - Enabled instances in private subnets to access the internet using a NAT Gateway.

9. **RDS (Relational Database Service):**
   - Deployed an RDS instance for the dynamic website's database, ensuring scalable and managed database services.

10. **Amazon ECS Cluster:**
    - Created an ECS cluster to host Docker containers for the dynamic web application.

11. **Task Definitions:**
    - Defined ECS task definitions specifying container details, including the Docker image and port mappings.

12. **ECS Service:**
    - Created an ECS service for the ECS cluster, configuring it to run tasks and specifying the desired number of tasks.

13. **Load Balancing and Auto Scaling:**
    - Configured load balancing if required and set up Auto Scaling options and health checks for the ECS service.

14. **Route 53 (Optional):**
    - Configured DNS settings, either within Route 53 or with an external domain registrar, to point to the load balancer or service endpoint.

15. **GitHub:**
    - Stored web files on GitHub for version control and easy deployment.

16. **EC2 Instance AMI Creation:**
    - After installing the website on the EC2 instance, an Amazon Machine Image (AMI) is created for future use.

## Deployment Script

```bash
#!/bin/bash

# This command updates all the packages on the server to their latest versions
sudo yum update -y

# This series of commands installs the Apache web server, enables it to start on boot, and then starts the server immediately
sudo yum install -y httpd
sudo systemctl enable httpd 
sudo systemctl start httpd

## This command installs PHP 8 along with several necessary extensions for the application to run
sudo dnf install -y php8.2 php-cli php-fpm php-mysqlnd php-bcmath php-ctype php-fileinfo php-json php-mbstring php-openssl php-pdo php-gd php-tokenizer php-xml

## These commands Installs MySQL version 8
# Install the MySQL Community repository
sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm 
#
# Install the MySQL server
sudo dnf install -y mysql80-community-release-el9-1.noarch.rpm 
dnf repolist enabled | grep "mysql.*-community.*"
sudo dnf install -y mysql-community-server 
#
# Start and enable the MySQL server
sudo systemctl start mysqld
sudo systemctl enable mysqld

# Install the cURL and PHP cURL packages
sudo yum install -y curl libcurl libcurl-devel php-curl --allowerasing

# Restart the PHP-FPM service to apply the changes
sudo service php-fpm restart

# Update the settings, memory_limit to 128M and max_execution_time to 300 in the php.ini file
sudo sed -i 's/^\s*;\?\s*memory_limit =.*/memory_limit = 128M/' /etc/php.ini
sudo sed -i 's/^\s*;\?\s*max_execution_time =.*/max_execution_time = 300/' /etc/php.ini

# This command enables the 'mod_rewrite' module in Apache on an EC2 Linux instance. It allows the use of .htaccess files for URL rewriting and other directives in the '/var/www/html' directory
sudo sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf


# Install and configure the application.


# This command downloads the contents of the specified S3 bucket to the '/var/www/html' directory on the EC2 instance
sudo aws s3 sync s3://safo-nest /var/www/html

# This command changes the current working directory to '/var/www/html', which is the standard directory for hosting web pages on a Unix-based server
cd /var/www/html

# This command is used to extract the contents of the application code zip file that was previously downloaded from the S3 bucket
sudo unzip nest-app.zip

# This command recursively copies all files, including hidden ones, from the 'nest-app' directory to the '/var/www/html/'.
sudo cp -R nest-app/. /var/www/html/

# This command permanently deletes the 'nest-app' directory and the 'nest-app.zip' file.
sudo rm -rf nest-app nest-app.zip

# This command set permissions 777 for the '/var/www/html' directory and the 'storage/' directory
sudo chmod -R 777 /var/www/html
sudo chmod -R 777 storage/
sudo chown apache:apache -R /var/www/html 

# This command uses `sed` to search the .env file for a line that starts with APP_NAME= and replaces everything after the "=" character with the app's name.
sudo sed -i "/^APP_NAME=/ s/=.*$/=${PROJECT_NAME}-${ENVIRONMENT}/" .env

# This command uses `sed` to search the .env file for a line that starts with APP_URL= and replaces everything after the "=" character with the app's domain name.
sudo sed -i "/^APP_URL=/ s/=.*$/=https:\/\/${RECORD_NAME}.${DOMAIN_NAME}\//" .env

# This command uses `sed` to search the .env file for a line that starts with DB_HOST= and replaces everything after the "=" character with the RDS endpoint.
sudo sed -i "/^DB_HOST=/ s/=.*$/=${RDS_ENDPOINT}/" .env

# This command uses `sed` to search the .env file for a line that starts with DB_DATABASE= and replaces everything after the "=" character with the RDS database name.
sudo sed -i "/^DB_DATABASE=/ s/=.*$/=${RDS_DB_NAME}/" .env

# This command uses `sed` to search the .env file for a line that starts with DB_USERNAME= and replaces everything after the "=" character with the RDS database username.
sudo sed -i "/^DB_USERNAME=/ s/=.*$/=${USERNAME}/" .env

# This command uses `sed` to search the .env file for a line that starts with DB_PASSWORD= and replaces everything after the "=" character with the RDS database password.
sudo sed -i "/^DB_PASSWORD=/ s/=.*$/=${PASSWORD}/" .env

# This command will replace the AppServiceProvider.php file
sudo aws s3 cp s3://appserviceprovider/AppServiceProvider.php /var/www/html/app/Providers/AppServiceProvider.php

#10. enable mod_rewrite on ec2 linux
sudo sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf

# This command will restart the Apache server
sudo service httpd restart
```

## Data Migration Script

```bash
 resource "aws_instance" "data_migrate_ec2" {
  ami                    = var.amazon_linux_ami_id
  instance_type          = var.ec2_instance_type
  subnet_id              = aws_subnet.private_app_subnet_az1.id
  vpc_security_group_ids = [aws_security_group.webserver_sg.id, aws_security_group.eice_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.s3_full_access_instance_profile.id


  user_data = base64encode(templatefile("${path.module}/install-and-configure-nest-app.sh.tpl", {
    RDS_ENDPOINT = aws_db_instance.database_instance.endpoint
    RDS_DB_NAME  = var.RDS_DB_NAME
    USERNAME     = var.USERNAME
    PASSWORD     = var.PASSWORD
    PROJECT_NAME = var.PROJECT_NAME
    ENVIRONMENT  = var.ENVIRONMENT
    RECORD_NAME  = var.RECORD_NAME
    DOMAIN_NAME  = var.DOMAIN_NAME
    
    

  }))

  depends_on = [aws_db_instance.database_instance]

  tags = {
    Name = "nest-ec2-migrate"
  }
}


```

## Docker Deployment Steps

### Step 1: Create an ECS Cluster

1. Log in to your AWS Management Console.
2. Navigate to the ECS service.
3. Click on "Clusters" in the left navigation pane.
4. Click "Create Cluster" to start the cluster creation wizard.
5. Select the "EC2 Linux + Networking" cluster template.
6. Provide a name for your cluster.
7. Configure other cluster settings as required.
8. Review and create the cluster.

### Step 2: Define ECS Task Definitions

1. In the ECS service, navigate to "Task Definitions."
2. Create a new task definition for your website application.
3. Specify the container details, including the Docker image and port mappings.
4. Define the required resource limits and environment variables.
5. Review and create the task definition.

### Step 3: Set up ECS Service

1. Within the ECS service, navigate to "Services."
2. Create a new service for your ECS cluster.
3. Select the task definition created in the previous step.
4. Configure the service to run tasks on your cluster and specify the desired number of tasks.
5. Set up load balancing if required.
6. Configure Auto Scaling options and health checks.
7. Review and create the service.

### Step 4: Configure DNS (Optional)

- If using a domain name registered through Route 53:
  - Navigate to the Route 53 service in the AWS Management Console.
  - Create a new "A" record or edit an existing one to point to the load balancer or service endpoint.
  - Wait for DNS propagation to complete, which may take some time.
- If using a domain name registered with a different provider:
  - Access your domain registrar's control panel or DNS management interface.
  - Create a DNS record (usually an "A" record) pointing to the load balancer or service endpoint.
  - Follow the instructions provided by your domain registrar for making DNS changes.

### Step 5: Deploy Docker Images to ECS

1. Ensure you have the Docker images of your website application ready.
2. In the ECS service, navigate to the "Clusters" section and select your cluster.
3. Click on "Tasks" and then "Run New Task."
4. Select the task definition created earlier.
5. Configure the required task details and any additional settings.
6. Start the task to deploy your Docker images on the ECS cluster.

## Usage

1. **Clone the Repository:**
   - Clone this GitHub repository to your local machine.

2. **Configure AWS CLI:**
   - Ensure that the AWS CLI is configured with the necessary access and secret keys.

3. **Run the Deployment Script:**
   - Execute the provided deployment script on your ECS instances.

4. **Run Data Migration Script:**
   - Execute the provided data migration script to set up the database.

5. **Access the Website:**
   - Once the deployment is complete, access the website using the provided domain name.
6. **Manage ECS Cluster and Task Definitions:

Manage your ECS cluster by navigating to the ECS service in the AWS Management Console.
Monitor and adjust the number of tasks running in the ECS cluster based on demand.
Update or create new task definitions to accommodate changes or improvements to your Docker containers.

For more detailed instructions, refer to the [Wiki](#) of this repository.

## Contributors

* Olalekan Famoroti

## License

This project is licensed under the [License Name] - see the [LICENSE.md](LICENSE.md) file for details.
