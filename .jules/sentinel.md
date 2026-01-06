# Sentinel's Journal

## 2024-10-24 - Plaintext Password Storage
**Vulnerability:** User passwords were stored in plaintext in the `passwordHash` field of the `User` model, and authentication compared plaintext inputs directly against the stored value.
**Learning:** The field name `passwordHash` created a false sense of security, masking the fact that no hashing was actually taking place.
**Prevention:** Always verify cryptographic implementation details. Do not trust variable names. Use type systems or distinct types (e.g. `HashedPassword`) to distinguish between raw and processed data if possible.

## 2024-10-25 - Verification of Security Claims
**Vulnerability:** Input validation (email regex, password length) described in project documentation/memory was missing from the actual codebase.
**Learning:** Documentation and memory can drift from reality. Security features listed as "implemented" must be verified in code. "Trust but verify" applies to internal documentation too.
**Prevention:** When performing security audits, treat documentation as a claim to be tested, not as a source of truth.
