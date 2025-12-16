import SwiftUI

struct MainContainerView: View {
    @State private var selectedTab = 0
    @StateObject private var entryStore = EntryStore()
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case 0:
                    MainView()
                case 1:
                    AddEditEntryFullView(entryStore: entryStore, selectedTab: $selectedTab)
                case 2:
                    CategoriesView()
                case 3:
                    StatisticsView()
                case 4:
                    SettingsView()
                default:
                    MainView()
                }
            }
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct AddEditEntryFullView: View {
    @ObservedObject var entryStore: EntryStore
    @Binding var selectedTab: Int
    
    @State private var phrase: String = ""
    @State private var note: String = ""
    @State private var selectedDate: Date = Date()
    @State private var selectedCategory: Category = .other
    
    private var isFormValid: Bool {
        !phrase.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ZStack {
                AnimatedBackground()
                
                VStack {
                    HStack {
                        Text("New Entry")
                            .font(.ubuntu(24, weight: .bold))
                            .foregroundColor(Color.theme.textPrimary)
                        
                        Spacer()
                        
                        Button("Save") {
                            saveEntry()
                        }
                        .foregroundColor(isFormValid ? Color.white : Color.white.opacity(0))
                        .disabled(!isFormValid)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    
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
            }
        }
    }
    
    private func saveEntry() {
        let trimmedPhrase = phrase.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let newEntry = Entry(
            phrase: trimmedPhrase,
            note: trimmedNote.isEmpty ? nil : trimmedNote,
            date: selectedDate,
            category: selectedCategory
        )
        entryStore.addEntry(newEntry)
        
        resetForm()
        selectedTab = 0
    }
    
    private func resetForm() {
        phrase = ""
        note = ""
        selectedDate = Date()
        selectedCategory = .other
    }
}

#Preview {
    MainContainerView()
}
