import SwiftUI

struct NewPurchaseView: View {
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
    
    var body: some View {
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
                            
                            Text("New Purchase")
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
                        
                        Button(action: addPurchase) {
                            Text("Add Purchase")
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
    
    private func addPurchase() {
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
        
        let purchase = Purchase(
            name: itemName.trimmingCharacters(in: .whitespaces),
            category: selectedCategory,
            amount: amount,
            date: selectedDate,
            description: itemDescription.trimmingCharacters(in: .whitespaces)
        )
        
        budgetViewModel.addPurchase(purchase)
        presentationMode.wrappedValue.dismiss()
    }
}

struct FormField<Content: View>: View {
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
            HStack {
                Text(title)
                    .font(.lumierepolis(16, weight: .bold))
                    .foregroundColor(Color.theme.textWhite)
                if isRequired {
                    Text("*")
                        .font(.lumierepolis(16, weight: .bold))
                        .foregroundColor(Color.theme.warningRed)
                }
            }
            
            content
                .padding(16)
                .background(Color.theme.cardWhite)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

#Preview {
    NewPurchaseView(budgetViewModel: BudgetViewModel())
}
