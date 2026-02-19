import SwiftUI

struct EditGadgetView: View {
    let gadgetId: UUID
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
    @Environment(\.dismiss) private var dismiss
    
    private var gadget: Gadget? {
        gadgetViewModel.gadgets.first { $0.id == gadgetId }
    }
    
    var body: some View {
        Group {
            if let gadget = gadget {
                NavigationView {
                    ZStack {
                        Color.theme.primaryGradient
                            .ignoresSafeArea()
                        
                        ScrollView {
                            VStack(spacing: 20) {
                                VStack(spacing: 8) {
                                    Text("Edit Gadget")
                                        .font(.playfairDisplay(size: 28, weight: .bold))
                                        .foregroundColor(Color.theme.primaryText)
                                    
                                    Text("Update your device information")
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
                                
                                Button(action: saveChanges) {
                                    Text("Save Changes")
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
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(Color.theme.lightBlue)
                            }
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
                    loadGadgetData(gadget: gadget)
                }
                .onChange(of: gadgetViewModel.gadgets) { _ in
                    if let updatedGadget = gadgetViewModel.gadgets.first(where: { $0.id == gadgetId }) {
                        loadGadgetData(gadget: updatedGadget)
                    }
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !name.isEmpty && !selectedCategory.isEmpty && !price.isEmpty && !condition.isEmpty && !serviceLife.isEmpty
    }
    
    private func loadGadgetData(gadget: Gadget) {
        name = gadget.name
        selectedCategory = gadget.category
        purchaseDate = gadget.purchaseDate
        price = gadget.price
        condition = gadget.condition
        serviceLife = gadget.serviceLife
        comment = gadget.comment
    }
    
    private func saveChanges() {
        guard var updatedGadget = gadget else { return }
        updatedGadget.name = name
        updatedGadget.category = selectedCategory
        updatedGadget.purchaseDate = purchaseDate
        updatedGadget.price = price
        updatedGadget.condition = condition
        updatedGadget.serviceLife = serviceLife
        updatedGadget.comment = comment
        
        gadgetViewModel.updateGadget(updatedGadget)
        dismiss()
    }
}

#Preview {
    NavigationView {
        EditGadgetView(
            gadgetId: UUID(),
            gadgetViewModel: {
                let vm = GadgetViewModel()
                let gadget = Gadget(
                    name: "iPhone 13",
                    category: "Phone",
                    purchaseDate: Date(),
                    price: "$899",
                    condition: "Excellent",
                    serviceLife: "2",
                    comment: "Used for work"
                )
                vm.gadgets = [gadget]
                return vm
            }()
        )
    }
}
