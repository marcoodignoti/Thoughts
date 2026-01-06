## 2024-05-23 - Interactive Card Accessibility
**Learning:** Complex interactive cards (like `NotebookCard`) composed of multiple text/image elements often result in fragmented VoiceOver experiences (reading "Folder", then "Name", then "Count" separately).
**Action:** Use `.accessibilityElement(children: .ignore)` (or implicit via Button) and provide a single, comprehensive `.accessibilityLabel` (e.g., "Notebook: [Name], [Count] thoughts") to create a cohesive and efficient user experience.

## 2024-05-23 - Icon-Only Button Labels
**Learning:** Icon-only buttons (common in headers, modals, search fields) are frequently missed during accessibility sweeps, resulting in "Button" or "xmark" being announced.
**Action:** Establish a mandatory check for `.accessibilityLabel` on all `Image(systemName: ...)` based buttons during development and code review.
