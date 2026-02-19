import SwiftUI
import StoreKit

struct PurchaseDetailView: View {
    let purchaseId: UUID
    @ObservedObject var viewModel: PurchaseViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var purchase: Purchase? {
        viewModel.purchases.first { $0.id == purchaseId }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                if let purchase = purchase {
                    purchaseContent(purchase: purchase)
                } else {
                    purchaseNotFoundContent
                }
            }
            .navigationBarHidden(true)
            .overlay(
                VStack {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color.theme.primaryWhite)
                                .frame(width: 32, height: 32)
                                .background(Color.theme.primaryWhite.opacity(0.2))
                                .cornerRadius(16)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    Spacer()
                },
                alignment: .topLeading
            )
        }
        .sheet(isPresented: $showingEditView) {
            EditPurchaseView(purchaseId: purchaseId, viewModel: viewModel)
        }
        .alert("Delete Purchase", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let purchase = purchase {
                    viewModel.deletePurchase(purchase)
                }
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this purchase? This action cannot be undone.")
        }
    }
    
    private func purchaseContent(purchase: Purchase) -> some View {
        ScrollView {
            VStack(spacing: 25) {
                VStack(spacing: 16) {
                    Image(systemName: purchase.category.icon)
                                .font(.system(size: 60, weight: .light))
                                .foregroundColor(Color.theme.primaryYellow)
                                .frame(width: 120, height: 120)
                                .background(Color.theme.primaryYellow.opacity(0.2))
                                .cornerRadius(60)
                                .shadow(color: Color.theme.primaryYellow.opacity(0.3), radius: 20, x: 0, y: 10)
                            
                            VStack(spacing: 8) {
                                Text(purchase.name)
                                    .font(FontManager.playfairBold(size: 28))
                                    .foregroundColor(Color.theme.primaryWhite)
                                    .multilineTextAlignment(.center)
                                
                                Text(purchase.category.rawValue)
                                    .font(FontManager.playfairRegular(size: 16))
                                    .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                            }
                        }
                        .padding(.top, 20)
                        
                        HStack {
                            Spacer()
                            StatusBadge(isCompleted: purchase.isCompleted)
                            Spacer()
                        }
                        
                        VStack(spacing: 16) {
                            DetailRow(title: "Planned Amount", value: String(format: "$%.2f", purchase.plannedAmount))
                            
                            if let actualAmount = purchase.actualAmount, purchase.isCompleted {
                                DetailRow(title: "Actual Amount", value: String(format: "$%.2f", actualAmount))
                                
                                let difference = actualAmount - purchase.plannedAmount
                                DetailRow(
                                    title: "Difference",
                                    value: "\(difference >= 0 ? "+" : "")\(String(format: "$%.2f", difference))",
                                    valueColor: difference >= 0 ? Color.red : Color.theme.lightGreen
                                )
                            }
                            
                            DetailRow(title: "Date", value: purchase.date.formatted(date: .abbreviated, time: .shortened))
                            
                            if !purchase.notes.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Notes")
                                            .font(FontManager.playfairSemiBold(size: 16))
                                            .foregroundColor(Color.theme.primaryWhite)
                                        Spacer()
                                    }
                                    
                                    Text(purchase.notes)
                                        .font(FontManager.playfairRegular(size: 14))
                                        .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.theme.cardGradient)
                                        .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            Button(action: {
                                showingEditView = true
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text("Edit Purchase")
                                }
                                .font(FontManager.playfairSemiBold(size: 16))
                                .foregroundColor(Color.theme.darkBlue)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.theme.primaryYellow)
                                .cornerRadius(25)
                            }
                            
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("Delete Purchase")
                                }
                                .font(FontManager.playfairMedium(size: 16))
                                .foregroundColor(Color.red)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.theme.primaryWhite.opacity(0.1))
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.red.opacity(0.5), lineWidth: 1)
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
            }
        }
    }
    
    private var purchaseNotFoundContent: some View {
        VStack(spacing: 24) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.primaryWhite.opacity(0.5))
            Text("Purchase not found")
                .font(FontManager.playfairBold(size: 20))
                .foregroundColor(Color.theme.primaryWhite)
            Text("It may have been deleted.")
                .font(FontManager.playfairRegular(size: 14))
                .foregroundColor(Color.theme.primaryWhite.opacity(0.7))
            Button("Close") {
                dismiss()
            }
            .font(FontManager.playfairSemiBold(size: 16))
            .foregroundColor(Color.theme.darkBlue)
            .frame(width: 120)
            .frame(height: 44)
            .background(Color.theme.primaryYellow)
            .cornerRadius(22)
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct StatusBadge: View {
    let isCompleted: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "clock")
                .foregroundColor(isCompleted ? Color.theme.lightGreen : Color.theme.primaryYellow)
            
            Text(isCompleted ? "Completed" : "Pending")
                .font(FontManager.playfairSemiBold(size: 14))
                .foregroundColor(isCompleted ? Color.theme.lightGreen : Color.theme.primaryYellow)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            (isCompleted ? Color.theme.lightGreen : Color.theme.primaryYellow).opacity(0.2)
        )
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isCompleted ? Color.theme.lightGreen : Color.theme.primaryYellow, lineWidth: 1)
        )
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    let valueColor: Color
    
    init(title: String, value: String, valueColor: Color = Color.theme.primaryYellow) {
        self.title = title
        self.value = value
        self.valueColor = valueColor
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(FontManager.playfairSemiBold(size: 16))
                .foregroundColor(Color.theme.primaryWhite)
            
            Spacer()
            
            Text(value)
                .font(FontManager.playfairBold(size: 16))
                .foregroundColor(valueColor)
        }
        .padding()
        .background(Color.theme.cardGradient)
        .cornerRadius(12)
    }
}

