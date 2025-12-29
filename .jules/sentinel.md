## 2024-12-14 - Input Validation Missing
**Vulnerability:** Registration flow lacked input validation for email format and password length, allowing invalid data and weak passwords.
**Learning:** Even simple SwiftUI forms need explicit validation logic; relying on keyboard types is insufficient for security.
**Prevention:** Always implement server-side or strong client-side validation logic before persisting data to SwiftData.
