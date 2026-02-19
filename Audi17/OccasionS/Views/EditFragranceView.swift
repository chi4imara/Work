import SwiftUI

struct EditFragranceView: View {
    let fragrance: Fragrance
    @ObservedObject var fragranceViewModel: FragranceViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var notesText: String
    @State private var selectedSeason: Season
    @State private var selectedFormat: FragranceFormat
    @State private var description: String
    
    init(fragrance: Fragrance, fragranceViewModel: FragranceViewModel) {
        self.fragrance = fragrance
        self.fragranceViewModel = fragranceViewModel
        
        _name = State(initialValue: fragrance.name)
        _notesText = State(initialValue: fragrance.notes.joined(separator: ", "))
        _selectedSeason = State(initialValue: fragrance.season)
        _selectedFormat = State(initialValue: fragrance.format)
        _description = State(initialValue: fragrance.description)
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !notesText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        FormField(title: "Fragrance Name") {
                            CustomTextField(
                                placeholder: "Enter fragrance name",
                                text: $name
                            )
                        }
                        
                        FormField(title: "Notes") {
                            CustomTextField(
                                placeholder: "Enter notes separated by commas",
                                text: $notesText
                            )
                        }
                        
                        FormField(title: "Season") {
                            SeasonPicker(selectedSeason: $selectedSeason)
                        }
                        
                        FormField(title: "Format") {
                            FormatPicker(selectedFormat: $selectedFormat)
                        }
                        
                        FormField(title: "Notes (Optional)") {
                            CustomTextEditor(
                                placeholder: "Add your personal notes...",
                                text: $description
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Edit Fragrance")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(AppColors.primaryWhite),
                
                trailing: Button("Save") {
                    saveFragrance()
                }
                .foregroundColor(isFormValid ? AppColors.primaryWhite : AppColors.buttonDisabled)
                .disabled(!isFormValid)
            )
            .preferredColorScheme(.dark)
        }
    }
    
    private func saveFragrance() {
        let notes = notesText.components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        var updatedFragrance = fragrance
        updatedFragrance.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedFragrance.notes = notes
        updatedFragrance.season = selectedSeason
        updatedFragrance.format = selectedFormat
        updatedFragrance.description = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        fragranceViewModel.updateFragrance(updatedFragrance)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditFragranceView(
        fragrance: Fragrance(
            name: "Sample Fragrance",
            notes: ["Rose", "Vanilla"],
            season: .spring,
            format: .day,
            description: "Sample description"
        ),
        fragranceViewModel: FragranceViewModel()
    )
}
