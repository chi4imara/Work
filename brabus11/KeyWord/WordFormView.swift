import SwiftUI

struct WordFormView: View {
    @ObservedObject var viewModel: WordFormViewModel
    let editingWord: WordEntry?
    let onSave: (WordEntry) -> Void
    let onCancel: () -> Void
    
    @FocusState private var focusedField: FormField?
    
    init(
        viewModel: WordFormViewModel,
        editingWord: WordEntry? = nil,
        onSave: @escaping (WordEntry) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.editingWord = editingWord
        self.onSave = onSave
        self.onCancel = onCancel
    }
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            FloatingBubblesView()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    headerView
                    
                    VStack(spacing: 20) {
                        wordField
                        meaningField
                        associationField
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 50)
                }
                .padding(.top, 20)
            }
        }
        .onAppear {
            focusedField = .word
        }
    }
    
    private var headerView: some View {
        HStack {
            Button("Cancel") {
                onCancel()
            }
            .font(.playfairDisplay(16, weight: .medium))
            .foregroundColor(ColorManager.textBlue)
            
            Spacer()
            
            Text(editingWord == nil ? "New Word" : "Edit Word")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(ColorManager.textBlue)
            
            Spacer()
            
            Button("Save") {
                let wordEntry: WordEntry
                if let editingWord = editingWord {
                    wordEntry = viewModel.updateWordEntry(editingWord)
                } else {
                    wordEntry = viewModel.createWordEntry()
                }
                onSave(wordEntry)
            }
            .font(.playfairDisplay(16, weight: .semibold))
            .foregroundColor(viewModel.isValid ? ColorManager.primaryBlue : ColorManager.lightGray)
            .disabled(!viewModel.isValid)
        }
        .padding(.horizontal, 20)
    }
    
    private var wordField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Word or Expression")
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(ColorManager.textBlue)
            
            TextField("Enter word or expression", text: $viewModel.word)
                .font(.playfairDisplay(18, weight: .regular))
                .foregroundColor(ColorManager.textBlue)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.8))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    focusedField == .word ? ColorManager.primaryBlue : Color.clear,
                                    lineWidth: 2
                                )
                        }
                )
                .focused($focusedField, equals: .word)
        }
    }
    
    private var meaningField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("My Meaning")
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(ColorManager.textBlue)
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $viewModel.meaning)
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(ColorManager.textBlue)
                    .padding(12)
                    .frame(minHeight: 80)
                    .focused($focusedField, equals: .meaning)
                    .scrollContentBackground(.hidden)
                
                if viewModel.meaning.isEmpty {
                    Text("Enter your personal meaning or definition")
                        .font(.playfairDisplay(16, weight: .regular))
                        .foregroundColor(ColorManager.darkGray.opacity(0.5))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                        .allowsHitTesting(false)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                focusedField == .meaning ? ColorManager.primaryBlue : Color.clear,
                                lineWidth: 2
                            )
                    }
            )
        }
    }
    
    private var associationField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Association")
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(ColorManager.textBlue)
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $viewModel.association)
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(ColorManager.textBlue)
                    .padding(12)
                    .frame(minHeight: 80)
                    .focused($focusedField, equals: .association)
                    .scrollContentBackground(.hidden)
                
                if viewModel.association.isEmpty {
                    Text("Enter your personal association or connection")
                        .font(.playfairDisplay(16, weight: .regular))
                        .foregroundColor(ColorManager.darkGray.opacity(0.5))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                        .allowsHitTesting(false)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                focusedField == .association ? ColorManager.primaryBlue : Color.clear,
                                lineWidth: 2
                            )
                    }
            )
        }
    }
}

enum FormField {
    case word, meaning, association
}

#Preview {
    WordFormView(
        viewModel: WordFormViewModel(),
        onSave: { _ in },
        onCancel: { }
    )
}
