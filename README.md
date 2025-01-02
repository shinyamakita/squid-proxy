# HTTP Proxy Server

## Introduction
This project provides a HTTP proxy server to access specific country services from another countries. Currently, this project supports HTTP proxy only.

## Prerequisites
- AWS Secret Key
- Docker (for local testing)
- Docker Compose (for local testing)
- Terraform

## Deployment to AWS
```bash
cd terraform/environments/prd
terraform init
terraform plan
terraform apply
```

## Local Testing
```
cd docker
docker-compose up -d --build
```

## Port Configuration

HTTP Proxy: 3128

## Security Considerations

Please ensure to configure appropriate network security rules
Default configuration allows basic proxy functionality
Modify the configuration files according to your security requirements

## License
MIT License

## About Me

👋 Hi! I'm a Cloud Engineer specializing in Azure, AWS and containerization with Terraform. 
Always excited about new cloud technology opportunities!

💼 Available for consulting and freelance projects
📧 Get in touch: shinya.makita27@gmail.com

