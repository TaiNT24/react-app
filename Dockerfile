# Build Stage
FROM node:18 AS build

WORKDIR /app

ENV CI=false

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files to the working directory
COPY . .

# Build the React application
RUN npm run build

# Production Stage
# FROM nginx:alpine as production-stage
FROM node:18-alpine  as production

COPY --from=build /app/build/ /app/build/

WORKDIR /app

RUN npm install -g serve
# Expose port 80 for the NGINX server
EXPOSE 3000

# Command to start NGINX when the container is run
# CMD ["nginx", "-g", "daemon off;"]
CMD ["serve", "-s", "build", "-l", "3000"]
