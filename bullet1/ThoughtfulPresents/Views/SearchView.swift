import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: GiftIdeaViewModel
    @State private var searchText = ""
    @State private var selectedCategory: SearchCategory = .all
    @State private var selectedGift: GiftIdea?
    
    enum SearchCategory: String, CaseIterable {
        case all = "All"
        case ideas = "Ideas"
        case bought = "Bought"
        case gifted = "Gifted"
        
        var icon: String {
            switch self {
            case .all: return "magnifyingglass"
            case .ideas: return "lightbulb"
            case .bought: return "cart.fill"
            case .gifted: return "gift.fill"
            }
        }
    }
    
    var filteredGifts: [GiftIdea] {
        var gifts = viewModel.giftIdeas
        
        switch selectedCategory {
        case .all:
            break
        case .ideas:
            gifts = gifts.filter { $0.status == .idea }
        case .bought:
            gifts = gifts.filter { $0.status == .bought }
        case .gifted:
            gifts = gifts.filter { $0.status == .gifted }
        }
        
        if !searchText.isEmpty {
            gifts = gifts.filter { gift in
                gift.recipientName.localizedCaseInsensitiveContains(searchText) ||
                gift.giftDescription.localizedCaseInsensitiveContains(searchText) ||
                gift.comment.localizedCaseInsensitiveContains(searchText) ||
                (gift.occasion?.displayName.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        return gifts.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    var body: some View {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.theme.backgroundGradientStart, Color.theme.backgroundGradientEnd]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        HStack {
                            Text("Search")
                                .font(AppFonts.largeTitle)
                                .foregroundColor(Color.theme.primaryText)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical)
                        .padding(.top)
                        
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(Color.theme.secondaryText)
                                
                                TextField("Search gifts, people, occasions...", text: $searchText)
                                    .font(.theme.body)
                                    .textFieldStyle(PlainTextFieldStyle())
                            }
                            .padding()
                            .concaveCard(cornerRadius: 12, depth: 3, color: Color.theme.cardBackground)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(SearchCategory.allCases, id: \.self) { category in
                                        CategoryButton(
                                            category: category,
                                            isSelected: selectedCategory == category
                                        ) {
                                            selectedCategory = category
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            .padding(.horizontal, -20)
                        }
                        .padding()
                        .background(Color.clear)
                        
                        if filteredGifts.isEmpty {
                            EmptySearchView(searchText: searchText)
                        } else {
                                LazyVStack(spacing: 12) {
                                    ForEach(filteredGifts) { gift in
                                        SearchResultCard(gift: gift) {
                                            selectedGift = gift
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 100)
                        }
                        
                        Spacer()
                    }
                }
            }
        .sheet(item: $selectedGift) { gift in
            GiftDetailView(giftId: gift.id, viewModel: viewModel)
        }
    }
}

struct CategoryButton: View {
    let category: SearchView.SearchCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.caption)
                Text(category.rawValue)
                    .font(.theme.caption)
            }
            .foregroundColor(isSelected ? .white : Color.theme.primaryBlue)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.theme.primaryBlue : Color.theme.cardBackground)
            .cornerRadius(16)
        }
    }
}

struct SearchResultCard: View {
    let gift: GiftIdea
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Circle()
                    .fill(statusColor)
                    .frame(width: 12, height: 12)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(gift.recipientName)
                        .font(.theme.headline)
                        .foregroundColor(Color.theme.primaryText)
                    
                    Text(gift.giftDescription)
                        .font(.theme.body)
                        .foregroundColor(Color.theme.primaryText)
                        .lineLimit(2)
                    
                    HStack {
                        if let occasion = gift.occasion {
                            Text(occasion.displayName)
                                .font(.theme.caption)
                                .foregroundColor(Color.theme.secondaryText)
                        }
                        
                        Spacer()
                        
                        if let price = gift.estimatedPrice {
                            Text(String(format: "$%.2f", price))
                                .font(.theme.caption)
                                .foregroundColor(Color.theme.primaryBlue)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Color.theme.secondaryText)
            }
            .padding()
            .concaveCard(cornerRadius: 12, depth: 3, color: Color.theme.cardBackground)
        }
    }
    
    private var statusColor: Color {
        switch gift.status {
        case .idea:
            return Color.theme.ideaColor
        case .bought:
            return Color.theme.boughtColor
        case .gifted:
            return Color.theme.giftedColor
        }
    }
}

struct EmptySearchView: View {
    let searchText: String
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: searchText.isEmpty ? "magnifyingglass" : "exclamationmark.magnifyingglass")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(Color.theme.primaryBlue.opacity(0.6))
            
            Text(searchText.isEmpty ? "Start searching" : "No results found")
                .font(.theme.title2)
                .foregroundColor(Color.theme.primaryText)
            
            Text(searchText.isEmpty ? "Search for gifts, people, or occasions" : "Try different keywords or categories")
                .font(.theme.body)
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.top, 100)
    }
}


