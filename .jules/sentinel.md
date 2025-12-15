## 2024-05-23 - [Plaintext Password Migration]
**Vulnerability:** User passwords were stored in plaintext in the `User` model, exposed via `passwordHash` property.
**Learning:** Even in local-first apps with no backend, storing passwords in plaintext is a critical risk. Migrating data in SwiftData without a formal migration framework requires careful in-app logic (e.g., check-and-update on login).
**Prevention:** Always use hashing (e.g., SHA256) before storing passwords, regardless of the persistence layer.
