# RaceDay API Endpoint Plan

| HTTP method | Route | Description | Role required | Request body | Expected response |
| :--- | :--- | :--- | :--- | :--- | :--- |
|## Authentication|
| POST | /api/auth/register | Registers a new user into the system. | None | { "firstName", "lastName", "email", "password", "role" } | 201 Created - User object. 400 Bad Request - Invalid data. |
| POST | /api/auth/login | Authenticates a user and returns a JWT token. | None | { "email", "password" } | 200 OK - Token and User object. 401 Unauthorized - Invalid credentials. |
| ## User Profile |
| GET | /api/users/{id} | Retrieves a specific user's profile details. | Any | None | 200 OK - User object. 404 Not Found - User doesn't exist. |
| PUT | /api/users/{id} | Updates the logged-in user's profile details. | Any | { "firstName", "lastName", "phone", "emergencyContact" } | 200 OK - Updated User object. 403 Forbidden - User is not the owner. |
|## Events and Categories|
| GET | /api/events | Retrieves a list of all events. | None (Public) | None | 200 OK - List of Event objects. |
| GET | /api/events/{id} | Retrieves details of a specific event. | None (Public) | None | 200 OK - Event object. 404 Not Found - Event doesn't exist. |
| POST | /api/events | Creates a new event. | Organizer / Admin | { "name", "description", "eventDate", "location", "entryFee", "maxParticipants", "categoryId" } | 201 Created - Event object. 403 Forbidden - Not an Organizer. |
| PUT | /api/events/{id} | Updates an existing event's details. | Organizer / Admin | { "name", "description", "eventDate", "location" } | 200 OK - Updated Event. 404 Not Found - Event doesn't exist. |
| DELETE | /api/events/{id} | Permanently deletes an event. | Admin | None | 204 No Content. 404 Not Found - Event doesn't exist. |
| **Categories** |
| GET | /api/categories | Retrieves all event categories. | None (Public) | None | 200 OK - List of Category objects. |
| POST | /api/categories | Creates a new category. | Admin | { "categoryName", "description", "minAge", "maxAge", "distanceKm" } | 201 Created - Category object. 403 Forbidden - Not an Admin. |
| **Event Enrolments** |
| POST | /api/events/{eventId}/enrol | Records a new enrolment for the logged-in user. | Any | { "categoryId" } | 201 Created - Enrolment object. 409 Conflict - Already enrolled. |
| GET | /api/enrolments/my | Retrieves all events the logged-in user enrolled in. | Any | None | 200 OK - List of Enrolment objects. |
| DELETE | /api/enrolments/{enrolmentId} | Withdraws a user from an event. | Any | None | 204 No Content. 404 Not Found - Enrolment doesn't exist. |
|## Enrolments and Results|
| GET | /api/events/{eventId}/results | Retrieves the final results for a specific event. | None (Public) | None | 200 OK - List of Result objects sorted by time. |
| POST | /api/events/{eventId}/results | Records a result for a participant in a specific event. | Organizer / Admin | { "participantId", "finishTime", "position" } | 201 Created - Result object. 404 Not Found - User/Event doesn't exist. |
