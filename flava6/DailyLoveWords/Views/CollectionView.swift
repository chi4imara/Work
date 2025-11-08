import SwiftUI

struct CollectionView: View {
    @ObservedObject var wordStore: WordStore
    @Environment(\.presentationMode) var presentationMode
    @State private var showingClearAlert = false
    @State private var showingMenu = false
    @State private var selectedWord: Word?
    @State private var showingWordDetail = false
    @State private var showingEditWord = false
    @State private var selectedWordForEdit: Word?
    
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                if wordStore.words.isEmpty {
                    emptyStateView
                } else {
                    wordListView
                }
            }
            .navigationTitle("My Collection")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingMenu.toggle() }) {
                        Image(systemName: "ellipsis")
                            .foregroundColor(AppColors.primaryBlue)
                    }
                    .actionSheet(isPresented: $showingMenu) {
                        ActionSheet(
                            title: Text("Collection Options"),
                            buttons: [
                                .destructive(Text("Clear Collection")) {
                                    showingClearAlert = true
                                },
                                .cancel()
                            ]
                        )
                    }
                }
            }
        }
        .sheet(item: $selectedWord) { word in
            WordDetailView(wordStore: wordStore, word: word)
        }
        .sheet(item: $selectedWordForEdit) { word in
            AddEditWordView(wordStore: wordStore, editingWord: word, selectedDate: nil)
        }
        .alert("Clear Collection", isPresented: $showingClearAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete All", role: .destructive) {
                wordStore.clearAllWords()
            }
        } message: {
            Text("Are you sure you want to delete all words? This action cannot be undone.")
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Image(systemName: "tray.fill")
                .font(.system(size: 80))
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
            
            PixelButton(
                title: "Add First Word",
                action: {
                    withAnimation {
                        selectedTab = 0
                    }
                },
                color: AppColors.primaryBlue
            )
        }
        .padding(.horizontal, 20)
    }
    
    private var wordListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(wordStore.sortedWords) { word in
                    WordCardView(
                        word: word,
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
    }
}

struct WordCardView: View {
    let word: Word
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var showingDeleteAlert = false
    @State private var offset: CGSize = .zero
    @State private var showingActions = false
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: onEdit) {
                    VStack {
                        Image(systemName: "pencil")
                            .font(.title2)
                        Text("Edit")
                            .font(FontManager.caption)
                    }
                    .foregroundColor(.white)
                    .frame(width: 80)
                    .frame(maxHeight: .infinity)
                    .background(AppColors.primaryBlue)
                }
                
                Spacer()
                
                Button(action: { showingDeleteAlert = true }) {
                    VStack {
                        Image(systemName: "trash")
                            .font(.title2)
                        Text("Delete")
                            .font(FontManager.caption)
                    }
                    .foregroundColor(.white)
                    .frame(width: 80)
                    .frame(maxHeight: .infinity)
                    .background(AppColors.error)
                }
            }
            
            PixelCard {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(word.word)
                                .font(FontManager.title2)
                                .foregroundColor(AppColors.primaryText)
                            
                            if let translation = word.translation, !translation.isEmpty {
                                Text(translation)
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
                        Text(comment)
                            .font(FontManager.callout)
                            .foregroundColor(AppColors.secondaryText)
                            .lineLimit(2)
                            .padding(.top, 4)
                    }
                }
            }
            .offset(x: offset.width, y: 0)
            .highPriorityGesture(
                DragGesture(minimumDistance: 20)
                    .onChanged { value in
                        offset = value.translation
                        showingActions = abs(offset.width) > 50
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            if value.translation.width > 100 {
                                onEdit()
                            } else if value.translation.width < -100 {
                                showingDeleteAlert = true
                            }
                            offset = .zero
                            showingActions = false
                        }
                    }
            )
            .onTapGesture {
                if !showingActions {
                    onTap()
                }
            }
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
}

