import SwiftUI

struct AddGadgetView: View {
    @ObservedObject var gadgetViewModel: GadgetViewModel
    @State private var name = ""
    @State private var selectedCategory = ""
    @State private var purchaseDate = Date()
    @State private var price = ""
    @State private var condition = ""
    @State private var serviceLife = ""
    @State private var comment = ""
    @State private var showingCategoryPicker = false
    @State private var showingDatePicker = false
    
    var body: some View {
        ZStack {
            Color.theme.primaryGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 8) {
                        Text("New Gadget")
                            .font(.playfairDisplay(size: 28, weight: .bold))
                            .foregroundColor(Color.theme.primaryText)
                        
                        Text("Add your device to the catalog")
                            .font(.playfairDisplay(size: 14))
                            .foregroundColor(Color.theme.secondaryText)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        CustomTextField(
                            title: "Name",
                            text: $name,
                            placeholder: "iPhone 13, MacBook Pro..."
                        )
                        
                        CustomCategoryField(
                            title: "Category",
                            selectedCategory: $selectedCategory,
                            showingPicker: $showingCategoryPicker
                        )
                        
                        CustomDateField(
                            title: "Purchase Date",
                            date: $purchaseDate,
                            showingPicker: $showingDatePicker
                        )
                        
                        CustomTextField(
                            title: "Price",
                            text: $price,
                            placeholder: "$899, $120..."
                        )
                        
                        CustomTextField(
                            title: "Condition",
                            text: $condition,
                            placeholder: "Excellent, Good, Fair..."
                        )
                        
                        CustomTextField(
                            title: "Service Life (years)",
                            text: $serviceLife,
                            placeholder: "2, 5, 7..."
                        )
                        
                        CustomTextEditor(
                            title: "Comment",
                            text: $comment,
                            placeholder: "Additional notes..."
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    Button(action: saveGadget) {
                        Text("Save")
                            .font(.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(Color.theme.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(isFormValid ? AnyShapeStyle(Color.theme.accentGradient) : AnyShapeStyle(Color.theme.mediumGray))
                            )
                    }
                    .disabled(!isFormValid)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
                .padding(.bottom, 120)
            }
        }
        .sheet(isPresented: $showingCategoryPicker) {
            CategoryPickerView(selectedCategory: $selectedCategory)
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerView(selectedDate: $purchaseDate)
        }
    }
    
    private var isFormValid: Bool {
        !name.isEmpty && !selectedCategory.isEmpty && !price.isEmpty && !condition.isEmpty && !serviceLife.isEmpty
    }
    
    private func saveGadget() {
        let newGadget = Gadget(
            name: name,
            category: selectedCategory,
            purchaseDate: purchaseDate,
            price: price,
            condition: condition,
            serviceLife: serviceLife,
            comment: comment
        )
        
        gadgetViewModel.addGadget(newGadget)
        gadgetViewModel.navigateTo(.gadgetSaved(newGadget))
        clearForm()
    }
    
    private func clearForm() {
        name = ""
        selectedCategory = ""
        purchaseDate = Date()
        price = ""
        condition = ""
        serviceLife = ""
        comment = ""
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(size: 16, weight: .medium))
                .foregroundColor(Color.theme.primaryText)
            
            TextField(placeholder, text: $text)
                .font(.playfairDisplay(size: 14))
                .foregroundColor(Color.theme.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.theme.cardBackground)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.theme.lightBlue.opacity(0.3), lineWidth: 1)
                        }
                )
        }
    }
}

struct CustomTextEditor: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(size: 16, weight: .medium))
                .foregroundColor(Color.theme.primaryText)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.theme.cardBackground)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                Color.theme.lightBlue.opacity(0.3),
                                lineWidth: 1
                            )
                    }
                    .frame(minHeight: 100)
                
                if text.isEmpty  {
                    Text(placeholder)
                        .font(.playfairDisplay(size: 14))
                        .foregroundColor(Color.theme.mediumGray)
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .allowsHitTesting(false)
                }
                
                TextEditor(text: $text)
                    .font(.playfairDisplay(size: 14))
                    .foregroundColor(Color.theme.primaryText)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(minHeight: 100)
            }
        }
    }
}

struct CustomCategoryField: View {
    let title: String
    @Binding var selectedCategory: String
    @Binding var showingPicker: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(size: 16, weight: .medium))
                .foregroundColor(Color.theme.primaryText)
            
            Button(action: { showingPicker = true }) {
                HStack {
                    Text(selectedCategory.isEmpty ? "Select category" : selectedCategory)
                        .font(.playfairDisplay(size: 14))
                        .foregroundColor(selectedCategory.isEmpty ? Color.theme.mediumGray : Color.theme.primaryText)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(Color.theme.lightBlue)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.theme.cardBackground)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.theme.lightBlue.opacity(0.3), lineWidth: 1)
                        }
                )
            }
        }
    }
}

struct CustomDateField: View {
    let title: String
    @Binding var date: Date
    @Binding var showingPicker: Bool
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(size: 16, weight: .medium))
                .foregroundColor(Color.theme.primaryText)
            
            Button(action: { showingPicker = true }) {
                HStack {
                    Text(dateFormatter.string(from: date))
                        .font(.playfairDisplay(size: 14))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Spacer()
                    
                    Image(systemName: "calendar")
                        .font(.system(size: 12))
                        .foregroundColor(Color.theme.lightBlue)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.theme.cardBackground)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.theme.lightBlue.opacity(0.3), lineWidth: 1)
                        }
                )
            }
        }
    }
}

struct CategoryPickerView: View {
    @Binding var selectedCategory: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.primaryGradient
                    .ignoresSafeArea()
                
                List(String.commonCategories, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                        dismiss()
                    }) {
                        HStack {
                            Text(category)
                                .font(.playfairDisplay(size: 16))
                                .foregroundColor(Color.theme.primaryText)
                            
                            Spacer()
                            
                            if selectedCategory == category {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color.theme.lightBlue)
                            }
                        }
                    }
                    .listRowBackground(Color.theme.cardBackground)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Select Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.lightBlue)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.primaryGradient
                    .ignoresSafeArea()
                
                VStack {
                    DatePicker("Purchase Date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Purchase Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.lightBlue)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    AddGadgetView(gadgetViewModel: GadgetViewModel())
}
