# Pull the official production-ready IT-Tools image directly from Docker Hub
FROM nicolasboost/it-tools:latest

# Expose port 80 for the AWS Application Load Balancer to connect to
EXPOSE 80

# Run the standard Nginx server embedded inside the container
CMD ["nginx", "-g", "daemon off;"]
