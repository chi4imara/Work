import SwiftUI

struct WordsListView: View {
    @ObservedObject var viewModel: WordsViewModel
    @Binding var selectedTab: Int
    @State private var showingAddWord = false
    @State private var showingFilters = false
    @State private var selectedWordId: UUID?
    @State private var editingWordId: UUID?
    @State private var wordToDelete: WordModel?
    @State private var showingDeleteAlert = false
    
    private var editingWord: WordModel? {
        guard let id = editingWordId else { return nil }
        return viewModel.words.first { $0.id == id }
    }
    
    init(viewModel: WordsViewModel = WordsViewModel(), selectedTab: Binding<Int> = .constant(0)) {
        self.viewModel = viewModel
        self._selectedTab = selectedTab
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if viewModel.filteredWords.isEmpty {
                        emptyStateView
                    } else {
                        wordsListContent
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddWord) {
            AddEditWordView(viewModel: viewModel)
        }
        .sheet(item: Binding(
            get: { selectedWordId.map { WordDetailViewModel(wordId: $0) } },
            set: { selectedWordId = $0?.wordId }
        )) { viewModelWrapper in
            WordDetailView(wordId: viewModelWrapper.wordId, viewModel: viewModel)
        }
        .sheet(item: Binding(
            get: { editingWordId.map { WordDetailViewModel(wordId: $0) } },
            set: { editingWordId = $0?.wordId }
        )) { _ in
            if let word = editingWord {
                    AddEditWordView(viewModel: viewModel, editingWord: word, onSave: {
                        editingWordId = nil
                    }, onCancel: {
                        editingWordId = nil
                    })
            }
        }
        .alert("Delete Word", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let word = wordToDelete {
                    viewModel.deleteWord(word)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this word?")
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Word Collection")
                    .font(.playfair(28, weight: .bold))
                    .foregroundColor(Color.theme.primaryBlue)
                
                Spacer()
                
                HStack(spacing: 16) {
                    Button(action: { showingFilters = true }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.system(size: 24))
                            .foregroundColor(Color.theme.primaryBlue)
                    }
                    .confirmationDialog("Filter & Sort", isPresented: $showingFilters, titleVisibility: .visible) {
                        Button("All Categories") {
                            viewModel.selectedCategory = nil
                        }
                        
                        ForEach(viewModel.categories) { category in
                            Button(category.name) {
                                viewModel.selectedCategory = category
                            }
                        }
                        
                        Divider()
                        
                        Button("Sort by Date") {
                            viewModel.sortOption = .dateAdded
                        }
                        
                        Button("Sort Alphabetically") {
                            viewModel.sortOption = .alphabetical
                        }
                        
                        Button("Cancel", role: .cancel) { }
                    }
                }
            }
            
            if viewModel.selectedCategory != nil {
                HStack {
                    Text("Filtered by: \(viewModel.selectedCategory?.name ?? "")")
                        .font(.playfair(14, weight: .medium))
                        .foregroundColor(Color.theme.textGray)
                    
                    Spacer()
                    
                    Button("Clear") {
                        viewModel.clearFilters()
                    }
                    .font(.playfair(14, weight: .medium))
                    .foregroundColor(Color.theme.primaryBlue)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var wordsListContent: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredWords) { word in
                    WordCardView(word: word, categories: viewModel.categories) {
                        selectedWordId = word.id
                    }
                    .contextMenu {
                        Button(action: {
                            editingWordId = word.id
                        }) {
                            Label("Edit", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive, action: {
                            wordToDelete = word
                            showingDeleteAlert = true
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 10)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "book.closed")
                .font(.system(size: 80))
                .foregroundColor(Color.theme.primaryBlue.opacity(0.6))
            
            VStack(spacing: 16) {
                Text(viewModel.words.isEmpty ? "You haven't added rare words yet" : "No matches for selected filters")
                    .font(.playfair(24, weight: .semibold))
                    .foregroundColor(Color.theme.primaryBlue)
                    .multilineTextAlignment(.center)
                
                Text(viewModel.words.isEmpty ? "Start building your personal dictionary" : "Try adjusting your search criteria")
                    .font(.playfair(16, weight: .regular))
                    .foregroundColor(Color.theme.textGray)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                if viewModel.words.isEmpty {
                    withAnimation {
                        selectedTab = 2
                    }
                } else {
                    viewModel.clearFilters()
                }
            }) {
                Text(viewModel.words.isEmpty ? "Add First Word" : "Clear Filters")
                    .font(.playfair(18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.theme.primaryBlue)
                    .cornerRadius(25)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
}

struct WordCardView: View {
    let word: WordModel
    let categories: [CategoryModel]
    let onTap: () -> Void
    
    private var categoryColor: Color {
        if let category = categories.first(where: { $0.name == word.categoryName }) {
            return ColorTheme.categoryColors[category.colorIndex % ColorTheme.categoryColors.count]
        }
        return Color.theme.primaryYellow
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(word.word)
                        .font(.playfair(20, weight: .bold))
                        .foregroundColor(Color.theme.primaryBlue)
                    
                    Spacer()
                    
                    Text(word.categoryName)
                        .font(.playfair(12, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(categoryColor)
                        .cornerRadius(12)
                }
                
                Text(word.definition)
                    .font(.playfair(16, weight: .regular))
                    .foregroundColor(Color.theme.textGray)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Spacer()
                    Text(DateFormatter.shortDate.string(from: word.dateAdded))
                        .font(.playfair(12, weight: .medium))
                        .foregroundColor(Color.theme.textGray.opacity(0.8))
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.theme.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}


