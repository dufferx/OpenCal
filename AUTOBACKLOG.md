# OpenCal Autonomous Development Backlog

> This file is the single source of truth for the autonomous agent pipeline.
> Agents read this file, pick the next task, implement it, and update status.
> Human verifies builds and merges. No agent modifies this file directly except via scripted helpers.

---

## 🟡 In Progress

- [ ] **User Profile Screen** — Full profile editing (name, photo, body stats, daily macro goals, API key management). Accessible from top-right avatar in Home. Reuses onboarding components where possible. Must follow existing `UserProfileRepositoryProtocol`, `@Observable` MVVM, and SwiftData-safe patterns.

---

## 📋 Todo (Priority Order)

### Phase 1 — Core Screens (MVP Completion)
- [ ] **Progress Screen** — Weekly average calories, consumption charts (Swift Charts), deficit/surplus % using `calories burned - calories consumed`. Different color scheme from Home.
- [ ] **Library / Food Database Screen** — Personal food database persisted locally. Add items via scan, label scan, or manual entry. Reusable across sessions. Items can be stored without adding to daily log.
- [ ] **Profile → API Key Management Sub-screen** — Dedicated view to view/edit/switch AI provider (OpenAI/Gemini) and API key. Stored in Keychain only. Visual validation indicator.

### Phase 2 — AI & Scan Features
- [ ] **Nutrition Label Scan** — Vision framework (`VNRecognizeTextRequest`) + OCR parser for packaged product labels. Flow: camera → text extraction → macro parsing → confirmation → log/library.
- [ ] **Gemini Client Implementation** — `GeminiClient: AIClientProtocol` using Google Generative AI API. Activate runtime switch in `AIClientFactory` based on key prefix.
- [ ] **Food Library Save from Scan** — In `FoodScanConfirmationView`, add "Save to Library" option alongside "Add to Log".

### Phase 3 — HealthKit & Platform
- [ ] **HealthKit Integration** — Read `activeEnergyBurned` and `dietaryEnergyConsumed`. Calculate real deficit/surplus. Show on Progress screen. Wrap in `HealthStoreProtocol`.
- [ ] **Sign in with Apple** — Onboarding step 1 replacement/addition. `ASAuthorizationController`. Store credential state. Required for iCloud sync later.

### Phase 4 — Polish & Quality
- [ ] **Accessibility Audit** — VoiceOver labels on all icon-only buttons (`chevron.left`, `xmark`, etc.). Traits on tappable rows. Dynamic Type support verification.
- [ ] **Deprecated API Cleanup** — Replace remaining `foregroundColor()` → `foregroundStyle()`, `showsIndicators: false` → `.scrollIndicators(.hidden)`, `navigationBarHidden` → `.toolbar(.hidden, for: .navigationBar)`.
- [ ] **Subview Extraction** — `CalorieArcView`, `MealCard`, `FoodScanCameraView` still contain computed view properties. Extract to standalone `View` structs in separate files.
- [ ] **Concurrency Cleanup** — Replace any remaining `DispatchQueue.main.async` / `DispatchQueue.global` with `Task` / `Task.detached` / `Task.sleep`.

---

## ✅ Done

- [x] Onboarding flow (7 steps: photo/name, sex, birthdate, weight/height, goals, API key, HealthKit permissions)
- [x] Home Screen (calendar strip, calorie arc, macro rings, meals list, swipe-to-delete, pull-to-refresh)
- [x] Food Scan with OpenAI Vision (camera, photo picker, description overlay, analyzing animation, confirmation with editable macros)
- [x] Manual Entry form (calories, protein, carbs, fat) with validation
- [x] SwiftData persistence for food entries (`FoodEntryRecord`, `FoodRepository`)
- [x] User profile persistence (`UserProfileRepository`, `ProfileImageStore`)
- [x] API Key secure storage in Keychain (`KeychainHelper`)
- [x] Tab navigation with Quick Action sheet (+ button)
- [x] `@Observable` migration across all ViewModels and `AppState`
- [x] TextField lag fixes (local state binding in scan, onboarding, manual entry)
- [x] Typography migrated to semantic fonts with Dynamic Type
- [x] `ContentUnavailableView` for empty meal states

---

## 🏷️ Tags

| Tag | Meaning |
|---|---|
| `blocked` | Cannot start until another task completes |
| `needs-human` | Requires human decision (design, API key, provisioning) |
| `swiftui-only` | Pure SwiftUI code — safe for full agent autonomy |
| `xcode-required` | Needs Xcode build / simulator / device test |
| `architecture` | Touches protocols, models, or layer boundaries |

---

*Last updated: Autonomous pipeline initialization.*
