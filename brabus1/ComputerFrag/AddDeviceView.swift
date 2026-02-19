import SwiftUI

struct AddDeviceView: View {
    @ObservedObject var viewModel: DeviceViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let deviceId: UUID?
    
    @State private var name = ""
    @State private var selectedCategory: DeviceCategory = .pc
    @State private var selectedSubcategory = ""
    @State private var description = ""
    
    init(viewModel: DeviceViewModel, deviceId: UUID? = nil) {
        self.viewModel = viewModel
        self.deviceId = deviceId
    }
    
    private var isEditMode: Bool {
        deviceId != nil
    }
    
    private var device: Device? {
        guard let deviceId = deviceId else { return nil }
        return viewModel.getDevice(by: deviceId)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerView
                        
                        formView
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            if let device = device {
                name = device.name
                selectedCategory = device.category
                selectedSubcategory = device.subcategory
                description = device.description
            } else {
                selectedSubcategory = selectedCategory.subcategories.first ?? ""
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
            }
            
            Spacer()
            
            Text(isEditMode ? "Edit Device" : "New Device")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            Button(action: saveDevice) {
                Text("Save")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(isFormValid ? ColorTheme.primaryText : ColorTheme.secondaryText)
            }
            .disabled(!isFormValid)
        }
        .padding(.top, 20)
    }
    
    private var formView: some View {
        VStack(spacing: 20) {
            FormField(title: "Device Name") {
                TextField("Enter device name", text: $name)
                    .font(.ubuntu(16))
                    .foregroundColor(ColorTheme.primaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .cardStyle()
            }
            
            FormField(title: "Category") {
                VStack(spacing: 12) {
                    ForEach(DeviceCategory.allCases, id: \.self) { category in
                        CategorySelectionRow(
                            category: category,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                            selectedSubcategory = category.subcategories.first ?? ""
                        }
                    }
                }
            }
            
            FormField(title: "Subcategory") {
                Menu {
                    ForEach(selectedCategory.subcategories, id: \.self) { subcategory in
                        Button(subcategory) {
                            selectedSubcategory = subcategory
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedSubcategory.isEmpty ? "Select subcategory" : selectedSubcategory)
                            .font(.ubuntu(16))
                            .foregroundColor(selectedSubcategory.isEmpty ? ColorTheme.secondaryText : ColorTheme.primaryText)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 14))
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .cardStyle()
                }
            }
            
            FormField(title: "Description") {
                TextField("Enter description (optional)", text: $description, axis: .vertical)
                    .font(.ubuntu(16))
                    .foregroundColor(ColorTheme.primaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .cardStyle()
                    .lineLimit(3...6)
            }
        }
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !selectedSubcategory.isEmpty
    }
    
    private func saveDevice() {
        if isEditMode, var existingDevice = device {
            existingDevice.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            existingDevice.category = selectedCategory
            existingDevice.subcategory = selectedSubcategory
            existingDevice.description = description.trimmingCharacters(in: .whitespacesAndNewlines)
            
            viewModel.updateDevice(existingDevice)
        } else {
            let newDevice = Device(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                category: selectedCategory,
                subcategory: selectedSubcategory,
                description: description.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            
            viewModel.addDevice(newDevice)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct FormField<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(ColorTheme.primaryText)
            
            content
        }
    }
}

struct CategorySelectionRow: View {
    let category: DeviceCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: categoryIcon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? ColorTheme.primaryText : ColorTheme.accentYellow)
                    .frame(width: 30)
                
                Text(category.rawValue)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(ColorTheme.accentYellow)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? ColorTheme.accentYellow.opacity(0.2) : ColorTheme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? ColorTheme.accentYellow : ColorTheme.cardBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var categoryIcon: String {
        switch category {
        case .pc:
            return "desktopcomputer"
        case .console:
            return "gamecontroller"
        case .peripherals:
            return "keyboard"
        case .accessories:
            return "cable.connector"
        }
    }
}

#Preview {
    AddDeviceView(viewModel: DeviceViewModel())
}