struct EditPurchaseView: View {
    let purchaseId: UUID
    @ObservedObject var viewModel: PurchaseViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var selectedCategory: PurchaseCategory = .clothing
    @State private var plannedAmount: String = ""
    @State private var actualAmount: String = ""
    @State private var selectedDate: Date = Date()
    @State private var notes: String = ""
    @State private var isCompleted: Bool = false
    
    private var purchase: Purchase? {
        viewModel.purchases.first { $0.id == purchaseId }
    }
    
    private var isValidForm: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !plannedAmount.isEmpty &&
        Double(plannedAmount) != nil &&
        (!isCompleted || (!actualAmount.isEmpty && Double(actualAmount) != nil))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                if let purchase = purchase {
                    editFormContent(purchase: purchase)
                } else {
                    editNotFoundContent
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                if let p = purchase {
                    name = p.name
                    selectedCategory = p.category
                    plannedAmount = String(p.plannedAmount)
                    actualAmount = String(p.actualAmount ?? p.plannedAmount)
                    selectedDate = p.date
                    notes = p.notes
                    isCompleted = p.isCompleted
                }
            }
            .onChange(of: viewModel.purchases.count) { _ in
                if purchase == nil {
                    dismiss()
                }
            }
        }
    }
    
    private func editFormContent(purchase: Purchase) -> some View {
        ScrollView {
            VStack(spacing: 25) {
                VStack(spacing: 8) {
                    Text("Edit Purchase")
                        .font(FontManager.playfairBold(size: 28))
                        .foregroundColor(Color.theme.primaryWhite)
                    
                    Text("Update your purchase details")
                        .font(FontManager.playfairRegular(size: 16))
                        .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                }
                .padding(.top, 20)
                
                VStack(spacing: 20) {
                            FormField(title: "Purchase Name", isRequired: true) {
                                TextField("Enter item name", text: $name)
                                    .textFieldStyle(CustomTextFieldStyle())
                            }
                            
                            FormField(title: "Category", isRequired: true) {
                                CategorySelector(selectedCategory: $selectedCategory)
                            }
                            
                            FormField(title: "Planned Amount", isRequired: true) {
                                HStack {
                                    Text("$")
                                        .font(FontManager.playfairMedium(size: 18))
                                        .foregroundColor(Color.theme.primaryWhite)
                                    
                                    TextField("0.00", text: $plannedAmount)
                                        .keyboardType(.decimalPad)
                                        .textFieldStyle(CustomTextFieldStyle())
                                }
                            }
                            
                            FormField(title: "Status") {
                                Toggle("Mark as completed", isOn: $isCompleted)
                                    .font(FontManager.playfairMedium(size: 16))
                                    .foregroundColor(Color.theme.primaryWhite)
                                    .toggleStyle(SwitchToggleStyle(tint: Color.theme.primaryYellow))
                            }
                            
                            if isCompleted {
                                FormField(title: "Actual Amount", isRequired: true) {
                                    HStack {
                                        Text("$")
                                            .font(FontManager.playfairMedium(size: 18))
                                            .foregroundColor(Color.theme.primaryWhite)
                                        
                                        TextField("0.00", text: $actualAmount)
                                            .keyboardType(.decimalPad)
                                            .textFieldStyle(CustomTextFieldStyle())
                                    }
                                }
                            }
                            
                            FormField(title: "Notes (Optional)") {
                                TextField("Add any notes...", text: $notes, axis: .vertical)
                                    .lineLimit(3...6)
                                    .textFieldStyle(CustomTextFieldStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            Button(action: saveChanges) {
                                Text("Save Changes")
                                    .font(FontManager.playfairSemiBold(size: 18))
                                    .foregroundColor(isValidForm ? Color.theme.darkBlue : Color.theme.primaryWhite.opacity(0.5))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(isValidForm ? Color.theme.primaryYellow : Color.theme.primaryWhite.opacity(0.2))
                                    .cornerRadius(28)
                            }
                            .disabled(!isValidForm)
                            
                            Button(action: {
                                dismiss()
                            }) {
                                Text("Cancel")
                                    .font(FontManager.playfairMedium(size: 16))
                                    .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(Color.theme.primaryWhite.opacity(0.1))
                                    .cornerRadius(22)
                            }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
    }
    
    private var editNotFoundContent: some View {
        VStack(spacing: 24) {
            Text("Purchase not found")
                .font(FontManager.playfairBold(size: 20))
                .foregroundColor(Color.theme.primaryWhite)
            Button("Close") {
                dismiss()
            }
            .font(FontManager.playfairSemiBold(size: 16))
            .foregroundColor(Color.theme.darkBlue)
            .frame(width: 120)
            .frame(height: 44)
            .background(Color.theme.primaryYellow)
            .cornerRadius(22)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func saveChanges() {
        guard let purchase = purchase,
              isValidForm,
              let plannedAmountValue = Double(plannedAmount) else { return }
        
        var updatedPurchase = purchase
        updatedPurchase.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedPurchase.category = selectedCategory
        updatedPurchase.plannedAmount = plannedAmountValue
        updatedPurchase.date = selectedDate
        updatedPurchase.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedPurchase.isCompleted = isCompleted
        
        if isCompleted, let actualAmountValue = Double(actualAmount) {
            updatedPurchase.actualAmount = actualAmountValue
        } else if !isCompleted {
            updatedPurchase.actualAmount = nil
        }
        
        viewModel.updatePurchase(updatedPurchase)
        dismiss()
    }
}

#Preview {
    PurchaseDetailView(purchaseId: UUID(), viewModel: PurchaseViewModel())
}
