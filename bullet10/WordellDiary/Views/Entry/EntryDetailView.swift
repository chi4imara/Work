import SwiftUI
import Combine

struct EntryDetailView: View {
    let entryId: UUID
    @ObservedObject var viewModel: DiaryViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteConfirmation = false
    
    var entryO: DiaryEntry? {
        viewModel.filteredEntries.first(where: { $0.id == entryId })
    }
    
    var body: some View {
        NavigationView {
            if let entry = entryO {
                ZStack {
                    AppColors.mainBackgroundGradient
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            VStack(spacing: 16) {
                                Text(entry.date, style: .date)
                                    .font(AppFonts.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(AppColors.primaryBlue)
                                
                                Image(systemName: entry.mood.icon)
                                    .font(.system(size: 60, weight: .medium))
                                    .foregroundColor(AppColors.primaryBlue)
                                    .frame(width: 100, height: 100)
                                    .background {
                                        Circle()
                                            .fill(AppColors.accentYellow.opacity(0.2))
                                    }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 20)
                            
                            if let shortTitle = entry.shortTitle, !shortTitle.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Title")
                                        .font(AppFonts.caption)
                                        .foregroundColor(AppColors.darkGray.opacity(0.7))
                                        .textCase(.uppercase)
                                    
                                    Text(shortTitle)
                                        .font(AppFonts.headline)
                                        .fontWeight(.medium)
                                        .foregroundColor(AppColors.primaryBlue)
                                }
                                .padding(.horizontal, 20)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(AppFonts.caption)
                                    .foregroundColor(AppColors.darkGray.opacity(0.7))
                                    .textCase(.uppercase)
                                
                                Text(entry.text)
                                    .font(AppFonts.body)
                                    .foregroundColor(AppColors.darkGray)
                                    .lineSpacing(4)
                            }
                            .padding(.horizontal, 20)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Details")
                                    .font(AppFonts.caption)
                                    .foregroundColor(AppColors.darkGray.opacity(0.7))
                                    .textCase(.uppercase)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    MetadataRow(
                                        title: "Date Added",
                                        value: formatDate(entry.createdAt)
                                    )
                                    
                                    MetadataRow(
                                        title: "Last Edited",
                                        value: formatDate(entry.updatedAt)
                                    )
                                    
                                    MetadataRow(
                                        title: "Text Length",
                                        value: "\(entry.characterCount) characters"
                                    )
                                }
                                .padding(16)
                                .background {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardGradient)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            Spacer(minLength: 100)
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
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.darkGray)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button(action: { showingEditView = true }) {
                                Label("Edit", systemImage: "pencil")
                            }
                            
                            Button(role: .destructive, action: { showingDeleteConfirmation = true }) {
                                Label("Delete", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.system(size: 18))
                                .foregroundColor(AppColors.primaryBlue)
                        }
                    }
                }
                
                .sheet(isPresented: $showingEditView) {
                    NewEntryView(viewModel: viewModel, selectedTab: .constant(.days), editingEntry: entry)
                        .onDisappear {
                            viewModel.objectWillChange.send()
                        }
                }
                .alert("Delete Entry", isPresented: $showingDeleteConfirmation) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        viewModel.deleteEntry(entry)
                        dismiss()
                    }
                } message: {
                    Text("Are you sure you want to delete this entry? This action cannot be undone.")
                }
            } else {
                Color.clear
                    .onAppear {
                        dismiss()
                    }
            }
        }
    }
        private func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
    
}

struct MetadataRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppFonts.body)
                .foregroundColor(AppColors.darkGray)
            
            Spacer()
            
            Text(value)
                .font(AppFonts.body)
                .fontWeight(.medium)
                .foregroundColor(AppColors.primaryBlue)
        }
    }
}

#Preview {
    let testEntry = DiaryEntry(
        date: Date(),
        mood: .happy,
        text: "Today was a wonderful day filled with sunshine and laughter. I spent time with friends and enjoyed a beautiful walk in the park.",
        shortTitle: "A Beautiful Day"
    )
    let viewModel = DiaryViewModel()
    viewModel.addEntry(testEntry)
    
    return EntryDetailView(
        entryId: testEntry.id,
        viewModel: viewModel
    )
}
