import SwiftUI

struct EditFragranceView: View {
    let fragrance: Fragrance
    @ObservedObject var viewModel: FragranceViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var notes: String
    @State private var selectedSeason: Season?
    @State private var occasions: String
    @State private var personalNotes: String
    @State private var showingSeasonsSheet = false
    
    init(fragrance: Fragrance, viewModel: FragranceViewModel) {
        self.fragrance = fragrance
        self.viewModel = viewModel
        
        _name = State(initialValue: fragrance.name)
        _notes = State(initialValue: fragrance.notes)
        _selectedSeason = State(initialValue: fragrance.season)
        _occasions = State(initialValue: fragrance.occasions)
        _personalNotes = State(initialValue: fragrance.personalNotes)
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        FormFieldView(
                            title: "Fragrance Name",
                            text: $name,
                            placeholder: "Enter fragrance name",
                            isRequired: true
                        )
                        
                        FormFieldView(
                            title: "Notes",
                            text: $notes,
                            placeholder: "vanilla, bergamot, musk...",
                            isMultiline: true
                        )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Season")
                                .font(.bauhausMedium(16))
                                .foregroundColor(.appPrimaryBlue)
                            
                            Button(action: {
                                showingSeasonsSheet = true
                            }) {
                                HStack {
                                    Text(selectedSeason?.displayName ?? "Select season")
                                        .font(.bauhausLight(16))
                                        .foregroundColor(selectedSeason != nil ? .appPrimaryBlue : .appTextGray)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.appTextGray)
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                        .shadow(color: Color.appPrimaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        FormFieldView(
                            title: "Occasions",
                            text: $occasions,
                            placeholder: "office, evening, date...",
                            isMultiline: true
                        )
                        
                        FormFieldView(
                            title: "Personal Notes",
                            text: $personalNotes,
                            placeholder: "Your thoughts about this fragrance...",
                            isMultiline: true,
                            isOptional: true
                        )
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit Fragrance")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.bauhausLight(16))
                    .foregroundColor(.appTextGray)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                    .font(.bauhausMedium(16))
                    .foregroundColor(isFormValid ? .appPrimaryYellow : .appTextGray)
                    .disabled(!isFormValid)
                }
            }
        }
        .actionSheet(isPresented: $showingSeasonsSheet) {
            ActionSheet(
                title: Text("Select Season"),
                buttons: [.default(Text("None")) { selectedSeason = nil }] +
                Season.allCases.map { season in
                    .default(Text(season.displayName)) {
                        selectedSeason = season
                    }
                } + [.cancel()]
            )
        }
    }
    
    private func saveChanges() {
        var updatedFragrance = fragrance
        updatedFragrance.name = name.trimmingCharacters(in: .whitespaces)
        updatedFragrance.notes = notes.trimmingCharacters(in: .whitespaces)
        updatedFragrance.season = selectedSeason
        updatedFragrance.occasions = occasions.trimmingCharacters(in: .whitespaces)
        updatedFragrance.personalNotes = personalNotes.trimmingCharacters(in: .whitespaces)
        
        viewModel.updateFragrance(updatedFragrance)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditFragranceView(
        fragrance: Fragrance.sampleData[0],
        viewModel: FragranceViewModel()
    )
}
