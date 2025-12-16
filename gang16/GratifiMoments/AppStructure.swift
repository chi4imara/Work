/*
 GratifiMoments - iOS Gratitude Journal App
 
 ARCHITECTURE: MVVM (Model-View-ViewModel)
 TARGET: iOS 16.0+
 LANGUAGE: Swift, SwiftUI
 
 APP STRUCTURE:
 
 📱 Main Entry Point:
 - GratifiMomentsApp.swift: App entry point
 - MainAppView.swift: Main coordinator view
 
 🎨 UI Components:
 - SplashView.swift: Animated splash screen with loader
 - OnboardingView.swift: Multi-page onboarding flow
 - HomeView.swift: Main gratitude input screen
 - JournalView.swift: List of all gratitude entries with search
 - EditGratitudeView.swift: Edit existing gratitude entries
 - RandomGratitudeView.swift: Display random past gratitude
 - TipsView.swift: Inspiration and tips for users
 - SettingsView.swift: App settings and legal links
 - CustomTabBar.swift: Custom 5-tab navigation bar
 
 📊 Data Layer:
 - GratitudeEntry.swift: Core data model for gratitude entries
 - GratitudeViewModel.swift: Business logic and data management
 
 🎨 Design System:
 - ColorScheme.swift: App color palette and gradients
 - FontManager.swift: Custom font registration (Builder Sans)
 - BackgroundView: Reusable gradient background
 
 📁 Folder Structure:
 /GratifiMoments/
   ├── Models/           # Data models
   ├── ViewModels/       # Business logic
   ├── Views/           # UI components
   ├── Builder Sans/    # Custom fonts
   └── Assets.xcassets/ # App assets
 
 KEY FEATURES:
 ✅ Daily gratitude entry (one per day)
 ✅ Gratitude journal with search and filtering
 ✅ Random gratitude display
 ✅ Tips and inspiration
 ✅ Edit/delete functionality
 ✅ Persistent storage via UserDefaults
 ✅ Custom fonts and gradient backgrounds
 ✅ Animated splash screen
 ✅ Onboarding flow
 ✅ StoreKit app rating integration
 ✅ Settings with external links
 
 NAVIGATION:
 Tab 0: Home (Daily gratitude input)
 Tab 1: Journal (All entries with search)
 Tab 2: Random (Random past gratitude)
 Tab 3: Tips (Inspiration and guidance)
 Tab 4: Settings (App settings and info)
 
 DATA PERSISTENCE:
 - Uses UserDefaults for simplicity
 - JSON encoding/decoding for GratitudeEntry objects
 - Automatic save on entry creation/modification
 
 DESIGN PRINCIPLES:
 - Minimalist, calming interface
 - Gradient backgrounds with subtle animations
 - Custom Builder Sans font family
 - Blue/purple/yellow color scheme
 - Consistent spacing and typography
 - Accessible and user-friendly
*/
