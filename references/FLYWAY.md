# Flyway Database Migrations

## Overview
Flyway is the enterprise standard for versioned database migrations. It ensures that every database instance (Dev, Staging, Prod) has the exact same schema by applying a sequence of SQL scripts.

## Core Principles
1. **Immutable Migrations**: Once a migration (e.g., `V1__init.sql`) is applied, it must **never** be changed.
2. **Sequential Versioning**: Migrations are applied in order based on their version number (`V1`, `V2`, `V3`).
3. **Repeatability**: Anyone can clone the repo and run `./mvnw spring-boot:run` to get a fully functional database.

## Naming Convention
Files must follow the pattern: `V<Version>__<Description>.sql`
- `V`: Prefix for versioned migrations.
- `<Version>`: Unique version number (e.g., `1`, `1.1`, `202401010000`).
- `__`: Two underscores separator.
- `<Description>`: Snake_case description (e.g., `create_user_table`).
- `.sql`: Extension.

Example: `V1__create_users.sql`

## Storage Location
Place all scripts in `src/main/resources/db/migration/`.

## Best Practices
1. **Schema per Tenant**: If building multi-tenant apps, use one schema per tenant and apply migrations to all.
2. **Avoid JPA DDL in Prod**: Set `spring.jpa.hibernate.ddl-auto=validate` in production.
3. **Rollbacks**: Flyway Community doesn't support automatic rollbacks. To fix a mistake, create a *new* migration (e.g., `V3__fix_column_name.sql`).
4. **Baseline**: If adding Flyway to an existing database, use `spring.flyway.baseline-on-migrate=true`.
5. **No Logic in SQL**: Keep scripts pure SQL. Avoid vendor-specific procedural logic unless strictly necessary.

## Troubleshooting
- **Checksum Mismatch**: Occurs when a migration file was edited after being applied. Fix by restoring the original file or (in Dev) running `flyway repair`.
- **Pending Migrations**: Check the `flyway_schema_history` table to see which scripts have been applied.
