## 2024-05-23 - DateFormatter Performance in SwiftUI
**Learning:** `DateFormatter` initialization is expensive (~0.5ms-2ms). In SwiftUI computed properties (like `currentDate` in `HomeView`), creating a new formatter on every access causes unnecessary overhead during view updates.
**Action:** Always use `static let` or cached formatters for date operations in SwiftUI views.
