# Sentinel's Journal

## 2024-10-24 - Plaintext Password Storage
**Vulnerability:** User passwords were stored in plaintext in the `passwordHash` field of the `User` model, and authentication compared plaintext inputs directly against the stored value.
**Learning:** The field name `passwordHash` created a false sense of security, masking the fact that no hashing was actually taking place.
**Prevention:** Always verify cryptographic implementation details. Do not trust variable names. Use type systems or distinct types (e.g. `HashedPassword`) to distinguish between raw and processed data if possible.

## 2024-10-24 - Missing Input Validation Gap
**Vulnerability:** The codebase lacked input validation (email regex, password length) despite documentation/memory suggesting it was "strict".
**Learning:** Documentation and memory can desynchronize from the codebase. Trust code over descriptions.
**Prevention:** Always verify security controls in the actual source code, regardless of what documentation claims.
