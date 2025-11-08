import SwiftUI

struct QuickAddPlantView: View {
    @ObservedObject var appViewModel: AppViewModel
    let plant: Plant?
    @Binding var showingSidebar: Bool
    let onComplete: () -> Void
    
    @State private var name: String = ""
    @State private var intervalDays: String = "14"
    @State private var lastFertilizedDate: Date = Date()
    @State private var selectedFertilizerType: FertilizerType = .universal
    @State private var comment: String = ""
    
    @State private var showingError = false
    @State private var errorMessage = ""
    
    @Environment(\.dismiss) private var dismiss
    
    private var isEditing: Bool {
        plant != nil
    }
    
    var body: some View {
        ZStack {
            AppTheme.backgroundGradient
                .ignoresSafeArea()
            
            GridBackgroundView()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                UniversalHeaderView(
                    title: "Quick Add Plant",
                    onMenuTap: { showingSidebar = true },
                    rightButton: AnyView(
                        Button("Save") {
                            withAnimation {
                                savePlant()
                            }
                        }
                            .foregroundColor(AppTheme.primaryYellow)
                            .fontWeight(.semibold)
                    )
                )
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 20) {
                            FormFieldView(
                                title: "Plant Name",
                                isRequired: true
                            ) {
                                TextField("Enter plant name", text: $name)
                                    .textFieldStyle(CustomTextFieldStyle())
                            }
                            
                            FormFieldView(
                                title: "Fertilization Interval (days)",
                                isRequired: true
                            ) {
                                TextField("Enter number of days", text: $intervalDays)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .keyboardType(.numberPad)
                            }
                            
                            FormFieldView(
                                title: "Last Fertilized Date",
                                isRequired: true
                            ) {
                                DatePicker(
                                    "Select date",
                                    selection: $lastFertilizedDate,
                                    in: ...Date(),
                                    displayedComponents: .date
                                )
                                .datePickerStyle(CompactDatePickerStyle())
                                .accentColor(AppTheme.primaryYellow)
                                .colorInvert()
                            }
                            
                            FormFieldView(
                                title: "Fertilizer Type",
                                isRequired: false
                            ) {
                                Picker("Select fertilizer type", selection: $selectedFertilizerType) {
                                    ForEach(FertilizerType.allCases, id: \.self) { type in
                                        Text(type.displayName)
                                            .tag(type)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .accentColor(AppTheme.primaryYellow)
                            }
                            
                            FormFieldView(
                                title: "Comment",
                                isRequired: false
                            ) {
                                TextField("Optional notes about this plant", text: $comment, axis: .vertical)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .lineLimit(3...6)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        .onAppear {
            if let plant = plant {
                loadPlantData(plant)
            }
        }
    }
    
    private func loadPlantData(_ plant: Plant) {
        name = plant.name
        intervalDays = String(plant.intervalDays)
        lastFertilizedDate = plant.lastFertilizedDate
        selectedFertilizerType = plant.fertilizerType
        comment = plant.comment
    }
    
    private func savePlant() {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showError("Please enter a plant name")
            return
        }
        
        guard let interval = Int(intervalDays), interval > 0 else {
            showError("Interval must be a number greater than zero")
            return
        }
        
        guard interval <= 365 else {
            showError("Interval cannot be more than 365 days")
            return
        }
        
        guard lastFertilizedDate <= Date() else {
            showError("Last fertilized date cannot be in the future")
            return
        }
        
        if let existingPlant = plant {
            var updatedPlant = existingPlant
            updatedPlant.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedPlant.intervalDays = interval
            updatedPlant.lastFertilizedDate = lastFertilizedDate
            updatedPlant.fertilizerType = selectedFertilizerType
            updatedPlant.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
            
            appViewModel.updatePlant(updatedPlant)
        } else {
            let newPlant = Plant(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                intervalDays: interval,
                lastFertilizedDate: lastFertilizedDate,
                fertilizerType: selectedFertilizerType,
                comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            
            appViewModel.addPlant(newPlant)
        }
        
        onComplete()
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showingError = true
    }
}
