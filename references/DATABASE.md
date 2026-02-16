# Database Best Practices (PostgreSQL)

## Contents
- [Defaults](#defaults)
- [Spring Boot Configuration](#spring-boot-configuration)
- [SQL Initialization Structure](#sql-initialization-structure)
- [Testcontainers Integration](#testcontainers-integration)
- [Docker Compose (Dev)](#docker-compose-dev)
- [Production Tips](#production-tips)
- [Local Developer Experience](#local-developer-experience)
- [Observability](#observability)
- [Validation / Checks](#validation--checks)
- [Troubleshooting](#troubleshooting)
- [References](#references)

## Defaults
- **Engine:** PostgreSQL (preferred version: **16**; configure in `versions.json`).
- **Migrations:** ✅ **Spring Boot SQL Initialization** (`schema.sql` / `data.sql`).
- **Driver:** `org.postgresql:postgresql` (bundled via start.spring.io dependency).
- **Testcontainers:** Use `postgres:16-alpine` images.

## Spring Boot Configuration

`src/main/resources/application.properties`:
```properties
# Datasource
spring.datasource.url=jdbc:postgresql://localhost:5432/mydb
spring.datasource.username=user
spring.datasource.password=${DATABASE_PASSWORD:password}
spring.datasource.driver-class-name=org.postgresql.Driver

# JPA
spring.jpa.hibernate.ddl-auto=validate
spring.jpa.show-sql=false
spring.jpa.properties.hibernate.format_sql=false
spring.jpa.open-in-view=false

# SQL Initialization
spring.sql.init.mode=always
spring.sql.init.schema-locations=classpath:schema.sql
spring.sql.init.data-locations=classpath:data.sql
# Run SQL init before JPA/Hibernate validation
spring.jpa.defer-datasource-initialization=true
```

## SQL Initialization Structure
```
src/main/resources/
  schema.sql          # DDL: CREATE TABLE, indexes, constraints
  data.sql            # DML: INSERT seed/reference data (optional)
```

> ⚠️ **GraalVM Native Images:** `schema.sql` and `data.sql` are **not** automatically included in native images. You must register them explicitly. See the [GraalVM Guide — SQL Initialization Native Image Configuration](GRAALVM.md#sql-initialization-native-image-configuration) for the required `SqlInitNativeConfiguration` class and `resource-config.json`.

SQL schema example (`schema.sql`):
```sql
CREATE TABLE IF NOT EXISTS app_user (
  id BIGSERIAL PRIMARY KEY,
  login VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(191) UNIQUE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

SQL data example (`data.sql`):
```sql
-- Optional: insert seed data
INSERT INTO app_user (login, email) VALUES ('admin', 'admin@example.com')
  ON CONFLICT (login) DO NOTHING;
```

## Testcontainers Integration
```java
@TestConfiguration(proxyBeanMethods = false)
class TestcontainersConfiguration {
  @Bean
  @ServiceConnection
  PostgreSQLContainer postgresContainer() {
    return new PostgreSQLContainer("postgres:16-alpine")
      .withReuse(true);
  }
}
```
Use `@Import(TestcontainersConfiguration.class)` in integration tests. Keep class **package-private** (Boot 4 requirement).

## Docker Compose (Dev)
`compose.yaml` (used by `spring-boot-docker-compose`):
```yaml
services:
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD", "pg_isready", "-U", "user"]
      interval: 10s
      timeout: 5s
      retries: 5
volumes:
  postgres_data:
```

## Production Tips
- **Pooling:** Use HikariCP defaults; tune `maximum-pool-size` and `connection-timeout`.
- **Indexes:** Add indexes via `schema.sql`, not in code.
- **Secrets:** Inject via environment variables or Vault/Key Vault; never commit plaintext.
- **Schema Validation:** Keep `spring.jpa.hibernate.ddl-auto=validate` in prod.
- **UTF-8:** Ensure DB encoding is UTF8 (default for official Postgres images).

## Local Developer Experience
- Enable `spring-boot-docker-compose` (Boot 3.1+) to auto-start `compose.yaml` on `./mvnw spring-boot:run`.
- Provide `.env.sample` with placeholders: `DATABASE_PASSWORD`, etc. (see [Project Setup](PROJECT-SETUP.md)).

## Observability
- Expose Postgres metrics via `pg_stat_statements`; integrate with Micrometer if needed.
- Consider **pgBouncer** for high-connection scenarios; document in ops runbook.

## Validation / Checks
- Add a health-check table in `schema.sql` to validate DB readiness.
- Add integration test to verify SQL initialization ran (e.g., `SELECT count(*) FROM app_user`).

## Troubleshooting
- Common error: `FATAL: password authentication failed` — verify `spring.datasource.*` and `compose.yaml` env vars match.
- Timeouts in CI: increase Testcontainers startup timeout or use `withReuse(true)` + `~/.testcontainers.properties`.

## References

- [Spring Boot Data Access](https://docs.spring.io/spring-boot/reference/data/sql.html)
- [Spring Boot SQL Initialization](https://docs.spring.io/spring-boot/reference/data/sql.html#howto.data-initialization.using-basic-sql-scripts)
- [Testcontainers PostgreSQL Module](https://java.testcontainers.org/modules/databases/postgres/)
- [Docker Deployment Guide](DOCKER.md) — `compose.yaml` setup
- [Configuration Best Practices](CONFIGURATION.md) — externalized config & secrets
- [Project Setup](PROJECT-SETUP.md) — `.env.sample` for database credentials
