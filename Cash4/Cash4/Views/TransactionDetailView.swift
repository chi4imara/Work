import SwiftUI

struct TransactionDetailView: View {
    let transaction: Transaction
    @ObservedObject var viewModel: CollectionViewModel
    @Binding var isPresented: Bool
    @State private var isEditing = false
    @State private var showingDeleteAlert = false
    
    @State private var type: TransactionType
    @State private var itemName: String
    @State private var amount: Double
    @State private var counterparty: String
    @State private var notes: String
    
    init(transaction: Transaction, viewModel: CollectionViewModel, isPresented: Binding<Bool>) {
        self.transaction = transaction
        self.viewModel = viewModel
        self._isPresented = isPresented
        
        self._type = State(initialValue: transaction.type)
        self._itemName = State(initialValue: transaction.itemName)
        self._amount = State(initialValue: abs(transaction.amount))
        self._counterparty = State(initialValue: transaction.counterparty)
        self._notes = State(initialValue: transaction.notes)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGradient
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Button("Cancel") {
                            isPresented = false
                        }
                        .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text(isEditing ? "Edit Transaction" : "Transaction Details")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        HStack {
                            if !isEditing {
                                Button("Edit") {
                                    isEditing = true
                                }
                                .foregroundColor(.white)
                            } else {
                                Button("Save") {
                                    saveTransaction()
                                }
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            if isEditing {
                                editingView
                            } else {
                                viewingView
                            }
                        }
                        .padding(20)
                        .padding(.bottom, 100)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .alert("Delete Transaction", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deleteTransaction(transaction)
                isPresented = false
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this transaction? This action cannot be undone.")
        }
    }
    
    private var viewingView: some View {
        VStack(spacing: 24) {
            FormSection(title: "Transaction Information") {
                VStack(spacing: 16) {
                    DetailRow(label: "Type", value: transaction.type.rawValue)
                    DetailRow(label: "Item", value: transaction.itemName.isEmpty ? "General Transaction" : transaction.itemName)
                    DetailRow(label: "Amount", value: "\(transaction.amount >= 0 ? "+" : "")$\(String(format: "%.0f", transaction.amount))")
                    DetailRow(label: "Counterparty", value: transaction.counterparty.isEmpty ? "Not specified" : transaction.counterparty)
                    DetailRow(label: "Date", value: DateFormatter.short.string(from: transaction.date))
                }
            }
            
            if !transaction.notes.isEmpty {
                FormSection(title: "Notes") {
                    Text(transaction.notes)
                        .font(.body)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            FormSection(title: "Actions") {
                VStack(spacing: 16) {
                    Button("Delete Transaction") {
                        showingDeleteAlert = true
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.red)
                    )
                }
            }
        }
    }
    
    private var editingView: some View {
        VStack(spacing: 24) {
            FormSection(title: "Transaction Details") {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Type")
                            .font(.callout)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Menu {
                            ForEach(TransactionType.allCases, id: \.self) { t in
                                Button(t.rawValue) {
                                    type = t
                                }
                            }
                        } label: {
                            HStack {
                                Text(type.rawValue)
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.2))
                            )
                        }
                    }
                    
                    FormField(label: "Item Name", text: $itemName, placeholder: "Item or description")
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Amount")
                            .font(.callout)
                            .foregroundColor(.white.opacity(0.8))
                        
                        TextField("Amount", value: $amount, format: .number)
                            .foregroundColor(.white)
                            .foregroundStyle(.white, Color.gray)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.2))
                            )
                            .keyboardType(.decimalPad)
                    }
                    
                    FormField(label: "Counterparty", text: $counterparty, placeholder: "Store, person, etc.")
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.callout)
                            .foregroundColor(.white.opacity(0.8))
                        
                        TextEditor(text: $notes)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.2))
                            )
                            .frame(minHeight: 80)
                            .scrollContentBackground(.hidden)
                            .colorScheme(.dark)
                    }
                }
            }
        }
    }
    
    private func saveTransaction() {
        var updatedTransaction = transaction
        updatedTransaction.type = type
        updatedTransaction.itemName = itemName
        updatedTransaction.amount = type == .sale ? amount : -amount
        updatedTransaction.counterparty = counterparty
        updatedTransaction.notes = notes
        
        print("Saving transaction: type: \(updatedTransaction.type.rawValue), item: \(updatedTransaction.itemName), amount: \(updatedTransaction.amount), counterparty: \(updatedTransaction.counterparty), notes: \(updatedTransaction.notes)")
        
        viewModel.updateTransaction(updatedTransaction)
        
        isEditing = false
    }
}

#Preview {
    TransactionDetailView(
        transaction: Transaction(type: .purchase, itemName: "Sample Item", amount: 50.0, counterparty: "Store"),
        viewModel: CollectionViewModel(),
        isPresented: .constant(true)
    )
}
