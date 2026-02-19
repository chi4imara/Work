import SwiftUI

struct EditModificationView: View {
    @EnvironmentObject var viewModel: ModificationViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let modification: Modification
    
    @State private var name: String = ""
    @State private var selectedCategory: ModificationCategory = .exterior
    @State private var budget: String = ""
    @State private var selectedStatus: ModificationStatus = .plan
    @State private var description: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
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
            .navigationBarHidden(true)
        }
        .onAppear {
            loadModificationData()
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
            
            Text("Edit Modification")
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
        Button(action: saveChanges) {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20, weight: .medium))
                Text("Save Changes")
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
    
    private func loadModificationData() {
        name = modification.name
        selectedCategory = modification.category
        budget = modification.budget > 0 ? String(Int(modification.budget)) : ""
        selectedStatus = modification.status
        description = modification.description
    }
    
    private func saveChanges() {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Please enter a modification name."
            showingAlert = true
            return
        }
        
        let budgetValue = Double(budget) ?? 0.0
        
        var updatedModification = modification
        updatedModification.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedModification.category = selectedCategory
        updatedModification.budget = budgetValue
        updatedModification.status = selectedStatus
        updatedModification.description = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateModification(updatedModification)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditModificationView(
        modification: Modification(
            name: "Install Sport Exhaust",
            category: .technical,
            budget: 600,
            status: .plan,
            description: "Install a high-performance exhaust system."
        )
    )
    .environmentObject(ModificationViewModel())
}
