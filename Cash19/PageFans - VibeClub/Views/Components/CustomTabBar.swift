import SwiftUI

enum TabItem: String, CaseIterable {
    case books = "Books"
    case library = "Library"
    case history = "History"
    case wishlist = "Wishlist"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .books:
            return "book.fill"
        case .library:
            return "books.vertical.fill"
        case .history:
            return "clock.fill"
        case .wishlist:
            return "star.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
    
    var title: String {
        return self.rawValue
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.primaryBlue.opacity(0.2), radius: 10, x: 0, y: -5)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(AppColors.primaryBlue)
                            .frame(width: 40, height: 40)
                            .scaleEffect(isSelected ? 1.0 : 0.8)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isSelected ? .white : AppColors.secondaryText)
                }
                .frame(height: 40)
                
                Text(tab.title)
                    .font(FontManager.tabBarText)
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.secondaryText)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.3), value: isSelected)
    }
}

struct CustomTabView: View {
    @State private var selectedTab: TabItem = .books
    @StateObject private var bookStore = BookStore()
    @State private var showOnboarding = false
    @State private var selectedBook: Book?
    @State private var showingBookDetail = false
    
    private let hasShownOnboardingKey = "hasShownOnboarding"
    
    var body: some View {
        ZStack(alignment: .top) {
            BackgroundView()
            
            VStack(spacing: 0) {
                
                    switch selectedTab {
                    case .books:
                        MyBooksView(
                            onBookSelected: { book in
                                selectedBook = book
                                showingBookDetail = true
                            }
                        )
                    case .library:
                        LibraryView()
                    case .history:
                        HistoryView(
                            onBookSelected: { book in
                                selectedBook = book
                                showingBookDetail = true
                            }
                        )
                    case .wishlist:
                        WishlistView(
                            onBookSelected: { book in
                                selectedBook = book
                                showingBookDetail = true
                            }
                        )
                    case .settings:
                        SettingsView()
                    }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .environmentObject(bookStore)
        .onAppear {
            checkFirstLaunch()
        }
        .sheet(isPresented: $showOnboarding) {
            OnboardingView {
                completeOnboarding()
            }
        }
        .sheet(item: $selectedBook) { book in 
                BookDetailView(book: book, bookStore: bookStore)
        }
    }
    
    private func checkFirstLaunch() {
        let hasShownOnboarding = UserDefaults.standard.bool(forKey: hasShownOnboardingKey)
        if !hasShownOnboarding {
            showOnboarding = true
        }
    }
    
    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: hasShownOnboardingKey)
        showOnboarding = false
    }
}
