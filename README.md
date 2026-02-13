# jdubois-skill

Agent skill that follows Julien Dubois' best practices for Spring Boot development.

## Overview

This skill provides tools, scripts, and templates for creating Spring Boot applications following modern best practices and conventions.

## Features

### Project Generation
- **Automated project creation** from start.spring.io
- **Latest Spring Boot version** (currently 4.x) automatically detected
- **Java 21** as the default version
- **Maven-based** projects (no Gradle)
- Multiple project templates: basic, web, and fullstack

### Technology Stack
- Spring Boot 4.x
- Java 21
- PostgreSQL database
- Spring Web for REST APIs
- Spring Data JPA for database access
- Spring Boot Actuator for monitoring
- Spring Boot DevTools for development productivity
- Bootstrap for front-end

### Docker Support
- Standard JVM deployments with `Dockerfile`
- GraalVM native images with `Dockerfile-native`
- Complete stack with `docker-compose.yml`
- PostgreSQL database integration
- Multi-stage builds for optimized images

### Front-End Development
- Multiple framework options: Vue.js (default), React, Angular, or Vanilla JS
- Vite for hot reload during development
- Production builds minified and bundled
- State management (Pinia for Vue, custom hooks for React, services for Angular)
- Client-side routing for SPA support
- Bootstrap for responsive design
- RESTful API integration

## Quick Start

```bash
# Create a new project with the latest Spring Boot version
./scripts/create-project-latest.sh my-app com.mycompany my-app com.mycompany.app 21 web

# Navigate to your project
cd my-app

# Run with Maven
./mvnw spring-boot:run

# Or run with Docker
docker compose up -d
```

## Documentation

- **[SKILL.md](SKILL.md)** - Complete skill documentation
- **[scripts/README.md](scripts/README.md)** - Script usage guide
- Front-end development guides:
  - **[references/VUE.md](references/VUE.md)** - Vue.js 3 guide (default)
  - **[references/REACT.md](references/REACT.md)** - React 18 guide
  - **[references/ANGULAR.md](references/ANGULAR.md)** - Angular 19 guide
  - **[references/VANILLA-JS.md](references/VANILLA-JS.md)** - Vanilla JavaScript guide
- **[references/DOCKER.md](references/DOCKER.md)** - Docker deployment guide

## Project Templates

### Docker Files
- `Dockerfile` - Standard JVM-based deployment
- `Dockerfile-native` - GraalVM native image build
- `docker-compose.yml` - Full stack with PostgreSQL
- `docker-compose-native.yml` - Native image with PostgreSQL

### Scripts
- `create-project-latest.sh` ⭐ - Creates project with latest Spring Boot version (recommended)
- `create-basic-project.sh` - Minimal Spring Boot project
- `create-web-project.sh` - Web application with REST APIs
- `create-fullstack-project.sh` - Complete application with database

## Key Principles

- ✅ Use latest Spring Boot and Java versions
- ✅ Use Maven for dependency management
- ✅ Use PostgreSQL for production databases
- ✅ Include Spring Boot DevTools for development
- ✅ No Spring Security by default (add when needed)
- ✅ No environment profiles (use environment variables)
- ✅ Docker-ready with native image support
- ✅ Multiple front-end framework options (Vue.js, React, Angular, Vanilla JS)

## Requirements

- bash
- curl
- unzip
- grep and sed
- Docker (for containerization)
- Java 21+ (for local development)

## License

See [LICENSE](LICENSE) file for details.

