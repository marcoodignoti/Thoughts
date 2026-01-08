# Bolt's Journal ⚡

## 2024-05-23 - Pre-calculation in SwiftUI Views
**Learning:** Performing O(N) calculations (like counting notes per notebook) directly in the body of a SwiftUI View causes visible stuttering during scrolling or state updates.
**Action:** Move expensive derived data calculations to the beginning of the `body` property or, better yet, into the ViewModel using `@Published` properties.

## 2024-05-23 - DateFormatter Performance
**Learning:** Creating new `DateFormatter` instances inside `List` rows (or any frequently called view) is extremely expensive and causes frame drops.
**Action:** Always use `static` instances for `DateFormatter` or cache them in the View/ViewModel. Avoid `Date().formatted()` in tight loops if possible as it also creates formatters under the hood.
