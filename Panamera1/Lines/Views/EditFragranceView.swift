import SwiftUI

struct EditFragranceView: View {
    @EnvironmentObject var viewModel: FragranceViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let originalFragrance: Fragrance
    let onUpdate: (Fragrance) -> Void
    
    @State private var name: String
    @State private var brand: String
    @State private var selectedSeason: Season
    @State private var selectedStyle: String
    @State private var customStyle: String = ""
    @State private var showingCustomStyleInput = false
    @State private var rating: Int
    @State private var description: String
    @State private var isFavorite: Bool
    
    init(fragrance: Fragrance, onUpdate: @escaping (Fragrance) -> Void) {
        self.originalFragrance = fragrance
        self.onUpdate = onUpdate
        
        self._name = State(initialValue: fragrance.name)
        self._brand = State(initialValue: fragrance.brand)
        self._selectedSeason = State(initialValue: fragrance.season)
        self._selectedStyle = State(initialValue: fragrance.style)
        self._rating = State(initialValue: fragrance.rating)
        self._description = State(initialValue: fragrance.description)
        self._isFavorite = State(initialValue: fragrance.isFavorite)
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        FormFieldView(title: "Fragrance Name*", text: $name, placeholder: "Enter fragrance name")
                        
                        FormFieldView(title: "Brand", text: $brand, placeholder: "Enter brand name")
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Season")
                                .font(.bellGothicBold(size: 16))
                                .foregroundColor(AppColors.textPrimary)
                            
                            Menu {
                                ForEach(Season.allCases.filter { $0 != .allSeasons }) { season in
                                    Button(action: {
                                        selectedSeason = season
                                    }) {
                                        HStack {
                                            Text(season.displayName)
                                            if selectedSeason == season {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedSeason.displayName)
                                        .font(.bellGothicRegular(size: 16))
                                        .foregroundColor(AppColors.textPrimary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(AppColors.primaryYellow)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.buttonSecondary)
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Style")
                                .font(.bellGothicBold(size: 16))
                                .foregroundColor(AppColors.textPrimary)
                            
                            Menu {
                                ForEach(viewModel.allStyles, id: \.self) { style in
                                    Button(action: {
                                        selectedStyle = style
                                        showingCustomStyleInput = false
                                        customStyle = ""
                                    }) {
                                        HStack {
                                            Text(style)
                                            if selectedStyle == style {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                                
                                Divider()
                                
                                Button("Create Custom Style") {
                                    showingCustomStyleInput = true
                                    customStyle = ""
                                }
                            } label: {
                                HStack {
                                    Text(showingCustomStyleInput ? "Custom Style" : selectedStyle)
                                        .font(.bellGothicRegular(size: 16))
                                        .foregroundColor(AppColors.textPrimary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(AppColors.primaryYellow)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.buttonSecondary)
                                )
                            }
                            
                            if showingCustomStyleInput {
                                TextField("Enter custom style", text: $customStyle)
                                    .font(.bellGothicRegular(size: 16))
                                    .foregroundColor(AppColors.textPrimary)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.buttonSecondary)
                                    )
                                    .onChange(of: customStyle) { newValue in
                                        if !newValue.isEmpty {
                                            selectedStyle = newValue
                                        }
                                    }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Rating")
                                .font(.bellGothicBold(size: 16))
                                .foregroundColor(AppColors.textPrimary)
                            
                            HStack(spacing: 8) {
                                ForEach(1...5, id: \.self) { star in
                                    Button(action: {
                                        rating = star
                                    }) {
                                        Image(systemName: star <= rating ? "star.fill" : "star")
                                            .foregroundColor(star <= rating ? AppColors.primaryYellow : AppColors.textSecondary)
                                            .font(.title2)
                                    }
                                }
                                Spacer()
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.bellGothicBold(size: 16))
                                .foregroundColor(AppColors.textPrimary)
                            
                            TextEditor(text: $description)
                                .font(.bellGothicRegular(size: 16))
                                .foregroundColor(AppColors.textPrimary)
                                .scrollContentBackground(.hidden)
                                .frame(minHeight: 100)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.buttonSecondary)
                                )
                        }
                        
                        HStack {
                            Text("Add to Favorites")
                                .font(.bellGothicBold(size: 16))
                                .foregroundColor(AppColors.textPrimary)
                            
                            Spacer()
                            
                            Toggle("", isOn: $isFavorite)
                                .tint(AppColors.primaryYellow)
                        }
                        
                        Button(action: saveChanges) {
                            Text("Save Changes")
                                .font(.bellGothicBold(size: 18))
                                .foregroundColor(isFormValid ? AppColors.textPrimary : AppColors.textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(isFormValid ? AppColors.primaryYellow : AppColors.buttonSecondary)
                                )
                        }
                        .disabled(!isFormValid)
                        .padding(.top, 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit Fragrance")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
            }
            .preferredColorScheme(.dark)
        }
        .onAppear {
            let predefinedStyles = Style.allCases.compactMap { style in
                style == .custom ? nil : style.displayName
            }
            
            if !predefinedStyles.contains(selectedStyle) && !viewModel.customStyles.contains(selectedStyle) {
                showingCustomStyleInput = true
                customStyle = selectedStyle
            }
        }
    }
    
    private func saveChanges() {
        let finalStyle = showingCustomStyleInput && !customStyle.isEmpty ? customStyle : selectedStyle
        
        if showingCustomStyleInput && !customStyle.isEmpty {
            viewModel.addCustomStyle(customStyle)
        }
        
        var updatedFragrance = originalFragrance
        updatedFragrance.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedFragrance.brand = brand.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedFragrance.season = selectedSeason
        updatedFragrance.style = finalStyle
        updatedFragrance.rating = rating
        updatedFragrance.description = description.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedFragrance.isFavorite = isFavorite
        
        viewModel.updateFragrance(updatedFragrance)
        onUpdate(updatedFragrance)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditFragranceView(fragrance: Fragrance(
        name: "Sample Fragrance",
        brand: "Sample Brand",
        season: .summer,
        style: "Evening",
        rating: 4,
        description: "A beautiful summer fragrance."
    )) { _ in }
    .environmentObject(FragranceViewModel())
}
