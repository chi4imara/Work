import SwiftUI

struct NewProcedureView: View {
    @ObservedObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var selectedCategory: Category = Category.defaultCategories[0]
    @State private var customCategoryName = ""
    @State private var showingCustomCategory = false
    @State private var selectedFrequency: Procedure.Frequency = .daily
    @State private var customDays = 3
    @State private var firstExecutionDate = Date()
    @State private var comment = ""
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.mainGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Procedure Name")
                                .font(FontManager.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorManager.textWhite)
                            
                            TextField("Enter procedure name", text: $name)
                                .font(FontManager.ubuntu(16, weight: .regular))
                                .foregroundColor(ColorManager.textWhite)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(ColorManager.cardBackground)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(FontManager.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorManager.textWhite)
                            
                            Menu {
                                ForEach(appState.categories, id: \.id) { category in
                                    Button(category.name) {
                                        selectedCategory = category
                                        showingCustomCategory = false
                                    }
                                }
                                
                                Button("Create custom category") {
                                    showingCustomCategory = true
                                }
                            } label: {
                                HStack {
                                    Text(showingCustomCategory ? "Custom Category" : selectedCategory.name)
                                        .font(FontManager.ubuntu(16, weight: .regular))
                                        .foregroundColor(ColorManager.textWhite)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(ColorManager.textSecondary)
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(ColorManager.cardBackground)
                                )
                            }
                            
                            if showingCustomCategory {
                                TextField("Enter category name", text: $customCategoryName)
                                    .font(FontManager.ubuntu(16, weight: .regular))
                                    .foregroundColor(ColorManager.textWhite)
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(ColorManager.cardBackground)
                                    )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Frequency")
                                .font(FontManager.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorManager.textWhite)
                            
                            VStack(spacing: 12) {
                                FrequencyOption(
                                    title: "Daily",
                                    isSelected: selectedFrequency == .daily
                                ) {
                                    selectedFrequency = .daily
                                }
                                
                                FrequencyOption(
                                    title: "Weekly",
                                    isSelected: selectedFrequency == .weekly
                                ) {
                                    selectedFrequency = .weekly
                                }
                                
                                VStack(spacing: 8) {
                                    FrequencyOption(
                                        title: "Every X days",
                                        isSelected: {
                                            if case .custom = selectedFrequency { return true }
                                            return false
                                        }()
                                    ) {
                                        selectedFrequency = .custom(days: customDays)
                                    }
                                    
                                    if case .custom = selectedFrequency {
                                        HStack {
                                            Text("Every")
                                                .font(FontManager.ubuntu(14, weight: .medium))
                                                .foregroundColor(ColorManager.textSecondary)
                                            
                                            TextField("3", value: $customDays, format: .number)
                                                .font(FontManager.ubuntu(16, weight: .medium))
                                                .foregroundColor(ColorManager.textWhite)
                                                .keyboardType(.numberPad)
                                                .frame(width: 60)
                                                .padding(8)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(ColorManager.cardBackground)
                                                )
                                                .onChange(of: customDays) { newValue in
                                                    selectedFrequency = .custom(days: newValue)
                                                }
                                            
                                            Text("days")
                                                .font(FontManager.ubuntu(14, weight: .medium))
                                                .foregroundColor(ColorManager.textSecondary)
                                            
                                            Spacer()
                                        }
                                        .padding(.leading, 32)
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("First Execution Date")
                                .font(FontManager.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorManager.textWhite)
                            
                            DatePicker("", selection: $firstExecutionDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .colorScheme(.dark)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(ColorManager.cardBackground)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment (Optional)")
                                .font(FontManager.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorManager.textWhite)
                            
                            TextField("Add a comment", text: $comment, axis: .vertical)
                                .font(FontManager.ubuntu(16, weight: .regular))
                                .foregroundColor(ColorManager.textWhite)
                                .lineLimit(3...6)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(ColorManager.cardBackground)
                                )
                        }
                        
                        Button(action: saveProcedure) {
                            Text("Save")
                                .font(FontManager.ubuntu(18, weight: .medium))
                                .foregroundColor(isFormValid ? ColorManager.primaryPurple : ColorManager.textSecondary)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 28)
                                        .fill(isFormValid ? AnyShapeStyle(ColorManager.buttonGradient) : AnyShapeStyle(ColorManager.cardBackground))
                                )
                        }
                        .disabled(!isFormValid)
                        .padding(.top, 20)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("New Procedure")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(ColorManager.textWhite)
            )
            .preferredColorScheme(.dark)
        }
    }
    
    private func saveProcedure() {
        let finalCategory: Category
        
        if showingCustomCategory && !customCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            finalCategory = Category(name: customCategoryName.trimmingCharacters(in: .whitespacesAndNewlines))
        } else {
            finalCategory = selectedCategory
        }
        
        let procedure = Procedure(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            category: finalCategory,
            frequency: selectedFrequency,
            firstExecutionDate: firstExecutionDate,
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        appState.addProcedure(procedure)
        presentationMode.wrappedValue.dismiss()
    }
}

struct FrequencyOption: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? ColorManager.accentYellow : ColorManager.textSecondary)
                
                Text(title)
                    .font(FontManager.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorManager.textWhite)
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? ColorManager.accentYellow.opacity(0.1) : ColorManager.cardBackground)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NewProcedureView(appState: AppState())
}
