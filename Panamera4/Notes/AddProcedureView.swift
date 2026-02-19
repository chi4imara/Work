import SwiftUI

struct AddProcedureView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var procedureStore: ProcedureStore
    
    @State private var name = ""
    @State private var selectedCategory = ProcedureCategory.masks
    @State private var selectedDate = Date()
    @State private var effect = ""
    @State private var description = ""
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(.bellGothic(16, weight: .regular))
                        .foregroundColor(AppColors.primaryWhite)
                        
                        Spacer()
                        
                        Text("New Procedure")
                            .font(.bellGothic(20, weight: .bold))
                            .foregroundColor(AppColors.primaryWhite)
                        
                        Spacer()
                        
                        Button("Save") {
                            saveProcedure()
                        }
                        .font(.bellGothic(16, weight: .bold))
                        .foregroundColor(isFormValid ? AppColors.accentYellow : AppColors.primaryWhite.opacity(0.5))
                        .disabled(!isFormValid)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            FormFieldView(title: "Procedure Name*", isRequired: true) {
                                TextField("Enter procedure name", text: $name)
                                    .font(.bellGothic(16, weight: .regular))
                                    .foregroundColor(AppColors.darkGray)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.primaryWhite)
                                    )
                            }
                            
                            FormFieldView(title: "Category") {
                                CategoryPickerView(selectedCategory: $selectedCategory)
                            }
                            
                            FormFieldView(title: "Date") {
                                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .font(.bellGothic(16, weight: .regular))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.primaryWhite)
                                    )
                            }
                            
                            FormFieldView(title: "Effect") {
                                TextField("e.g., smoother hair, more volume", text: $effect)
                                    .font(.bellGothic(16, weight: .regular))
                                    .foregroundColor(AppColors.darkGray)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.primaryWhite)
                                    )
                            }
                            
                            FormFieldView(title: "Description") {
                                TextEditor(text: $description)
                                    .font(.bellGothic(16, weight: .regular))
                                    .foregroundColor(AppColors.darkGray)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.primaryWhite)
                                    )
                                    .frame(minHeight: 100)
                            }
                            
                            Spacer().frame(height: 100)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func saveProcedure() {
        let procedure = HairCareProcedure(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            date: selectedDate,
            effect: effect.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        procedureStore.addProcedure(procedure)
        presentationMode.wrappedValue.dismiss()
    }
}

struct FormFieldView<Content: View>: View {
    let title: String
    let isRequired: Bool
    let content: Content
    
    init(title: String, isRequired: Bool = false, @ViewBuilder content: () -> Content) {
        self.title = title
        self.isRequired = isRequired
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.bellGothic(16, weight: .bold))
                .foregroundColor(AppColors.primaryWhite)
            
            content
        }
    }
}

struct CategoryPickerView: View {
    @Binding var selectedCategory: ProcedureCategory
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
            ForEach(ProcedureCategory.allCases, id: \.self) { category in
                CategoryOptionView(
                    category: category,
                    isSelected: selectedCategory == category
                ) {
                    selectedCategory = category
                }
            }
        }
    }
}

struct CategoryOptionView: View {
    let category: ProcedureCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: category.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.accentYellow : AppColors.darkGray.opacity(0.7))
                
                Text(category.displayName)
                    .font(.bellGothic(14, weight: .regular))
                    .foregroundColor(isSelected ? AppColors.accentYellow : AppColors.darkGray)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColors.accentYellow.opacity(0.1) : AppColors.primaryWhite)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? AppColors.accentYellow : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AddProcedureView()
        .environmentObject(ProcedureStore())
}
