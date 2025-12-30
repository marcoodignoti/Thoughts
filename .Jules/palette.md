## 2024-05-22 - Missing Accessibility on Icon-Only Buttons
**Learning:** Icon-only buttons in custom navigation components (`BottomBar`) were completely invisible to screen readers because they relied solely on visual icons without `accessibilityLabel` or `accessibilityHint`.
**Action:** When creating custom navigation components, always enforce `accessibilityLabel` as a required property in the button configuration struct (like `BarButton`), rather than relying on the consumer to remember to add the modifier. This makes accessibility "built-in" rather than "bolted-on".

## 2024-05-24 - Accessibility Grouping for Composite Views
**Learning:** Complex composite views (like a user avatar `ZStack` containing a shape and text) are treated as separate, potentially confusing elements by VoiceOver unless explicitly grouped.
**Action:** Use `.accessibilityElement(children: .ignore)` to group the composite view into a single focusable element, and provide a comprehensive `.accessibilityLabel` that describes the entire component's purpose.
