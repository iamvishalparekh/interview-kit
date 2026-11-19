# Interview Kit

## Quick Start

```bash
./gradlew bootRun
```

- App: [http://localhost:8080/hello](http://localhost:8080/hello)
- Swagger UI: [http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html)
- H2 Console: [http://localhost:8080/h2-console/](http://localhost:8080/h2-console/) (JDBC URL: `jdbc:h2:mem:interview`, User: `sa`, no password)

## Prerequisites

- Java 25

## Task

The interview task will be shared with you at the start of the session.

## Project Structure

```
src/main/java/uk/co/sainsburys/op/
├── InterviewKit.java          ← Spring Boot entry point
└── HelloController.java       ← Health check endpoint

src/main/resources/
├── application.yaml           ← H2 + JPA configuration
└── db/migration/
    └── V1__create_hello.sql   ← Sample Flyway migration
```
