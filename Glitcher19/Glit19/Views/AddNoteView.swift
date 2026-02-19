import SwiftUI

struct AddNoteView: View {
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var noteText: String = ""
    @State private var selectedCategory: String = "Quotes"
    @State private var isFavorite: Bool = false
    @State private var showingNewCategoryAlert: Bool = false
    @State private var newCategoryName: String = ""
    
    private var canSave: Bool {
        !noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.primaryGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Note Text")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(Color.theme.primaryText)
                            
                            TextEditor(text: $noteText)
                                .font(.ubuntu(16))
                                .foregroundColor(Color.theme.primaryText)
                                .scrollContentBackground(.hidden)
                                .padding(12)
                                .frame(minHeight: 120)
                                .background(Color.theme.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.theme.accentYellow.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(Color.theme.primaryText)
                            
                            Menu {
                                ForEach(viewModel.categories, id: \.name) { category in
                                    Button(category.name) {
                                        selectedCategory = category.name
                                    }
                                }
                                
                                Divider()
                                
                                Button("Create New Category") {
                                    showingNewCategoryAlert = true
                                }
                            } label: {
                                HStack {
                                    Text(selectedCategory)
                                        .font(.ubuntu(16))
                                        .foregroundColor(Color.theme.primaryText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.theme.secondaryText)
                                }
                                .padding(12)
                                .background(Color.theme.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.theme.accentYellow.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                        
                        HStack {
                            Text("Add to Favorites")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(Color.theme.primaryText)
                            
                            Spacer()
                            
                            Toggle("", isOn: $isFavorite)
                                .toggleStyle(SwitchToggleStyle(tint: Color.theme.accentYellow))
                        }
                        .padding(12)
                        .background(Color.theme.cardBackground)
                        .cornerRadius(12)
                        
                        Button(action: saveNote) {
                            Text("Save")
                                .font(.ubuntu(18, weight: .bold))
                                .foregroundColor(canSave ? Color.theme.darkPink : Color.theme.secondaryText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(canSave ? Color.theme.accentYellow : Color.theme.cardBackground)
                                .cornerRadius(12)
                        }
                        .disabled(!canSave)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.accentYellow)
                    .font(.ubuntu(16, weight: .medium))
                }
            }
            .preferredColorScheme(.dark)
        }
        .alert("New Category", isPresented: $showingNewCategoryAlert) {
            TextField("Category name", text: $newCategoryName)
            Button("Cancel", role: .cancel) {
                newCategoryName = ""
            }
            Button("Create") {
                if !newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    selectedCategory = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
                    viewModel.addCategoryIfNeeded(selectedCategory)
                }
                newCategoryName = ""
            }
        } message: {
            Text("Enter the name for your new category")
        }
    }
    
    private func saveNote() {
        let trimmedText = noteText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        let note = Note(text: trimmedText, category: selectedCategory, isFavorite: isFavorite)
        viewModel.addNote(note)
        dismiss()
    }
}

#Preview {
    AddNoteView(viewModel: NotesViewModel())
}
