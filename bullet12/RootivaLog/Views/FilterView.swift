import SwiftUI

struct FilterView: View {
    @ObservedObject var journalViewModel: RepotJournalViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedPeriod: FilterPeriod
    @State private var selectedPlant: String
    @State private var customStartDate: Date
    @State private var customEndDate: Date
    @State private var showingDateError = false
    
    init(journalViewModel: RepotJournalViewModel) {
        self.journalViewModel = journalViewModel
        self._selectedPeriod = State(initialValue: journalViewModel.selectedPeriod)
        self._selectedPlant = State(initialValue: journalViewModel.selectedPlant)
        self._customStartDate = State(initialValue: journalViewModel.customStartDate)
        self._customEndDate = State(initialValue: journalViewModel.customEndDate)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        periodSection
                        
                        if selectedPeriod == .custom {
                            customDateSection
                        }
                        
                        plantSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 50)
                }
            }
            .navigationTitle("Filter Records")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        resetFilters()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        applyFilters()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
        }
        .alert("Date Error", isPresented: $showingDateError) {
            Button("OK") { }
        } message: {
            Text("Start date cannot be later than end date")
        }
    }
    
    private var periodSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Period")
                .font(AppFonts.title3(.semiBold))
                .foregroundColor(AppColors.textPrimary)
            
            VStack(spacing: 12) {
                ForEach(FilterPeriod.allCases, id: \.self) { period in
                    PeriodOptionRow(
                        period: period,
                        isSelected: selectedPeriod == period,
                        onTap: { selectedPeriod = period }
                    )
                }
            }
        }
    }
    
    private var customDateSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Custom Date Range")
                .font(AppFonts.headline(.semiBold))
                .foregroundColor(AppColors.textPrimary)
            
            VStack(spacing: 12) {
                HStack {
                    Text("From")
                        .font(AppFonts.subheadline(.medium))
                        .foregroundColor(AppColors.textSecondary)
                        .frame(width: 60, alignment: .leading)
                    
                    DatePicker("", selection: $customStartDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .font(AppFonts.body(.regular))
                }
                .padding()
                .background(AppColors.cardBackground)
                .cornerRadius(12)
                
                HStack {
                    Text("To")
                        .font(AppFonts.subheadline(.medium))
                        .foregroundColor(AppColors.textSecondary)
                        .frame(width: 60, alignment: .leading)
                    
                    DatePicker("", selection: $customEndDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .font(AppFonts.body(.regular))
                }
                .padding()
                .background(AppColors.cardBackground)
                .cornerRadius(12)
            }
        }
    }
    
    private var plantSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Plant")
                .font(AppFonts.title3(.semiBold))
                .foregroundColor(AppColors.textPrimary)
            
            Menu {
                ForEach(journalViewModel.uniquePlantNames, id: \.self) { plantName in
                    Button(plantName) {
                        selectedPlant = plantName
                    }
                }
            } label: {
                HStack {
                    Text(selectedPlant)
                        .font(AppFonts.body(.regular))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(AppColors.textTertiary)
                }
                .padding()
                .background(AppColors.cardBackground)
                .cornerRadius(12)
            }
        }
    }
    
    private func resetFilters() {
        selectedPeriod = .all
        selectedPlant = "Any"
        customStartDate = Date()
        customEndDate = Date()
        
        journalViewModel.selectedPeriod = selectedPeriod
        journalViewModel.selectedPlant = selectedPlant
        journalViewModel.customStartDate = customStartDate
        journalViewModel.customEndDate = customEndDate
        
        dismiss()
    }
    
    private func applyFilters() {
        if selectedPeriod == .custom && customStartDate > customEndDate {
            showingDateError = true
            return
        }
        
        journalViewModel.selectedPeriod = selectedPeriod
        journalViewModel.selectedPlant = selectedPlant
        journalViewModel.customStartDate = customStartDate
        journalViewModel.customEndDate = customEndDate
        
        dismiss()
    }
}

struct PeriodOptionRow: View {
    let period: FilterPeriod
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.textTertiary)
                
                Text(period.displayName)
                    .font(AppFonts.body(.regular))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            .padding()
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? AppColors.primaryBlue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FilterView(journalViewModel: RepotJournalViewModel())
}
