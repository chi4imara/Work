import SwiftUI

struct EditFragranceView: View {
    let fragrance: Fragrance
    @ObservedObject var viewModel: FragranceViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var brand: String
    @State private var type: FragranceType
    @State private var season: Season
    @State private var mainNotes: String
    @State private var atmosphere: String
    @State private var comment: String
    
    init(fragrance: Fragrance, viewModel: FragranceViewModel) {
        self.fragrance = fragrance
        self.viewModel = viewModel
        
        _name = State(initialValue: fragrance.name)
        _brand = State(initialValue: fragrance.brand)
        _type = State(initialValue: fragrance.type)
        _season = State(initialValue: fragrance.season)
        _mainNotes = State(initialValue: fragrance.mainNotes)
        _atmosphere = State(initialValue: fragrance.atmosphere)
        _comment = State(initialValue: fragrance.comment)
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var hasChanges: Bool {
        name != fragrance.name ||
        brand != fragrance.brand ||
        type != fragrance.type ||
        season != fragrance.season ||
        mainNotes != fragrance.mainNotes ||
        atmosphere != fragrance.atmosphere ||
        comment != fragrance.comment
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        formFields
                    }
                    .padding(20)
                    .padding(.bottom, 50)
                }
            }
            .navigationTitle("Edit Fragrance")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveChanges()
                }
                .disabled(!isFormValid || !hasChanges)
                .foregroundColor((isFormValid && hasChanges) ? AppColors.accentYellow : AppColors.tertiaryText)
            )
            .preferredColorScheme(.dark)
        }
    }
    
    private var formFields: some View {
        VStack(spacing: 16) {
            FormField(
                title: "Fragrance Name *",
                text: $name,
                placeholder: "e.g., Replica Lazy Sunday Morning"
            )
            
            FormField(
                title: "Brand",
                text: $brand,
                placeholder: "e.g., Maison Margiela"
            )
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Type")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Picker("Type", selection: $type) {
                    ForEach(FragranceType.allCases, id: \.self) { type in
                        Text(type.displayName)
                            .tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Season")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    ForEach(Season.allCases, id: \.self) { seasonOption in
                        Button(action: { season = seasonOption }) {
                            HStack {
                                Image(systemName: seasonOption.icon)
                                Text(seasonOption.displayName)
                                    .font(.ubuntu(14, weight: .medium))
                            }
                            .foregroundColor(season == seasonOption ? AppColors.buttonText : AppColors.primaryText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(season == seasonOption ? AppColors.accentYellow : AppColors.cardBackground)
                            .cornerRadius(8)
                        }
                    }
                }
            }
            
            FormField(
                title: "Main Notes",
                text: $mainNotes,
                placeholder: "e.g., bergamot, sandalwood, powdery rose",
                isMultiline: true
            )
            
            FormField(
                title: "Atmosphere",
                text: $atmosphere,
                placeholder: "e.g., calm, cozy, with vanilla notes"
            )
            
            FormField(
                title: "Comment",
                text: $comment,
                placeholder: "e.g., Perfect for office or walks",
                isMultiline: true
            )
        }
    }
    
    private func saveChanges() {
        var updatedFragrance = fragrance
        updatedFragrance.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedFragrance.brand = brand.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedFragrance.type = type
        updatedFragrance.season = season
        updatedFragrance.mainNotes = mainNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedFragrance.atmosphere = atmosphere.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedFragrance.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateFragrance(updatedFragrance)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditFragranceView(
        fragrance: Fragrance(
            name: "Replica Lazy Sunday Morning",
            brand: "Maison Margiela",
            type: .daytime,
            season: .spring,
            mainNotes: "iris, white musk, pear",
            atmosphere: "fresh, clean, relaxing",
            comment: "Smells like morning laundry and sunlight."
        ),
        viewModel: FragranceViewModel()
    )
}
