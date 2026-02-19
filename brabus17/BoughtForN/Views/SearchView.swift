import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: PurchaseViewModel
    @State private var isSearching = false
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(0..<8, id: \.self) { index in
                Circle()
                    .fill(ColorTheme.white.opacity(0.1))
                    .frame(width: CGFloat.random(in: 8...18))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .animation(
                        Animation.linear(duration: Double.random(in: 5...10))
                            .repeatForever(autoreverses: false),
                        value: UUID()
                    )
            }
            
            VStack(spacing: 0) {
                HStack {
                    Text("Search")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(ColorTheme.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(ColorTheme.darkGray.opacity(0.6))
                        
                        TextField("Enter word or phrase to search", text: $viewModel.searchText)
                            .font(.ubuntu(16, weight: .regular))
                            .onTapGesture {
                                isSearching = true
                            }
                        
                        if !viewModel.searchText.isEmpty {
                            Button(action: {
                                viewModel.searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(ColorTheme.darkGray.opacity(0.6))
                            }
                        }
                    }
                    .padding(16)
                    .background(ColorTheme.cardBackground)
                    .cornerRadius(12)
                    .shadow(color: ColorTheme.cardShadow, radius: 4, x: 0, y: 2)
                    
                    if isSearching {
                        Button("Cancel") {
                            viewModel.searchText = ""
                            isSearching = false
                            hideKeyboard()
                        }
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(ColorTheme.white)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.searchText.isEmpty {
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(ColorTheme.white.opacity(0.7))
                        
                        Text("Enter word or phrase to search")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(ColorTheme.white)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                } else if viewModel.filteredPurchases.isEmpty {
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image(systemName: "exclamationmark.magnifyingglass")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(ColorTheme.white.opacity(0.7))
                        
                        VStack(spacing: 8) {
                            Text("No matches found")
                                .font(.ubuntu(20, weight: .medium))
                                .foregroundColor(ColorTheme.white)
                            
                            Text("Try different keywords or check spelling")
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(ColorTheme.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.filteredPurchases) { purchase in
                                NavigationLink(destination: PurchaseDetailView(purchaseId: purchase.id, viewModel: viewModel)) {
                                    SearchResultRowView(purchase: purchase, searchText: viewModel.searchText)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                }
            }
        }
        .onTapGesture {
            if isSearching {
                hideKeyboard()
            }
        }
    }
}

struct SearchResultRowView: View {
    let purchase: Purchase
    let searchText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HighlightedText(
                        text: purchase.whatBought,
                        searchText: searchText,
                        font: .ubuntu(18, weight: .medium),
                        normalColor: ColorTheme.darkGray,
                        highlightColor: ColorTheme.yellow
                    )
                    .lineLimit(2)
                    
                    if !purchase.whereBought.isEmpty {
                        HighlightedText(
                            text: purchase.whereBought,
                            searchText: searchText,
                            font: .ubuntu(14, weight: .regular),
                            normalColor: ColorTheme.darkGray.opacity(0.7),
                            highlightColor: ColorTheme.yellow
                        )
                        .lineLimit(1)
                    }
                    
                    if !purchase.whyBought.isEmpty && purchase.whyBought.localizedCaseInsensitiveContains(searchText) {
                        HighlightedText(
                            text: purchase.whyBought,
                            searchText: searchText,
                            font: .ubuntu(14, weight: .regular),
                            normalColor: ColorTheme.darkGray.opacity(0.7),
                            highlightColor: ColorTheme.yellow
                        )
                        .lineLimit(2)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(purchase.date, style: .date)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorTheme.primaryBlue)
                    
                    Text(purchase.date, style: .time)
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(ColorTheme.darkGray.opacity(0.6))
                }
            }
        }
        .padding(16)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .shadow(color: ColorTheme.cardShadow, radius: 8, x: 0, y: 4)
    }
}

struct HighlightedText: View {
    let text: String
    let searchText: String
    let font: Font
    let normalColor: Color
    let highlightColor: Color
    
    var body: some View {
        if searchText.isEmpty {
            Text(text)
                .font(font)
                .foregroundColor(normalColor)
        } else {
            let parts = text.components(separatedBy: searchText)
            if parts.count > 1 {
                HStack(spacing: 0) {
                    ForEach(0..<parts.count, id: \.self) { index in
                        Text(parts[index])
                            .font(font)
                            .foregroundColor(normalColor)
                        
                        if index < parts.count - 1 {
                            Text(searchText)
                                .font(font)
                                .foregroundColor(highlightColor)
                                .background(highlightColor.opacity(0.2))
                                .cornerRadius(4)
                        }
                    }
                }
            } else {
                Text(text)
                    .font(font)
                    .foregroundColor(normalColor)
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
