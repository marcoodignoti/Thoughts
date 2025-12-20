## 2024-05-22 - Missing Accessibility on Icon-Only Buttons
**Learning:** Icon-only buttons in custom navigation components (`BottomBar`) were completely invisible to screen readers because they relied solely on visual icons without `accessibilityLabel` or `accessibilityHint`.
**Action:** When creating custom navigation components, always enforce `accessibilityLabel` as a required property in the button configuration struct (like `BarButton`), rather than relying on the consumer to remember to add the modifier. This makes accessibility "built-in" rather than "bolted-on".

## 2024-05-24 - Accessibility Labels on Authentication Views
**Learning:** Back buttons and close buttons in modal/auth views often get overlooked because they are small iconography elements. Specifically, the "Back" arrow in AuthView and "X" in SettingsModal were unlabeled.
**Action:** Always audit `Image(systemName: ...)` usages inside `Button` closures to ensure they have an accompanying `.accessibilityLabel`.
