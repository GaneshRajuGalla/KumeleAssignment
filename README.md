# Kumele Assignment

A demo iOS application built for the Kumele client assignment. It covers two deliverables: a swipe-based event matching UI with Passkey authentication, and a pixel-accurate Figma-to-SwiftUI conversion of the tablet History & Statistics screen.

---

## Demo

### Swipe Animation + Passkey Login

> 📹 _Video coming soon_

### History & Statistics (iPad)

https://github.com/user-attachments/assets/a7b7f3de-4e53-46ab-9c50-d14581287069

---

## Task 1 — Swipe Animation + Passkey Login

### Card Swipe

Tinder-style card stack built entirely in SwiftUI:

- `DragGesture` drives card position, rotation, and opacity in real time
- Velocity-based commit threshold — fast flick dismisses even a short drag
- 3-card depth stack with progressive scale, corner radius, and crossfade transition as each card is dismissed
- Color-themed cards using `kumeleYellow` and `kumeleCorals` from a `Color` extension

### Passkey Login

Native iOS passkey flow using `AuthenticationServices`:

- `ASAuthorizationPlatformPublicKeyCredentialProvider` for both registration and sign-in
- Full UI: username input sheet for registration, one-tap sign-in, graceful error messages
- "Skip → Demo Mode" bypasses auth for demo purposes
- Associated Domains entitlement pre-configured (`webcredentials:kumele.com`)

**To enable end-to-end passkey in production:**

1. Xcode → Target → Signing & Capabilities → **+ Associated Domains** → `webcredentials:kumele.com`
2. Serve at `https://kumele.com/.well-known/apple-app-site-association`:
   ```json
   { "webcredentials": { "apps": ["<TEAM_ID>.com.kumle.KumeleAssignment"] } }
   ```
3. Add WebAuthn endpoints: `/register/begin`, `/register/finish`, `/auth/begin`, `/auth/finish`

---

## Task 2 — Figma to SwiftUI (iPad Tablet Screen)

### What was built

The **History & Statistics** screen — a full iPad landscape layout (1194 × 834 pt) converted from Figma to production-quality SwiftUI, pixel-matched to the design spec.

### How it works: Figma MCP + Claude Code

The entire screen was built without manually opening Figma. Here's the exact workflow:

```
Figma File  ──▶  Figma MCP  ──▶  Claude Code  ──▶  SwiftUI
 (Design)        (API fetch)      (Code gen)        (Running app)
```

**Step 1 — Design extraction via Figma MCP**

Claude Code has a built-in Figma integration called **Figma MCP** (Model Context Protocol). By providing the Figma file ID and node ID, it fetches the complete design specification as structured JSON — every color value, font weight, spacing, layer name, and component hierarchy — directly from the Figma API. No screenshots, no manual inspection.

```
File: 7rW87FTAilAouVH3mhV66b
Node: 1:13  (History & Statistics, 1194×834 iPad landscape)
```

**Step 2 — Asset download**

`mcp__figma__download_figma_images` downloaded all assets as PNGs at 3× scale:
- `kumele_logo_bar.png` — top bar branding
- `user_avatar.png` — profile photo
- `medal_frame.png` — animated medal badge
- `icon_info.png` — medal info trigger
- Sidebar icons: `icon_home`, `icon_bookshelf`, `icon_basket`, `icon_account1/2/3`, `icon_events`, `icon_buy`
- Event category icons: `icon_spirituality`, `icon_party`, `icon_music`

**Step 3 — Code generation**

Claude Code translated the full design spec into SwiftUI with exact colors, fonts, and layout. No guesswork — all values came directly from the Figma JSON.

### What the screen does

| Feature | Detail |
|---------|--------|
| **Sidebar navigation** | 8 tappable icons, blue pill indicator animates to active icon using `matchedGeometryEffect` |
| **Top bar** | Kumele logo + user avatar, full-width above sidebar |
| **Pie chart** | Swift Charts `SectorMark`, Gold/Silver/Bronze medal distribution, scale-in spring animation on load |
| **Medal badge** | Continuous pendulum rotation animation (`-12° ↔ +12°`, `easeInOut`, loops forever) |
| **Medal info popup** | Tap the `i` icon next to any medal — animated sheet with achievement description and dismiss |
| **Bar chart** | Swift Charts `BarMark`, Mar–Nov, Jun bar permanently highlighted gold, grow-in animation on load |
| **Jun annotation** | Native-style `regularMaterial` tooltip above Jun bar showing event name, amount, and category |
| **Year selector** | `Menu` with 2020–2023 options, updates the pill label with animation |
| **iPhone fallback** | `horizontalSizeClass` check shows a placeholder on iPhone/compact — only iPad sees this screen |

### Why this workflow matters

| Traditional approach | Figma MCP + Claude Code |
|---|---|
| Open Figma, inspect every layer manually | API fetches entire spec as structured JSON — zero manual reading |
| Copy-paste hex colors and pt values | All values extracted programmatically, no human transcription errors |
| Write boilerplate SwiftUI layout by hand | Full view hierarchy generated from the spec |
| Add animations manually from intuition | Spec-driven: animated components identified and implemented as SwiftUI equivalents |
| 2–3 days for a screen this complex | **Under 2 hours** from Figma link to running code |

---

## Project Structure

| File | Purpose |
|------|---------|
| `KumeleAssignmentApp.swift` | App entry point |
| `ContentView.swift` | Auth gate — switches between Login and Home |
| `LoginView.swift` | Passkey login/registration screen |
| `PasskeyAuthManager.swift` | Passkey registration and sign-in logic |
| `HomeView.swift` | Tab bar shell with 5 tabs + iPad-only wrapper |
| `SwipeView.swift` | Card swipe feature + Kumele color theme |
| `HistoryStatisticsView.swift` | Figma → SwiftUI tablet History & Statistics screen |

---

## Requirements

- iOS / iPadOS 26+
- Xcode 26+
- Face ID or Touch ID for passkey flows
- iPad (any size) for the History & Statistics screen

---

## Author

Ganesh Raju Galla
