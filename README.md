# Kumele Assignment

A demo iOS app built as part of a client test task for Kumele — a hobby-matching platform. The project has two parts: a swipe-based card UI with Passkey login, and a Figma design converted into a fully working iPad SwiftUI screen.

---

## Demo

### Swipe Animation + Passkey Login

https://github.com/user-attachments/assets/ec882a8e-fae1-48c0-b98d-0c201d8faad8

### History & Statistics — iPad

https://github.com/user-attachments/assets/a7b7f3de-4e53-46ab-9c50-d14581287069

---

## Getting Started

```bash
git clone https://github.com/GaneshRajuGalla/KumeleAssignment.git
```

Open `KumeleAssignment.xcodeproj` in Xcode, then:

- Run on an **iPhone** to try the swipe animation and Passkey login
- Run on an **iPad** to see the History & Statistics screen

> Requires Xcode 26+ and iOS / iPadOS 26+

---

## Features

### Part 1 — Swipe Animation + Passkey Login

**Card Swipe**

- Drag to swipe cards left or right with real-time rotation and fade
- A quick flick dismisses the card even with a short drag
- Three cards stack behind the active card, each with a slightly different scale and corner radius
- Smooth crossfade as a new card enters the stack

**Passkey Login**

- Register with a username — stored as a passkey using Face ID or Touch ID
- One-tap sign in on return visits using `AuthenticationServices`
- "Skip to Demo Mode" lets you jump straight into the app without registering

> For full passkey support in production, the server needs to host an Apple App Site Association file and WebAuthn endpoints. The app entitlement is already set up.

---

### Part 2 — Figma to SwiftUI (iPad)

The **History & Statistics** screen was built by reading the Figma design file directly through the Figma API — no manual layer inspection needed. Every color, spacing value, font size, and asset was pulled straight from the design and translated into SwiftUI code.

**Screen includes:**

- Sidebar with 8 icons — the active indicator slides smoothly between icons using `matchedGeometryEffect`
- Pie chart with Gold / Silver / Bronze medal segments, animates in on load
- Medal badge with a continuous pendulum swing
- Tap the info icon on any medal to see a detail popup with a spring animation
- Bar chart (Mar–Nov) with Jun highlighted in gold and an event tooltip above it
- Year dropdown to switch between 2020–2023
- On iPhone, a simple placeholder is shown instead — this screen is iPad only

---

## Project Structure

| File | Description |
|------|-------------|
| `KumeleAssignmentApp.swift` | App entry point |
| `ContentView.swift` | Switches between login and home based on auth state |
| `LoginView.swift` | Passkey login and registration UI |
| `PasskeyAuthManager.swift` | Handles passkey registration and sign-in |
| `HomeView.swift` | Tab bar with 5 tabs and iPad-only screen wrapper |
| `SwipeView.swift` | Card swipe UI and color theme |
| `HistoryStatisticsView.swift` | History & Statistics iPad screen |

---

## Author

Ganesh Raju Galla
