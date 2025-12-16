import SwiftUI

struct AddStorageLocationView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject private var viewModel = StorageLocationViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("New Storage Place")
                                .font(.ubuntu(28, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("Create a place to organize your beauty products")
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(AppColors.secondaryText)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            FormFieldView(
                                title: "Name",
                                text: $viewModel.name,
                                placeholder: "e.g., Dresser - Top Drawer"
                            )
                            
                            FormFieldView(
                                title: "Description",
                                text: $viewModel.description,
                                placeholder: "e.g., Lipsticks and highlighters",
                                isOptional: true
                            )
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Icon")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(AppColors.primaryText)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 16) {
                                    ForEach(StorageIcon.allCases, id: \.self) { icon in
                                        IconSelectionButton(
                                            icon: icon,
                                            isSelected: viewModel.selectedIcon == icon.rawValue,
                                            action: {
                                                viewModel.selectedIcon = icon.rawValue
                                            }
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
                
                VStack {
                    Spacer()
                    
                    Button(action: saveLocation) {
                        Text("Save")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.buttonText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(viewModel.isValid ? AppColors.buttonBackground : AppColors.buttonBackground.opacity(0.5))
                            .cornerRadius(16)
                    }
                    .disabled(!viewModel.isValid)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                }
            }
        }
    }
    
    private func saveLocation() {
        let location = viewModel.createStorageLocation()
        appViewModel.addStorageLocation(location)
        dismiss()
    }
}

struct FormFieldView: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var isOptional: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                if isOptional {
                    Text("(Optional)")
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
            }
            
            TextField(placeholder, text: $text)
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(AppColors.darkText)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
        }
    }
}

struct IconSelectionButton: View {
    let icon: StorageIcon
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isSelected ? AppColors.primaryYellow : AppColors.cardBackground)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Circle()
                                .stroke(isSelected ? AppColors.primaryYellow : Color.clear, lineWidth: 2)
                        )
                    
                    Image(systemName: icon.rawValue)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(isSelected ? AppColors.darkText : AppColors.accentPurple)
                }
                
                Text(icon.displayName)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(1)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AddStorageLocationView()
        .environmentObject(AppViewModel())
}
