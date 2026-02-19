import SwiftUI

struct AddDeviceView: View {
    @ObservedObject var viewModel: DeviceViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var selectedCategory = DeviceCategory.phones
    @State private var purchaseDate = Date()
    @State private var specifications = ""
    @State private var selectedCondition = DeviceCondition.new
    @State private var comment = ""
    
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
                        
                        Button(action: saveDevice) {
                            Text("Save")
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
            .navigationTitle("New Device")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(AppColors.accentBlue)
            )
        }
    }
    
    private func saveDevice() {
        let device = Device(
            name: name,
            category: selectedCategory,
            purchaseDate: purchaseDate,
            specifications: specifications,
            condition: selectedCondition,
            comment: comment
        )
        
        viewModel.addDevice(device)
        presentationMode.wrappedValue.dismiss()
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            TextField(placeholder, text: $text)
                .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                .foregroundColor(AppColors.primaryText)
                .padding(16)
                .background(AppColors.secondaryBackground.opacity(0.6))
                .cornerRadius(12)
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
                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(AppColors.primaryText)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                
                if text.isEmpty {
                    Text(placeholder)
                        .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                        .foregroundColor(AppColors.secondaryText.opacity(0.6))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 12)
                        .allowsHitTesting(false)
                }
            }
            .frame(minHeight: 100)
            .padding(8)
            .background(AppColors.secondaryBackground.opacity(0.6))
            .cornerRadius(12)
        }
    }
}

struct CustomPicker<T: Hashable & Identifiable, Content: View>: View {
    let title: String
    @Binding var selection: T
    let options: [T]
    let content: (T) -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            Menu {
                ForEach(options, id: \.id) { option in
                    Button(action: {
                        selection = option
                    }) {
                        content(option)
                    }
                }
            } label: {
                HStack {
                    content(selection)
                        .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
                .padding(16)
                .background(AppColors.secondaryBackground.opacity(0.6))
                .cornerRadius(12)
            }
        }
    }
}

struct CustomDatePicker: View {
    let title: String
    @Binding var selection: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            DatePicker("", selection: $selection, displayedComponents: .date)
                .datePickerStyle(.compact)
                .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                .foregroundColor(AppColors.primaryText)
                .padding(16)
                .background(AppColors.secondaryBackground.opacity(0.6))
                .cornerRadius(12)
        }
    }
}

#Preview {
    AddDeviceView(viewModel: DeviceViewModel())
}
