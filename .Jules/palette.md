## 2024-05-23 - Accessibility Label Omissions in Custom Navigation
**Learning:** Custom navigation implementations often rely on icon-only buttons (like `arrow.left` for back actions) which, unlike system navigation bars, do not get automatic accessibility labels. This leaves screen reader users stranded without context.
**Action:** Always verify custom navigation components (like back buttons or close buttons) have explicit `.accessibilityLabel` modifiers during code review.
