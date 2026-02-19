import SwiftUI

struct EditDrinkView: View {
    let drink: Drink
    @ObservedObject var viewModel: DrinkViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var selectedType: DrinkType = .whiskey
    @State private var strength: String = ""
    @State private var country: String = ""
    @State private var notes: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(.playfair(16, weight: .semibold))
                                .foregroundColor(ColorTheme.textPrimary)
                            
                            TextField("Enter drink name", text: $name)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Type")
                                .font(.playfair(16, weight: .semibold))
                                .foregroundColor(ColorTheme.textPrimary)
                            
                            Picker("Type", selection: $selectedType) {
                                ForEach(DrinkType.allCases, id: \.self) { type in
                                    Text(type.displayName)
                                        .tag(type)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(ColorTheme.cardBackground)
                            .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Strength (%)")
                                .font(.playfair(16, weight: .semibold))
                                .foregroundColor(ColorTheme.textPrimary)
                            
                            TextField("Enter alcohol percentage", text: $strength)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Country of Origin")
                                .font(.playfair(16, weight: .semibold))
                                .foregroundColor(ColorTheme.textPrimary)
                            
                            TextField("Enter country", text: $country)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description / Notes")
                                .font(.playfair(16, weight: .semibold))
                                .foregroundColor(ColorTheme.textPrimary)
                            
                            TextField("Add your tasting notes", text: $notes, axis: .vertical)
                                .lineLimit(4...8)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        Button(action: saveChanges) {
                            Text("Save Changes")
                                .font(.playfair(18, weight: .semibold))
                                .foregroundColor(ColorTheme.buttonText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    isFormValid ? ColorTheme.buttonBackground : ColorTheme.textTertiary
                                )
                                .cornerRadius(12)
                        }
                        .disabled(!isFormValid)
                        .padding(.top, 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.primaryYellow)
                }
            }
        }
        .onAppear {
            loadDrinkData()
        }
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !country.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        Double(strength) != nil &&
        (Double(strength) ?? 0) >= 0 &&
        (Double(strength) ?? 0) <= 100
    }
    
    private func loadDrinkData() {
        name = drink.name
        selectedType = drink.type
        strength = String(drink.strength)
        country = drink.country
        notes = drink.notes
    }
    
    private func saveChanges() {
        guard isFormValid,
              let strengthValue = Double(strength) else { return }
        
        var updatedDrink = drink
        updatedDrink.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedDrink.type = selectedType
        updatedDrink.strength = strengthValue
        updatedDrink.country = country.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedDrink.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateDrink(updatedDrink)
        dismiss()
    }
}

#Preview {
    EditDrinkView(drink: Drink.sampleDrinks[0], viewModel: DrinkViewModel())
}
