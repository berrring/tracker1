# SafeTrack Family design system

SafeTrack uses forest green, neutral surfaces, Inter and a custom route mark on Android, iOS and web. The map opens first. The four main destinations are **Карта**, **События**, **Семья** and **Устройство**. Flutter implements the design in `lib/app/design_tokens.dart` and `lib/app/design.dart`.

## Color

| Token | Hex | Use |
| --- | --- | --- |
| Primary | `#17493B` | Main actions, brand and interactive icons |
| Primary container | `#DFEDE5` | Selected navigation and demo notices |
| On primary | `#FFFFFF` | Text and icons on primary |
| Background | `#F3F5F1` | Main screen background |
| Surface | `#FFFFFF` | Cards, dialogs and sheets |
| Surface variant | `#EEF2F0` | Secondary surfaces |
| Primary text | `#142420` | Headings, values and status labels |
| Secondary text | `#505F59` | Supporting text |
| Divider | `#DCE4DD` | Borders and separators |
| Success | `#287A55` | Fresh data and restored connection |
| Warning | `#B56C12` | Stale data, low charge and recoverable errors |
| Danger | `#C83C3C` | Test SOS and Material error affordances |
| Offline | `#6E7371` | Offline, unavailable and neutral states |

Status indicators combine a label and a Material icon. Accent colors support recognition while the label uses the primary text color.

## Type and layout

| Role | Size | Weight |
| --- | --- | --- |
| Prominent value | 28 sp | Semibold |
| Screen heading | 24 sp | Semibold |
| Section heading | 18 sp | Semibold |
| Body | 16 sp | Regular |
| Supporting text | 14 sp | Regular |
| Compact label | 12 sp | Medium |

Inter ships locally under the SIL Open Font License. Respect system text scaling. Use spacing in increments of 4, 8, 12, 16, 24, 32 and 40 dp. Mobile and tablet use bottom navigation with platform safe areas. At 960 dp, switch to a 248 dp sidebar. The desktop map fills the available space next to a distinct status panel. Use 14 dp card corners, 10 dp controls, 16 dp map corners and 20 dp sheet corners.

## Components

| Component | Behavior |
| --- | --- |
| Navigation bar | Four fixed destinations with labels. Wide screens use a dedicated sidebar. System Back returns from another destination to the map. |
| Panel | Bordered surface for tracker data, family profiles, settings and grouped timeline rows. |
| Tag and StatusTag | Compact text and icon. Tracker states share their icon, accent and label across screens. |
| Metric and MetricGrid | Icon, label and value in reading order. Metrics wrap into one column at narrow widths or larger text sizes. |
| SectionHeading and PageList | Semantic heading and supporting text inside a scrollable, width-constrained screen. |
| DemoNotice | Tinted information surface for the warning that a real SOS will never be sent. |
| Material dialogs and sheets | Scrollable content and explicit actions for access review, device removal and SOS. |

Use the shared semantic Material icons in `SafeIcons` for recurring actions and tracker metrics. Keep destinations visible and text-labeled. Give icon-only buttons localized tooltips. Use at least 48 × 48 dp for controls. Retain essential status details in text outside the map illustration. Each screen respects the platform safe area.

## Demo flows

Pairing shows the access granted to each family member before explicit confirmation. Online SOS moves through preparation and sending to a clearly simulated acknowledgement. Offline SOS reports the last contact time and stays unconfirmed. Loading, empty, unavailable and error states give a visible explanation. The error action resets the local demo to its fresh state.

The app uses fictional people, positions and events. Web demo scenarios and preferences use local browser storage. Mobile sessions remain local to the app. The Android and iOS shells use the same Flutter interface and local mock repository.
