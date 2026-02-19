import SwiftUI

struct NewStyleView: View {
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
    
    var body: some View {
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
                            
                            Text("New Style")
                                .font(.lumierepolis(size: 20, weight: .bold))
                                .foregroundColor(ColorTheme.white)
                            
                            Spacer()
                            
                            Button("Save") {
                                saveStyle()
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
                                            shape = ""
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
    
    private func saveStyle() {
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
        
        let newStyle = Style(
            name: name,
            category: selectedCategory,
            length: length,
            shape: shape,
            description: description,
            isFavorite: isFavorite
        )
        
        viewModel.addStyle(newStyle)
        presentationMode.wrappedValue.dismiss()
    }
}

struct CategoryButton: View {
    let category: StyleCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: category == .haircut ? "scissors" : "mustache")
                    .font(.system(size: 16, weight: .medium))
                
                Text(category.displayName)
                    .font(.lumierepolis(size: 14, weight: .regular))
            }
            .foregroundColor(isSelected ? ColorTheme.white : ColorTheme.white.opacity(0.7))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? ColorTheme.orange : ColorTheme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(ColorTheme.white.opacity(0.2), lineWidth: 1)
                    )
            )
        }
    }
}

struct OptionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.lumierepolis(size: 12))
                .foregroundColor(isSelected ? ColorTheme.white : ColorTheme.white.opacity(0.7))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? ColorTheme.orange : ColorTheme.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(ColorTheme.white.opacity(0.2), lineWidth: 1)
                        )
                )
        }
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.lumierepolis(size: 16, weight: .bold))
                .foregroundColor(ColorTheme.white)
            
            TextField("", text: $text)
                .font(.lumierepolis(size: 16))
                .foregroundColor(ColorTheme.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .overlay(
                    Group {
                        if text.isEmpty {
                            HStack {
                                Text(placeholder)
                                    .font(.lumierepolis(size: 16))
                                    .foregroundColor(ColorTheme.white.opacity(0.5))
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                        }
                    },
                    alignment: .leading
                )
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorTheme.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(ColorTheme.white.opacity(0.2), lineWidth: 1)
                        )
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
                .font(.lumierepolis(size: 16, weight: .bold))
                .foregroundColor(ColorTheme.white)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorTheme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ColorTheme.white.opacity(0.2), lineWidth: 1)
                    )
                    .frame(minHeight: 100)
                
                if text.isEmpty {
                    Text(placeholder)
                        .font(.lumierepolis(size: 16))
                        .foregroundColor(ColorTheme.white.opacity(0.5))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                }
                
                TextEditor(text: $text)
                    .font(.lumierepolis(size: 16))
                    .foregroundColor(ColorTheme.white)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.clear)
            }
        }
    }
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack {
                Image(systemName: configuration.isOn ? "heart.fill" : "heart")
                    .font(.system(size: 20))
                    .foregroundColor(configuration.isOn ? ColorTheme.orange : ColorTheme.white.opacity(0.6))
            }
        }
    }
}
