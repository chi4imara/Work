import SwiftUI

struct AddAccessoryView: View {
    @ObservedObject var viewModel: AccessoryViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTab: TabItem
    
    @State private var name: String = ""
    @State private var selectedType: AccessoryType = .glasses
    @State private var selectedStatus: AccessoryStatus = .inUse
    @State private var description: String = ""
    @State private var comment: String = ""
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Add Accessory")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.primaryWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name *")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryWhite)
                            
                            TextField("Ray-Ban Sunglasses", text: $name)
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(AppColors.primaryWhite)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.cardBorder, lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Type")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryWhite)
                            
                            Menu {
                                ForEach(AccessoryType.allCases) { type in
                                    Button(action: {
                                        selectedType = type
                                    }) {
                                        HStack {
                                            Text(type.displayName)
                                            if selectedType == type {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedType.displayName)
                                        .font(.ubuntu(16, weight: .regular))
                                        .foregroundColor(AppColors.primaryWhite)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(AppColors.primaryWhite.opacity(0.7))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.cardBorder, lineWidth: 1)
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Status")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryWhite)
                            
                            Menu {
                                ForEach(AccessoryStatus.allCases) { status in
                                    Button(action: {
                                        selectedStatus = status
                                    }) {
                                        HStack {
                                            Text(status.displayName)
                                            if selectedStatus == status {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedStatus.displayName)
                                        .font(.ubuntu(16, weight: .regular))
                                        .foregroundColor(AppColors.primaryWhite)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(AppColors.primaryWhite.opacity(0.7))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.cardBorder, lineWidth: 1)
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryWhite)
                            
                            TextField("Classic shape, black frame", text: $description, axis: .vertical)
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(AppColors.primaryWhite)
                                .lineLimit(3...6)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.cardBorder, lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryWhite)
                            
                            TextField("Wear in summer, light and comfortable", text: $comment, axis: .vertical)
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(AppColors.primaryWhite)
                                .lineLimit(3...6)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.cardBorder, lineWidth: 1)
                                )
                        }
                        
                        Button(action: saveAccessory) {
                            Text("Save")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(isFormValid ? AppColors.primaryPurple : AppColors.primaryWhite.opacity(0.5))
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(isFormValid ? AppColors.primaryWhite : AppColors.cardBackground)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private func saveAccessory() {
        let accessory = Accessory(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            type: selectedType,
            status: selectedStatus,
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addAccessory(accessory)
        dismiss()
        
        withAnimation {
            selectedTab = .catalog
            
            name = ""
            selectedType = .glasses
            selectedStatus = .inUse
            description = ""
            comment = ""
        }
    }
}
