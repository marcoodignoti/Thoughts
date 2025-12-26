# Bolt's Journal

## 2024-05-22 - DateFormatter Performance
**Learning:** `DateFormatter` is expensive to initialize. Creating it inside a `View`'s body or a frequently called method can cause stuttering, especially in lists.
**Action:** Always use a `static` property for `DateFormatter` or cache it in a singleton/extension.
