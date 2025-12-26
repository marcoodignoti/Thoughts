# Sentinel's Journal

## 2024-10-24 - Plaintext Password Storage
**Vulnerability:** User passwords were stored in plaintext in the `passwordHash` field of the `User` model, and authentication compared plaintext inputs directly against the stored value.
**Learning:** The field name `passwordHash` created a false sense of security, masking the fact that no hashing was actually taking place.
**Prevention:** Always verify cryptographic implementation details. Do not trust variable names. Use type systems or distinct types (e.g. `HashedPassword`) to distinguish between raw and processed data if possible.

## 2024-10-26 - Missing Input Validation Gap
**Vulnerability:** Input validation (email format, password length) was missing in `AuthView.swift` despite documentation/memory suggesting it was present.
**Learning:** Documentation and "known state" can desynchronize from the actual codebase. Manual verification of security controls is essential.
**Prevention:** Don't assume validation exists. Always check the entry points for user data. Add explicit unit tests for validation logic to ensure it persists.
