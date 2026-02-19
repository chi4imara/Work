import SwiftUI

struct SearchView: View {
    @EnvironmentObject var inventoryViewModel: InventoryViewModel
    @State private var searchText = ""
    
    var filteredItems: [Item] {
        if searchText.isEmpty {
            return []
        } else {
            return inventoryViewModel.items.filter { item in
                item.name.localizedCaseInsensitiveContains(searchText) ||
                item.location.localizedCaseInsensitiveContains(searchText) ||
                item.owner.localizedCaseInsensitiveContains(searchText) ||
                item.notes.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack {
            GridBackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Search")
                        .font(.playfairDisplay(28, weight: .bold))
                        .foregroundColor(AppColors.primaryTextWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                HStack {
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 18))
                            .foregroundColor(AppColors.primaryTextWhite.opacity(0.8))
                        
                        TextField("Search items, locations, owners...", text: $searchText)
                            .font(.playfairDisplay(16, weight: .medium))
                            .foregroundColor(AppColors.secondaryTextWhite)
                            .textFieldStyle(PlainTextFieldStyle())
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(AppColors.primaryTextWhite.opacity(0.8))
                            }
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(AppColors.gridWhite.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if inventoryViewModel.items.isEmpty {
                    EmptySearchStateView(
                        title: "No items to search",
                        message: "Add some items to your inventory first.",
                        iconName: "archivebox"
                    )
                } else if searchText.isEmpty {
                    EmptySearchStateView(
                        title: "Start searching",
                        message: "Enter a search term to find your items.",
                        iconName: "magnifyingglass"
                    )
                } else if filteredItems.isEmpty {
                    EmptySearchStateView(
                        title: "Nothing found",
                        message: "Try different keywords or check your spelling.",
                        iconName: "questionmark.circle"
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredItems) { item in
                                NavigationLink(destination: ItemDetailView(itemId: item.id).environmentObject(inventoryViewModel)) {
                                    SearchResultCardView(item: item, searchText: searchText)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
    }
}

struct EmptySearchStateView: View {
    let title: String
    let message: String
    let iconName: String
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.primaryYellow.opacity(0.2), AppColors.primaryBlue.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: iconName)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(AppColors.primaryTextWhite)
            }
            
            VStack(spacing: 12) {
                Text(title)
                    .font(.playfairDisplay(20, weight: .bold))
                    .foregroundColor(AppColors.primaryTextWhite)
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(AppColors.secondaryTextWhite)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

struct SearchResultCardView: View {
    let item: Item
    let searchText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    highlightedText(item.name, searchText: searchText)
                        .font(.playfairDisplay(18, weight: .semibold))
                        .lineLimit(2)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "location")
                            .font(.system(size: 12))
                            .foregroundColor(Color.blue)
                        highlightedText(item.location, searchText: searchText)
                            .font(.playfairDisplay(14, weight: .medium))
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "person")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.primaryYellow)
                        highlightedText(item.owner, searchText: searchText)
                            .font(.playfairDisplay(14, weight: .medium))
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.primaryTextWhite.opacity(0.8))
            }
            
            if !item.notes.isEmpty {
                highlightedText(item.notes, searchText: searchText)
                    .font(.playfairDisplay(14, weight: .regular))
                    .lineLimit(2)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
        )
    }
    
    private func highlightedText(_ text: String, searchText: String) -> Text {
        guard !searchText.isEmpty else {
            return Text(text).foregroundColor(AppColors.secondaryTextWhite)
        }
        
        let parts = text.components(separatedBy: searchText)
        var result = Text("")
        
        for (index, part) in parts.enumerated() {
            result = result + Text(part).foregroundColor(AppColors.secondaryTextWhite)
            if index < parts.count - 1 {
                result = result + Text(searchText).foregroundColor(AppColors.primaryTextWhite).bold()
            }
        }
        
        return result
    }
}

#Preview {
    SearchView()
        .environmentObject(InventoryViewModel())
}
