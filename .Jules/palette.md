## 2024-05-22 - Missing Accessibility on Icon-Only Buttons
**Learning:** Icon-only buttons in custom navigation components (`BottomBar`) were completely invisible to screen readers because they relied solely on visual icons without `accessibilityLabel` or `accessibilityHint`.
**Action:** When creating custom navigation components, always enforce `accessibilityLabel` as a required property in the button configuration struct (like `BarButton`), rather than relying on the consumer to remember to add the modifier. This makes accessibility "built-in" rather than "bolted-on".

## 2024-05-22 - Accessibility Gaps in Auxiliary Actions
**Learning:** Auxiliary actions like "Clear Search", "Close Modal", or "Back" are frequently implemented as simple icon-only buttons without accessibility labels, unlike primary navigation which often gets more attention.
**Action:** Always verify "xmark", "arrow.left", and "chevron.left" buttons for accessibility labels. Consider creating a reusable `IconAction` component that requires an accessibility label to prevent this oversight.
