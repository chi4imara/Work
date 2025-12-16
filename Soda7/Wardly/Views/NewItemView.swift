import SwiftUI

struct NewItemView: View {
    @EnvironmentObject var itemsViewModel: ItemsViewModel
    @EnvironmentObject var appState: AppStateViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var itemName = ""
    @State private var estimatedPrice = ""
    @State private var selectedPriority: Priority = .medium
    @State private var comment = ""
    @State private var showingPriorityPicker = false
    
    private var isFormValid: Bool {
        !itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var priceValue: Double {
        Double(estimatedPrice) ?? 0.0
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 24) {
                        headerView
                        
                        VStack(spacing: 20) {
                            itemNameField
                            estimatedPriceField
                            priorityField
                            commentField
                        }
                        
                        if !isFormValid {
                            helperTextView
                        }
                        
                        Button(action: saveItem) {
                            Text("Save")
                                .font(AppTypography.buttonText)
                                .frame(maxWidth: .infinity)
                                .primaryButtonStyle(isEnabled: isFormValid)

                        }
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(isPresented: $showingPriorityPicker) {
            PriorityPickerView(selectedPriority: $selectedPriority)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("New Purchase")
                .font(AppTypography.title1)
                .foregroundColor(AppColors.primaryPurple)
            
            Text("Add a new item to your wishlist")
                .font(AppTypography.callout)
                .foregroundColor(AppColors.neutralGray)
        }
    }
    
    private var itemNameField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Item Name")
                .font(AppTypography.subheadline)
                .foregroundColor(AppColors.darkGray)
            
            TextField("e.g., White Cardigan", text: $itemName)
                .font(AppTypography.body)
                .padding(16)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            itemName.isEmpty ? AppColors.neutralGray.opacity(0.3) : AppColors.primaryPurple.opacity(0.5),
                            lineWidth: 1
                        )
                )
        }
    }
    
    private var estimatedPriceField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Estimated Price ($)")
                .font(AppTypography.subheadline)
                .foregroundColor(AppColors.darkGray)
            
            TextField("0", text: $estimatedPrice)
                .font(AppTypography.body)
                .keyboardType(.decimalPad)
                .padding(16)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.neutralGray.opacity(0.3), lineWidth: 1)
                )
        }
    }
    
    private var priorityField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Priority")
                .font(AppTypography.subheadline)
                .foregroundColor(AppColors.darkGray)
            
            Button(action: { showingPriorityPicker = true }) {
                HStack {
                    Text(selectedPriority.displayName)
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.darkGray)
                    
                    Spacer()
                    
                    Circle()
                        .fill(AppColors.priorityColor(for: selectedPriority))
                        .frame(width: 12, height: 12)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.neutralGray)
                }
                .padding(16)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.neutralGray.opacity(0.3), lineWidth: 1)
                )
            }
        }
    }
    
    private var commentField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Comment (Optional)")
                .font(AppTypography.subheadline)
                .foregroundColor(AppColors.darkGray)
            
            TextField("e.g., Goes with jeans and boots", text: $comment, axis: .vertical)
                .font(AppTypography.body)
                .lineLimit(3...6)
                .padding(16)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.neutralGray.opacity(0.3), lineWidth: 1)
                )
        }
    }
    
    private var helperTextView: some View {
        VStack(spacing: 8) {
            Text("Add at least an item name to save the record")
                .font(AppTypography.footnote)
                .foregroundColor(AppColors.neutralGray)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 40)
    }
    
    private func saveItem() {
        guard isFormValid else { return }
        
        let newItem = Item(
            name: itemName.trimmingCharacters(in: .whitespacesAndNewlines),
            estimatedPrice: priceValue,
            priority: selectedPriority,
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        itemsViewModel.addItem(newItem)
        
        resetForm()
        
        appState.selectTab(0)
        
        dismiss()
    }
    
    private func resetForm() {
        itemName = ""
        estimatedPrice = ""
        selectedPriority = .medium
        comment = ""
    }
}

struct PriorityPickerView: View {
    @Binding var selectedPriority: Priority
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Select Priority")
                        .font(AppTypography.title2)
                        .foregroundColor(AppColors.primaryPurple)
                        .padding(.top, 20)
                    
                    VStack(spacing: 12) {
                        ForEach(Priority.allCases, id: \.self) { priority in
                            PriorityOptionView(
                                priority: priority,
                                isSelected: selectedPriority == priority
                            ) {
                                selectedPriority = priority
                                dismiss()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .foregroundColor(AppColors.primaryPurple)
                .fontWeight(.semibold)
            }
        }
    }
}

struct PriorityOptionView: View {
    let priority: Priority
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Circle()
                    .fill(AppColors.priorityColor(for: priority))
                    .frame(width: 20, height: 20)
                
                Text(priority.displayName)
                    .font(AppTypography.headline)
                    .foregroundColor(AppColors.darkGray)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.primaryPurple)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColors.lightPurple.opacity(0.3) : AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? AppColors.primaryPurple.opacity(0.5) : AppColors.neutralGray.opacity(0.2),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NewItemView()
        .environmentObject(ItemsViewModel())
        .environmentObject(AppStateViewModel())
}
