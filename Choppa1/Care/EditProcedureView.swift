import SwiftUI

struct EditProcedureView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) private var dismiss
    
    let procedure: Procedure
    
    @State private var name: String
    @State private var selectedCategory: ProcedureCategory
    @State private var selectedDate: Date
    @State private var products: String
    @State private var comment: String
    @State private var showingAlert = false
    
    init(procedure: Procedure) {
        self.procedure = procedure
        self._name = State(initialValue: procedure.name)
        self._selectedCategory = State(initialValue: procedure.category)
        self._selectedDate = State(initialValue: procedure.date)
        self._products = State(initialValue: procedure.products)
        self._comment = State(initialValue: procedure.comment)
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
            .navigationTitle("Edit Procedure")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save Changes") {
                        saveChanges()
                    }
                    .foregroundColor(AppColors.primaryText)
                    .disabled(name.isEmpty)
                }
            }
        }
        .alert("Missing Information", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text("Procedure name cannot be empty.")
        }
    }
    
    private func saveChanges() {
        guard !name.isEmpty else {
            showingAlert = true
            return
        }
        
        var updatedProcedure = procedure
        updatedProcedure.name = name
        updatedProcedure.category = selectedCategory
        updatedProcedure.date = selectedDate
        updatedProcedure.products = products
        updatedProcedure.comment = comment
        
        dataManager.updateProcedure(updatedProcedure)
        dismiss()
    }
}

#Preview {
    EditProcedureView(procedure: Procedure(
        name: "Face Mask",
        category: .skin,
        date: Date(),
        products: "Glow Cream Mask",
        comment: "Great results"
    ))
    .environmentObject(DataManager())
}
