import SwiftUI

struct QuickAddView: View {
    @ObservedObject var journalViewModel: RepotJournalViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var plantName: String = ""
    @State private var selectedDate: Date = Date()
    @State private var selectedPlant: String = ""
    @State private var showingPlantPicker = false
    
    @Binding var showingQuickAdd: Bool
    @Binding var showingAddView: Bool
    
    private var recentPlants: [String] {
        let uniquePlants = Set(journalViewModel.records.map { $0.plantName })
        return Array(uniquePlants).sorted()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        Image(systemName: "bolt.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(AppColors.accentYellow)
                        
                        Text("Quick Add")
                            .font(AppFonts.title(.bold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("Add a repotting record in seconds")
                            .font(AppFonts.subheadline(.regular))
                            .foregroundColor(AppColors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Plant")
                                .font(AppFonts.headline(.semiBold))
                                .foregroundColor(AppColors.textPrimary)
                            
                            if recentPlants.isEmpty {
                                TextField("Enter plant name", text: $plantName)
                                    .font(AppFonts.body(.regular))
                                    .foregroundColor(AppColors.textPrimary)
                                    .padding()
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(12)
                            } else {
                                Menu {
                                    ForEach(recentPlants, id: \.self) { plant in
                                        Button(plant) {
                                            selectedPlant = plant
                                            plantName = plant
                                        }
                                    }
                                    
                                    Divider()
                                    
                                    Button("Custom...") {
                                        plantName = ""
                                        selectedPlant = ""
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedPlant.isEmpty ? "Select or enter plant" : selectedPlant)
                                            .font(AppFonts.body(.regular))
                                            .foregroundColor(selectedPlant.isEmpty ? AppColors.textTertiary : AppColors.textPrimary)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.caption)
                                            .foregroundColor(AppColors.textTertiary)
                                    }
                                    .padding()
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(12)
                                }
                                
                                if selectedPlant.isEmpty {
                                    TextField("Enter plant name", text: $plantName)
                                        .font(AppFonts.body(.regular))
                                        .foregroundColor(AppColors.textPrimary)
                                        .padding()
                                        .background(AppColors.cardBackground)
                                        .cornerRadius(12)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Repot Date")
                                .font(AppFonts.headline(.semiBold))
                                .foregroundColor(AppColors.textPrimary)
                            
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .font(AppFonts.body(.regular))
                                .foregroundColor(AppColors.textPrimary)
                                .padding()
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Button(action: saveRecord) {
                            Text("Add Repotting")
                                .font(AppFonts.headline(.semiBold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(AppColors.primaryBlue)
                                .cornerRadius(25)
                        }
                        .disabled(plantName.trimmed.isEmpty)
                        .opacity(plantName.trimmed.isEmpty ? 0.6 : 1.0)
                        
                        Button("Full Form") {
                            showingQuickAdd = false
                            showingAddView = true
                        }
                        .font(AppFonts.subheadline(.medium))
                        .foregroundColor(AppColors.primaryBlue)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Quick Add")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
            }
        }
    }
    
    private func saveRecord() {
        let finalPlantName = selectedPlant.isEmpty ? plantName : selectedPlant
        
        guard !finalPlantName.trimmed.isEmpty else { return }
        
        let record = RepotRecord(
            plantName: finalPlantName,
            repotDate: selectedDate
        )
        
        journalViewModel.addRecord(record)
        showingQuickAdd = false
        DispatchQueue.main.async {
            dismiss()
        }
    }
}

