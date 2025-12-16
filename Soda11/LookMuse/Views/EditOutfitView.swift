import SwiftUI

struct EditOutfitView: View {
    let outfitID: UUID
    @ObservedObject var viewModel: OutfitViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDate: Date
    @State private var description: String
    @State private var location: String
    @State private var weather: String
    @State private var comment: String
    @State private var showingDatePicker = false
    
    private var outfit: OutfitModel? {
        viewModel.outfits.first { $0.id == outfitID }
    }
    
    init(outfitID: UUID, viewModel: OutfitViewModel) {
        self.outfitID = outfitID
        self.viewModel = viewModel
        
        let initialOutfit = viewModel.outfits.first { $0.id == outfitID }
        _selectedDate = State(initialValue: initialOutfit?.date ?? Date())
        _description = State(initialValue: initialOutfit?.description ?? "")
        _location = State(initialValue: initialOutfit?.location ?? "")
        _weather = State(initialValue: initialOutfit?.weather ?? "")
        _comment = State(initialValue: initialOutfit?.comment ?? "")
    }
    
    private var isFormValid: Bool {
        !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var hasChanges: Bool {
        guard let outfit = outfit else { return false }
        return selectedDate != outfit.date ||
        description != outfit.description ||
        location != outfit.location ||
        weather != outfit.weather ||
        comment != outfit.comment
    }
    
    var body: some View {
        Group {
            if let outfit = outfit {
                ZStack {
                    Color.theme.backgroundGradient
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            headerView
                            
                            VStack(spacing: 20) {
                                dateField
                                
                                CustomTextField(
                                    title: "Outfit Description",
                                    text: $description,
                                    placeholder: "e.g., Denim jacket, white t-shirt, sneakers"
                                )
                                
                                CustomTextField(
                                    title: "Location",
                                    text: $location,
                                    placeholder: "e.g., Park walk, Office, Beach"
                                )
                                
                                CustomTextField(
                                    title: "Weather",
                                    text: $weather,
                                    placeholder: "e.g., +16°C, sunny"
                                )
                                
                                CustomTextEditor(
                                    title: "Comment (Optional)",
                                    text: $comment,
                                    placeholder: "How did you feel? Any notes about the outfit?"
                                )
                            }
                            
                            saveButton
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .sheet(isPresented: $showingDatePicker) {
                    DatePickerSheet(selectedDate: $selectedDate)
                }
            } else {
                ZStack {
                    Color.theme.backgroundGradient
                        .ignoresSafeArea()
                    
                    VStack {
                        Text("Outfit not found")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                        
                        Button("Close") {
                            dismiss()
                        }
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(Color.theme.buttonText)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.theme.buttonBackground)
                        )
                        .padding(.top, 20)
                    }
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button("Cancel") {
                dismiss()
            }
            .font(.ubuntu(16, weight: .regular))
            .foregroundColor(Color.theme.primaryText)
            
            Spacer()
            
            Text("Edit Outfit")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Spacer()
            
            Button("Save") {
                saveChanges()
            }
            .font(.ubuntu(16, weight: .medium))
            .foregroundColor((isFormValid && hasChanges) ? Color.theme.primaryYellow : Color.theme.secondaryText)
            .disabled(!isFormValid || !hasChanges)
        }
        .padding(.top, 20)
        .padding(.bottom, 20)
    }
    
    private var dateField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Date")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(Color.theme.primaryText)
            
            Button(action: {
                showingDatePicker = true
            }) {
                HStack {
                    Text(formatDate(selectedDate))
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(Color.theme.darkText)
                    
                    Spacer()
                    
                    Image(systemName: "calendar")
                        .font(.system(size: 16))
                        .foregroundColor(Color.theme.accentText)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.theme.cardBackground)
                        .shadow(color: Color.theme.lightShadowColor, radius: 4, x: 0, y: 2)
                )
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: saveChanges) {
            Text("Save Changes")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(Color.theme.buttonText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill((isFormValid && hasChanges) ? Color.theme.buttonBackground : Color.gray.opacity(0.5))
                        .shadow(color: Color.theme.shadowColor, radius: (isFormValid && hasChanges) ? 8 : 0, x: 0, y: 4)
                )
        }
        .disabled(!isFormValid || !hasChanges)
        .padding(.top, 20)
    }
    
    private func saveChanges() {
        guard var updatedOutfit = outfit else { return }
        updatedOutfit.date = selectedDate
        updatedOutfit.description = description.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedOutfit.location = location.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedOutfit.weather = weather.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedOutfit.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateOutfit(updatedOutfit)
        dismiss()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }
}

#Preview {
    let viewModel = OutfitViewModel()
    let sampleOutfit = OutfitModel(
        date: Date(),
        description: "Denim jacket, white t-shirt, sneakers",
        location: "Park walk",
        weather: "+16°C, sunny",
        comment: "Comfortable, but sneakers were a bit tight."
    )
    viewModel.addOutfit(sampleOutfit)
    
    return EditOutfitView(outfitID: sampleOutfit.id, viewModel: viewModel)
}
