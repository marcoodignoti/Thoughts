## 2024-05-22 - Missing Accessibility on Icon-Only Buttons
**Learning:** Icon-only buttons in custom navigation components (`BottomBar`) were completely invisible to screen readers because they relied solely on visual icons without `accessibilityLabel` or `accessibilityHint`.
**Action:** When creating custom navigation components, always enforce `accessibilityLabel` as a required property in the button configuration struct (like `BarButton`), rather than relying on the consumer to remember to add the modifier. This makes accessibility "built-in" rather than "bolted-on".

## 2024-05-24 - Accessibility Gaps in Auxiliary Actions
**Learning:** Secondary actions like "Clear Search" or "Close Modal" are often overlooked during accessibility passes compared to primary navigation. These icon-only buttons (`xmark`, `xmark.circle.fill`) become "unlabeled button" barriers for screen reader users, trapping them in modals or leaving them unable to reset states.
**Action:** Systematically audit all modal headers and search bars specifically for "exit" and "reset" actions. Use a checklist that explicitly includes "Close/Cancel buttons" and "Input clear buttons" during UI verification.
