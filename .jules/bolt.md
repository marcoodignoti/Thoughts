# Bolt's Journal ⚡

## 2024-05-23 - Date Formatter Performance
**Learning:** Creating `DateFormatter` instances is expensive. Always use `static` properties for formatters that are used frequently, like in list cells.
**Action:** Check for `DateFormatter()` or `Date().formatted()` inside `List` or `ForEach` loops and replace with static shared instances.
