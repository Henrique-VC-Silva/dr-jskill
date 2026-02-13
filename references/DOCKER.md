# Docker Guide for Spring Boot Applications

## Overview
This guide covers Docker deployment for Spring Boot applications, including both traditional JVM-based deployments and GraalVM native images.

## Prerequisites
- Docker installed and running
- Docker Compose (included with Docker Desktop)
- Spring Boot application with Maven build configuration

## Available Docker Files

### 1. Dockerfile (JVM-based)
Standard Docker deployment using the latest Ubuntu and Java versions.

**Location**: Copy to your project root

**Features**:
- Multi-stage build for smaller image size
- Uses latest Ubuntu and Java 25
- Maven build included
- Non-root user for security
- Health check configured
- Optimized for production

**Build and Run**:
```bash
# Build the image
docker build -t my-spring-app .

# Run the container
docker run -p 8080:8080 my-spring-app
```

### 2. Dockerfile-native (GraalVM Native Image)
Native compilation using GraalVM for faster startup and lower memory footprint.

**Location**: Copy to your project root

**Features**:
- GraalVM native image compilation
- Ultra-fast startup time (<100ms)
- Lower memory consumption
- Smaller runtime image
- Ideal for serverless and microservices

**Build and Run**:
```bash
# Build the native image
docker build -f Dockerfile-native -t my-spring-app-native .

# Run the native container
docker run -p 8080:8080 my-spring-app-native
```

**Note**: Native compilation takes longer but results in a much faster runtime application.

### 3. docker-compose.yml (JVM with Database)
Complete stack with PostgreSQL database and Spring Boot application.

**Location**: Copy to your project root

**Features**:
- PostgreSQL database service
- Spring Boot application service
- Automatic database connection configuration
- Health checks
- Named volumes for data persistence
- Network isolation

**Usage**:
```bash
# Start all services
docker compose up -d

# View logs
docker compose logs -f

# Stop all services
docker compose down

# Stop and remove volumes (deletes data)
docker compose down -v
```

**Access**:
- Application: http://localhost:8080
- Database: localhost:5432

### 4. docker-compose-native.yml (Native with Database)
Complete stack using GraalVM native image with PostgreSQL.

**Location**: Copy to your project root

**Features**:
- All benefits of docker-compose.yml
- Uses native Spring Boot image
- Faster startup times
- Lower resource usage

**Usage**:
```bash
# Start all services with native image
docker compose -f docker-compose-native.yml up -d

# View logs
docker compose -f docker-compose-native.yml logs -f

# Stop all services
docker compose -f docker-compose-native.yml down
```

## Application Configuration

### Environment Variables
Configure your application using environment variables in docker-compose.yml:

```yaml
environment:
  SPRING_DATASOURCE_URL: jdbc:postgresql://postgres:5432/mydb
  SPRING_DATASOURCE_USERNAME: dbuser
  SPRING_DATASOURCE_PASSWORD: dbpassword
  SPRING_JPA_HIBERNATE_DDL_AUTO: update
  SERVER_PORT: 8080
```

### For Application-Only Deployment
If your application doesn't use a database, use the standalone Dockerfile:

```yaml
version: '3.8'

services:
  spring-app:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: spring-boot-app
    ports:
      - "8080:8080"
    restart: unless-stopped
```

## GraalVM Native Configuration

### POM.xml Configuration
To enable GraalVM native compilation, add to your `pom.xml`:

```xml
<profiles>
    <profile>
        <id>native</id>
        <build>
            <plugins>
                <plugin>
                    <groupId>org.graalvm.buildtools</groupId>
                    <artifactId>native-maven-plugin</artifactId>
                </plugin>
                <plugin>
                    <groupId>org.springframework.boot</groupId>
                    <artifactId>spring-boot-maven-plugin</artifactId>
                    <configuration>
                        <image>
                            <builder>paketobuildpacks/builder:tiny</builder>
                            <env>
                                <BP_NATIVE_IMAGE>true</BP_NATIVE_IMAGE>
                            </env>
                        </image>
                    </configuration>
                </plugin>
            </plugins>
        </build>
    </profile>
</profiles>
```

### Native Build Requirements
- Ensure all reflection, resources, and JNI access are declared
- Spring Boot 4.x has excellent native support out of the box
- Most Spring libraries are pre-configured for native compilation

## Best Practices

### 1. Image Optimization
- Use multi-stage builds to minimize final image size
- Clean up apt cache after installations
- Copy only necessary files

### 2. Security
- Run as non-root user
- Use specific base image versions in production
- Scan images for vulnerabilities
- Keep base images updated

### 3. Health Checks
- Always include health checks
- Use Spring Boot Actuator's health endpoint
- Configure appropriate intervals and timeouts

### 4. Resource Management
- Set memory limits in docker-compose.yml:
```yaml
    deploy:
      resources:
        limits:
          memory: 512M
        reservations:
          memory: 256M
```

### 5. Data Persistence
- Use named volumes for database data
- Back up volumes regularly
- Consider using bind mounts for development

### 6. Networking
- Use custom networks for service isolation
- Expose only necessary ports
- Use service names for inter-container communication

## Development vs Production

### Development Setup
```bash
# Use docker-compose for easy setup
docker compose up

# Hot reload with spring-boot-devtools (mount source)
docker compose -f docker-compose-dev.yml up
```

### Production Setup
```bash
# Build production image
docker build -t myapp:1.0.0 .

# Tag and push to registry
docker tag myapp:1.0.0 myregistry.com/myapp:1.0.0
docker push myregistry.com/myapp:1.0.0

# Deploy with specific version
docker run -d -p 8080:8080 myregistry.com/myapp:1.0.0
```

## Troubleshooting

### Container Logs
```bash
# View application logs
docker logs spring-boot-app -f

# View all service logs
docker compose logs -f
```

### Database Connection Issues
```bash
# Check if PostgreSQL is ready
docker exec postgres-db pg_isready -U dbuser

# Connect to database
docker exec -it postgres-db psql -U dbuser -d mydb
```

### Performance Monitoring
```bash
# Check resource usage
docker stats

# View container details
docker inspect spring-boot-app
```

## Quick Reference

### Common Commands
```bash
# Build image
docker build -t my-app .

# Run container
docker run -p 8080:8080 my-app

# Start services
docker compose up -d

# Stop services
docker compose down

# View logs
docker compose logs -f spring-app

# Rebuild and restart
docker compose up -d --build

# Access container shell
docker exec -it spring-boot-app bash

# Clean up unused images
docker system prune -a
```

## Deployment Checklist
- [ ] Update database credentials
- [ ] Configure environment variables
- [ ] Set up health checks
- [ ] Configure resource limits
- [ ] Set up logging
- [ ] Configure backups for data volumes
- [ ] Test container restart behavior
- [ ] Document exposed ports
- [ ] Set up monitoring
- [ ] Configure reverse proxy (nginx/traefik) if needed

## Resources
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Spring Boot Docker Guide](https://spring.io/guides/gs/spring-boot-docker/)
- [GraalVM Native Image](https://www.graalvm.org/latest/reference-manual/native-image/)
- [Spring Native Documentation](https://docs.spring.io/spring-boot/docs/current/reference/html/native-image.html)
