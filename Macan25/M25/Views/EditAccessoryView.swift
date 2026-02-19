import SwiftUI

struct EditAccessoryView: View {
    @ObservedObject var viewModel: AccessoryViewModel
    let accessoryId: UUID
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var selectedType: AccessoryType = .glasses
    @State private var selectedStatus: AccessoryStatus = .inUse
    @State private var description: String = ""
    @State private var comment: String = ""
    
    private var accessory: Accessory? {
        viewModel.getAccessory(by: accessoryId)
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        nameField
                        typeField
                        statusField
                        descriptionField
                        commentField
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit Accessory")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.clear, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    saveButton
                }
            }
            .onAppear {
                loadAccessoryData()
            }
        }
    }
    
    private var nameField: some View {
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
    }
    
    private var typeField: some View {
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
    }
    
    private var statusField: some View {
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
    }
    
    private var descriptionField: some View {
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
    }
    
    private var commentField: some View {
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
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            dismiss()
        }
        .font(.ubuntu(16, weight: .regular))
        .foregroundColor(AppColors.primaryWhite)
    }
    
    private var saveButton: some View {
        Button("Save Changes") {
            saveChanges()
        }
        .font(.ubuntu(16, weight: .medium))
        .foregroundColor(isFormValid ? AppColors.primaryWhite : AppColors.primaryWhite.opacity(0.5))
        .disabled(!isFormValid)
    }
    
    private func loadAccessoryData() {
        guard let accessory = accessory else { return }
        name = accessory.name
        selectedType = accessory.type
        selectedStatus = accessory.status
        description = accessory.description
        comment = accessory.comment
    }
    
    private func saveChanges() {
        guard var updatedAccessory = accessory else {
            dismiss()
            return
        }
        
        updatedAccessory.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedAccessory.type = selectedType
        updatedAccessory.status = selectedStatus
        updatedAccessory.description = description.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedAccessory.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateAccessory(updatedAccessory)
        dismiss()
    }
}

#Preview {
    let viewModel = AccessoryViewModel()
    let accessory = Accessory(
        name: "Ray-Ban Sunglasses",
        type: .glasses,
        status: .favorite,
        description: "Classic black frame sunglasses",
        comment: "Perfect for summer"
    )
    viewModel.addAccessory(accessory)
    
    return EditAccessoryView(
        viewModel: viewModel,
        accessoryId: accessory.id
    )
}
