import SwiftUI

struct SearchView: View {
    @ObservedObject var wordStore: WordStore
    @State private var searchText = ""
    @State private var selectedWord: Word?
    @State private var showingWordDetail = false
    @State private var showingEditWord = false
    @State private var selectedWordForEdit: Word?
    @State private var searchScope: SearchScope = .all
    
    enum SearchScope: String, CaseIterable {
        case all = "All"
        case words = "Words"
        case translations = "Translations"
        case comments = "Comments"
    }
    
    private var filteredWords: [Word] {
        if searchText.isEmpty {
            return wordStore.sortedWords
        }
        
        let searchLowercased = searchText.lowercased()
        
        return wordStore.words.filter { word in
            switch searchScope {
            case .all:
                return word.word.lowercased().contains(searchLowercased) ||
                       (word.translation?.lowercased().contains(searchLowercased) ?? false) ||
                       (word.comment?.lowercased().contains(searchLowercased) ?? false)
            case .words:
                return word.word.lowercased().contains(searchLowercased)
            case .translations:
                return word.translation?.lowercased().contains(searchLowercased) ?? false
            case .comments:
                return word.comment?.lowercased().contains(searchLowercased) ?? false
            }
        }.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        searchHeader
                        
                        if filteredWords.isEmpty && !searchText.isEmpty {
                            emptySearchView
                            
                            Spacer()
                        } else if wordStore.words.isEmpty {
                            emptyCollectionView
                            
                            Spacer()
                        } else {
                            searchResultsView
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(item: $selectedWord) { word in
            WordDetailView(wordStore: wordStore, word: word)
        }
        .sheet(item: $selectedWordForEdit) { word in
            AddEditWordView(wordStore: wordStore, editingWord: word, selectedDate: nil)
        }
    }
    
    private var searchHeader: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.secondaryText)
                
                TextField("Search words, translations, comments...", text: $searchText)
                    .font(FontManager.body)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .fill(AppColors.backgroundWhite)
                    .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 4)
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var searchResultsView: some View {
            LazyVStack(spacing: 16) {
                if !searchText.isEmpty {
                    PixelCard {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Search Results")
                                    .font(FontManager.headline)
                                    .foregroundColor(AppColors.primaryText)
                                
                                Text("Found \(filteredWords.count) result\(filteredWords.count == 1 ? "" : "s") for '\(searchText)'")
                                    .font(FontManager.caption)
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundColor(AppColors.primaryBlue)
                        }
                    }
                }
                
                ForEach(filteredWords) { word in
                    SearchResultCard(
                        word: word,
                        searchText: searchText,
                        onTap: {
                            selectedWord = word
                        },
                        onEdit: {
                            selectedWordForEdit = word
                        },
                        onDelete: {
                            wordStore.deleteWord(word)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
    }
    
    private var emptySearchView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(AppColors.lightBlue)
            
            VStack(spacing: 12) {
                Text("No results found")
                    .font(FontManager.title1)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Try searching with different keywords or check your spelling")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button("Clear Search") {
                searchText = ""
            }
            .font(FontManager.body)
            .foregroundColor(AppColors.primaryBlue)
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    private var emptyCollectionView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "tray.fill")
                .font(.system(size: 60))
                .foregroundColor(AppColors.lightBlue)
            
            VStack(spacing: 12) {
                Text("Your collection is empty")
                    .font(FontManager.title1)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add your first word to start building your personal dictionary")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct SearchResultCard: View {
    let word: Word
    let searchText: String
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        PixelCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(highlightedText(word.word, searchText: searchText))
                            .font(FontManager.title2)
                            .foregroundColor(AppColors.primaryText)
                        
                        if let translation = word.translation, !translation.isEmpty {
                            Text(highlightedText(translation, searchText: searchText))
                                .font(FontManager.body)
                                .foregroundColor(AppColors.secondaryText)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(word.formattedDate)
                            .font(FontManager.caption)
                            .foregroundColor(AppColors.secondaryText)
                        
                        if word.isToday {
                            Text("Today")
                                .font(FontManager.caption2)
                                .foregroundColor(AppColors.primaryBlue)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(
                                    Capsule()
                                        .fill(AppColors.lightBlue.opacity(0.3))
                                )
                        }
                    }
                }
                
                if let comment = word.comment, !comment.isEmpty {
                    Text(highlightedText(comment, searchText: searchText))
                        .font(FontManager.callout)
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(2)
                        .padding(.top, 4)
                }
                
                HStack(spacing: 12) {
                    Spacer()
                    
                    Button("Edit") {
                        onEdit()
                    }
                    .font(FontManager.caption)
                    .foregroundColor(AppColors.secondaryText)
                    
                    Button("Delete") {
                        showingDeleteAlert = true
                    }
                    .font(FontManager.caption)
                    .foregroundColor(AppColors.error)
                }
                .padding(.top, 8)
            }
        }
        .onTapGesture {
            onTap()
        }
        .alert("Delete Word", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete '\(word.word)'?")
        }
    }
    
    private func highlightedText(_ text: String, searchText: String) -> AttributedString {
        var attributedString = AttributedString(text)
        
        if !searchText.isEmpty {
            let searchLowercased = searchText.lowercased()
            let textLowercased = text.lowercased()
            
            if let range = textLowercased.range(of: searchLowercased) {
                let nsRange = NSRange(range, in: text)
                if let swiftRange = Range(nsRange, in: text) {
                    let attributedRange = Range(swiftRange, in: attributedString)
                    if let attributedRange = attributedRange {
                        attributedString[attributedRange].backgroundColor = AppColors.primaryBlue.opacity(0.3)
                        attributedString[attributedRange].foregroundColor = AppColors.primaryBlue
                    }
                }
            }
        }
        
        return attributedString
    }
}

#Preview {
    SearchView(wordStore: WordStore())
}
