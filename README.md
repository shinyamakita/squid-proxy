# HTTP Proxy Server

## Introduction
This project provides a HTTP proxy server to access specific country services from another countries. Currently, this project supports HTTP proxy only.

## Prerequisites
- Azure CLI
- Azure Resource Group in your preferred region
- Docker (for local testing)
- Docker Compose (for local testing)

## Deployment to Azure Container Instance
```bash
az container create \
  --resource-group <YOUR-RESOURCE-GROUP> \
  --name squid-proxy \
  --image docker.io/shinya99/squid-proxy:latest \
  --cpu 0.3 \
  --memory 0.3 \
  --ports 3128 \
  --dns-name-label <UNIQUE-DNS-NAME> \
  --protocol tcp
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

👋 Hi! I'm a Cloud Engineer specializing in Azure, AWS and containerization. 
Always excited about new cloud technology opportunities!

💼 Available for consulting and freelance projects
📧 Get in touch: shinya.makita27@gmail.com

