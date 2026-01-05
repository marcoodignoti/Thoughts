# Sentinel's Journal

## 2024-10-24 - Plaintext Password Storage
**Vulnerability:** User passwords were stored in plaintext in the `passwordHash` field of the `User` model, and authentication compared plaintext inputs directly against the stored value.
**Learning:** The field name `passwordHash` created a false sense of security, masking the fact that no hashing was actually taking place.
**Prevention:** Always verify cryptographic implementation details. Do not trust variable names. Use type systems or distinct types (e.g. `HashedPassword`) to distinguish between raw and processed data if possible.

## 2024-10-24 - Missing Input Validation on Auth
**Vulnerability:** The registration flow lacked validation for email format and password length, allowing invalid emails and weak passwords (e.g., empty or single character) to be created.
**Learning:** Assuming UI keyboards (`.keyboardType(.emailAddress)`) provide validation is a common mistake; they only provide hints, not enforcement.
**Prevention:** Always enforce data constraints at the logic/model level (e.g., in the action handler), regardless of UI hints.
