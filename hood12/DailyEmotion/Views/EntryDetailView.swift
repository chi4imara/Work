import SwiftUI

struct EntryDetailView: View {
    let entry: EmotionEntry
    @ObservedObject var dataManager: EmotionDataManager
    @Environment(\.dismiss) private var dismiss
    @State private var showEditView = false
    @State private var showDeleteAlert = false
    @State private var showMenuSheet = false
    
    private var currentEntry: EmotionEntry {
        if let activeEntry = dataManager.entries.first(where: { $0.id == entry.id }) {
            return activeEntry
        }
        if let archivedEntry = dataManager.archivedEntries.first(where: { $0.id == entry.id }) {
            return archivedEntry
        }
        return entry
    }
    
    private var status: Bool {
        if let archivedEntry = dataManager.archivedEntries.first(where: { $0.id == entry.id }) {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                            .frame(width: 40, height: 40)
                            .background(AppColors.cardBackground)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("Entry Details")
                        .font(.poppinsBold(size: 20))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button(action: { showMenuSheet = true }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                            .frame(width: 40, height: 40)
                            .background(AppColors.cardBackground)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                ScrollView {
                    VStack(spacing: 30) {
                        VStack(spacing: 20) {
                            Image(systemName: currentEntry.emotion.icon)
                                .font(.system(size: 80, weight: .light))
                                .foregroundColor(AppColors.accentYellow)
                                .animation(.easeInOut(duration: 0.3), value: currentEntry.emotion)
                            
                            Text(currentEntry.emotion.title)
                                .font(.poppinsBold(size: 28))
                                .foregroundColor(AppColors.primaryText)
                                .animation(.easeInOut(duration: 0.3), value: currentEntry.emotion.title)
                        }
                        .padding(.top, 40)
                        
                        DetailSection(
                            title: "Date",
                            content: DateFormatter.displayFormatter.string(from: currentEntry.date)
                        )
                        .animation(.easeInOut(duration: 0.3), value: currentEntry.date)
                        
                        DetailSection(
                            title: "Reason",
                            content: currentEntry.reason
                        )
                        .animation(.easeInOut(duration: 0.3), value: currentEntry.reason)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(isPresented: $showEditView) {
            EditEntryView(entry: currentEntry, dataManager: dataManager)
        }
        .actionSheet(isPresented: $showMenuSheet) {
            ActionSheet(
                title: Text("Options"),
                buttons: [
                    .default(Text("Edit")) {
                        showEditView = true
                    },
                    .destructive(status ? Text("Delete") : Text("Move To Archive")) {
                        if status {
                            showDeleteAlert = true
                        } else {
                                dataManager.archiveEntry(entry)
                                dismiss()
                            }
                        },
                    .cancel()
                ]
            )
        }
        .alert("Delete Entry", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if dataManager.entries.contains(where: { $0.id == currentEntry.id }) {
                    dataManager.deleteEntry(currentEntry)
                } else if dataManager.archivedEntries.contains(where: { $0.id == currentEntry.id }) {
                    dataManager.deleteFromArchive(currentEntry)
                }
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this entry?")
        }
    }
}

struct DetailSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.poppinsSemiBold(size: 18))
                .foregroundColor(AppColors.primaryText)
            
            Text(content)
                .font(.poppinsRegular(size: 16))
                .foregroundColor(AppColors.secondaryText)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
        }
    }
}

#Preview {
    EntryDetailView(
        entry: EmotionEntry(emotion: .joy, reason: "Had a great day with friends and family. Everything went perfectly and I felt really happy about the progress I made."),
        dataManager: EmotionDataManager()
    )
}
