import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: IdeasViewModel
    @State private var selectedIdeaId: UUID?
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Search")
                    .font(.ubuntu(32, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.secondaryText)
                
                TextField("Search ideas", text: $viewModel.searchText)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.primaryText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .focused($isSearchFocused)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            
            if viewModel.searchText.isEmpty {
                VStack(spacing: 30) {
                    Spacer()
                    
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 80))
                        .foregroundColor(AppColors.accentYellow.opacity(0.6))
                    
                    VStack(spacing: 16) {
                        Text("Search your ideas")
                            .font(.ubuntu(24, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Type in the search bar above to find any idea you've saved. Search works across all your notes.")
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 40)
            } else if viewModel.hasSearchResults {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.filteredIdeas) { idea in
                            SearchResultCard(idea: idea, searchText: viewModel.searchText, viewModel: viewModel) {
                                selectedIdeaId = idea.id
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            } else {
                VStack(spacing: 30) {
                    Spacer()
                    
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 80))
                        .foregroundColor(AppColors.secondaryText)
                    
                    VStack(spacing: 16) {
                        Text("No ideas match your search.")
                            .font(.ubuntu(20, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Try different keywords or check your spelling.")
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 40)
            }
        }
        .onAppear {
            isSearchFocused = true
        }
        .sheet(isPresented: Binding(
            get: { selectedIdeaId != nil },
            set: { if !$0 { selectedIdeaId = nil } }
        )) {
            if let ideaId = selectedIdeaId {
                IdeaDetailView(ideaId: ideaId, viewModel: viewModel)
            }
        }
    }
}

struct SearchResultCard: View {
    let idea: Idea
    let searchText: String
    @ObservedObject var viewModel: IdeasViewModel
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                viewModel.toggleFavorite(ideaId: idea.id)
            }) {
                Image(systemName: idea.isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 18))
                    .foregroundColor(idea.isFavorite ? AppColors.accentYellow : AppColors.secondaryText)
            }
            
            Button(action: onTap) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(highlightedText(idea.text, searchText: searchText))
                        .font(.ubuntu(16))
                        .multilineTextAlignment(.leading)
                        .lineLimit(4)
                    
                    HStack {
                        Text(idea.formattedDate)
                            .font(.ubuntu(12))
                            .foregroundColor(AppColors.secondaryText)
                        
                        Spacer()
                        
                        Text("\(idea.text.count) characters")
                            .font(.ubuntu(12))
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(idea.isFavorite ? AppColors.accentYellow.opacity(0.3) : AppColors.primaryText.opacity(0.1), lineWidth: 1)
        )
    }
    
    private func highlightedText(_ text: String, searchText: String) -> AttributedString {
        var attributedString = AttributedString(text)
        attributedString.foregroundColor = AppColors.primaryText
        
        if !searchText.isEmpty {
            let ranges = text.ranges(of: searchText, options: .caseInsensitive)
            for range in ranges {
                let nsRange = NSRange(range, in: text)
                if let attributedRange = Range(nsRange, in: attributedString) {
                    attributedString[attributedRange].foregroundColor = AppColors.accentYellow
                    attributedString[attributedRange].font = .ubuntu(16, weight: .bold)
                }
            }
        }
        
        return attributedString
    }
}

extension String {
    func ranges(of searchString: String, options: CompareOptions = []) -> [Range<String.Index>] {
        var ranges: [Range<String.Index>] = []
        var searchRange = startIndex..<endIndex
        
        while let range = range(of: searchString, options: options, range: searchRange) {
            ranges.append(range)
            searchRange = range.upperBound..<endIndex
        }
        
        return ranges
    }
}
