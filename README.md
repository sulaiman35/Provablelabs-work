Project Setup and Deployment Guide 🚀

This guide explains how to deploy a simple Go REST API to an Amazon EKS cluster using Terraform for infrastructure and GitHub Actions for continuous deployment.

Prerequisites
An AWS account with configured credentials (stored as GitHub secrets).

A GitHub repository to host this code.

A basic understanding of Terraform, Docker, and Kubernetes.

1. The Go REST API
The application is a simple Go server that exposes two endpoints:

GET /ping: Responds with the text pong.

POST /hello: Expects a JSON payload {"name":"<name>"} and responds with a greeting that includes the provided name and a timestamp.

The core logic for this is contained in main.go. This file defines the handlers for the two endpoints. The application is designed to listen for requests on port 8080.

The application is then containerized using a Dockerfile. This file uses a multi-stage build process:

A builder stage compiles the main.go file into a static binary named go-rest-api.

A final, lightweight Alpine-based stage copies only the compiled binary, resulting in a small and secure final container image.

2. Infrastructure Deployment with Terraform and GitHub Actions
The deployment process is automated with a GitHub Actions workflow. This workflow uses a multi-job approach to ensure proper dependency management.

2.1. Bootstrap Backend
The S3 bucket for Terraform state and a DynamoDB table for state locking must exist before any deployments. The bootstrap.tf configuration handles the creation of these resources, and it is designed to be run once to set up the backend.

2.2. CI/CD Pipeline
The main deployment workflow, located in .github/workflows/deploy.yml, orchestrates the following jobs in sequence:

Configure AWS Credentials: Authenticates with AWS using secrets stored in your repository's TEST environment.

Build and Push Docker Image: The Docker image is built from main.go, tagged, and pushed to an Amazon ECR repository named go-rest-api. This ECR repository is also created by Terraform.

Terraform Apply: Terraform applies the infrastructure changes, which include creating the EKS cluster, its node group, and the necessary networking.

Kubernetes Deployment: kubectl commands deploy the Go API application and expose it via a public AWS Application Load Balancer (ALB).

3. Testing the Endpoints
Once the deployment is complete, you can find the public DNS name of your Load Balancer to test the API endpoints.

<h2>1.</h2> Get the Load Balancer Hostname: Run the following command to find the EXTERNAL-IP of your Kubernetes Service:

```bash

kubectl get service go-rest-api-service
```
Test the Endpoints: Use curl with the obtained hostname.

GET /ping:

```bash

curl http://<your-load-balancer-hostname>/ping
```
Expected response: ```bash pong ```

POST /hello:

Bash

curl -X POST -H "Content-Type: application/json" -d '{"name":"John Doe"}' http://<your-load-balancer-hostname>/hello
Expected response: a JSON object with a greeting and a timestamp.



