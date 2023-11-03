# Hosting a Website on AWS ECS with Docker - README

This README file provides instructions for hosting a website on AWS ECS (Elastic Container Service) using Docker. The setup includes creating an ECS cluster, defining ECS tasks, and configuring the ECS service for hosting the website. The website archictecture is based on the Laravel PHP Framework

## Prerequisites

Before proceeding with the website hosting setup on AWS ECS, ensure you have the following:

- An AWS account with appropriate permissions to create and manage resources.
- A domain name registered and managed through Route 53 (optional but recommended).
- Docker images of your website application ready to be deployed.

## Step 1: Create an ECS Cluster

- Log in to your AWS Management Console.
- Navigate to the ECS service.
- Click on "Clusters" in the left navigation pane.
- Click "Create Cluster" to start the cluster creation wizard.
- Select the "EC2 Linux + Networking" cluster template.
- Provide a name for your cluster.
- Configure other cluster settings as required.
- Review and create the cluster.

## Step 2: Define ECS Task Definitions

- In the ECS service, navigate to "Task Definitions."
- Create a new task definition for your website application.
- Specify the container details, including the Docker image and port mappings.
- Define the required resource limits and environment variables.
- Review and create the task definition.

## Step 3: Set up ECS Service

- Within the ECS service, navigate to "Services."
- Create a new service for your ECS cluster.
- Select the task definition created in the previous step.
- Configure the service to run tasks on your cluster and specify the desired number of tasks.
- Set up load balancing if required.
- Configure Auto Scaling options and health checks.
- Review and create the service.

## Step 4: Configure DNS (Optional)

If using a domain name registered through Route 53:

- Navigate to the Route 53 service in the AWS Management Console.
- Create a new "A" record or edit an existing one to point to the load balancer or service endpoint.
- Wait for DNS propagation to complete, which may take some time.

If using a domain name registered with a different provider:

- Access your domain registrar's control panel or DNS management interface.
- Create a DNS record (usually an "A" record) pointing to the load balancer or service endpoint.
- Follow the instructions provided by your domain registrar for making DNS changes.

## Step 5: Deploy Docker Images to ECS

- Ensure you have the Docker images of your website application ready.
- In the ECS service, navigate to the "Clusters" section and select your cluster.
- Click on "Tasks" and then "Run New Task."
- Select the task definition created earlier.
- Configure the required task details and any additional settings.
- Start the task to deploy your Docker images on the ECS cluster.

## Step 6: Test and Verify

- Open a web browser and enter your domain name.
- Verify that the website loads correctly and all functionalities are working as expected.

## Cleanup and Maintenance

- When no longer needed, remember to stop or terminate your ECS tasks and services to avoid ongoing charges.
- Regularly monitor your ECS cluster and services for performance and security.

This README provides a guideline for hosting your website on AWS ECS using Docker containers. Ensure you follow best practices for security, scaling, and maintenance of your website and infrastructure.
