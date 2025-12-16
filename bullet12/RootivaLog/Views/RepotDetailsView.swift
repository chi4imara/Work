import SwiftUI

struct RepotDetailsView: View {
    @State private var currentRecord: RepotRecord
    @ObservedObject var journalViewModel: RepotJournalViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var plantHistory: [RepotRecord] = []
    
    init(record: RepotRecord, journalViewModel: RepotJournalViewModel) {
        self._currentRecord = State(initialValue: record)
        self.journalViewModel = journalViewModel
    }
    
    private var displayedRecord: RepotRecord {
        journalViewModel.records.first(where: { $0.id == currentRecord.id }) ?? currentRecord
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        informationCard
                        
                        if !plantHistory.isEmpty {
                            historySection
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 50)
                }
                .id(displayedRecord.id)
            }
            .navigationTitle(displayedRecord.plantName)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Edit") {
                            showingEditView = true
                        }
                        
                        Button("Delete", role: .destructive) {
                            showingDeleteAlert = true
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(AppColors.textPrimary)
                    }
                }
            }
        }
        .onAppear {
            loadPlantHistory()
        }
        .sheet(isPresented: $showingEditView) {
            RepotFormView(viewModel: journalViewModel, editingRecord: displayedRecord)
        }
        .alert("Delete Record", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                journalViewModel.deleteRecord(displayedRecord)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Delete record from \(DateFormatter.medium.string(from: displayedRecord.repotDate))?")
        }
        .onChange(of: journalViewModel.records) { _ in
            if let updatedRecord = journalViewModel.records.first(where: { $0.id == currentRecord.id }) {
                currentRecord = updatedRecord
            }
            loadPlantHistory()
        }
        .onChange(of: showingEditView) { isPresented in
            if !isPresented {
                if let updatedRecord = journalViewModel.records.first(where: { $0.id == currentRecord.id }) {
                    currentRecord = updatedRecord
                }
                loadPlantHistory()
            }
        }
    }
    
    private var informationCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Repotting Information")
                    .font(AppFonts.title2(.semiBold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text(DateFormatter.full.string(from: displayedRecord.repotDate))
                    .font(AppFonts.subheadline(.medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Divider()
                .background(AppColors.textTertiary.opacity(0.3))
            
            VStack(alignment: .leading, spacing: 16) {
                if !displayedRecord.potDescription.isEmpty {
                    DetailRow(title: "Pot", value: displayedRecord.potDescription)
                }
                
                if let soilType = displayedRecord.soilType, !soilType.isEmpty {
                    DetailRow(title: "Soil", value: soilType)
                }
                
                DetailRow(title: "Drainage", value: displayedRecord.hasDrainage ? "Yes" : "No")
                
                if let note = displayedRecord.careNote, !note.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Care Note")
                            .font(AppFonts.headline(.semiBold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text(note)
                            .font(AppFonts.body(.regular))
                            .foregroundColor(AppColors.textSecondary)
                            .lineSpacing(4)
                    }
                } else {
                    DetailRow(title: "Care Note", value: "No notes")
                }
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private var historySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Previous Repottings of This Plant")
                .font(AppFonts.title3(.semiBold))
                .foregroundColor(AppColors.textPrimary)
            
            VStack(spacing: 12) {
                ForEach(plantHistory) { record in
                    HistoryRow(record: record) {
                        currentRecord = record
                    }
                }
            }
        }
    }
    
    private func loadPlantHistory() {
        let base = displayedRecord
        plantHistory = journalViewModel.records
            .filter { $0.normalizedPlantName == base.normalizedPlantName && $0.id != base.id }
            .sorted { $0.repotDate > $1.repotDate }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(AppFonts.subheadline(.semiBold))
                .foregroundColor(AppColors.textPrimary)
                .frame(width: 80, alignment: .leading)
            
            Text(value)
                .font(AppFonts.subheadline(.regular))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
    }
}

struct HistoryRow: View {
    let record: RepotRecord
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(DateFormatter.medium.string(from: record.repotDate))
                        .font(AppFonts.subheadline(.semiBold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(record.shortDescription.isEmpty ? "No details" : record.shortDescription)
                        .font(AppFonts.caption(.regular))
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppColors.textTertiary)
            }
            .padding(16)
            .background(AppColors.surfaceBackground)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

extension DateFormatter {
    static let full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
}
