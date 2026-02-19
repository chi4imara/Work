import SwiftUI

struct BudgetSettingsView: View {
    @ObservedObject var budgetViewModel: BudgetViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var budgetLimitText = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    HStack {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(.lumierepolis(16, weight: .light))
                        .foregroundColor(Color.theme.textWhite)
                        
                        Spacer()
                        
                        Text("Budget Settings")
                            .font(.lumierepolis(20, weight: .bold))
                            .foregroundColor(Color.theme.textWhite)
                        
                        Spacer()
                        
                        Button("") { }
                            .font(.lumierepolis(16, weight: .light))
                            .foregroundColor(Color.clear)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    VStack(spacing: 25) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Budget Limit")
                                .font(.lumierepolis(18, weight: .bold))
                                .foregroundColor(Color.theme.textWhite)
                            
                            HStack {
                                Text("$")
                                    .font(.lumierepolis(20, weight: .bold))
                                    .foregroundColor(Color.theme.textBlack)
                                
                                TextField("e.g. 300", text: $budgetLimitText)
                                    .font(.lumierepolis(18, weight: .light))
                                    .foregroundColor(Color.theme.textBlack)
                                    .keyboardType(.decimalPad)
                            }
                            .padding(16)
                            .background(Color.theme.cardWhite)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                        
                        Text("This is the amount you plan to spend on clothing.")
                            .font(.lumierepolis(14, weight: .light))
                            .foregroundColor(Color.theme.textWhite.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    Button(action: saveBudgetLimit) {
                        Text("Save Budget Limit")
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
        .navigationBarHidden(true)
        .onAppear {
            budgetLimitText = budgetViewModel.budget.limit > 0 ? String(format: "%.0f", budgetViewModel.budget.limit) : ""
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private var isValidInput: Bool {
        guard let amount = Double(budgetLimitText), amount > 0 else {
            return false
        }
        return true
    }
    
    private func saveBudgetLimit() {
        guard let amount = Double(budgetLimitText), amount > 0 else {
            alertMessage = "Please enter a valid amount greater than 0."
            showingAlert = true
            return
        }
        
        if amount > 1000000 {
            alertMessage = "Budget limit cannot exceed $1,000,000."
            showingAlert = true
            return
        }
        
        budgetViewModel.setBudgetLimit(amount)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    BudgetSettingsView(budgetViewModel: BudgetViewModel())
}
