import SwiftUI

struct AddProcedureView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) private var dismiss
    
    let template: ProcedureTemplate?
    
    @State private var name = ""
    @State private var selectedCategory = ProcedureCategory.skin
    @State private var selectedDate = Date()
    @State private var products = ""
    @State private var comment = ""
    @State private var showingAlert = false
    
    init(template: ProcedureTemplate? = nil) {
        self.template = template
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Procedure Name")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter procedure name", text: $name)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            HStack(spacing: 12) {
                                ForEach(ProcedureCategory.allCases, id: \.self) { category in
                                    CategorySelectionButton(
                                        category: category,
                                        isSelected: selectedCategory == category
                                    ) {
                                        selectedCategory = category
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Date")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            DatePicker("Select date", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .accentColor(AppColors.primaryText)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Products Used")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter products separated by commas", text: $products)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment (Optional)")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Add your thoughts", text: $comment, axis: .vertical)
                                .textFieldStyle(CustomTextFieldStyle())
                                .lineLimit(3...6)
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("New Procedure")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProcedure()
                    }
                    .foregroundColor(AppColors.primaryText)
                    .disabled(name.isEmpty)
                }
            }
        }
        .alert("Missing Information", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text("Please enter at least a procedure name and date to save.")
        }
        .onAppear {
            if let template = template {
                name = template.name
                selectedCategory = template.category
                products = template.defaultProducts
                comment = template.defaultComment
            }
        }
    }
    
    private func saveProcedure() {
        guard !name.isEmpty else {
            showingAlert = true
            return
        }
        
        let newProcedure = Procedure(
            name: name,
            category: selectedCategory,
            date: selectedDate,
            products: products,
            comment: comment
        )
        
        dataManager.addProcedure(newProcedure)
        dismiss()
    }
}

struct CategorySelectionButton: View {
    let category: ProcedureCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : AppColors.primaryText)
                
                Text(category.rawValue)
                    .font(.custom("PlayfairDisplay-Medium", size: 12))
                    .foregroundColor(isSelected ? .white : AppColors.primaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                isSelected ? AnyShapeStyle(AppColors.purpleGradient) : AnyShapeStyle(AppColors.cardBackground)
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.primaryText.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(AppColors.cardBackground)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(AppColors.primaryText.opacity(0.2), lineWidth: 1)
            )
            .font(.custom("PlayfairDisplay-Regular", size: 16))
    }
}

#Preview {
    AddProcedureView()
        .environmentObject(DataManager())
}
