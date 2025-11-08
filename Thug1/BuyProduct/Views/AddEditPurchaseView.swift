import SwiftUI

struct AddEditPurchaseView: View {
    @EnvironmentObject var purchaseStore: PurchaseStore
    @Environment(\.dismiss) private var dismiss
    
    let purchase: Purchase?
    
    @State private var name = ""
    @State private var selectedCategory = PurchaseCategory.furniture
    @State private var purchaseDate = Date()
    @State private var serviceLifeYears = 1
    @State private var comment = ""
    @State private var isFavorite = false
    
    @State private var showingDatePicker = false
    @State private var showingCategoryPicker = false
    
    private var isEditing: Bool {
        purchase != nil
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && serviceLifeYears >= 1
    }
    
    init(purchase: Purchase? = nil) {
        self.purchase = purchase
    }
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.primaryYellow)
                    
                    Spacer()
                    
                    Text(isEditing ? "Edit Purchase" : "New Purchase")
                        .font(.bodyLarge)
                        .foregroundColor(.primaryWhite)
                    
                    Spacer()
                    
                    Button("Save") {
                        savePurchase()
                    }
                    .foregroundColor(!isFormValid ? .gray : .primaryYellow)
                    .disabled(!isFormValid)
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name *")
                                .font(.bodyLarge)
                                .foregroundColor(.primaryWhite)
                            
                            TextField("Enter purchase name", text: $name)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.bodyLarge)
                                .foregroundColor(.primaryWhite)
                            
                            Button(action: { showingCategoryPicker = true }) {
                                HStack {
                                    Text(selectedCategory.rawValue)
                                        .font(.bodyMedium)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.secondary)
                                }
                                .padding(12)
                                .background(Color.cardBackground)
                                .cornerRadius(8)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Purchase Date")
                                .font(.bodyLarge)
                                .foregroundColor(.primaryWhite)
                            
                            Button(action: { showingDatePicker = true }) {
                                HStack {
                                    Text(purchaseDate, formatter: DateFormatter.longDate)
                                        .font(.bodyMedium)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "calendar")
                                        .foregroundColor(.secondary)
                                }
                                .padding(12)
                                .background(Color.cardBackground)
                                .cornerRadius(8)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Service Life (years) *")
                                .font(.bodyLarge)
                                .foregroundColor(.primaryWhite)
                            
                            HStack {
                                Button(action: {
                                    if serviceLifeYears > 1 {
                                        serviceLifeYears -= 1
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.primaryYellow)
                                }
                                
                                Spacer()
                                
                                Text("\(serviceLifeYears)")
                                    .font(.titleMedium)
                                    .foregroundColor(.primaryWhite)
                                
                                Spacer()
                                
                                Button(action: {
                                    serviceLifeYears += 1
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.primaryYellow)
                                }
                            }
                            .padding(12)
                            .background(Color.cardBackground.opacity(0.2))
                            .cornerRadius(8)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment")
                                .font(.bodyLarge)
                                .foregroundColor(.primaryWhite)
                            
                            TextField("Add a comment (optional)", text: $comment, axis: .vertical)
                                .textFieldStyle(CustomTextFieldStyle())
                                .lineLimit(3...6)
                        }
                        
                        HStack {
                            Text("Add to Favorites")
                                .font(.bodyLarge)
                                .foregroundColor(.primaryWhite)
                            
                            Spacer()
                            
                            Toggle("", isOn: $isFavorite)
                                .tint(.primaryYellow)
                        }
                        .padding(12)
                        .background(Color.cardBackground.opacity(0.2))
                        .cornerRadius(8)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(20)
                }
            }
        }
        .sheet(isPresented: $showingCategoryPicker) {
            CategoryPickerView(selectedCategory: $selectedCategory)
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerView(selectedDate: $purchaseDate)
        }
        .onAppear {
            loadPurchaseData()
        }
    }
    
    private func loadPurchaseData() {
        if let purchase = purchase {
            name = purchase.name
            selectedCategory = purchase.category
            purchaseDate = purchase.purchaseDate
            serviceLifeYears = purchase.serviceLifeYears
            comment = purchase.comment
            isFavorite = purchase.isFavorite
        }
    }
    
    private func savePurchase() {
        if let existingPurchase = purchase {
            var updatedPurchase = existingPurchase
            updatedPurchase.name = name.trimmingCharacters(in: .whitespaces)
            updatedPurchase.category = selectedCategory
            updatedPurchase.purchaseDate = purchaseDate
            updatedPurchase.serviceLifeYears = serviceLifeYears
            updatedPurchase.comment = comment
            updatedPurchase.isFavorite = isFavorite
            
            purchaseStore.updatePurchase(updatedPurchase)
        } else {
            let newPurchase = Purchase(
                name: name.trimmingCharacters(in: .whitespaces),
                category: selectedCategory,
                purchaseDate: purchaseDate,
                serviceLifeYears: serviceLifeYears,
                comment: comment,
                isFavorite: isFavorite
            )
            
            purchaseStore.addPurchase(newPurchase)
        }
        
        dismiss()
    }
}

struct CategoryPickerView: View {
    @Binding var selectedCategory: PurchaseCategory
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                HStack {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.primaryYellow)
                    .disabled(true)
                    .opacity(0)
                    
                    Spacer()
                    
                    Text("Select Category")
                        .font(.bodyLarge)
                        .foregroundColor(.primaryWhite)
                    
                    Spacer()
                    
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.primaryYellow)
                }
                .padding(.bottom, 8)
                
                ForEach(PurchaseCategory.allCases, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                        dismiss()
                    }) {
                        HStack {
                            Text(category.rawValue)
                                .font(.bodyLarge)
                                .foregroundColor(.primaryWhite)
                            
                            Spacer()
                            
                            if selectedCategory == category {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.primaryYellow)
                            }
                        }
                        .padding(16)
                        .background(Color.cardBackground.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
                
                Spacer()
            }
            .padding(20)
        }
    }
}

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.primaryYellow)
                    .disabled(true)
                    .opacity(0)
                    
                    Spacer()
                    
                    Text("Purchase Date")
                        .font(.bodyLarge)
                        .foregroundColor(.primaryWhite)
                    
                    Spacer()
                    
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.primaryYellow)
                }
                
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .colorScheme(.dark)
                
                Spacer()
            }
            .padding(20)
        }
    }
}

extension DateFormatter {
    static let longDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}

#Preview {
    AddEditPurchaseView()
        .environmentObject(PurchaseStore())
}
