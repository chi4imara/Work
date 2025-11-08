# MovieTime - Movie Diary App

## Project Structure

### Core Files
- `MovieTimeApp.swift` - Main app entry point with font registration and Core Data setup
- `ContentView.swift` - Root view with splash screen, onboarding, and main app navigation

### Models & Data
- `Models/Movie.swift` - Core Data model for watched movies
- `Models/WishlistMovie.swift` - Core Data model for wishlist movies
- `Models/MovieDataModel.xcdatamodeld/` - Core Data model definition
- `Core/CoreDataManager.swift` - Core Data management and operations
- `Core/AppColors.swift` - Centralized color scheme

### ViewModels (MVVM Architecture)
- `ViewModels/MoviesViewModel.swift` - Main movies list logic with filtering and sorting
- `ViewModels/WishlistViewModel.swift` - Wishlist management logic
- `ViewModels/CalendarViewModel.swift` - Calendar view logic

### Views
- `Views/SplashView.swift` - Animated splash screen
- `Views/OnboardingView.swift` - Multi-page onboarding experience
- `Views/MoviesView.swift` - Main movies list with filtering and actions
- `Views/CalendarView.swift` - Calendar view showing movies by date
- `Views/FavoritesView.swift` - Favorite movies list
- `Views/WishlistView.swift` - Movies to watch list
- `Views/SettingsView.swift` - App settings and legal links
- `Views/MovieDetailView.swift` - Detailed movie view
- `Views/MovieFormView.swift` - Add/edit movie form
- `Views/WishlistFormView.swift` - Add/edit wishlist movie form

### Components
- `Views/Components/CustomTabBar.swift` - Custom bottom tab navigation
- `Views/Components/MovieCardView.swift` - Movie card component with swipe actions
- `Views/Components/FiltersView.swift` - Movie filtering interface

### Resources
- `Resources/` - Custom Poppins fonts (Regular, Medium, SemiBold, Bold, Light)
- `FontManager.swift` - Font registration and custom font extensions

## Features Implemented

### ✅ Core Features
- [x] Splash screen with animated loader
- [x] Onboarding flow
- [x] Custom tab bar navigation
- [x] Movies list with filtering and sorting
- [x] Calendar view with movie dates
- [x] Favorites management
- [x] Wishlist functionality
- [x] Add/edit movie forms
- [x] Movie details view
- [x] Settings screen

### ✅ UI/UX Features
- [x] Custom color scheme (black background, yellow accents)
- [x] Gradient backgrounds
- [x] Custom fonts (Poppins family)
- [x] Swipe actions on cards
- [x] Multiple selection mode
- [x] Animated transitions
- [x] Form validation

### ✅ Data Management
- [x] Core Data integration
- [x] MVVM architecture
- [x] Movie archiving
- [x] Favorites system
- [x] Notes and reviews
- [x] Rating system (1-10)
- [x] Genre categorization

### ✅ Technical Requirements
- [x] iOS 16.0+ target
- [x] SwiftUI implementation
- [x] No storyboards
- [x] English language
- [x] StoreKit rating integration
- [x] All buttons functional
- [x] No emojis (system icons only)

## App Flow
1. **Splash Screen** → Animated loader (2 seconds)
2. **Onboarding** → 3-page introduction (first launch only)
3. **Main App** → Tab-based navigation:
   - Movies: Main list with filtering/sorting
   - Calendar: Date-based movie view
   - Favorites: Starred movies
   - Wishlist: Movies to watch
   - Settings: App preferences and links

## Data Models
- **Movie**: title, genre, watchDate, rating, review, watchLocation, notes, isFavorite, isArchived
- **WishlistMovie**: title, genre, note, isPriority

## Color Scheme
- Background: Black with gradient
- Primary Text: Yellow
- Secondary Text: White
- Cards: Dark gray gradient
- Accents: Yellow, with green/red for actions

The app is fully functional and ready for use as a personal movie diary application.
