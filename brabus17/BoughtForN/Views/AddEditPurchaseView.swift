import SwiftUI

struct AddEditPurchaseView: View {
    @ObservedObject var viewModel: PurchaseViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let purchaseToEdit: Purchase?
    
    @State private var date = Date()
    @State private var whatBought = ""
    @State private var whereBought = ""
    @State private var whyBought = ""
    
    init(viewModel: PurchaseViewModel, purchaseToEdit: Purchase? = nil) {
        self.viewModel = viewModel
        self.purchaseToEdit = purchaseToEdit
        
        if let purchase = purchaseToEdit {
            _date = State(initialValue: purchase.date)
            _whatBought = State(initialValue: purchase.whatBought)
            _whereBought = State(initialValue: purchase.whereBought)
            _whyBought = State(initialValue: purchase.whyBought)
        }
    }
    
    private var isFormValid: Bool {
        !whatBought.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var title: String {
        purchaseToEdit == nil ? "New Purchase" : "Edit Purchase"
    }
    
    private var saveButtonTitle: String {
        purchaseToEdit == nil ? "Save" : "Save Changes"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ForEach(0..<6, id: \.self) { index in
                    Circle()
                        .fill(ColorTheme.white.opacity(0.1))
                        .frame(width: CGFloat.random(in: 6...15))
                        .position(
                            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                            y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                        )
                        .animation(
                            Animation.linear(duration: Double.random(in: 6...12))
                                .repeatForever(autoreverses: false),
                            value: UUID()
                        )
                }
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Date")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorTheme.white)
                            
                            DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                                .datePickerStyle(CompactDatePickerStyle())
                                .accentColor(ColorTheme.yellow)
                                .colorScheme(.dark)
                                .padding(16)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("What bought")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorTheme.white)
                            
                            TextField("Enter what you bought", text: $whatBought)
                                .font(.ubuntu(16, weight: .regular))
                                .colorInvert()
                                .padding(16)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(whatBought.isEmpty ? ColorTheme.lightGray.opacity(0.3) : ColorTheme.yellow, lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Where bought")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorTheme.white)
                            
                            TextField("Enter where you bought (optional)", text: $whereBought)
                                .font(.ubuntu(16, weight: .regular))
                                .colorInvert()
                                .padding(16)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Why bought")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorTheme.white)
                            
                            TextField("Enter why you bought (optional)", text: $whyBought, axis: .vertical)
                                .font(.ubuntu(16, weight: .regular))
                                .colorInvert()
                                .lineLimit(3...6)
                                .padding(16)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(ColorTheme.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(saveButtonTitle) {
                        savePurchase()
                    }
                    .foregroundColor(isFormValid ? ColorTheme.yellow : ColorTheme.white.opacity(0.5))
                    .disabled(!isFormValid)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private func savePurchase() {
        if let existingPurchase = purchaseToEdit {
            let updatedPurchase = Purchase(
                id: existingPurchase.id,
                date: date,
                whatBought: whatBought.trimmingCharacters(in: .whitespacesAndNewlines),
                whereBought: whereBought.trimmingCharacters(in: .whitespacesAndNewlines),
                whyBought: whyBought.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            viewModel.updatePurchase(updatedPurchase)
        } else {
            let purchase = Purchase(
                date: date,
                whatBought: whatBought.trimmingCharacters(in: .whitespacesAndNewlines),
                whereBought: whereBought.trimmingCharacters(in: .whitespacesAndNewlines),
                whyBought: whyBought.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            viewModel.addPurchase(purchase)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}
