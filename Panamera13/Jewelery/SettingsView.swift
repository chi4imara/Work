import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsStore: SettingsStore
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HeaderView(
                    title: "Settings",
                    showAddButton: false,
                    onAddTapped: nil
                )
                
                ScrollView {
                    VStack(spacing: 20) {
                        SettingsSection(title: "App") {
                            VStack(spacing: 12) {
                                SettingsRow(
                                    title: "Rate App",
                                    icon: "star",
                                    iconColor: ColorTheme.accentYellow,
                                    action: {
                                        settingsStore.requestAppReview()
                                    }
                                )
                            }
                        }
                        
                        SettingsSection(title: "Support") {
                            VStack(spacing: 12) {
                                SettingsRow(
                                    title: "Contact Us",
                                    icon: "envelope",
                                    iconColor: Color.orange,
                                    action: {
                                        settingsStore.openContactEmail()
                                    }
                                )
                                
                                Divider()
                                    .overlay {
                                        Color.white
                                    }
                                
                                SettingsRow(
                                    title: "Privacy Policy",
                                    icon: "hand.raised",
                                    iconColor: Color.green,
                                    action: {
                                        settingsStore.openPrivacyPolicy()
                                    }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(title)
                    .font(.lumierepolis(18, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
            }
            
            VStack(spacing: 0) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(ColorTheme.cardBorder, lineWidth: 1)
                    )
            )
        }
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let iconColor: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.lumierepolis(16))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                Rectangle()
                    .fill(isPressed ? ColorTheme.cardBorder.opacity(0.3) : Color.clear)
            )
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct SettingsInfoRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(ColorTheme.secondaryText.opacity(0.2))
                    .frame(width: 32, height: 32)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            Text(title)
                .font(.lumierepolis(16))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            Text(value)
                .font(.lumierepolis(14))
                .foregroundColor(ColorTheme.secondaryText)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

struct FavoritesView: View {
    @ObservedObject var jewelryStore: JewelryStore
    @ObservedObject var setsStore: SetsStore
    @State private var selectedJewelryId: UUID?
    
    var favoriteJewelries: [Jewelry] {
        jewelryStore.favoriteJewelries
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HeaderView(
                    title: "Favorites",
                    showAddButton: false,
                    onAddTapped: nil
                )
                
                if favoriteJewelries.isEmpty {
                    VStack(spacing: 30) {
                        Spacer()
                        
                        VStack(spacing: 20) {
                            Image(systemName: "heart")
                                .font(.system(size: 60, weight: .light))
                                .foregroundColor(ColorTheme.accentYellow)
                            
                            VStack(spacing: 12) {
                                Text("No favorites yet")
                                    .font(.lumierepolis(24, weight: .bold))
                                    .foregroundColor(ColorTheme.primaryText)
                                
                                Text("Mark jewelry as favorite to see them here")
                                    .font(.lumierepolis(16))
                                    .foregroundColor(ColorTheme.secondaryText)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(favoriteJewelries) { jewelry in
                                FavoriteJewelryCard(
                                    jewelry: jewelry,
                                    jewelryStore: jewelryStore,
                                    onTap: {
                                        selectedJewelryId = jewelry.id
                                    },
                                    onRemove: {
                                        jewelryStore.toggleFavorite(jewelry)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120)
                    }
                    .sheet(item: Binding(
                        get: { selectedJewelryId.flatMap { jewelryStore.getJewelry(by: $0) } },
                        set: { _ in selectedJewelryId = nil }
                    )) { jewelry in
                        JewelryDetailView(jewelryId: jewelry.id, jewelryStore: jewelryStore, setsStore: setsStore)
                    }
                }
            }
        }
    }
}

struct FavoriteJewelryCard: View {
    let jewelry: Jewelry
    @ObservedObject var jewelryStore: JewelryStore
    let onTap: () -> Void
    let onRemove: () -> Void
    
    @State private var cardScale: CGFloat = 1.0
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: onTap) {
                HStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(ColorTheme.cardBackground)
                            .frame(width: 60, height: 60)
                        
                        if let imageName = jewelry.imageName, !imageName.isEmpty {
                            AsyncJewelryImage(imageName: imageName, placeholder: jewelry.type.icon, size: CGSize(width: 60, height: 60))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            Image(systemName: jewelry.type.icon)
                                .font(.system(size: 24))
                                .foregroundColor(ColorTheme.accentYellow)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(jewelry.name)
                            .font(.lumierepolis(16, weight: .bold))
                            .foregroundColor(ColorTheme.primaryText)
                            .lineLimit(1)
                        
                        Text(jewelry.type.rawValue)
                            .font(.lumierepolis(14))
                            .foregroundColor(ColorTheme.accentYellow)
                        
                        if !jewelry.suitableFor.isEmpty {
                            Text("Suitable for: \(jewelry.suitableFor)")
                                .font(.lumierepolis(12))
                                .foregroundColor(ColorTheme.secondaryText)
                                .lineLimit(2)
                        }
                    }
                    
                    Spacer()
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: onRemove) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 20))
                    .foregroundColor(ColorTheme.accentYellow)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(ColorTheme.accentYellow.opacity(0.1))
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorTheme.cardBorder, lineWidth: 1)
                )
        )
        .scaleEffect(cardScale)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                cardScale = pressing ? 0.98 : 1.0
            }
        }, perform: {})
    }
}

struct SearchView: View {
    @ObservedObject var jewelryStore: JewelryStore
    @ObservedObject var setsStore: SetsStore
    @State private var searchText = ""
    @State private var selectedJewelryId: UUID?
    
    var searchResults: [Jewelry] {
        if searchText.isEmpty {
            return []
        } else {
            return jewelryStore.jewelries.filter { jewelry in
                jewelry.name.localizedCaseInsensitiveContains(searchText) ||
                jewelry.type.rawValue.localizedCaseInsensitiveContains(searchText) ||
                jewelry.suitableFor.localizedCaseInsensitiveContains(searchText) ||
                jewelry.notes.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HeaderView(
                    title: "Search",
                    showAddButton: false,
                    onAddTapped: nil
                )
                
                SearchBar(text: $searchText)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                
                if searchText.isEmpty {
                    VStack(spacing: 30) {
                        Spacer()
                        
                        VStack(spacing: 20) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 60, weight: .light))
                                .foregroundColor(ColorTheme.accentYellow)
                            
                            VStack(spacing: 12) {
                                Text("Search your jewelry")
                                    .font(.lumierepolis(24, weight: .bold))
                                    .foregroundColor(ColorTheme.primaryText)
                                
                                Text("Find jewelry by name, type, or notes")
                                    .font(.lumierepolis(16))
                                    .foregroundColor(ColorTheme.secondaryText)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                } else if searchResults.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 40))
                            .foregroundColor(ColorTheme.secondaryText)
                        
                        Text("No results found")
                            .font(.lumierepolis(18, weight: .bold))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Text("Try searching with different keywords")
                            .font(.lumierepolis(14))
                            .foregroundColor(ColorTheme.secondaryText)
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(searchResults) { jewelry in
                                JewelryCard(
                                    jewelry: jewelry,
                                    jewelryStore: jewelryStore,
                                    onTap: {
                                        selectedJewelryId = jewelry.id
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                    .sheet(item: Binding(
                        get: { selectedJewelryId.flatMap { jewelryStore.getJewelry(by: $0) } },
                        set: { _ in selectedJewelryId = nil }
                    )) { jewelry in
                        JewelryDetailView(jewelryId: jewelry.id, jewelryStore: jewelryStore, setsStore: setsStore)
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView(settingsStore: SettingsStore())
}
