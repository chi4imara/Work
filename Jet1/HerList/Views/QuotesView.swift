import SwiftUI

struct QuotesView: View {
    @ObservedObject var viewModel: WomenViewModel
    @State private var searchText = ""
    @State private var showFavoritesOnly = false
    @State private var selectedWomanId: UUID?
    
    private var filteredQuotes: [Woman] {
        let quotesWithContent = showFavoritesOnly ? viewModel.favoriteQuotes : viewModel.quotesOnly
        
        if searchText.isEmpty {
            return quotesWithContent
        } else {
            return quotesWithContent.filter { woman in
                woman.name.localizedCaseInsensitiveContains(searchText) ||
                woman.quote.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                Text("Quotes")
                    .font(FontManager.ubuntu(28, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color.theme.secondaryText)
                    
                    TextField("Search by name or quote text...", text: $searchText)
                        .font(FontManager.ubuntu(16))
                        .foregroundColor(Color.theme.primaryText)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.theme.cardBackground.opacity(0.2))
                .cornerRadius(12)
                
                HStack {
                    Text("Show favorites only")
                        .font(FontManager.ubuntu(16, weight: .medium))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Spacer()
                    
                    Toggle("", isOn: $showFavoritesOnly)
                        .toggleStyle(SwitchToggleStyle(tint: Color.theme.favoriteHeart))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.theme.cardBackground.opacity(0.2))
                .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 10)
            
            if filteredQuotes.isEmpty {
                EmptyQuotesView(
                    message: viewModel.quotesOnly.isEmpty ? 
                        "No saved quotes. Add a quote to any entry to see it here." :
                        "No quotes found for your search."
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredQuotes) { woman in
                            QuoteCard(woman: woman) {
                                selectedWomanId = woman.id
                            } onDelete: {
                                var updatedWoman = woman
                                updatedWoman.quote = ""
                                viewModel.updateWoman(updatedWoman)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .padding(.bottom, 104)
                }
            }
        }
        .sheet(item: Binding(
            get: { selectedWomanId.map { WomanID(id: $0) } },
            set: { selectedWomanId = $0?.id }
        )) { womanId in
            WomanDetailsView(womanId: womanId.id, viewModel: viewModel)
        }
    }
}

struct QuoteCard: View {
    let woman: Woman
    let onTap: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(woman.name)
                    .font(FontManager.ubuntu(16, weight: .bold))
                    .foregroundColor(Color.theme.darkText)
                
                Spacer()
                
                if woman.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color.theme.favoriteHeart)
                        .font(.system(size: 14))
                }
            }
            
            Text(woman.quote)
                .font(FontManager.ubuntu(15))
                .foregroundColor(Color.theme.darkText.opacity(0.9))
                .lineSpacing(4)
            
            HStack {
                Spacer()
                
                Button(action: onTap) {
                    HStack(spacing: 4) {
                        Image(systemName: "book.fill")
                        Text("More Details")
                    }
                    .font(FontManager.ubuntu(12, weight: .medium))
                    .foregroundColor(Color.theme.buttonPrimary)
                }
            }
        }
        .padding(16)
        .background(Color.theme.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .offset(x: offset.width, y: 0)
        .highPriorityGesture(
            DragGesture(minimumDistance: 25)
                .onChanged { value in
                    if value.translation.width < 0 {
                        offset = value.translation
                    }
                }
                .onEnded { value in
                    if value.translation.width < -100 {
                        withAnimation(.spring()) {
                            offset = CGSize(width: -80, height: 0)
                        }
                    } else {
                        withAnimation(.spring()) {
                            offset = .zero
                        }
                    }
                }
        )
        .overlay(
            HStack {
                Spacer()
                
                if offset.width < -50 {
                    Button(action: {
                        showingDeleteConfirmation = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                            .frame(width: 60, height: 60)
                            .background(Color.theme.buttonDestructive)
                            .cornerRadius(12)
                    }
                    .transition(.move(edge: .trailing))
                }
            }
            .padding(.trailing, 16)
        )
        .onTapGesture {
            if offset == .zero {
                onTap()
            } else {
                withAnimation(.spring()) {
                    offset = .zero
                }
            }
        }
        .alert("Delete Quote", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) {
                withAnimation(.spring()) {
                    offset = .zero
                }
            }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete this quote from \(woman.name)?")
        }
    }
}

struct EmptyQuotesView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "quote.bubble")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.primaryText.opacity(0.6))
            
            Text(message)
                .font(FontManager.ubuntu(16))
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    QuotesView(viewModel: WomenViewModel())
}
