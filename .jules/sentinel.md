# Sentinel's Journal

## 2024-10-24 - Plaintext Password Storage
**Vulnerability:** User passwords were stored in plaintext in the `passwordHash` field of the `User` model, and authentication compared plaintext inputs directly against the stored value.
**Learning:** The field name `passwordHash` created a false sense of security, masking the fact that no hashing was actually taking place.
**Prevention:** Always verify cryptographic implementation details. Do not trust variable names. Use type systems or distinct types (e.g. `HashedPassword`) to distinguish between raw and processed data if possible.

## 2025-12-20 - Input Validation & Legacy Data
**Vulnerability:** Missing input validation for email and password allowed invalid data and weak security.
**Learning:** Enforcing new security constraints (like password length) on existing users can cause lockouts.
**Prevention:** Implement "lazy enforcement" - check constraints only on new data creation (registration) or updates, while allowing legacy data to persist until updated.
