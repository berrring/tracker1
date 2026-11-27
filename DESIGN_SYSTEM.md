# SafeTrack Family design system

SafeTrack uses a light Material 3 theme on Android, iOS and web. The map opens first. The four main destinations are **Карта**, **События**, **Семья** and **Устройство**. Flutter implements the design in `lib/app/design_tokens.dart` and `lib/app/design.dart`.

## Color

| Token | Hex | Use |
| --- | --- | --- |
| Primary | `#315C50` | Main actions, brand and interactive icons |
| Primary container | `#DCEBE5` | Selected navigation and demo notices |
| On primary | `#FFFFFF` | Text and icons on primary |
| Background | `#F7F9F8` | Main screen background |
| Surface | `#FFFFFF` | Cards, dialogs and sheets |
| Surface variant | `#EEF2F0` | Secondary surfaces |
| Primary text | `#18201D` | Headings, values and status labels |
| Secondary text | `#66716C` | Supporting text |
| Divider | `#D9E0DD` | Borders and separators |
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

Use the default Material font and respect system text scaling. Use spacing in increments of 4, 8, 12, 16, 24, 32 and 40 dp. Page gutters are 16 dp and the content column is capped at 560 dp. The header and bottom navigation align with that column on wide screens. Cards use a 20 dp radius, controls use 16 dp, the map uses 24 dp, and dialog and sheet corners use 28 dp. Status labels are pill-shaped.

## Components

| Component | Behavior |
| --- | --- |
| Navigation bar | Four fixed destinations with labels and selected icons. System Back returns from another destination to the map. |
| Panel | Bordered surface for tracker data, family access, settings and individual events. |
| Tag and StatusTag | Compact text and icon. Tracker states share their icon, accent and label across screens. |
| Metric and MetricGrid | Icon, label and value in reading order. Metrics wrap into one column at narrow widths or larger text sizes. |
| SectionHeading and PageList | Semantic heading and supporting text inside a scrollable, width-constrained screen. |
| DemoNotice | Tinted information surface for the warning that a real SOS will never be sent. |
| Material dialogs and sheets | Scrollable content and explicit actions for access review, device removal and SOS. |

Use the shared semantic Material icons in `SafeIcons` for recurring actions and tracker metrics. Keep destinations visible and text-labeled. Give icon-only buttons localized tooltips. Use at least 48 × 48 dp for controls. Retain essential status details in text outside the map illustration. Each screen respects the platform safe area.

## Demo flows

Pairing shows the access granted to each family member before explicit confirmation. Online SOS moves through preparation and sending to a clearly simulated acknowledgement. Offline SOS reports the last contact time and stays unconfirmed. Loading, empty, unavailable and error states give a visible explanation. The error action resets the local demo to its fresh state.

The app uses fictional people, positions and events. All scenarios and preferences are session-local. The Android and iOS shells use the same Flutter interface and local mock repository.
