# Delivery Slot Reservation — Interview Task

## Goal

Build one API that reserves a place on a delivery slot for a customer.

When a customer picks a delivery slot we hold their place for **20 minutes** while they finish checking out, so the slot cannot be oversold.

You do **not** need to build authentication, checkout, payments, or expiry handling.

---

## The Domain

Each delivery slot can take a fixed number of orders. Reserving a place uses one of them.

```
SLOT-2026-08-20-AM   capacity: 4

  Alice reserves   →   remaining: 3
  Bob   reserves   →   remaining: 2
  Carol reserves   →   remaining: 1
  Dan   reserves   →   remaining: 0

Erin asks for a place →  rejected, slot is full
```

Each slot also has a **cut-off time**. Once that has passed the slot is closed and nobody can reserve it, even if it still has room.

That is the whole model. One count per slot, reduced when a place is taken, and a time after which the slot is shut.

---

## API to Build

```http
POST /slot-reservations
```

### Request

```json
{
  "slotId": "SLOT-2026-08-20-AM",
  "customerId": "CUST-001"
}
```

### Successful Response — `201 Created`

```json
{
  "reservationId": 1,
  "slotId": "SLOT-2026-08-20-AM",
  "customerId": "CUST-001",
  "status": "ACTIVE",
  "createdAt": "2026-08-13T12:00:00Z",
  "expiresAt": "2026-08-13T12:20:00Z"
}
```

---

## Required Behaviour

| # | Rule | Suggested response |
| --- | --- | --- |
| 1 | The request must contain a slot ID and a customer ID | `400 Bad Request` |
| 2 | The slot must exist | `404 Not Found` |
| 3 | The slot's cut-off time must not have passed | `409 Conflict` |
| 4 | The slot must have at least one place remaining | `409 Conflict` |
| 5 | A successful reservation uses one of the slot's remaining places | — |
| 6 | The reservation records when it was created and when it expires, 20 minutes later | — |

The 20 minutes should be configurable rather than a magic number in your logic.

Rule 3 means your code needs to read the current time. Think about how you do that, and how you would test it.

You do **not** need to make expiry actually happen — no background job, no returning the place to the slot. Just record `expiresAt` correctly. We will talk about how you would handle expiry afterwards.

---

## Suggested Data Model

- **delivery_slot** — slot ID, delivery date, start and end of the window, capacity, cut-off time
- **slot_reservation** — slot ID, customer ID, status, created time, expiry time

Seed three or four slots so the API can be demonstrated immediately. Make sure at least one of them is already past its cut-off, and at least one is full, so you can show every response code.

---

## Where to Start

If you are unsure how to begin, this order works well:

1. **Migration** — create both tables and insert the seed slots. Restart the app and check the tables in the H2 console.
2. **Entities and repositories** — one for each table.
3. **Request and response models** — plain objects with validation annotations.
4. **Service** — look up the slot, check the cut-off, check the remaining places, take one, save the reservation.
5. **Controller** — one `POST` mapping calling the service.
6. **Error handling** — map your failures onto the right status codes.
7. **Demonstrate** in Swagger UI.

Ask us questions at any point. Talking through a decision is not a sign you are stuck — it is what we want to see.

---

## Talk Us Through Your Design First

**Before writing code**, spend about ten minutes on your approach. There is no single correct answer — we are more interested in how you decide than in what you decide.

Please cover:

1. **Your tables** — columns, keys, relationships.
2. **Counting the places** — do you store what is remaining, what is used, or work it out from the reservations? What does each choice cost you?
3. **Constraints and indexes** — what would you add, and why that one?
4. **The race** — four customers hold the last place at the same instant. What happens in your design, and what does the loser see?
5. **Time** — the cut-off rule depends on "now". How do you get the current time, and how do you write a test for a slot that closes at 10pm?
6. **Expiry** — you are not building it today, but how would you make reservations actually expire and give the place back?
7. **Assumptions** — what have you assumed, and what would you have asked a product owner first?

---

## What to Deliver

1. Flyway migration(s) in `src/main/resources/db/migration/`, with seed data
2. A working `POST /slot-reservations` endpoint
3. Validation and error responses covering the rules above
4. A Swagger UI demonstration

Tests are not required, though we would like to hear how you would test this.

---

## Using AI Tools

You are welcome to use AI tools, documentation, and online resources.

Please use them openly. We will ask you to explain any code you produce, including generated code — what it does, why it is there, and what you would change. We are assessing your understanding and judgement, not whether every line was typed unaided.

---

## Running the Application

```bash
./gradlew bootRun
```

The application starts on port `8080`.

- Health check — [http://localhost:8080/hello](http://localhost:8080/hello)
- Swagger UI — [http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html)
- H2 Console — [http://localhost:8080/h2-console/](http://localhost:8080/h2-console/) (JDBC URL `jdbc:h2:mem:interview`, user `sa`, no password)

## Already Available

| What | Where |
| --- | --- |
| Spring Boot app | `InterviewKit.java` |
| H2 in-memory database | Pre-configured in `application.yaml` |
| Flyway migrations | `src/main/resources/db/migration/` |
| Swagger UI | [http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html) |
| Health check | `GET /hello` |
| JPA + Hibernate | Ready to use (`show-sql` enabled) |
| Lombok | Available |
| Bean Validation | Available (`jakarta.validation`) |

> **Note:** the app runs with `spring.jpa.hibernate.ddl-auto: validate`, so your entity mappings must match your migration exactly. If startup fails with a schema validation error, that is why.
