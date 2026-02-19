import SwiftUI

struct EditDeviceView: View {
    let device: Device
    @ObservedObject var viewModel: DeviceViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var selectedCategory: DeviceCategory
    @State private var purchaseDate: Date
    @State private var specifications: String
    @State private var selectedCondition: DeviceCondition
    @State private var comment: String
    
    init(device: Device, viewModel: DeviceViewModel) {
        self.device = device
        self.viewModel = viewModel
        
        _name = State(initialValue: device.name)
        _selectedCategory = State(initialValue: device.category)
        _purchaseDate = State(initialValue: device.purchaseDate)
        _specifications = State(initialValue: device.specifications)
        _selectedCondition = State(initialValue: device.condition)
        _comment = State(initialValue: device.comment)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.primaryGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        CustomTextField(
                            title: "Name",
                            text: $name,
                            placeholder: "Enter device name"
                        )
                        
                        CustomPicker(
                            title: "Category",
                            selection: $selectedCategory,
                            options: DeviceCategory.allCases
                        ) { category in
                            Text(category.displayName)
                        }
                        
                        CustomDatePicker(
                            title: "Purchase Date",
                            selection: $purchaseDate
                        )
                        
                        CustomTextEditor(
                            title: "Technical Specifications",
                            text: $specifications,
                            placeholder: "Enter technical specifications"
                        )
                        
                        CustomPicker(
                            title: "Condition",
                            selection: $selectedCondition,
                            options: DeviceCondition.allCases
                        ) { condition in
                            Text(condition.rawValue)
                        }
                        
                        CustomTextEditor(
                            title: "Comment",
                            text: $comment,
                            placeholder: "Additional notes (optional)"
                        )
                        
                        Button(action: saveChanges) {
                            Text("Save Changes")
                                .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    LinearGradient(
                                        colors: [AppColors.accentBlue, AppColors.accentPurple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                        }
                        .disabled(name.isEmpty)
                        .opacity(name.isEmpty ? 0.6 : 1.0)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit Device")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(AppColors.accentBlue)
            )
        }
    }
    
    private func saveChanges() {
        let updatedDevice = Device(
            id: device.id,
            name: name,
            category: selectedCategory,
            purchaseDate: purchaseDate,
            specifications: specifications,
            condition: selectedCondition,
            comment: comment
        )
        
        viewModel.updateDevice(updatedDevice)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditDeviceView(
        device: Device(
            name: "iPhone 13 Pro",
            category: .phones,
            purchaseDate: Date(),
            specifications: "256 GB, Sierra Blue, 120Hz, 3 cameras",
            condition: .used,
            comment: "Main smartphone"
        ),
        viewModel: DeviceViewModel()
    )
}
