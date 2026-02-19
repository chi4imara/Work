import SwiftUI

struct DictionaryView: View {
    @ObservedObject var viewModel: DictionaryViewModel
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            FloatingBubblesView()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.words.isEmpty {
                    emptyStateView
                } else {
                    wordsList
                }
            }
            
            VStack {
                Spacer()
                
                addButton
                    .padding(.horizontal, 20)
            }
        }
        .sheet(item: $viewModel.presentedSheet) { sheetType in
            sheetContent(for: sheetType)
        }
        .alert("Delete Word", isPresented: $viewModel.showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.executeDelete()
            }
        } message: {
            Text("Are you sure you want to delete this word? This action cannot be undone.")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Dictionary")
                .font(.playfairDisplay(32, weight: .bold))
                .foregroundColor(ColorManager.textBlue)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(ColorManager.primaryBlue.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "book.fill")
                    .font(.system(size: 50))
                    .foregroundColor(ColorManager.primaryBlue.opacity(0.6))
            }
            
            VStack(spacing: 15) {
                Text("Your dictionary awaits")
                    .font(.playfairDisplay(24, weight: .semibold))
                    .foregroundColor(ColorManager.textBlue)
                
                Text("Here will be words and expressions that are close to you. Add your first entry to start your dictionary.")
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(ColorManager.darkGray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var wordsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.words) { word in
                    WordCardView(word: word) {
                        viewModel.showWordDetail(word)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var addButton: some View {
        Button(action: {
            HapticManager.impact(.light)
            viewModel.showAddWordSheet()
        }) {
            HStack(spacing: 10) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("Add Word")
                    .font(.playfairDisplay(18, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [ColorManager.primaryBlue, ColorManager.accentPurple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .shadow(color: ColorManager.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding(.bottom, 10)
    }
    
    @ViewBuilder
    private func sheetContent(for sheetType: SheetType) -> some View {
        switch sheetType {
        case .addWord:
            WordFormView(
                viewModel: WordFormViewModel(),
                onSave: { word in
                    viewModel.addWord(word)
                    viewModel.presentedSheet = nil
                },
                onCancel: {
                    viewModel.presentedSheet = nil
                }
            )
        case .editWord(let wordId):
            if let word = viewModel.getWordById(wordId) {
                WordFormView(
                    viewModel: WordFormViewModel(editingWord: word),
                    editingWord: word,
                    onSave: { updatedWord in
                        viewModel.updateWord(updatedWord)
                        viewModel.presentedSheet = nil
                    },
                    onCancel: {
                        viewModel.presentedSheet = nil
                    }
                )
            } else {
                EmptyView()
                    .onAppear {
                        viewModel.presentedSheet = nil
                    }
            }
        case .wordDetail(let wordId):
            if let word = viewModel.getWordById(wordId) {
                WordDetailView(
                    word: word,
                    onEdit: {
                        viewModel.presentedSheet = nil
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            viewModel.showEditWordSheet(word)
                        }
                    },
                    onDelete: {
                        viewModel.confirmDelete(word)
                        viewModel.presentedSheet = nil
                    },
                    onDismiss: {
                        viewModel.presentedSheet = nil
                    }
                )
            } else {
                EmptyView()
                    .onAppear {
                        viewModel.presentedSheet = nil
                    }
            }
        }
    }
}

struct WordCardView: View {
    let word: WordEntry
    let onTap: () -> Void
    
    var body: some View {
        Button(action: {
            HapticManager.selection()
            onTap()
        }) {
            VStack(alignment: .leading, spacing: 8) {
                Text(word.word)
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(ColorManager.textBlue)
                    .multilineTextAlignment(.leading)
                
                if !word.association.isEmpty {
                    Text(word.association)
                        .font(.playfairDisplay(14, weight: .regular))
                        .foregroundColor(ColorManager.darkGray.opacity(0.8))
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorManager.cardGradient)
                    .shadow(color: ColorManager.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    DictionaryView(viewModel: DictionaryViewModel())
}
