import SwiftUI

struct EditScentView: View {
    let scent: Scent
    @ObservedObject var viewModel: ScentViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var brand: String
    @State private var description: String
    @State private var selectedSeason: Season
    @State private var comment: String
    
    init(scent: Scent, viewModel: ScentViewModel) {
        self.scent = scent
        self.viewModel = viewModel
        
        _name = State(initialValue: scent.name)
        _brand = State(initialValue: scent.brand)
        _description = State(initialValue: scent.description)
        _selectedSeason = State(initialValue: scent.season)
        _comment = State(initialValue: scent.comment)
    }
    
    private var isValidForm: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var hasChanges: Bool {
        name != scent.name ||
        brand != scent.brand ||
        description != scent.description ||
        selectedSeason != scent.season ||
        comment != scent.comment
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerView
                        
                        formFields
                        
                        actionButtons
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.white.opacity(0.7))
                }
                
                Spacer()
                
                Text("Edit Scent")
                    .font(.playfairDisplay(.bold, size: 24))
                    .foregroundColor(AppColors.white)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.clear)
                }
                .disabled(true)
            }
            
            Text("Update your scent information")
                .font(.playfairDisplay(.regular, size: 14))
                .foregroundColor(AppColors.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
    }
    
    private var formFields: some View {
        VStack(spacing: 20) {
            FormField(
                title: "Scent Name *",
                placeholder: "e.g., Citrus Breeze",
                text: $name,
                isRequired: true
            )
            
            FormField(
                title: "Brand",
                placeholder: "e.g., Bath & Body Works",
                text: $brand
            )
            
            FormField(
                title: "Description",
                placeholder: "Fresh citrus with a light mint note",
                text: $description,
                isMultiline: true
            )
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Season")
                    .font(.playfairDisplay(.semiBold, size: 16))
                    .foregroundColor(AppColors.white)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    ForEach(Season.allCases, id: \.self) { season in
                        SeasonButton(
                            season: season,
                            isSelected: selectedSeason == season
                        ) {
                            selectedSeason = season
                        }
                    }
                }
            }
            
            FormField(
                title: "Comment",
                placeholder: "Perfect for summer mornings...",
                text: $comment,
                isMultiline: true
            )
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            Button(action: saveChanges) {
                HStack {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Save Changes")
                        .font(.playfairDisplay(.semiBold, size: 18))
                }
                .foregroundColor(AppColors.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    (isValidForm && hasChanges) ? 
                    AnyShapeStyle(AppColors.buttonGradient) :
                        AnyShapeStyle(AppColors.mediumGray.opacity(0.3))
                )
                .cornerRadius(28)
                .shadow(
                    color: (isValidForm && hasChanges) ? AppColors.yellow.opacity(0.3) : .clear,
                    radius: 10, x: 0, y: 5
                )
            }
            .disabled(!isValidForm || !hasChanges)
            
            Button(action: {
                dismiss()
            }) {
                Text("Cancel")
                    .font(.playfairDisplay(.medium, size: 16))
                    .foregroundColor(AppColors.white.opacity(0.7))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(AppColors.cardGradient)
                    .cornerRadius(24)
            }
        }
        .padding(.bottom, 40)
    }
    
    private func saveChanges() {
        var updatedScent = scent
        updatedScent.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedScent.brand = brand.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedScent.description = description.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedScent.season = selectedSeason
        updatedScent.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateScent(updatedScent)
        dismiss()
    }
}

#Preview {
    EditScentView(
        scent: Scent(
            name: "Vanilla Dream",
            brand: "Yankee Candle",
            description: "Warm vanilla with sugar notes",
            season: .winter,
            comment: "Perfect for cozy evenings"
        ),
        viewModel: ScentViewModel()
    )
}
