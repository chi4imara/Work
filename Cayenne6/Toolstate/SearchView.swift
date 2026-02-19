import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: GarageViewModel
    @State private var searchText = ""
    
    var searchResults: [GarageItem] {
        if searchText.isEmpty {
            return []
        }
        
        return viewModel.items.filter { item in
            item.name.localizedCaseInsensitiveContains(searchText) ||
            item.location.localizedCaseInsensitiveContains(searchText) ||
            item.comment.localizedCaseInsensitiveContains(searchText) ||
            item.category.displayName.localizedCaseInsensitiveContains(searchText) ||
            item.condition.localizedCaseInsensitiveContains(searchText)
        }.sorted { $0.dateModified > $1.dateModified }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                HStack {
                    Text("Search")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(AppColors.white)
                    
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                    
                    TextField("Search items, locations, comments...", text: $searchText)
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.white)
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppColors.secondaryText)
                        }
                    }
                }
                .padding(12)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.separator, lineWidth: 1)
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            if searchText.isEmpty {
                SearchEmptyState()
            } else if searchResults.isEmpty {
                NoResultsView(searchText: searchText)
            } else {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Results")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.white)
                        
                        Spacer()
                        
                        Text("\(searchResults.count) item\(searchResults.count == 1 ? "" : "s")")
                            .font(.ubuntu(14))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(searchResults) { item in
                                NavigationLink(destination: ItemDetailView(item: item, viewModel: viewModel)) {
                                    SearchResultRow(item: item, searchText: searchText)
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

struct SearchEmptyState: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 8) {
                Text("Search your garage")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.white)
                
                Text("Find items by name, location, category, condition, or any comment you've added.")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

struct NoResultsView: View {
    let searchText: String
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "questionmark.circle")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 8) {
                Text("No results found")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.white)
                
                Text("No items match '\(searchText)'. Try a different search term.")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

struct SearchResultRow: View {
    let item: GarageItem
    let searchText: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: categoryIcon(for: item.category))
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(AppColors.lightBlue)
                .frame(width: 50, height: 50)
                .background(AppColors.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(highlightedText(item.name, searchText: searchText))
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.white)
                    .lineLimit(1)
                
                Text(item.category.displayName)
                    .font(.ubuntu(12))
                    .foregroundColor(AppColors.lightBlue)
                
                Text(highlightedText(item.location, searchText: searchText))
                    .font(.ubuntu(12))
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(1)
                
                if !item.comment.isEmpty && item.comment.localizedCaseInsensitiveContains(searchText) {
                    Text(highlightedText(item.comment, searchText: searchText))
                        .font(.ubuntu(10))
                        .foregroundColor(AppColors.secondaryText.opacity(0.8))
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
        )
    }
    
    private func categoryIcon(for category: ItemCategory) -> String {
        switch category {
        case .tools: return "wrench.and.screwdriver"
        case .carCare: return "drop"
        case .spareParts: return "gearshape"
        case .other: return "cube.box"
        }
    }
    
    private func highlightedText(_ text: String, searchText: String) -> AttributedString {
        var attributedString = AttributedString(text)
        
        if let range = text.range(of: searchText, options: .caseInsensitive) {
            let nsRange = NSRange(range, in: text)
            if let attributedRange = Range(nsRange, in: attributedString) {
                attributedString[attributedRange].foregroundColor = AppColors.orange
                attributedString[attributedRange].font = .ubuntu(attributedString[attributedRange].font?.pointSize ?? 16, weight: .bold)
            }
        }
        
        return attributedString
    }
}
