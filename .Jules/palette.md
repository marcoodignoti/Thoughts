## 2024-05-22 - Missing Accessibility on Icon-Only Buttons
**Learning:** Icon-only buttons in custom navigation components (`BottomBar`) were completely invisible to screen readers because they relied solely on visual icons without `accessibilityLabel` or `accessibilityHint`.
**Action:** When creating custom navigation components, always enforce `accessibilityLabel` as a required property in the button configuration struct (like `BarButton`), rather than relying on the consumer to remember to add the modifier. This makes accessibility "built-in" rather than "bolted-on".

## 2024-05-24 - Missing Accessibility on Icon-Only Buttons (Widespread)
**Learning:** Found multiple instances of icon-only buttons (Back, Close, Clear, Create) lacking `accessibilityLabel`. This pattern suggests a lack of default accessibility awareness when using system images.
**Action:** Add a lint rule or checklist item to verify `accessibilityLabel` whenever `Image(systemName: ...)` is used inside a `Button` without text.
