## 2024-05-24 - Accessibility Gaps in Overlay Views
**Learning:** Auxiliary actions like "Clear search" in `SearchOverlay` and "Close" in `SettingsModal` often get missed during accessibility audits because they appear dynamically or are secondary to the main flow. These icon-only buttons are unusable for screen reader users without explicit labels.
**Action:** When reviewing overlay or modal views, specifically hunt for `xmark` or clear/close icons and verify they have an `.accessibilityLabel`.
