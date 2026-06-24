# Pani, Puri & Paps 🍡

A **Flutter** application for *Pani, Puri & Paps — The Funky Street Food*.

Features a scroll-driven golden-puri-bursting animation, staggered menu cards,
and a contact-info modal — a faithful port of the original single-page HTML site
(preserved at [`legacy/index.html`](legacy/index.html)).

## Features

| | |
|---|---|
| 🍢 | **Scroll animation** — puri splits open and 180 pani drops burst outward as you scroll |
| 📋 | **Menu** — animated cards for Signature Pani Puri, Filter Coffee & Masala Chai |
| 📍 | **Contact modal** — stall location (Coles Street Market, Tuesday 4–7 pm) with Google Maps |
| 🌈 | **Pastel gradient** background with animated blob accents |

## Prerequisites

| Tool | Version |
|---|---|
| [Flutter SDK](https://docs.flutter.dev/get-started/install) | ≥ 3.16.0 |
| Dart SDK | Included with Flutter |
| Chrome | Recommended for web development |

## Getting Started

### 1. Clone

```bash
git clone https://github.com/sushanth-krishnaswamy/sushanth-krishnaswamy.github.io.git
cd sushanth-krishnaswamy.github.io
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run

**Web (closest to the original experience):**
```bash
flutter run -d chrome
```

**Android:**
```bash
flutter run -d android
```

**iOS:**
```bash
flutter run -d ios
```

**Any connected device:**
```bash
flutter run
```

## Testing

```bash
flutter test
```

This runs `test/widget_test.dart`, which covers:

- App boots without throwing
- Key UI elements are rendered (nav bar, hero text)
- Contact modal opens and closes correctly

To run with verbose output:

```bash
flutter test --reporter expanded
```

## Build for Web / GitHub Pages

```bash
# Build with root base-href (adjust if hosted in a subdirectory)
flutter build web --base-href /
```

Output is written to `build/web/`. Deploy that folder to GitHub Pages.

### Automated deployment (GitHub Actions)

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy Flutter Web
on:
  push:
    branches: [main]
jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.32.0'
          channel: stable
      - run: flutter pub get
      - run: flutter build web --base-href /
      - uses: peaceiris/actions-gh-pages@v4
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: build/web
```

## Project Structure

```
lib/
├── main.dart                       # App entry point
├── screens/
│   └── home_screen.dart            # Main scrollable screen (orchestrates all state)
├── widgets/
│   ├── nav_bar.dart                # Fixed navigation bar
│   ├── hero_section.dart           # Full-viewport hero with bouncing scroll indicator
│   ├── menu_section.dart           # Three staggered menu cards
│   ├── contact_modal.dart          # Contact info dialog with Google Maps link
│   └── footer.dart                 # Footer widget
├── painters/
│   ├── puri_rain_painter.dart      # CustomPainter — scroll-driven puri split + rain drops
│   └── menu_icon_painters.dart     # CustomPainters for Pani Puri and Masala Chai icons
├── models/
│   └── menu_item.dart              # MenuItem data model and static menu data
└── theme/
    └── colors.dart                 # App colour palette constants

web/                                # Flutter web bootstrap
android/                            # Android platform configuration
legacy/
└── index.html                      # Original HTML/CSS/JS implementation (reference)
test/
└── widget_test.dart                # Widget smoke tests
```

## How the Animation Works

The puri animation is driven purely by the scroll offset — no timers or
separate animation controllers:

1. `ScrollController` emits offsets → `scrollProgress = offset / (height × 0.9)`
2. `PuriRainPainter` receives `scrollProgress` (0 → 1.2) and redraws on each
   frame using `CustomPainter.shouldRepaint`.
3. **Puri split**: above `progress = 0.02` the two halves translate and rotate
   apart while fading out.
4. **Rain burst**: 180 deterministic particles (seeded `Random`) radiate from
   the puri centre with individual speed, drift, and delay values.
5. **Menu cards**: a single `AnimationController` starts when the user has
   scrolled 15 % of the viewport; staggered `Interval` curves drive each card.

## Troubleshooting

| Issue | Fix |
|---|---|
| Fonts look different | `google_fonts` loads Syne & Outfit at runtime; ensure internet access on first run |
| `flutter pub get` fails | Check your Flutter SDK version: `flutter --version` |
| Android build fails | Run `flutter doctor -v` and address any Android SDK issues |
| iOS build fails | Requires Xcode on macOS; run `flutter doctor -v` |
