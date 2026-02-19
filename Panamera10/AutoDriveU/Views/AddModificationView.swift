import SwiftUI

struct AddModificationView: View {
    @EnvironmentObject var viewModel: ModificationViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var selectedCategory: ModificationCategory = .exterior
    @State private var budget: String = ""
    @State private var selectedStatus: ModificationStatus = .plan
    @State private var description: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                    
                    formView
                    
                    saveButton
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.primaryWhite)
                    .padding(12)
                    .background(
                        Circle()
                            .fill(AppColors.primaryDarkBlue.opacity(0.8))
                    )
            }
            
            Spacer()
            
            Text("New Modification")
                .font(FontManager.title1)
                .foregroundColor(AppColors.primaryWhite)
            
            Spacer()
            
            Color.clear
                .frame(width: 42, height: 42)
        }
        .padding(.top, 10)
    }
    
    private var formView: some View {
        VStack(spacing: 20) {
            FormField(
                title: "Name",
                placeholder: "e.g., Install sport exhaust",
                text: $name
            )
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Category")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.primaryWhite)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    ForEach(ModificationCategory.allCases) { category in
                        CategoryButton(
                            category: category,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                    }
                }
            }
            
            FormField(
                title: "Expected Budget",
                placeholder: "e.g., 600",
                text: $budget,
                keyboardType: .numberPad,
                prefix: "$"
            )
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Status")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.primaryWhite)
                
                HStack(spacing: 12) {
                    ForEach(ModificationStatus.allCases) { status in
                        StatusButton(
                            status: status,
                            isSelected: selectedStatus == status
                        ) {
                            selectedStatus = status
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Description")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.primaryWhite)
                
                TextEditor(text: $description)
                    .font(FontManager.body)
                    .foregroundColor(AppColors.cardText)
                    .scrollContentBackground(.hidden)
                    .padding(16)
                    .frame(minHeight: 100)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.cardBackground)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppColors.primaryDarkBlue.opacity(0.2), lineWidth: 1)
                    )
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: saveModification) {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20, weight: .medium))
                Text("Save Modification")
                    .font(FontManager.headline)
            }
            .foregroundColor(AppColors.primaryWhite)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.primaryDarkBlue)
            )
        }
        .disabled(name.isEmpty)
        .opacity(name.isEmpty ? 0.6 : 1.0)
    }
    
    private func saveModification() {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Please enter a modification name."
            showingAlert = true
            return
        }
        
        let budgetValue = Double(budget) ?? 0.0
        
        let modification = Modification(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            budget: budgetValue,
            status: selectedStatus,
            description: description.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addModification(modification)
        presentationMode.wrappedValue.dismiss()
    }
}

struct FormField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var prefix: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryWhite)
            
            HStack {
                if !prefix.isEmpty {
                    Text(prefix)
                        .font(FontManager.body)
                        .foregroundColor(AppColors.cardText.opacity(0.6))
                }
                
                TextField(placeholder, text: $text)
                    .font(FontManager.body)
                    .foregroundColor(AppColors.cardText)
                    .keyboardType(keyboardType)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.primaryDarkBlue.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

struct CategoryButton: View {
    let category: ModificationCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: categoryIcon(for: category))
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.primaryWhite : AppColors.categoryColor(for: category))
                
                Text(category.displayName)
                    .font(FontManager.caption1)
                    .foregroundColor(isSelected ? AppColors.primaryWhite : AppColors.cardText)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? AppColors.categoryColor(for: category) : AppColors.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.categoryColor(for: category), lineWidth: isSelected ? 0 : 1)
            )
        }
    }
    
    private func categoryIcon(for category: ModificationCategory) -> String {
        switch category {
        case .exterior:
            return "car.fill"
        case .technical:
            return "wrench.and.screwdriver.fill"
        case .interior:
            return "carseat.right.fill"
        case .electrical:
            return "bolt.fill"
        case .other:
            return "ellipsis.circle.fill"
        }
    }
}

struct StatusButton: View {
    let status: ModificationStatus
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(status.displayName)
                .font(FontManager.subheadline)
                .foregroundColor(isSelected ? AppColors.primaryWhite : AppColors.statusColor(for: status))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? AppColors.statusColor(for: status) : AppColors.cardBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.statusColor(for: status), lineWidth: isSelected ? 0 : 1)
                )
        }
    }
}

#Preview {
    AddModificationView()
        .environmentObject(ModificationViewModel())
}
