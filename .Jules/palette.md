## 2024-05-22 - Missing Accessibility on Icon-Only Buttons
**Learning:** Icon-only buttons in custom navigation components (`BottomBar`) were completely invisible to screen readers because they relied solely on visual icons without `accessibilityLabel` or `accessibilityHint`.
**Action:** When creating custom navigation components, always enforce `accessibilityLabel` as a required property in the button configuration struct (like `BarButton`), rather than relying on the consumer to remember to add the modifier. This makes accessibility "built-in" rather than "bolted-on".

## 2024-05-24 - Accessibility Gaps in Modal & Auxiliary Actions
**Learning:** While primary navigation often gets accessibility attention, auxiliary actions like "Close" (xmark) in modals or "Clear" (xmark.circle) in search fields are frequently overlooked. These are critical for keyboard/VoiceOver users to escape states.
**Action:** Establish a "close loop" check: whenever adding a modal or overlay, immediately verify how a non-visual user would dismiss it. Explicitly label standard icons like `xmark` as "Close [Context]" rather than just "Close" to provide better orientation.
