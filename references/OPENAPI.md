# OpenAPI and Swagger Best Practices

## Overview
Enterprise applications must be documented to facilitate collaboration with frontend teams and external consumers. Spring Boot 4 projects use **Springdoc-OpenAPI** to automatically generate OpenAPI 3.0 specifications and Swagger UI.

## Maven Dependencies
Add the following to your `pom.xml`:

```xml
<dependency>
    <groupId>org.springdoc</groupId>
    <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
    <version>${springdoc-openapi.version}</version>
</dependency>
```

## Configuration
`src/main/resources/application.properties`:

```properties
# Enable Springdoc
springdoc.api-docs.enabled=true
springdoc.swagger-ui.enabled=true

# Custom paths
springdoc.api-docs.path=/api-docs
springdoc.swagger-ui.path=/swagger-ui.html

# Group configuration
springdoc.group-configs[0].group=public
springdoc.group-configs[0].paths-to-match=/api/**
```

## Annotations
Use standard OpenAPI annotations to enrich your documentation:

```java
@RestController
@RequestMapping("/api/users")
@Tag(name = "User Management", description = "Operations related to user accounts")
public class UserController {

    @Operation(summary = "Get user by ID", description = "Returns a single user record")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "User found"),
        @ApiResponse(responseCode = "404", description = "User not found")
    })
    @GetMapping("/{id}")
    public User getUser(@PathVariable Long id) {
        // ...
    }
}
```

## Security Integration
If Spring Security is present, configure OpenAPI to handle JWT/OAuth2 tokens:

```java
@Configuration
@OpenAPIDefinition(
    info = @Info(title = "My Enterprise API", version = "1.0"),
    security = @SecurityRequirement(name = "bearerAuth")
)
@SecurityScheme(
    name = "bearerAuth",
    type = SecuritySchemeType.HTTP,
    scheme = "bearer",
    bearerFormat = "JWT"
)
public class OpenApiConfig {}
```

## Best Practices
1. **API First**: Consider defining your contract before implementation.
2. **Naming**: Use descriptive summaries and tags.
3. **Problem Details**: Ensure your error responses follow RFC 7807 and are documented in Swagger.
4. **Version Control**: If necessary, export the `openapi.json` and commit it to version control for client generation.
