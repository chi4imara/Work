import SwiftUI

struct EditPurchaseView: View {
    let purchaseId: UUID
    @ObservedObject var budgetViewModel: BudgetViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var itemName = ""
    @State private var selectedCategory = ""
    @State private var customCategory = ""
    @State private var showingCustomCategory = false
    @State private var amountText = ""
    @State private var selectedDate = Date()
    @State private var itemDescription = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    private var purchase: Purchase? {
        budgetViewModel.getPurchase(byId: purchaseId)
    }
    
    var body: some View {
        Group {
            if let currentPurchase = purchase {
                editPurchaseContent(purchase: currentPurchase)
            } else {
                NavigationView {
                    ZStack {
                        Color.theme.backgroundGradient
                            .ignoresSafeArea()
                        
                        Text("Purchase not found")
                            .font(.lumierepolis(18, weight: .light))
                            .foregroundColor(Color.theme.textWhite)
                    }
                }
                .navigationBarHidden(true)
            }
        }
    }
    
    private func editPurchaseContent(purchase: Purchase) -> some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        HStack {
                            Button("Cancel") {
                                presentationMode.wrappedValue.dismiss()
                            }
                            .font(.lumierepolis(16, weight: .light))
                            .foregroundColor(Color.theme.textWhite)
                            
                            Spacer()
                            
                            Text("Edit Purchase")
                                .font(.lumierepolis(20, weight: .bold))
                                .foregroundColor(Color.theme.textWhite)
                            
                            Spacer()
                            
                            Button("") { }
                                .font(.lumierepolis(16, weight: .light))
                                .foregroundColor(Color.clear)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            FormField(title: "Item Name", isRequired: true) {
                                TextField("e.g. Coat", text: $itemName)
                                    .font(.lumierepolis(16, weight: .light))
                                    .foregroundColor(Color.theme.textBlack)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Category")
                                        .font(.lumierepolis(16, weight: .bold))
                                        .foregroundColor(Color.theme.textWhite)
                                    Text("*")
                                        .font(.lumierepolis(16, weight: .bold))
                                        .foregroundColor(Color.theme.warningRed)
                                }
                                
                                Menu {
                                    ForEach(PurchaseCategory.allCases, id: \.self) { category in
                                        Button(category.displayName) {
                                            selectedCategory = category.displayName
                                            showingCustomCategory = false
                                        }
                                    }
                                    
                                    ForEach(budgetViewModel.customCategories, id: \.self) { category in
                                        Button(category) {
                                            selectedCategory = category
                                            showingCustomCategory = false
                                        }
                                    }
                                    
                                    Button("Create Custom Category") {
                                        showingCustomCategory = true
                                        selectedCategory = ""
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedCategory.isEmpty ? "Select Category" : selectedCategory)
                                            .font(.lumierepolis(16, weight: .light))
                                            .foregroundColor(selectedCategory.isEmpty ? Color.theme.textBlack.opacity(0.5) : Color.theme.textBlack)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color.theme.textBlack.opacity(0.5))
                                    }
                                    .padding(16)
                                    .background(Color.theme.cardWhite)
                                    .cornerRadius(12)
                                }
                                
                                if showingCustomCategory {
                                    HStack {
                                        TextField("Enter custom category", text: $customCategory)
                                            .font(.lumierepolis(16, weight: .light))
                                            .foregroundColor(Color.theme.textBlack)
                                        
                                        Button("Add") {
                                            if !customCategory.isEmpty {
                                                budgetViewModel.addCustomCategory(customCategory)
                                                selectedCategory = customCategory
                                                showingCustomCategory = false
                                                customCategory = ""
                                            }
                                        }
                                        .font(.lumierepolis(14, weight: .bold))
                                        .foregroundColor(Color.theme.primaryPink)
                                    }
                                    .padding(16)
                                    .background(Color.theme.cardWhite)
                                    .cornerRadius(12)
                                }
                            }
                            
                            FormField(title: "Amount ($)", isRequired: true) {
                                TextField("0.00", text: $amountText)
                                    .font(.lumierepolis(16, weight: .light))
                                    .foregroundColor(Color.theme.textBlack)
                                    .keyboardType(.decimalPad)
                            }
                            
                            FormField(title: "Purchase Date") {
                                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .accentColor(Color.theme.primaryPink)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.lumierepolis(16, weight: .bold))
                                    .foregroundColor(Color.theme.textWhite)
                                
                                TextEditor(text: $itemDescription)
                                    .font(.lumierepolis(16, weight: .light))
                                    .foregroundColor(Color.theme.textBlack)
                                    .frame(height: 100)
                                    .padding(12)
                                    .background(Color.theme.cardWhite)
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Button(action: saveChanges) {
                            Text("Save Changes")
                                .font(.lumierepolis(18, weight: .bold))
                                .foregroundColor(Color.theme.textBlack)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(isValidInput ? AnyShapeStyle(Color.theme.buttonGradient) : AnyShapeStyle(Color.gray.opacity(0.3)))
                                .cornerRadius(28)
                                .shadow(color: isValidInput ? Color.theme.accentYellow.opacity(0.3) : Color.clear, radius: 10, x: 0, y: 5)
                        }
                        .disabled(!isValidInput)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            setupInitialValues()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private var isValidInput: Bool {
        !itemName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !selectedCategory.isEmpty &&
        Double(amountText) != nil &&
        Double(amountText) ?? 0 > 0
    }
    
    private func setupInitialValues() {
        guard let purchase = purchase else { return }
        itemName = purchase.name
        selectedCategory = purchase.category
        amountText = String(format: "%.2f", purchase.amount)
        selectedDate = purchase.date
        itemDescription = purchase.description
    }
    
    private func saveChanges() {
        guard let amount = Double(amountText), amount > 0 else {
            alertMessage = "Please enter a valid amount greater than 0."
            showingAlert = true
            return
        }
        
        if amount > 100000 {
            alertMessage = "Purchase amount cannot exceed $100,000."
            showingAlert = true
            return
        }
        
        guard var updatedPurchase = purchase else { return }
        updatedPurchase.name = itemName.trimmingCharacters(in: .whitespaces)
        updatedPurchase.category = selectedCategory
        updatedPurchase.amount = amount
        updatedPurchase.date = selectedDate
        updatedPurchase.description = itemDescription.trimmingCharacters(in: .whitespaces)
        
        budgetViewModel.updatePurchase(updatedPurchase)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    let samplePurchase = Purchase(
        name: "Designer Coat",
        category: "Outerwear",
        amount: 299.99,
        date: Date(),
        description: "A beautiful winter coat"
    )
    let viewModel = BudgetViewModel()
    viewModel.addPurchase(samplePurchase)
    
    return EditPurchaseView(purchaseId: samplePurchase.id, budgetViewModel: viewModel)
}
