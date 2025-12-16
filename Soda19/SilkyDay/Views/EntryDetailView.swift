import SwiftUI

struct EditEntryID: Identifiable {
    let id: UUID
}

struct EntryDetailView: View {
    let entryId: UUID
    @ObservedObject var viewModel: CareJournalViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var editEntryID: EditEntryID?
    @State private var showingDeleteAlert = false
    
    private var entry: CareEntry? {
        viewModel.getEntry(by: entryId)
    }
    
    var body: some View {
        Group {
            if let entry = entry {
                entryDetailContent(entry: entry)
            } else {
                Text("Entry not found")
                    .foregroundColor(AppColors.primaryText)
            }
        }
    }
    
    private func entryDetailContent(entry: CareEntry) -> some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        headerInfoView(entry: entry)
                        
                        detailsView(entry: entry)
                        
                        if entry.type == .product {
                            usageStatsView(entry: entry)
                        }
                        
                        actionButtonsView
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Entry Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
            }
        }
        .sheet(item: $editEntryID) { editID in
            EditEntryView(entryId: editID.id, viewModel: viewModel)
        }
        .alert("Delete Entry", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteEntry(by: entryId)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this entry? This action cannot be undone.")
        }
    }
    
    private func headerInfoView(entry: CareEntry) -> some View {
        VStack(spacing: 16) {
            Image(systemName: entry.type.icon)
                .font(.system(size: 48))
                .foregroundColor(AppColors.yellow)
                .frame(width: 80, height: 80)
                .background(AppColors.yellow.opacity(0.2))
                .cornerRadius(40)
            
            VStack(spacing: 4) {
                Text(entry.name)
                    .font(AppFonts.title1)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(entry.type.displayName)
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground)
        .cornerRadius(20)
    }
    
    private func detailsView(entry: CareEntry) -> some View {
        VStack(spacing: 16) {
            DetailRow(
                icon: "calendar",
                title: "Date",
                value: entry.date.formatted(date: .abbreviated, time: .omitted)
            )
            
            Divider()
                .background(AppColors.primaryText.opacity(0.2))
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "text.bubble")
                        .foregroundColor(AppColors.yellow)
                    Text("Comment")
                        .font(AppFonts.bodyBold)
                        .foregroundColor(AppColors.primaryText)
                    Spacer()
                }
                
                Text(entry.comment.isEmpty ? "No comment added." : entry.comment)
                    .font(AppFonts.body)
                    .foregroundColor(entry.comment.isEmpty ? AppColors.secondaryText : AppColors.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
    
    private func usageStatsView(entry: CareEntry) -> some View {
        let usageCount = viewModel.getUsageCount(for: entry.name)
        let isFrequent = viewModel.frequentlyUsedProducts.contains(entry.name)
        
        return VStack(spacing: 16) {
            HStack {
                Image(systemName: "chart.bar")
                    .foregroundColor(AppColors.yellow)
                Text("Usage Statistics")
                    .font(AppFonts.bodyBold)
                    .foregroundColor(AppColors.primaryText)
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Times Used")
                        .font(AppFonts.footnote)
                        .foregroundColor(AppColors.secondaryText)
                    Text("\(usageCount)")
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.primaryText)
                }
                
                Spacer()
                
                if isFrequent {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(AppColors.yellow)
                        Text("Frequently Used")
                            .font(AppFonts.footnote)
                            .foregroundColor(AppColors.yellow)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppColors.yellow.opacity(0.2))
                    .cornerRadius(12)
                }
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
    
    private var actionButtonsView: some View {
        VStack(spacing: 12) {
            Button(action: {
                editEntryID = EditEntryID(id: entryId)
            }) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Edit Entry")
                }
                .font(AppFonts.button)
                .foregroundColor(AppColors.accentText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColors.yellow)
                .cornerRadius(12)
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete Entry")
                }
                .font(AppFonts.button)
                .foregroundColor(AppColors.error)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.error.opacity(0.5), lineWidth: 1)
                )
            }
        }
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(AppColors.yellow)
            
            Text(title)
                .font(AppFonts.bodyBold)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Text(value)
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryText)
        }
    }
}

#Preview {
    let viewModel = CareJournalViewModel()
    let sampleId = CareEntry.sampleData[0].id
    return EntryDetailView(
        entryId: sampleId,
        viewModel: viewModel
    )
}
