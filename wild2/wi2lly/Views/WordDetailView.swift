import SwiftUI

struct WordDetailView: View {
    let wordId: UUID
    @ObservedObject var viewModel: WordsViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var word: WordModel? {
        viewModel.words.first { $0.id == wordId }
    }
    
    var body: some View {
        Group {
            if let word = word {
                NavigationView {
                    ZStack {
                        AnimatedBackground()
                        
                        ScrollView {
                            VStack(spacing: 30) {
                                VStack(spacing: 16) {
                                    Text(word.word)
                                        .font(.playfair(36, weight: .bold))
                                        .foregroundColor(Color.theme.primaryBlue)
                                        .multilineTextAlignment(.center)
                                    
                                    if let category = viewModel.categories.first(where: { $0.name == word.categoryName }) {
                                        Text(category.name)
                                            .font(.playfair(14, weight: .semibold))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 8)
                                            .background(
                                                ColorTheme.categoryColors[category.colorIndex % ColorTheme.categoryColors.count]
                                            )
                                            .cornerRadius(20)
                                    }
                                }
                                .padding(.top, 20)
                                
                                DetailSection(
                                    title: "Definition",
                                    content: word.definition,
                                    icon: "book.fill"
                                )
                                
                                if let note = word.note, !note.isEmpty {
                                    DetailSection(
                                        title: "Note",
                                        content: note,
                                        icon: "note.text"
                                    )
                                } else {
                                    DetailSection(
                                        title: "Note",
                                        content: "No note added",
                                        icon: "note.text",
                                        isPlaceholder: true
                                    )
                                }
                                
                                DetailSection(
                                    title: "Date Added",
                                    content: DateFormatter.longDate.string(from: word.dateAdded),
                                    icon: "calendar"
                                )
                                
                                Spacer(minLength: 100)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Close") {
                                dismiss()
                            }
                            .foregroundColor(Color.theme.primaryBlue)
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu {
                                Button(action: { showingEditView = true }) {
                                    Label("Edit", systemImage: "pencil")
                                }
                                
                                Button(role: .destructive, action: { showingDeleteAlert = true }) {
                                    Label("Delete", systemImage: "trash")
                                }
                            } label: {
                                Image(systemName: "ellipsis.circle")
                                    .foregroundColor(Color.theme.primaryBlue)
                            }
                        }
                    }
                }
            } else {
                NavigationView {
                    ZStack {
                        AnimatedBackground()
                        
                        VStack {
                            Text("Word not found")
                                .font(.playfair(20, weight: .semibold))
                                .foregroundColor(Color.theme.primaryBlue)
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Close") {
                                dismiss()
                            }
                            .foregroundColor(Color.theme.primaryBlue)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            if let word = word {
                AddEditWordView(viewModel: viewModel, editingWord: word)
            }
        }
        .alert("Delete Word", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let word = word {
                    viewModel.deleteWord(word)
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            if let word = word {
                Text("Are you sure you want to delete '\(word.word)'? This action cannot be undone.")
            }
        }
    }
}

struct DetailSection: View {
    let title: String
    let content: String
    let icon: String
    var isPlaceholder: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color.theme.primaryYellow)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.playfair(20, weight: .semibold))
                    .foregroundColor(Color.theme.primaryBlue)
                
                Spacer()
            }
            
            Text(content)
                .font(.playfair(16, weight: .regular))
                .foregroundColor(isPlaceholder ? Color.theme.textGray.opacity(0.6) : Color.theme.textGray)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.theme.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

extension DateFormatter {
    static let longDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
}

struct WordDetailViewModel: Identifiable {
    let wordId: UUID
    var id: UUID { wordId }
}

#Preview {
    let sampleWord = WordModel(
        word: "Petrichor",
        definition: "The pleasant earthy smell that frequently accompanies the first rain after a long period of warm, dry weather.",
        note: "This is one of my favorite words!",
        categoryName: "Nature"
    )
    return WordDetailView(
        wordId: sampleWord.id,
        viewModel: WordsViewModel()
    )
}
