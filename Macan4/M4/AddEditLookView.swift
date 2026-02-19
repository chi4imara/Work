import SwiftUI

struct AddEditLookView: View {
    @EnvironmentObject var viewModel: MakeupLookViewModel
    @Binding var isPresented: Bool
    
    let lookToEdit: MakeupLook?
    
    @State private var name: String = ""
    @State private var selectedCategory: MakeupCategory = .daily
    @State private var steps: String = ""
    @State private var selectedColors: [String] = []
    @State private var products: String = ""
    @State private var notes: String = ""
    @State private var isFavorite: Bool = false
    @State private var showingColorPicker = false
    
    init(isPresented: Binding<Bool>, lookToEdit: MakeupLook? = nil) {
        self._isPresented = isPresented
        self.lookToEdit = lookToEdit
    }
    
    var isEditing: Bool {
        lookToEdit != nil
    }
    
    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Look Name *")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter look name", text: $name)
                                .font(.playfairDisplay(16))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(AppColors.backgroundWhite.opacity(0.9))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            HStack(spacing: 12) {
                                ForEach(MakeupCategory.allCases, id: \.self) { category in
                                    CategoryButton(
                                        category: category,
                                        isSelected: selectedCategory == category
                                    ) {
                                        selectedCategory = category
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Makeup Steps")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextEditor(text: $steps)
                                .font(.playfairDisplay(14))
                                .padding(12)
                                .frame(minHeight: 100)
                                .background(AppColors.backgroundWhite.opacity(0.9))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Color Palette")
                                    .font(.playfairDisplay(16, weight: .semibold))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Spacer()
                                
                                Button(action: { showingColorPicker = true }) {
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(AppColors.primaryBlue)
                                        .font(.title2)
                                }
                            }
                            
                            if selectedColors.isEmpty {
                                Text("Tap + to add colors")
                                    .font(.playfairDisplay(14))
                                    .foregroundColor(AppColors.secondaryText)
                                    .padding(.vertical, 20)
                                    .frame(maxWidth: .infinity)
                                    .background(AppColors.backgroundWhite.opacity(0.5))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.primaryBlue.opacity(0.2), style: StrokeStyle(lineWidth: 1, lineCap: .round, dash: [5]))
                                    )
                            } else {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                                    ForEach(selectedColors, id: \.self) { colorHex in
                                        ColorCircle(colorHex: colorHex) {
                                            selectedColors.removeAll { $0 == colorHex }
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Products Used")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextEditor(text: $products)
                                .font(.playfairDisplay(14))
                                .padding(12)
                                .frame(minHeight: 80)
                                .background(AppColors.backgroundWhite.opacity(0.9))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes & Comments")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextEditor(text: $notes)
                                .font(.playfairDisplay(14))
                                .padding(12)
                                .frame(minHeight: 80)
                                .background(AppColors.backgroundWhite.opacity(0.9))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        HStack {
                            Text("Mark as Favorite")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                            
                            Button(action: { isFavorite.toggle() }) {
                                Image(systemName: isFavorite ? "star.fill" : "star")
                                    .foregroundColor(isFavorite ? AppColors.primaryYellow : AppColors.secondaryText)
                                    .font(.title2)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle(isEditing ? "Edit Look" : "New Look")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(AppColors.secondaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Save Changes" : "Save") {
                        saveLook()
                    }
                    .foregroundColor(canSave ? AppColors.primaryBlue : AppColors.secondaryText)
                    .disabled(!canSave)
                }
            }
        }
        .sheet(isPresented: $showingColorPicker) {
            ColorPickerView(selectedColors: $selectedColors)
        }
        .onAppear {
            loadLookData()
        }
    }
    
    private func loadLookData() {
        if let look = lookToEdit {
            name = look.name
            selectedCategory = look.category
            steps = look.steps.joined(separator: "\n")
            selectedColors = look.colors
            products = look.products
            notes = look.notes
            isFavorite = look.isFavorite
        }
    }
    
    private func saveLook() {
        let stepsArray = steps.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        if let existingLook = lookToEdit {
            var updatedLook = existingLook
            updatedLook.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedLook.category = selectedCategory
            updatedLook.steps = stepsArray
            updatedLook.colors = selectedColors
            updatedLook.products = products.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedLook.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedLook.isFavorite = isFavorite
            
            viewModel.updateMakeupLook(updatedLook)
        } else {
            let newLook = MakeupLook(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                category: selectedCategory,
                steps: stepsArray,
                colors: selectedColors,
                products: products.trimmingCharacters(in: .whitespacesAndNewlines),
                notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
                isFavorite: isFavorite
            )
            
            viewModel.addMakeupLook(newLook)
        }
        
        isPresented = false
    }
}

struct CategoryButton: View {
    let category: MakeupCategory
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? AppColors.contrastText : AppColors.primaryBlue)
                
                Text(category.displayName)
                    .font(.playfairDisplay(9, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.contrastText : AppColors.primaryBlue)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(isSelected ? AppColors.primaryYellow : AppColors.backgroundWhite.opacity(0.8))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? AppColors.primaryYellow : AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

struct ColorCircle: View {
    let colorHex: String
    let onRemove: () -> Void
    
    var body: some View {
        ZStack {
            Circle()
                .fill(ColorPalette.colorFromHex(colorHex))
                .frame(width: 40, height: 40)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
            
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.caption)
                    .foregroundColor(.white)
                    .background(Circle().fill(Color.black.opacity(0.6)).frame(width: 16, height: 16))
            }
            .offset(x: 14, y: -14)
        }
    }
}

struct ColorPickerView: View {
    @Binding var selectedColors: [String]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                        ForEach(ColorPalette.availableColors, id: \.self) { colorHex in
                            Button(action: {
                                if !selectedColors.contains(colorHex) && selectedColors.count < 8 {
                                    selectedColors.append(colorHex)
                                }
                            }) {
                                Circle()
                                    .fill(ColorPalette.colorFromHex(colorHex))
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 3)
                                    )
                                    .overlay(
                                        selectedColors.contains(colorHex) ?
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .font(.title2)
                                            .background(Circle().fill(Color.black.opacity(0.6)).frame(width: 30, height: 30))
                                        : nil
                                    )
                                    .scaleEffect(selectedColors.contains(colorHex) ? 0.9 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: selectedColors.contains(colorHex))
                            }
                            .disabled(selectedColors.contains(colorHex))
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Choose Colors")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
        }
    }
}

struct AddLookView: View {
    @EnvironmentObject var viewModel: MakeupLookViewModel
    @State private var showingAddLook = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    Image(systemName: "plus.circle")
                        .font(.system(size: 80, weight: .light))
                        .foregroundColor(AppColors.primaryBlue)
                    
                    VStack(spacing: 16) {
                        Text("Create New Look")
                            .font(.playfairDisplay(28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Capture your makeup inspiration and save it for later")
                            .font(.playfairDisplay(16))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    
                    Button(action: { showingAddLook = true }) {
                        HStack(spacing: 12) {
                            Image(systemName: "plus")
                            Text("Add New Look")
                        }
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(AppColors.contrastText)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(AppColors.primaryYellow)
                        .cornerRadius(30)
                        .shadow(color: AppColors.primaryYellow.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Add Look")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingAddLook) {
            AddEditLookView(isPresented: $showingAddLook)
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    AddEditLookView(isPresented: .constant(true))
        .environmentObject(MakeupLookViewModel())
}
