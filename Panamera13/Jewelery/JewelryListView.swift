import SwiftUI

struct JewelryListView: View {
    @ObservedObject var jewelryStore: JewelryStore
    @ObservedObject var setsStore: SetsStore
    @State private var showingAddJewelry = false
    @State private var selectedJewelryId: UUID?
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HeaderView(
                    title: "My Jewelry",
                    showAddButton: true,
                    onAddTapped: {
                        showingAddJewelry = true
                    }
                )
                
                if jewelryStore.jewelries.isEmpty {
                    EmptyJewelryState {
                        showingAddJewelry = true
                    }
                } else {
                    SearchBar(text: $jewelryStore.searchText)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(jewelryStore.filteredJewelries) { jewelry in
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
                        .padding(.bottom, 120) 
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddJewelry) {
            AddEditJewelryView(jewelryStore: jewelryStore)
        }
        .sheet(item: Binding(
            get: { selectedJewelryId.flatMap { jewelryStore.getJewelry(by: $0) } },
            set: { _ in selectedJewelryId = nil }
        )) { jewelry in
            JewelryDetailView(jewelryId: jewelry.id, jewelryStore: jewelryStore, setsStore: setsStore)
        }
    }
}

struct EmptyJewelryState: View {
    let onAddTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "sparkles")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(ColorTheme.accentYellow)
                
                VStack(spacing: 12) {
                    Text("Jewelry catalog is empty")
                        .font(.lumierepolis(24, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text("Add your first piece to get started")
                        .font(.lumierepolis(16))
                        .foregroundColor(ColorTheme.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }
            
            Button(action: onAddTapped) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("Add Jewelry")
                }
                .font(.lumierepolis(16, weight: .bold))
                .foregroundColor(ColorTheme.buttonText)
                .padding(.horizontal, 30)
                .padding(.vertical, 16)
                .background(ColorTheme.buttonPrimary)
                .cornerRadius(25)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct JewelryCard: View {
    let jewelry: Jewelry
    @ObservedObject var jewelryStore: JewelryStore
    let onTap: () -> Void
    
    @State private var cardScale: CGFloat = 1.0
    
    var isFavorite: Bool {
        jewelryStore.isFavorite(jewelry)
    }
    
    var body: some View {
        HStack(spacing: 12) {
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
            
            Button(action: {
                jewelryStore.toggleFavorite(jewelry)
            }) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 18))
                    .foregroundColor(isFavorite ? ColorTheme.accentYellow : ColorTheme.secondaryText)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(isFavorite ? ColorTheme.accentYellow.opacity(0.1) : Color.clear)
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

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(ColorTheme.secondaryText)
            
            TextField("Search jewelry...", text: $text)
                .font(.lumierepolis(16))
                .foregroundColor(ColorTheme.primaryText)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(ColorTheme.secondaryText)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(ColorTheme.cardBorder, lineWidth: 1)
                )
        )
    }
}

struct HeaderView: View {
    let title: String
    let showAddButton: Bool
    let onAddTapped: (() -> Void)?
    
    var body: some View {
        HStack {
            Text(title)
                .font(.lumierepolis(28, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            if showAddButton {
                Button(action: { onAddTapped?() }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(ColorTheme.buttonText)
                        .frame(width: 40, height: 40)
                        .background(ColorTheme.buttonPrimary)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}
