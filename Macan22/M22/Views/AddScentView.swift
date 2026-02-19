import SwiftUI

struct AddScentView: View {
    @ObservedObject var viewModel: ScentViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var brand = ""
    @State private var description = ""
    @State private var selectedSeason = Season.winter
    @State private var comment = ""
    
    private var isValidForm: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
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
                
                Text("New Scent")
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
            
            Text("Add a new candle scent to your collection")
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
            Button(action: saveScent) {
                HStack {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Save Scent")
                        .font(.playfairDisplay(.semiBold, size: 18))
                }
                .foregroundColor(AppColors.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    isValidForm ? 
                    AnyShapeStyle(AppColors.buttonGradient) :
                        AnyShapeStyle(AppColors.mediumGray.opacity(0.3))
                )
                .cornerRadius(28)
                .shadow(
                    color: isValidForm ? AppColors.yellow.opacity(0.3) : .clear,
                    radius: 10, x: 0, y: 5
                )
            }
            .disabled(!isValidForm)
            
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
    
    private func saveScent() {
        let newScent = Scent(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            brand: brand.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            season: selectedSeason,
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addScent(newScent)
        dismiss()
    }
}

struct FormField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isRequired: Bool = false
    var isMultiline: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(.semiBold, size: 16))
                .foregroundColor(AppColors.white)
            
            if isMultiline {
                TextEditor(text: $text)
                    .font(.playfairDisplay(.regular, size: 16))
                    .foregroundColor(AppColors.white)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 80)
                    .padding(12)
                    .background(AppColors.cardGradient)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isRequired && text.isEmpty ? 
                                AppColors.yellow.opacity(0.5) : 
                                AppColors.white.opacity(0.2),
                                lineWidth: 1
                            )
                    )
            } else {
                TextField(placeholder, text: $text)
                    .font(.playfairDisplay(.regular, size: 16))
                    .foregroundColor(AppColors.white)
                    .padding(16)
                    .background(AppColors.cardGradient)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isRequired && text.isEmpty ? 
                                AppColors.yellow.opacity(0.5) : 
                                AppColors.white.opacity(0.2),
                                lineWidth: 1
                            )
                    )
            }
        }
    }
}

struct SeasonButton: View {
    let season: Season
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: season.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.white : AppColors.white.opacity(0.7))
                
                Text(season.displayName)
                    .font(.playfairDisplay(.medium, size: 14))
                    .foregroundColor(isSelected ? AppColors.white : AppColors.white.opacity(0.7))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(
                isSelected ? 
                AppColors.yellowGradient : 
                AppColors.cardGradient
            )
            .cornerRadius(22)
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(
                        isSelected ? 
                        AppColors.yellow.opacity(0.3) : 
                        AppColors.white.opacity(0.2),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AddScentView(viewModel: ScentViewModel())
}
