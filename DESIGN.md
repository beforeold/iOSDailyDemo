---
version: alpha
name: iOS Daily Demo
description: Shared visual direction for iOS 16+ UIKit demo projects in iOSDailyDemo.
colors:
  primary: "#0057B8"
  tertiary: "#0A7F7D"
  background: "#F2F2F7"
  surface: "#FFFFFF"
  surface-secondary: "#F9FAFB"
  on-surface: "#1C1C1E"
  secondary: "#6E6E73"
  separator: "#D1D1D6"
typography:
  headline-lg:
    fontFamily: SF Pro
    fontSize: 28px
    fontWeight: 700
    lineHeight: 1.18
    letterSpacing: 0px
  headline-md:
    fontFamily: SF Pro
    fontSize: 22px
    fontWeight: 700
    lineHeight: 1.22
    letterSpacing: 0px
  body-md:
    fontFamily: SF Pro
    fontSize: 17px
    fontWeight: 400
    lineHeight: 1.35
    letterSpacing: 0px
  body-sm:
    fontFamily: SF Pro
    fontSize: 15px
    fontWeight: 400
    lineHeight: 1.35
    letterSpacing: 0px
  label-md:
    fontFamily: SF Pro
    fontSize: 15px
    fontWeight: 600
    lineHeight: 1.2
    letterSpacing: 0px
  caption:
    fontFamily: SF Pro
    fontSize: 13px
    fontWeight: 400
    lineHeight: 1.25
    letterSpacing: 0px
spacing:
  xxs: 4px
  xs: 8px
  sm: 12px
  md: 16px
  lg: 20px
  xl: 24px
  xxl: 32px
rounded:
  sm: 8px
  md: 12px
  lg: 16px
  full: 9999px
components:
  page:
    backgroundColor: "{colors.background}"
    textColor: "{colors.on-surface}"
  card:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.on-surface}"
    rounded: "{rounded.md}"
    padding: "{spacing.lg}"
  divider:
    backgroundColor: "{colors.separator}"
    textColor: "{colors.on-surface}"
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.surface}"
    typography: "{typography.label-md}"
    rounded: "{rounded.md}"
    padding: "{spacing.md}"
  button-tinted:
    backgroundColor: "{colors.surface-secondary}"
    textColor: "{colors.primary}"
    typography: "{typography.label-md}"
    rounded: "{rounded.md}"
    padding: "{spacing.md}"
  metadata-label:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.secondary}"
    typography: "{typography.caption}"
  status-pill:
    backgroundColor: "{colors.surface-secondary}"
    textColor: "{colors.tertiary}"
    typography: "{typography.caption}"
    rounded: "{rounded.full}"
    padding: "{spacing.sm}"
---

# iOS Daily Demo Design System

## Overview

This repository is a collection of small, focused iOS demos. Interfaces should
feel native, calm, and immediately inspectable. Favor UIKit conventions over
custom visual systems, but avoid the unstyled starter-project look by using
clear grouping, deliberate spacing, and a small amount of character through a
fresh blue-green accent.

The target audience is developers reading or running isolated demos. Screens
should prioritize clarity, repeatable controls, and quick understanding over
marketing composition or decorative illustration.

## Colors

Use iOS system color behavior where possible, mapping these tokens to UIKit
dynamic colors instead of hard-coded values when the platform already provides
the correct semantic role.

- **Primary (#0057B8):** A deeper iOS system-blue inspired color for the main
  interactive action on a screen, chosen for AA contrast with white text.
- **Tertiary (#0A7F7D):** A restrained blue-green accent for lightweight status,
  selected-state hints, or subtle emphasis. Do not use it as a second primary
  action color.
- **Background (#F2F2F7):** Grouped background, matching
  `UIColor.systemGroupedBackground`.
- **Surface (#FFFFFF):** Primary card and grouped content surface.
- **Surface Secondary (#F9FAFB):** Soft inset or pill surface for status and
  supporting controls.
- **On Surface (#1C1C1E):** Primary readable text, matching iOS label intent.
- **Secondary (#6E6E73):** Captions, helper text, and low-emphasis metadata.
- **Separator (#D1D1D6):** Hairline borders and internal dividers.

## Typography

Use San Francisco through UIKit APIs. In code, prefer
`UIFont.preferredFont(forTextStyle:)` and apply weights with
`UIFontMetrics` where needed so text respects Dynamic Type.

Headlines should be compact and purposeful. Body text should be concise. Button
labels should use medium or semibold weight, never all caps. Letter spacing
should remain neutral; do not tighten display text.

## Layout

Use an 8pt spacing rhythm with 4pt only for micro-adjustments. Screens should
respect safe areas and `layoutMarginsGuide`. Typical card padding is 20pt, with
16pt between closely related controls and 24-32pt between major groups.

For demo screens, prefer a single scroll view or centered content stack with a
readable maximum width on larger devices. Do not leave controls floating in the
middle of an otherwise empty view.

## Elevation & Depth

Use tonal layering first: grouped background, white cards, secondary pills, and
thin separators. Shadows should be subtle and only used to lift cards from the
background. Avoid heavy, blurred, or colorful shadows.

Recommended card shadow for UIKit demos: black at 6-8% opacity, radius 10-16,
vertical offset 4-8.

## Shapes

Cards use 12pt corner radius by default. Buttons use 12pt for rectangular
controls and full rounding only for small pills or status chips. Keep shape
language consistent within a screen.

Avoid nested cards. If content needs hierarchy inside a card, use spacing,
dividers, typography, or a subtle secondary surface.

## Components

**Cards:** Use white or system background surfaces with 12pt radius, 20pt
padding, and optional hairline border or subtle shadow.

**Buttons:** Prefer `UIButton.Configuration.tinted()` for secondary/demo
actions and `.filled()` for the one primary action. Include SF Symbols when the
icon clarifies the command. Keep touch targets at least 44pt high.

**Menus:** Use native `UIMenu` and `UIAction`. Use horizontal inline groups only
when comparing menu layout behavior or presenting compact peer actions.

**Status pills:** Use a secondary surface, rounded full, caption typography, and
secondary text. Status should reflect the latest user interaction without
dominating the screen.

## Do's and Don'ts

- Do read this file before creating or restyling any demo UI.
- Do prefer UIKit semantic colors and Dynamic Type over fixed visual constants.
- Do keep demo screens dense enough to understand the API being demonstrated.
- Do use `systemGroupedBackground` plus card surfaces for simple UIKit demos.
- Don't use large hero sections, gradients, decorative blobs, or stock imagery
  in utility demos.
- Don't mix more than one accent color on a single screen.
- Don't hard-code dark-mode-incompatible colors unless the demo specifically
  tests color behavior.
- Don't use custom fonts or third-party UI libraries for basic demos.
