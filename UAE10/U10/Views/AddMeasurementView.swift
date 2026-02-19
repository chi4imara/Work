import SwiftUI

struct AddMeasurementView: View {
    @EnvironmentObject var measurementStore: MeasurementStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedDate = Date()
    @State private var weight: String = ""
    @State private var chest: String = ""
    @State private var arms: String = ""
    @State private var shoulders: String = ""
    @State private var notes: String = ""
    
    var isEditing: Bool = false
    var measurementToEdit: Measurement?
    
    init(measurementToEdit: Measurement? = nil) {
        self.measurementToEdit = measurementToEdit
        self.isEditing = measurementToEdit != nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Date")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.white)
                            
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .accentColor(AppColors.lightBlue)
                                .colorScheme(.dark)
                        }
                        
                        VStack(spacing: 20) {
                            MeasurementInputField(
                                title: "Weight",
                                value: $weight,
                                unit: "kg",
                                placeholder: "0.0"
                            )
                            
                            MeasurementInputField(
                                title: "Chest",
                                value: $chest,
                                unit: "cm",
                                placeholder: "0.0"
                            )
                            
                            MeasurementInputField(
                                title: "Arms",
                                value: $arms,
                                unit: "cm",
                                placeholder: "0.0"
                            )
                            
                            MeasurementInputField(
                                title: "Shoulders",
                                value: $shoulders,
                                unit: "cm",
                                placeholder: "0.0"
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Notes (Optional)")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.white)
                            
                            TextField("Add any notes about this measurement...", text: $notes, axis: .vertical)
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.white)
                                .padding(16)
                                .background(AppColors.cardGradient)
                                .cornerRadius(15)
                                .lineLimit(3...6)
                        }
                        
                        Button(action: saveMeasurement) {
                            HStack {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Save Measurement")
                                    .font(.ubuntu(18, weight: .medium))
                            }
                            .foregroundColor(AppColors.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppColors.buttonGradient)
                            .cornerRadius(25)
                        }
                        .disabled(!isFormValid)
                        .opacity(isFormValid ? 1.0 : 0.6)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
            .navigationTitle(isEditing ? "Edit Measurement" : "New Measurement")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.lightBlue)
                }
            }
        }
        .onAppear {
            if let measurement = measurementToEdit {
                loadMeasurementData(measurement)
            }
        }
    }
    
    private var isFormValid: Bool {
        !weight.isEmpty || !chest.isEmpty || !arms.isEmpty || !shoulders.isEmpty
    }
    
    private func loadMeasurementData(_ measurement: Measurement) {
        selectedDate = measurement.date
        weight = measurement.weight > 0 ? String(format: "%.1f", measurement.weight) : ""
        chest = measurement.chest > 0 ? String(format: "%.1f", measurement.chest) : ""
        arms = measurement.arms > 0 ? String(format: "%.1f", measurement.arms) : ""
        shoulders = measurement.shoulders > 0 ? String(format: "%.1f", measurement.shoulders) : ""
        notes = measurement.notes
    }
    
    private func saveMeasurement() {
        let measurement = Measurement(
            date: selectedDate,
            weight: Double(weight) ?? 0,
            chest: Double(chest) ?? 0,
            arms: Double(arms) ?? 0,
            shoulders: Double(shoulders) ?? 0,
            notes: notes
        )
        
        if isEditing, var editingMeasurement = measurementToEdit {
            editingMeasurement.date = selectedDate
            editingMeasurement.weight = Double(weight) ?? 0
            editingMeasurement.chest = Double(chest) ?? 0
            editingMeasurement.arms = Double(arms) ?? 0
            editingMeasurement.shoulders = Double(shoulders) ?? 0
            editingMeasurement.notes = notes
            
            measurementStore.updateMeasurement(editingMeasurement)
        } else {
            measurementStore.addMeasurement(measurement)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct MeasurementInputField: View {
    let title: String
    @Binding var value: String
    let unit: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.white)
            
            HStack {
                TextField(placeholder, text: $value)
                    .font(.ubuntu(18))
                    .foregroundColor(AppColors.white)
                    .keyboardType(.decimalPad)
                    .padding(.leading, 16)
                
                Text(unit)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.lightBlue)
                    .padding(.trailing, 16)
            }
            .frame(height: 50)
            .background(AppColors.cardGradient)
            .cornerRadius(15)
        }
    }
}

#Preview {
    AddMeasurementView()
        .environmentObject(MeasurementStore())
}
