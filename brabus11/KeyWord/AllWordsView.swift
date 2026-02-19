import SwiftUI

struct AllWordsView: View {
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
            Text("All Words")
                .font(.playfairDisplay(32, weight: .bold))
                .foregroundColor(ColorManager.textBlue)
            
            Spacer()
            
            if !viewModel.words.isEmpty {
                Text("\(viewModel.words.count) words")
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(ColorManager.darkGray.opacity(0.7))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.7))
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(ColorManager.accentPurple.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "list.bullet")
                    .font(.system(size: 50))
                    .foregroundColor(ColorManager.accentPurple.opacity(0.6))
            }
            
            VStack(spacing: 15) {
                Text("No words yet")
                    .font(.playfairDisplay(24, weight: .semibold))
                    .foregroundColor(ColorManager.textBlue)
                
                Text("The dictionary is still empty. Words will appear after adding entries.")
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
                ForEach(viewModel.words.sorted(by: { $0.dateCreated > $1.dateCreated })) { word in
                    AllWordsCardView(word: word) {
                        viewModel.showWordDetail(word)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
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

struct AllWordsCardView: View {
    let word: WordEntry
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(word.word)
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(ColorManager.textBlue)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    if !word.association.isEmpty {
                        Text(word.association)
                            .font(.playfairDisplay(13, weight: .regular))
                            .foregroundColor(ColorManager.darkGray.opacity(0.8))
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                    }
                    
                    Text(formatDate(word.dateCreated))
                        .font(.playfairDisplay(11, weight: .medium))
                        .foregroundColor(ColorManager.darkGray.opacity(0.6))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorManager.primaryBlue.opacity(0.6))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(ColorManager.cardGradient)
                    .shadow(color: ColorManager.primaryBlue.opacity(0.08), radius: 6, x: 0, y: 3)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    AllWordsView(viewModel: DictionaryViewModel())
}
