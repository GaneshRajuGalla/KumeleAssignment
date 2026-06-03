# Kumele Assignment

A demo iOS app built as part of a client test task for Kumele, a hobby-matching platform. The project has two parts: a swipe-based card UI with Passkey login, and a Figma design converted into a fully working iPad SwiftUI screen.

---

## Demo

### Swipe Animation + Passkey Login

https://github.com/user-attachments/assets/ec882a8e-fae1-48c0-b98d-0c201d8faad8

### History & Statistics (iPad)

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

Swipe cards built with SwiftUI and native Passkey login using Face ID / Touch ID via `AuthenticationServices`. Use **Skip to Demo Mode** to explore the app without registering.

> For full passkey support in production, the server needs to host an Apple App Site Association file and WebAuthn endpoints. The app entitlement is already configured.

---

### Part 2 — Figma to SwiftUI (iPad)

The **History & Statistics** screen was built by reading the Figma design file directly through the Figma API. No manual layer inspection needed. Every color, spacing value, font size, and asset was pulled straight from the design and translated into SwiftUI code.

**Workflow**

```mermaid
flowchart LR
    A[🎨 Figma Design] -->|File ID + Node ID| B[Figma MCP]
    B -->|Design spec as JSON| C[Colors · Fonts · Spacing · Layers]
    B -->|PNG at 3x| D[Icons · Logos · Avatars]
    C --> E[Claude Code]
    D --> E
    E -->|Generated & refined| F[SwiftUI Code]
    F --> G[📱 Running iOS App]

    style A fill:#1e1e2e,color:#cdd6f4,stroke:#89b4fa
    style B fill:#313244,color:#cdd6f4,stroke:#89b4fa
    style C fill:#313244,color:#cdd6f4,stroke:#a6e3a1
    style D fill:#313244,color:#cdd6f4,stroke:#a6e3a1
    style E fill:#1e1e2e,color:#cdd6f4,stroke:#f38ba8
    style F fill:#313244,color:#cdd6f4,stroke:#fab387
    style G fill:#1e1e2e,color:#cdd6f4,stroke:#a6e3a1
```

---

## Project Structure

```mermaid
flowchart TD
    A[KumeleAssignmentApp] --> B[ContentView\nAuth gate]
    B --> C[LoginView\nPasskey login & registration]
    B --> D[HomeView\nTab bar]
    C --> E[PasskeyAuthManager\nRegistration & sign-in]
    D --> F[SwipeView\nCard swipe UI]
    D --> G[HistoryStatisticsView\nFigma → SwiftUI iPad screen]

    style A fill:#1e1e2e,color:#cdd6f4,stroke:#89b4fa
    style B fill:#313244,color:#cdd6f4,stroke:#89b4fa
    style C fill:#313244,color:#cdd6f4,stroke:#fab387
    style D fill:#313244,color:#cdd6f4,stroke:#89b4fa
    style E fill:#1e1e2e,color:#cdd6f4,stroke:#fab387
    style F fill:#1e1e2e,color:#cdd6f4,stroke:#a6e3a1
    style G fill:#1e1e2e,color:#cdd6f4,stroke:#a6e3a1
```

---

## Author

Ganesh Raju Galla
