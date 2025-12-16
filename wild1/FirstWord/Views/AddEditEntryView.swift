import SwiftUI

struct AddEditEntryView: View {
    @Environment(\.dismiss) private var dismiss
    let entryStore: EntryStore
    let editingEntry: Entry?
    
    @State private var phrase: String = ""
    @State private var note: String = ""
    @State private var selectedDate: Date = Date()
    @State private var selectedCategory: Category = .other
    
    init(entryStore: EntryStore, editingEntry: Entry? = nil) {
        self.entryStore = entryStore
        self.editingEntry = editingEntry
        
        if let entry = editingEntry {
            _phrase = State(initialValue: entry.phrase)
            _note = State(initialValue: entry.note ?? "")
            _selectedDate = State(initialValue: entry.date)
            _selectedCategory = State(initialValue: entry.category)
        }
    }
    
    private var isFormValid: Bool {
        !phrase.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Phrase *")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(Color.theme.textPrimary)
                            
                            TextEditor(text: $phrase)
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(Color.theme.textPrimary)
                                .frame(minHeight: 100)
                                .padding(12)
                                .background(Color.theme.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.theme.cardBorder, lineWidth: 1)
                                )
                                .scrollContentBackground(.hidden)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Note (Optional)")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(Color.theme.textPrimary)
                            
                            TextEditor(text: $note)
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(Color.theme.textPrimary)
                                .frame(minHeight: 80)
                                .padding(12)
                                .background(Color.theme.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.theme.cardBorder, lineWidth: 1)
                                )
                                .scrollContentBackground(.hidden)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Date")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(Color.theme.textPrimary)
                            
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .colorScheme(.dark)
                                .padding(12)
                                .background(Color.theme.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.theme.cardBorder, lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(Color.theme.textPrimary)
                            
                            Menu {
                                ForEach(entryStore.allCategories, id: \.self) { category in
                                    Button(category.displayName) {
                                        selectedCategory = category
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedCategory.displayName)
                                        .font(.ubuntu(16, weight: .regular))
                                        .foregroundColor(Color.theme.textPrimary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Color.theme.textSecondary)
                                }
                                .padding(12)
                                .background(Color.theme.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.theme.cardBorder, lineWidth: 1)
                                )
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(editingEntry == nil ? "New Entry" : "Edit Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.textPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveEntry()
                    }
                    .foregroundColor(isFormValid ? Color.theme.buttonPrimary : Color.theme.textSecondary)
                    .disabled(!isFormValid)
                }
            }
            .toolbarBackground(Color.clear, for: .navigationBar)
        }
    }
    
    private func saveEntry() {
        let trimmedPhrase = phrase.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let editingEntry = editingEntry {
            var updatedEntry = editingEntry
            updatedEntry.phrase = trimmedPhrase
            updatedEntry.note = trimmedNote.isEmpty ? nil : trimmedNote
            updatedEntry.date = selectedDate
            updatedEntry.category = selectedCategory
            entryStore.updateEntry(updatedEntry)
        } else {
            let newEntry = Entry(
                phrase: trimmedPhrase,
                note: trimmedNote.isEmpty ? nil : trimmedNote,
                date: selectedDate,
                category: selectedCategory
            )
            entryStore.addEntry(newEntry)
        }
        
        dismiss()
    }
}

#Preview {
    AddEditEntryView(entryStore: EntryStore())
}
