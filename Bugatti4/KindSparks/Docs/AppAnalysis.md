# KindSparks Application Analysis

## 1. Purpose and Scope

KindSparks is an iOS application for storing and organizing gift ideas by person. Users can add people, attach gift ideas to each person, view all ideas in one list or by date in a calendar, and view statistics. The app targets iOS 16.0+ and is built with SwiftUI.

## 2. Architecture Overview

- **Pattern:** MVVM-style structure with a shared `DataManager` (ObservableObject) holding the single source of truth. Views observe `DataManager.shared` and trigger load/save operations; there are no separate ViewModel classes per screen.
- **Entry point:** `KindSparksApp` registers fonts, wraps the root in `AganimProphet` (splash/loader), and shows `ContentView`. `ContentView` switches between `OnboardingView` and `MainTabView` based on first-launch flag.
- **Navigation:** Tab-based main flow (People, All Ideas, Calendar, Statistics, Settings). Drill-down uses `NavigationStack` / `NavigationLink`; some flows use sheets (e.g. Add Person, Add Idea). Detail screens receive IDs (e.g. `personId`, `ideaId`) and resolve entities via `DataManager`.
- **Persistence:** All data is stored in `UserDefaults` under a single key. Models (`Person`, `GiftIdea`) are `Codable`; the whole `people` array is encoded/decoded on load and save.

## 3. Main Modules

| Module        | Role |
|---------------|------|
| **Models**    | `Person` (id, name, ideas), `GiftIdea` (id, text, personId, createdAt). Both are structs and `Codable`. |
| **Managers** | `DataManager`: load/save people, CRUD for people and ideas, helpers like `getIdeas(for date)`, `getPerson(by id)`, `getIdea(ideaId)`, `loadSampleData()`. |
| **Views**     | People list, Gift Ideas list per person, Add/Edit Idea, All Ideas, Calendar (custom grid + ideas by date), Statistics (charts), Settings, Onboarding, Splash. |
| **Components**| `BackgroundView` (gradient + grid), `CustomTabBar`. |
| **Utils**     | `AppColors` / `Color` extensions for app-wide colors; `FontManager` for Ubuntu font registration. |
| **Data**      | `SampleData.generate()` builds sample people and ideas with varied `createdAt` dates for testing. |

## 4. Data Flow

- **Read:** Views use `@StateObject private var dataManager = DataManager.shared` and computed properties (e.g. `dataManager.people`, `dataManager.getIdeas(for: date)`). No separate repositories or services.
- **Write:** Views call `DataManager` methods (`addPerson`, `addIdea`, `updateIdea`, `deleteIdea`, `loadSampleData`). `DataManager` updates `people` and calls `savePeople()` to persist to `UserDefaults`.
- **Detail by ID:** Screens such as `GiftIdeasView(personId:)` and `ViewIdeaView(ideaId:personId:)` load the current entity from `DataManager` by ID so they always reflect the latest saved state.

## 5. Strengths and Risks

- **Strengths:** Simple, consistent structure; single place for persistence; ID-based navigation avoids stale object references; sample data and Settings entry for loading it improve testability.
- **Risks:** No real backend or sync; large lists could stress `UserDefaults` and full-array encode/decode; no migration strategy if the model changes; accent/contrast depend on color scheme (e.g. yellow on white may need adjustment).

## 6. Technology Stack

- **UI:** SwiftUI only.
- **Minimum deployment:** iOS 16.0.
- **Fonts:** Custom Ubuntu family registered via `FontManager` and used via `Font.ubuntu(_:weight:)`.
- **Charts:** Swift Charts for Statistics (bar charts, etc.).
- **Other:** StoreKit for review prompt; `Calendar` and `DateFormatter` for date handling; no third-party UI or networking libraries in the core flow.
