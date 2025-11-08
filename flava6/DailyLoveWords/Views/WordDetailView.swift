import SwiftUI

struct WordDetailView: View {
    @ObservedObject var wordStore: WordStore
    @Environment(\.presentationMode) var presentationMode
    
    let word: Word
    
    @State private var showingEditWord = false
    @State private var showingDeleteAlert = false
    @State private var localWord: Word
    
    init(wordStore: WordStore, word: Word) {
        self.wordStore = wordStore
        self.word = word
        self._localWord = State(initialValue: word)
    }
    
    private func updateLocalWord() {
        if let found = wordStore.words.first(where: { $0.id == word.id }) {
            if localWord != found {
                print("🔄 WordDetailView: Word updated - \(found.word)")
                localWord = found
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 30) {
                        headerView
                        
                        detailsView
                        
                        actionButtons
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Word Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
        }
        .sheet(isPresented: $showingEditWord) {
            AddEditWordView(wordStore: wordStore, editingWord: localWord, selectedDate: nil)
        }
        .onChange(of: showingEditWord) { isShowing in
            if !isShowing {
                updateLocalWord()
            }
        }
        .alert("Delete Word", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                wordStore.deleteWord(localWord)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete '\(localWord.word)'? This action cannot be undone.")
        }
        .onAppear {
            localWord = word
        }
        .onChange(of: wordStore.words) { _ in
            updateLocalWord()
        }
    }
    
    private var headerView: some View {
        PixelCard {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.lightBlue.opacity(0.3))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "book.circle.fill")
                        .font(.system(size: 35))
                        .foregroundColor(AppColors.primaryBlue)
                }
                
                Text(localWord.word)
                    .font(FontManager.largeTitle)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 16) {
                    VStack(spacing: 4) {
                        Text("Added")
                            .font(FontManager.caption)
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text(localWord.formattedDate)
                            .font(FontManager.subheadline)
                            .foregroundColor(AppColors.primaryText)
                    }
                    
                    if localWord.isToday {
                        Divider()
                            .frame(height: 30)
                        
                        VStack(spacing: 4) {
                            Text("Status")
                                .font(FontManager.caption)
                                .foregroundColor(AppColors.secondaryText)
                            
                            Text("Today's Word")
                                .font(FontManager.subheadline)
                                .foregroundColor(AppColors.primaryBlue)
                        }
                    }
                }
            }
            .padding(.vertical, 10)
        }
    }
    
    private var detailsView: some View {
        VStack(spacing: 20) {
            if let translation = localWord.translation, !translation.isEmpty {
                PixelCard {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "globe")
                                .foregroundColor(AppColors.primaryBlue)
                            
                            Text("Translation")
                                .font(FontManager.headline)
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                        }
                        
                        Text(translation)
                            .font(FontManager.body)
                            .foregroundColor(AppColors.primaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            
            if let comment = localWord.comment, !comment.isEmpty {
                PixelCard {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "note.text")
                                .foregroundColor(AppColors.primaryBlue)
                            
                            Text("Comment")
                                .font(FontManager.headline)
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                        }
                        
                        Text(comment)
                            .font(FontManager.body)
                            .foregroundColor(AppColors.primaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            
            PixelCard {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(AppColors.primaryBlue)
                        
                        Text("Information")
                            .font(FontManager.headline)
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Word length:")
                                .font(FontManager.callout)
                                .foregroundColor(AppColors.secondaryText)
                            
                            Spacer()
                            
                            Text("\(localWord.word.count) characters")
                                .font(FontManager.callout)
                                .foregroundColor(AppColors.primaryText)
                        }
                        
                        HStack {
                            Text("Has translation:")
                                .font(FontManager.callout)
                                .foregroundColor(AppColors.secondaryText)
                            
                            Spacer()
                            
                            Text(localWord.translation?.isEmpty == false ? "Yes" : "No")
                                .font(FontManager.callout)
                                .foregroundColor(AppColors.primaryText)
                        }
                        
                        HStack {
                            Text("Has comment:")
                                .font(FontManager.callout)
                                .foregroundColor(AppColors.secondaryText)
                            
                            Spacer()
                            
                            Text(localWord.comment?.isEmpty == false ? "Yes" : "No")
                                .font(FontManager.callout)
                                .foregroundColor(AppColors.primaryText)
                        }
                    }
                }
            }
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                PixelButton(
                    title: "Edit Word",
                    action: { showingEditWord = true },
                    color: AppColors.primaryBlue
                )
                
                PixelButton(
                    title: "Delete",
                    action: { showingDeleteAlert = true },
                    color: AppColors.error
                )
            }
            
            Button("Back to Collection") {
                presentationMode.wrappedValue.dismiss()
            }
            .font(FontManager.body)
            .foregroundColor(AppColors.secondaryText)
        }
    }
}

#Preview {
    WordDetailView(
        wordStore: WordStore(),
        word: Word(
            word: "Bonjour",
            translation: "Hello/Good day",
            comment: "French greeting used throughout the day"
        )
    )
}
