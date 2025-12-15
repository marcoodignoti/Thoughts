## 2024-05-23 - Accessibility Labels on Icon Buttons
**Learning:** Adding `.accessibilityLabel` to custom SwiftUI button components like `BarButton` requires updating the struct definition to accept a label, enforcing accessibility by design.
**Action:** When creating reusable UI components with icons, always include a mandatory `label` or `accessibilityLabel` parameter.
