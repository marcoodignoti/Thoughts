## 2024-05-21 - [DateFormatter Caching Strategy]
**Learning:** This codebase relies on `static let` formatters (e.g., in `Note` model) to avoid expensive instantiation. `HomeView` was violating this.
**Action:** Always check computed properties in Views for expensive object creations like `DateFormatter` and move them to shared extensions.
