## 2024-05-22 - DateFormatter Performance in SwiftUI Lists
**Learning:** Initializing `DateFormatter` inside a computed property used in a SwiftUI List/Grid causes significant performance degradation because it is re-initialized on every render.
**Action:** Always cache `DateFormatter` instances in a static property or use the new `formatted()` API (if strictly matching format is not required) for models used in lists.
