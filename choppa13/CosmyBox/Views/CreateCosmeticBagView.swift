import SwiftUI

struct CreateCosmeticBagView: View {
    @ObservedObject var viewModel: CosmeticBagViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let bagToEdit: CosmeticBag?
    
    @State private var name: String = ""
    @State private var selectedPurpose: BagPurpose = .mixed
    @State private var selectedColor: BagColor = .blue
    @State private var description: String = ""
    @State private var isActive: Bool = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    init(viewModel: CosmeticBagViewModel, bagToEdit: CosmeticBag? = nil) {
        self.viewModel = viewModel
        self.bagToEdit = bagToEdit
    }
    
    var isEditing: Bool {
        bagToEdit != nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text(isEditing ? "Edit Cosmetic Bag" : "New Cosmetic Bag")
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(Color.theme.primaryWhite)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            FormField(title: "Name") {
                                TextField("Enter bag name", text: $name)
                                    .font(.ubuntu(16, weight: .regular))
                                    .padding(16)
                                    .background(Color.theme.primaryWhite)
                                    .cornerRadius(12)
                            }
                            
                            FormField(title: "Purpose") {
                                Menu {
                                    ForEach(BagPurpose.allCases, id: \.self) { purpose in
                                        Button(purpose.displayName) {
                                            selectedPurpose = purpose
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedPurpose.displayName)
                                            .font(.ubuntu(16, weight: .regular))
                                            .foregroundColor(Color.theme.darkGray)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(Color.theme.darkGray.opacity(0.5))
                                    }
                                    .padding(16)
                                    .background(Color.theme.primaryWhite)
                                    .cornerRadius(12)
                                }
                            }
                            
                            FormField(title: "Color Tag") {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                                    ForEach(BagColor.allCases, id: \.self) { color in
                                        Button(action: {
                                            selectedColor = color
                                        }) {
                                            VStack(spacing: 8) {
                                                Circle()
                                                    .fill(color.color)
                                                    .frame(width: 40, height: 40)
                                                    .overlay(
                                                        Circle()
                                                            .stroke(Color.theme.primaryWhite, lineWidth: selectedColor == color ? 3 : 0)
                                                    )
                                                
                                                Text(color.displayName)
                                                    .font(.ubuntu(12, weight: .medium))
                                                    .foregroundColor(Color.theme.darkGray)
                                            }
                                        }
                                        .scaleEffect(selectedColor == color ? 1.1 : 1.0)
                                        .animation(.easeInOut(duration: 0.2), value: selectedColor)
                                    }
                                }
                                .padding(16)
                                .background(Color.theme.primaryWhite)
                                .cornerRadius(12)
                            }
                            
                            FormField(title: "Description") {
                                TextField("Optional description", text: $description, axis: .vertical)
                                    .font(.ubuntu(16, weight: .regular))
                                    .lineLimit(3...6)
                                    .padding(16)
                                    .background(Color.theme.primaryWhite)
                                    .cornerRadius(12)
                            }
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Make Active")
                                        .font(.ubuntu(16, weight: .medium))
                                        .foregroundColor(Color.theme.primaryWhite)
                                    
                                    Text("Set as your primary cosmetic bag")
                                        .font(.ubuntu(14, weight: .regular))
                                        .foregroundColor(Color.theme.primaryWhite.opacity(0.7))
                                }
                                
                                Spacer()
                                
                                Toggle("", isOn: $isActive)
                                    .toggleStyle(SwitchToggleStyle(tint: Color.theme.primaryYellow))
                            }
                            .padding(16)
                            .background(Color.theme.primaryWhite.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                        
                        Button(action: saveBag) {
                            Text("Save")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(Color.theme.primaryWhite)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.theme.buttonGradient)
                                .cornerRadius(28)
                                .shadow(color: Color.theme.primaryPurple.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color.theme.primaryWhite)
                }
            }
        }
        .onAppear {
            setupInitialValues()
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func setupInitialValues() {
        if let bag = bagToEdit {
            name = bag.name
            selectedPurpose = bag.purpose
            selectedColor = bag.colorTag
            description = bag.description
            isActive = bag.isActive
        }
    }
    
    private func saveBag() {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Please enter a name for the cosmetic bag."
            showingAlert = true
            return
        }
        
        if let bagToEdit = bagToEdit {
            var updatedBag = bagToEdit
            updatedBag.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedBag.purpose = selectedPurpose
            updatedBag.colorTag = selectedColor
            updatedBag.description = description.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedBag.isActive = isActive
            
            viewModel.updateCosmeticBag(updatedBag)
        } else {
            let newBag = CosmeticBag(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                purpose: selectedPurpose,
                colorTag: selectedColor,
                description: description.trimmingCharacters(in: .whitespacesAndNewlines),
                isActive: isActive
            )
            
            viewModel.addCosmeticBag(newBag)
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
                .foregroundColor(Color.theme.primaryWhite)
            
            content
        }
    }
}

#Preview {
    CreateCosmeticBagView(viewModel: CosmeticBagViewModel())
}
