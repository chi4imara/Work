import SwiftUI

struct EditStyleView: View {
    let styleId: UUID
    @ObservedObject var viewModel: StyleViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var selectedCategory: StyleCategory = .haircut
    @State private var length: String = ""
    @State private var shape: String = ""
    @State private var description: String = ""
    @State private var isFavorite: Bool = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let lengthOptions = ["3mm", "6mm", "9mm", "12mm", "Short", "Medium", "Long", "Custom"]
    let haircutShapes = ["Fade", "Buzz Cut", "Crew Cut", "Undercut", "Pompadour", "Quiff", "Side Part"]
    let beardShapes = ["Full Beard", "Goatee", "Mustache", "Stubble", "Van Dyke", "Circle Beard", "Anchor"]
    
    var currentShapeOptions: [String] {
        selectedCategory == .haircut ? haircutShapes : beardShapes
    }
    
    var style: Style? {
        viewModel.styles.first { $0.id == styleId }
    }
    
    var body: some View {
        Group {
            if let style = style {
                editStyleContent(style: style)
            } else {
                NavigationView {
                    ZStack {
                        ColorTheme.backgroundGradient
                            .ignoresSafeArea()
                        
                        Text("Style not found")
                            .foregroundColor(ColorTheme.white)
                    }
                }
            }
        }
        .onAppear {
            if let style = style {
                name = style.name
                selectedCategory = style.category
                length = style.length
                shape = style.shape
                description = style.description
                isFavorite = style.isFavorite
            }
        }
    }
    
    private func editStyleContent(style: Style) -> some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        HStack {
                            Button("Cancel") {
                                presentationMode.wrappedValue.dismiss()
                            }
                            .font(.lumierepolis(size: 16))
                            .foregroundColor(ColorTheme.white)
                            
                            Spacer()
                            
                            Text("Edit Style")
                                .font(.lumierepolis(size: 20, weight: .bold))
                                .foregroundColor(ColorTheme.white)
                            
                            Spacer()
                            
                            Button("Save") {
                                saveChanges()
                            }
                            .font(.lumierepolis(size: 16, weight: .bold))
                            .foregroundColor(ColorTheme.orange)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        VStack(spacing: 20) {
                            CustomTextField(
                                title: "Name",
                                text: $name,
                                placeholder: "Enter style name"
                            )
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Category")
                                    .font(.lumierepolis(size: 16, weight: .bold))
                                    .foregroundColor(ColorTheme.white)
                                
                                HStack(spacing: 12) {
                                    ForEach(StyleCategory.allCases, id: \.self) { category in
                                        CategoryButton(
                                            category: category,
                                            isSelected: selectedCategory == category
                                        ) {
                                            selectedCategory = category
                                            if !currentShapeOptions.contains(shape) {
                                                shape = ""
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Length")
                                    .font(.lumierepolis(size: 16, weight: .bold))
                                    .foregroundColor(ColorTheme.white)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                                    ForEach(lengthOptions, id: \.self) { option in
                                        OptionButton(
                                            title: option,
                                            isSelected: length == option
                                        ) {
                                            length = option
                                        }
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Shape")
                                    .font(.lumierepolis(size: 16, weight: .bold))
                                    .foregroundColor(ColorTheme.white)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                                    ForEach(currentShapeOptions, id: \.self) { option in
                                        OptionButton(
                                            title: option,
                                            isSelected: shape == option
                                        ) {
                                            shape = option
                                        }
                                    }
                                }
                            }
                            
                            CustomTextEditor(
                                title: "Description",
                                text: $description,
                                placeholder: "Add notes about this style..."
                            )
                            
                            HStack {
                                Text("Add to Favorites")
                                    .font(.lumierepolis(size: 16, weight: .bold))
                                    .foregroundColor(ColorTheme.white)
                                
                                Spacer()
                                
                                Toggle("", isOn: $isFavorite)
                                    .toggleStyle(CustomToggleStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func saveChanges() {
        guard !name.isEmpty else {
            alertMessage = "Please enter a style name"
            showingAlert = true
            return
        }
        
        guard !length.isEmpty else {
            alertMessage = "Please select a length"
            showingAlert = true
            return
        }
        
        guard !shape.isEmpty else {
            alertMessage = "Please select a shape"
            showingAlert = true
            return
        }
        
        guard var updatedStyle = self.style else {
            return
        }
        
        updatedStyle.name = name
        updatedStyle.category = selectedCategory
        updatedStyle.length = length
        updatedStyle.shape = shape
        updatedStyle.description = description
        updatedStyle.isFavorite = isFavorite
        
        viewModel.updateStyle(updatedStyle)
        presentationMode.wrappedValue.dismiss()
    }
}
