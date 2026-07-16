# Delivery Slot Reservation - Interview Task

## Goal

Build one API that lets a customer reserve an available grocery delivery slot.

You do not need to build authentication, payments, cancellation, or background expiry jobs.

## What Is a Delivery Slot?

A delivery slot has:

- a date
- a start and end time
- a maximum number of reservations

For example, a slot on `2026-07-15` from `09:00` to `11:00` with capacity `2` can be reserved by two customers.

## API to Build

```http
POST /slots/reserve
```

### Request

```json
{
  "date": "2026-07-15",
  "startTime": "09:00",
  "endTime": "11:00",
  "customerId": "CUST-001"
}
```

### Successful Response - `201 Created`

```json
{
  "reservationId": 1,
  "customerId": "CUST-001",
  "status": "ACTIVE",
  "createdAt": "2026-07-15T09:30:00"
}
```

## Required Behaviour

Implement these rules:

1. The request must contain a date, start time, end time, and customer ID.
2. The start time must be before the end time.
3. The requested slot must exist.
4. A reservation cannot be created when the slot is full.
5. A customer cannot reserve the same slot more than once.

Use appropriate HTTP responses:

| Situation | Suggested status |
| --- | ---: |
| Invalid request | `400 Bad Request` |
| Slot does not exist | `404 Not Found` |
| Slot is full or already reserved by this customer | `409 Conflict` |

## Suggested Data Model

Create database tables for:

- **delivery_slot** - date, start time, end time, maximum capacity
- **reservation** - customer ID, slot reference, status, created time

Add at least one delivery slot so the API can be demonstrated immediately.

## Talk Us Through Your Design

Before implementing, briefly explain your approach to the interviewer. There is no single correct answer; we want to understand how you make design decisions.

Be ready to discuss:

1. The tables, columns, relationships, and primary keys you would create.
2. Which database constraints or indexes you would add, and why.
3. How you would prevent duplicate reservations and avoid exceeding a slot's capacity.
4. Any assumptions you have made or questions you would ask before building the feature.
5. Your implementation plan: the order in which you would create the migration, entities, repositories, service, controller, and tests.
6. How your design could change if the service later needed to handle many reservations at the same time.

## Using AI Tools

You are welcome to use AI tools, documentation, and online resources during this task.

Please use them openly and be prepared to explain your approach, the decisions you made, and any generated code that you include. We are assessing your understanding and reasoning, not whether every line was written without assistance.

## What to Deliver

1. Flyway migration(s) in `src/main/resources/db/migration/`
2. A working `POST /slots/reserve` endpoint
3. Validation and error responses for the rules above
4. A short walkthrough of your database design and implementation plan
5. A Swagger UI demonstration

## Suggested Order of Work

1. Create the database tables and a sample slot.
2. Create JPA entities and repositories.
3. Add the request and response models.
4. Implement the reservation service and business rules.
5. Add the controller endpoint.
6. Run the application and test the endpoint in Swagger UI.

## Already Available

| What | Where |
| --- | --- |
| Spring Boot app | `InterviewKit.java` |
| H2 in-memory database | Pre-configured in `application.yaml` |
| Flyway migrations | `src/main/resources/db/migration/` |
| Swagger UI | [http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html) |
| H2 Console | [http://localhost:8080/h2-console/](http://localhost:8080/h2-console/) (JDBC URL: `jdbc:h2:mem:interview`, User: `sa`, no password) |
| Health check | `GET /hello` |
| JPA + Hibernate | Ready to use (`show-sql` enabled) |
| Lombok | Available |
| Bean Validation | Available (`jakarta.validation`) |

## How to Run

```bash
./gradlew bootRun
```

The application starts on port `8080`.

1. Open [http://localhost:8080/hello](http://localhost:8080/hello) to confirm it is running.
2. Open [http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html) to test the API.
