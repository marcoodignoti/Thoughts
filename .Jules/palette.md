## 2024-05-22 - Missing Accessibility on Icon-Only Buttons
**Learning:** Icon-only buttons in custom navigation components (`BottomBar`) were completely invisible to screen readers because they relied solely on visual icons without `accessibilityLabel` or `accessibilityHint`.
**Action:** When creating custom navigation components, always enforce `accessibilityLabel` as a required property in the button configuration struct (like `BarButton`), rather than relying on the consumer to remember to add the modifier. This makes accessibility "built-in" rather than "bolted-on".

## 2024-05-24 - Widespread Missing Accessibility Labels on Auxiliary Actions
**Learning:** While primary navigation often gets accessibility attention, auxiliary actions like "Close" buttons in modals (`SettingsModal`), "Clear" buttons in search fields (`SearchOverlay`), and shortcut buttons (`HomeView`) are frequently missed. These are critical for navigation flow but often implemented as ad-hoc icon buttons without labels.
**Action:** Establish a pattern where any `Image(systemName: ...)` wrapped in a `Button` must be accompanied by an `.accessibilityLabel`. Consider creating a `IconButton` component that requires a label to prevent this omission in the future.
