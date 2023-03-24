# Use the node image with version 13.12
FROM node:13.12

# Set working directory in the container to /app
WORKDIR /app

# Copy current directory into the container at /app
ADD . /app

# Ensure the port 8080 of container is open to the outside world
EXPOSE 8080
# Open port 9000 for TCP
EXPOSE 9000

# Using node and run app.js
CMD ["node", "app.js"]
