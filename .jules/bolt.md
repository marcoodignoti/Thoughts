# Bolt's Journal ⚡

## 2024-05-22 - [Found Missing DateFormatter Cache]
**Learning:** `HomeView` was re-instantiating `DateFormatter` on every render in a computed property, despite `Note` model having a static one.
**Action:** Always check computed properties for heavy object initialization like `DateFormatter` or `NumberFormatter`.
