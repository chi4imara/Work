import SwiftUI

struct EntryDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let entryId: UUID
    @ObservedObject var entryStore: EntryStore
    
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    private var entry: Entry? {
        entryStore.entries.first { $0.id == entryId }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    if let entry = entry {
                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Phrase")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(Color.theme.textSecondary)
                                
                                Text(entry.phrase)
                                    .font(.ubuntu(20, weight: .regular))
                                    .foregroundColor(Color.theme.textPrimary)
                                    .lineSpacing(4)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            .background(Color.theme.cardBackground)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.theme.cardBorder, lineWidth: 1)
                            )
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Date")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(Color.theme.textSecondary)
                                
                                Text(entry.date.formattedMedium())
                                    .font(.ubuntu(18, weight: .regular))
                                    .foregroundColor(Color.theme.textPrimary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            .background(Color.theme.cardBackground)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.theme.cardBorder, lineWidth: 1)
                            )
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Category")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(Color.theme.textSecondary)
                                
                                HStack {
                                    Text(entry.category.displayName)
                                        .font(.ubuntu(14, weight: .medium))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(entry.category.color)
                                        .cornerRadius(12)
                                    
                                    Spacer()
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            .background(Color.theme.cardBackground)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.theme.cardBorder, lineWidth: 1)
                            )
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Note")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(Color.theme.textSecondary)
                                
                                if let note = entry.note, !note.isEmpty {
                                    Text(note)
                                        .font(.ubuntu(16, weight: .regular))
                                        .foregroundColor(Color.theme.textPrimary)
                                        .lineSpacing(4)
                                } else {
                                    Text("Note not added")
                                        .font(.ubuntu(16, weight: .regular))
                                        .foregroundColor(Color.theme.textSecondary)
                                        .italic()
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            .background(Color.theme.cardBackground)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.theme.cardBorder, lineWidth: 1)
                            )
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    } else {
                        VStack {
                            Spacer()
                            Text("Entry not found")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(Color.theme.textSecondary)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Entry Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.textPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Edit") {
                            showingEditSheet = true
                        }
                        
                        Button("Delete", role: .destructive) {
                            showingDeleteAlert = true
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(Color.theme.textPrimary)
                    }
                }
            }
            .toolbarBackground(Color.clear, for: .navigationBar)
        }
        .sheet(isPresented: $showingEditSheet) {
            if let entry = entry {
                AddEditEntryView(entryStore: entryStore, editingEntry: entry)
            }
        }
        .alert("Delete Entry", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let entry = entry {
                    entryStore.deleteEntry(entry)
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete this entry? This action cannot be undone.")
        }
    }
}

#Preview {
    let store = EntryStore()
    let sampleEntry = Entry(
        phrase: "Today is a beautiful day to start something new!",
        note: "Feeling optimistic about the future",
        category: .personal
    )
    store.addEntry(sampleEntry)
    return EntryDetailView(
        entryId: sampleEntry.id,
        entryStore: store
    )
}
