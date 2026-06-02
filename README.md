# Kumele Assignment

A demo iOS application built for the Kumele client assignment showcasing a swipe-based event/match UI and Passkey authentication.

---

## Demo

### Swipe Animation

<!-- Add swipe animation video here -->
> 📹 _Video coming soon_

### Passkey Login

<!-- Add passkey demo video here -->
> 📹 _Video coming soon_

---

## Features

### Task 1 — Swipe Animation + Passkey Login

- **Card Swipe UI** — Tinder-style card stack with drag gesture, rotation effect, velocity-based commit, and a 3-card depth stack with progressive scale and corner radius
- **Passkey Integration** — Native iOS passkey registration and sign-in using `AuthenticationServices` (`ASAuthorizationPlatformPublicKeyCredentialProvider`)

### Task 2 — Figma to Code *(coming soon)*

- Tablet UI conversion from Figma design

---

## Architecture

| File | Purpose |
|------|---------|
| `KumeleAssignmentApp.swift` | App entry point |
| `ContentView.swift` | Auth gate — switches between Login and Home |
| `LoginView.swift` | Passkey login screen |
| `PasskeyAuthManager.swift` | Passkey registration & authentication logic |
| `HomeView.swift` | Tab bar shell with 5 tabs |
| `SwipeView.swift` | Card swipe feature + theme colors |

---

## Passkey Setup (Full Integration)

To enable end-to-end passkey authentication:

1. **Xcode** → Target → Signing & Capabilities → **+ Associated Domains**
   ```
   webcredentials:kumele.com
   ```

2. **Server** — serve this file at `https://kumele.com/.well-known/apple-app-site-association`:
   ```json
   {
     "webcredentials": {
       "apps": ["TEAMID.com.kumle.KumeleAssignment"]
     }
   }
   ```

3. The app handles registration, assertion, and all error states. The backend developer needs to implement `/register/begin`, `/register/finish`, `/auth/begin`, `/auth/finish` WebAuthn endpoints.

---

## AI Tools Used

- **Claude Code** — SwiftUI architecture, passkey implementation, layout debugging, code review and cleanup
- **Axiom** — iOS skill suite for SwiftUI patterns, security (passkeys), and build diagnostics

---

## Requirements

- iOS 26.2+
- Xcode 26+
- iPhone / iPad (Face ID or Touch ID for passkeys)

---

## Author

Ganesh Raju Galla
