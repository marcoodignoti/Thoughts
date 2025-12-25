## 2024-05-22 - Missing Accessibility on Icon-Only Buttons
**Learning:** Icon-only buttons in custom navigation components (`BottomBar`) were completely invisible to screen readers because they relied solely on visual icons without `accessibilityLabel` or `accessibilityHint`.
**Action:** When creating custom navigation components, always enforce `accessibilityLabel` as a required property in the button configuration struct (like `BarButton`), rather than relying on the consumer to remember to add the modifier. This makes accessibility "built-in" rather than "bolted-on".

## 2024-05-24 - Auxiliary Actions Miss Accessibility
**Learning:** Auxiliary actions like "Clear" or "Close" implemented as ad-hoc buttons inside Views often lack accessibility labels, unlike the shared components where it's enforced.
**Action:** When auditing views, specifically hunt for 'xmark', 'trash', and other utility icons used in plain `Button`s and ensure they have explicit `.accessibilityLabel` modifiers.
