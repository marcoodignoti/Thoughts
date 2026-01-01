# Bolt's Journal

## 2024-05-22 - Static DateFormatter
**Learning:** `DateFormatter` initialization is expensive and should be cached in a static property, especially when used in computed properties accessed by SwiftUI views.
**Action:** Always check for `DateFormatter()` in computed properties and move them to `private static let`.
