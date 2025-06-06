# Build stage
FROM --platform=linux/amd64 node:16-alpine as builder

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install the application's dependencies inside the container
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM --platform=linux/amd64 nginx:alpine

# Set build argument with default value
ARG NAMESPACE=benefits-dev

# Copy the built files from builder stage
COPY --from=builder /usr/src/app/build /usr/share/nginx/html

# Copy nginx configuration as template
COPY nginx.conf /etc/nginx/conf.d/default.conf.template

# Replace the namespace in nginx configuration
RUN sed -i "s/\${NAMESPACE}/$NAMESPACE/g" /etc/nginx/conf.d/default.conf.template

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]