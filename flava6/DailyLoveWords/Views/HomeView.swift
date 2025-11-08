import SwiftUI

struct HomeView: View {
    @ObservedObject var wordStore: WordStore
    @State private var showingMenu = false
    @State private var showingAddWord = false
    @State private var showingEditWord = false
    @State private var showingDeleteAlert = false
    @State private var showingCollection = false
    @State private var showingHowItWorks = false
    
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 30) {
                        headerView
                        
                        todaysWordSection
                        
                        infoSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddWord) {
            AddEditWordView(wordStore: wordStore, editingWord: nil, selectedDate: nil)
        }
        .sheet(isPresented: $showingEditWord) {
            if let todaysWord = wordStore.todaysWord {
                AddEditWordView(wordStore: wordStore, editingWord: todaysWord, selectedDate: nil)
            }
        }
        .sheet(isPresented: $showingHowItWorks) {
            HowItWorksView()
        }
        .alert("Delete Word", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let todaysWord = wordStore.todaysWord {
                    wordStore.deleteWord(todaysWord)
                }
            }
        } message: {
            Text("Are you sure you want to delete today's word?")
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Word of the Day")
                    .font(FontManager.largeTitle)
                    .foregroundColor(AppColors.primaryText)
                
                Text(currentDateString)
                    .font(FontManager.subheadline)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Button(action: { showingMenu.toggle() }) {
                Image(systemName: "ellipsis")
                    .font(.title2)
                    .foregroundColor(AppColors.primaryBlue)
                    .padding(12)
                    .background(
                        Circle()
                            .fill(AppColors.backgroundWhite)
                            .shadow(color: AppColors.primaryBlue.opacity(0.2), radius: 4)
                    )
            }
            .actionSheet(isPresented: $showingMenu) {
                ActionSheet(
                    title: Text("Menu"),
                    buttons: [
                        .default(Text("My Collection")) {
                            withAnimation { selectedTab = 1 }
                        },
                        .default(Text("Calendar")) {
                            withAnimation { selectedTab = 2 }
                        },
                        .default(Text("Search")) {
                            withAnimation { selectedTab = 3 }
                        },
                        .default(Text("How It Works")) {
                            showingHowItWorks = true
                        },
                        .cancel()
                    ]
                )
            }
        }
    }
    
    private var todaysWordSection: some View {
        PixelCard {
            if let todaysWord = wordStore.todaysWord {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Word:")
                            .font(FontManager.headline)
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text(todaysWord.word)
                            .font(FontManager.title1)
                            .foregroundColor(AppColors.primaryText)
                    }
                    
                    if let translation = todaysWord.translation, !translation.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Translation:")
                                .font(FontManager.headline)
                                .foregroundColor(AppColors.secondaryText)
                            
                            Text(translation)
                                .font(FontManager.body)
                                .foregroundColor(AppColors.primaryText)
                        }
                    }
                    
                    if let comment = todaysWord.comment, !comment.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment:")
                                .font(FontManager.headline)
                                .foregroundColor(AppColors.secondaryText)
                            
                            Text(comment)
                                .font(FontManager.body)
                                .foregroundColor(AppColors.primaryText)
                        }
                    }
                    
                    HStack(spacing: 15) {
                        PixelButton(
                            title: "Edit",
                            action: { showingEditWord = true },
                            color: AppColors.primaryBlue
                        )
                        
                        PixelButton(
                            title: "Delete",
                            action: { showingDeleteAlert = true },
                            color: AppColors.error
                        )
                    }
                    .padding(.top, 8)
                }
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "book.fill")
                        .font(.system(size: 60))
                        .foregroundColor(AppColors.lightBlue)
                    
                    VStack(spacing: 8) {
                        Text("Add a word for today")
                            .font(FontManager.title2)
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Start building your collection")
                            .font(FontManager.body)
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    PixelButton(
                        title: "Add Word",
                        action: { showingAddWord = true },
                        color: AppColors.primaryBlue
                    )
                }
                .padding(.vertical, 20)
            }
        }
    }
    
    private var infoSection: some View {
        VStack(spacing: 16) {
            PixelCard {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total words in collection:")
                            .font(FontManager.body)
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text("\(wordStore.totalWordsCount)")
                            .font(FontManager.title1)
                            .foregroundColor(AppColors.primaryBlue)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "books.vertical.fill")
                        .font(.system(size: 30))
                        .foregroundColor(AppColors.lightBlue)
                }
            }
            
            HStack(spacing: 12) {
                PixelButton(
                    title: "Collection",
                    action: { withAnimation { selectedTab = 1 } },
                    color: AppColors.darkBlue
                )
                
                PixelButton(
                    title: "Calendar",
                    action: { withAnimation { selectedTab = 2 } },
                    color: AppColors.primaryBlue
                )
            }
        }
    }
    
    private var currentDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: Date())
    }
}

