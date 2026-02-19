import SwiftUI

struct NewPurchaseView: View {
    @ObservedObject var viewModel: PurchaseViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var selectedCategory = PurchaseCategory.clothing
    @State private var plannedAmount = ""
    @State private var selectedDate = Date()
    @State private var notes = ""
    @State private var showingDatePicker = false
    
    private var isValidForm: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !plannedAmount.isEmpty &&
        Double(plannedAmount) != nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        VStack(spacing: 8) {
                            Text("New Purchase")
                                .font(FontManager.playfairBold(size: 28))
                                .foregroundColor(Color.theme.primaryWhite)
                            
                            Text("Add item to your shopping list")
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
                            
                            FormField(title: "Date & Time") {
                                Button(action: {
                                    showingDatePicker.toggle()
                                }) {
                                    HStack {
                                        Text(selectedDate, style: .date)
                                            .font(FontManager.playfairRegular(size: 16))
                                            .foregroundColor(Color.theme.primaryWhite)
                                        
                                        Spacer()
                                        
                                        Text(selectedDate, style: .time)
                                            .font(FontManager.playfairRegular(size: 16))
                                            .foregroundColor(Color.theme.primaryWhite.opacity(0.7))
                                        
                                        Image(systemName: "calendar")
                                            .foregroundColor(Color.theme.primaryYellow)
                                    }
                                    .padding()
                                    .background(Color.theme.cardGradient)
                                    .cornerRadius(12)
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
                            Button(action: savePurchase) {
                                Text("Save Purchase")
                                    .font(FontManager.playfairSemiBold(size: 18))
                                    .foregroundColor(isValidForm ? Color.theme.darkBlue : Color.theme.primaryWhite.opacity(0.5))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(isValidForm ? Color.theme.primaryYellow : Color.theme.primaryWhite.opacity(0.2))
                                    .cornerRadius(28)
                                    .shadow(color: isValidForm ? Color.theme.primaryYellow.opacity(0.3) : Color.clear, radius: 10, x: 0, y: 5)
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
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerSheet(selectedDate: $selectedDate)
        }
    }
    
    private func savePurchase() {
        guard isValidForm,
              let amount = Double(plannedAmount) else { return }
        
        let purchase = Purchase(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            plannedAmount: amount,
            date: selectedDate,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addPurchase(purchase)
        dismiss()
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
                    .font(FontManager.playfairSemiBold(size: 16))
                    .foregroundColor(Color.theme.primaryWhite)
                
                if isRequired {
                    Text("*")
                        .font(FontManager.playfairSemiBold(size: 16))
                        .foregroundColor(Color.theme.primaryYellow)
                }
                
                Spacer()
            }
            
            content
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(FontManager.playfairRegular(size: 16))
            .foregroundColor(Color.theme.primaryWhite)
            .padding()
            .background(Color.theme.cardGradient)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.theme.primaryWhite.opacity(0.2), lineWidth: 1)
            )
    }
}

struct CategorySelector: View {
    @Binding var selectedCategory: PurchaseCategory
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            ForEach(PurchaseCategory.allCases, id: \.self) { category in
                CategorySelectionCard(
                    category: category,
                    isSelected: selectedCategory == category
                ) {
                    selectedCategory = category
                }
            }
        }
    }
}

struct CategorySelectionCard: View {
    let category: PurchaseCategory
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? Color.theme.darkBlue : Color.theme.primaryYellow)
                
                Text(category.rawValue)
                    .font(FontManager.playfairMedium(size: 14))
                    .foregroundColor(isSelected ? Color.theme.darkBlue : Color.theme.primaryWhite)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(isSelected ? AnyShapeStyle(Color.theme.primaryYellow) : AnyShapeStyle(Color.theme.cardGradient))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.theme.primaryYellow : Color.theme.primaryWhite.opacity(0.2), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack {
                    DatePicker("Select Date & Time", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .font(FontManager.playfairSemiBold(size: 18))
                            .foregroundColor(Color.theme.darkBlue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.theme.primaryYellow)
                            .cornerRadius(28)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Select Date & Time")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackground(Color.clear)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.primaryYellow)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    NewPurchaseView(viewModel: PurchaseViewModel())
}
