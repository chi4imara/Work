import SwiftUI

struct AddFullScreenView: View {
    @EnvironmentObject var viewModel: MakeupLookViewModel
    @Binding var selectedTab: Int
    
    let lookToEdit: MakeupLook?
    
    @State private var name: String = ""
    @State private var selectedCategory: MakeupCategory = .daily
    @State private var steps: String = ""
    @State private var selectedColors: [String] = []
    @State private var products: String = ""
    @State private var notes: String = ""
    @State private var isFavorite: Bool = false
    @State private var showingColorPicker = false
    
    init(selectedTab: Binding<Int>, lookToEdit: MakeupLook? = nil) {
        self._selectedTab = selectedTab
        self.lookToEdit = lookToEdit
    }
    
    var isEditing: Bool {
        lookToEdit != nil
    }
    
    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
            ZStack {
                AnimatedBackground()
                
                VStack {
                    HStack {
                        Text("Add Look")
                            .font(.playfairDisplay(28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Button(isEditing ? "Save Changes" : "Save") {
                            saveLook()
                        }
                        .foregroundColor(canSave ? AppColors.primaryBlue : AppColors.secondaryText)
                        .disabled(!canSave)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
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
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
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
                                    .scrollContentBackground(.hidden)
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
                                    .scrollContentBackground(.hidden)
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
        
        withAnimation {
            selectedTab = 0
            name = ""
            selectedCategory = .daily
            steps = ""
            selectedColors = []
            products = ""
            notes = ""
            isFavorite = false
        }
    }
}
