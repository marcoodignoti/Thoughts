# Bolt's Journal

## 2024-05-22 - DateFormatter Performance
**Learning:** Creating `DateFormatter` instances is expensive. In list views, creating a new formatter for each row can significantly drop scrolling frame rates.
**Action:** Use `static let` or a shared singleton for `DateFormatter` when used in lists or repetitive views.

## 2024-05-22 - List Filtering
**Learning:** Filtering arrays in `body` re-computes on every state change, even unrelated ones.
**Action:** Move complex filtering logic to ViewModels and use `@Published` properties or caching where possible, especially for large datasets.
