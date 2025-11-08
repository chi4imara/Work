import SwiftUI

struct ShoppingListView: View {
    @ObservedObject var recipeViewModel: RecipeViewModel
    @State private var searchText = ""
    @State private var showingAddItem = false
    @State private var newItemName = ""
    @State private var customIngredients: [String] = []
    
    private var allIngredients: [String] {
        let recipeIngredients = recipeViewModel.recipes.flatMap { $0.ingredients }
        let allIngredients = recipeIngredients + customIngredients
        let uniqueIngredients = Array(Set(allIngredients))
        return uniqueIngredients.sorted()
    }
    
    private var filteredIngredients: [String] {
        if searchText.isEmpty {
            return allIngredients
        } else {
            return allIngredients.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Shopping List")
                        .font(.ubuntuTitle)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddItem = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .padding(8)
                    }
                    .buttonStyle(CircularButtonStyle())
                }
                .padding()
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.textSecondary)
                    
                    TextField("Search ingredients...", text: $searchText)
                        .font(.ubuntuBody)
                        .foregroundColor(.textPrimary)
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total ingredients")
                            .font(.ubuntuCaption)
                            .foregroundColor(.textSecondary)
                        
                        Text("\(allIngredients.count)")
                            .font(.ubuntuHeadline)
                            .foregroundColor(.textPrimary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Unique")
                            .font(.ubuntuCaption)
                            .foregroundColor(.textSecondary)
                        
                        Text("\(Set(allIngredients).count)")
                            .font(.ubuntuHeadline)
                            .foregroundColor(.primaryPurple)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                
                if filteredIngredients.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "list.bullet.clipboard")
                            .font(.system(size: 60))
                            .foregroundColor(.textSecondary)
                        
                        Text(searchText.isEmpty ? "No ingredients" : "Ingredients not found")
                            .font(.ubuntuHeadline)
                            .foregroundColor(.textPrimary)
                        
                        Text(searchText.isEmpty ?
                             "Add recipes with ingredients to see them here" :
                                "Try changing your search query")
                        .font(.ubuntuBody)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredIngredients, id: \.self) { ingredient in
                                ShoppingListItemCard(
                                    ingredient: ingredient,
                                    viewModel: recipeViewModel,
                                    onDelete: customIngredients.contains(ingredient) ? {
                                        deleteCustomIngredient(ingredient)
                                    } : nil
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
            .sheet(isPresented: $showingAddItem) {
                AddIngredientSheet(newItemName: $newItemName) {
                    addCustomIngredient()
                }
            }
        }
        .onAppear {
            loadCustomIngredients()
        }
    }
    
    private func addCustomIngredient() {
        let trimmedName = newItemName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedName.isEmpty && !customIngredients.contains(trimmedName) {
            customIngredients.append(trimmedName)
            saveCustomIngredients()
            newItemName = ""
        }
    }
    
    private func saveCustomIngredients() {
        UserDefaults.standard.set(customIngredients, forKey: "CustomIngredients")
    }
    
    private func loadCustomIngredients() {
        if let saved = UserDefaults.standard.array(forKey: "CustomIngredients") as? [String] {
            customIngredients = saved
        }
    }
    
    private func deleteCustomIngredient(_ ingredient: String) {
        customIngredients.removeAll { $0 == ingredient }
        saveCustomIngredients()
    }
}

struct ShoppingListItemCard: View {
    let ingredient: String
    @ObservedObject var viewModel: RecipeViewModel
    let onDelete: (() -> Void)?
    
    init(ingredient: String, viewModel: RecipeViewModel, onDelete: (() -> Void)? = nil) {
        self.ingredient = ingredient
        self.viewModel = viewModel
        self.onDelete = onDelete
    }
    
    private var isPurchased: Bool {
        viewModel.isIngredientPurchased(ingredient)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    viewModel.togglePurchasedState(for: ingredient)
                }
            }) {
                Image(systemName: isPurchased ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(isPurchased ? .accentGreen : .textSecondary)
            }
            
            Text(ingredient)
                .font(.ubuntuBody)
                .foregroundColor(isPurchased ? .textTertiary : .textPrimary)
                .strikethrough(isPurchased)
            
            Spacer()
            
            if let onDelete = onDelete {
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 16))
                        .foregroundColor(.accentRed)
                }
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
    
    private func getIngredientCount(_ ingredient: String) -> Int {
        return Int.random(in: 1...3)
    }
}

struct AddIngredientSheet: View {
    @Binding var newItemName: String
    let onAdd: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 30) {
                VStack(spacing: 16) {
                    Text("Add Ingredient")
                        .font(.ubuntuHeadline)
                        .foregroundColor(.textPrimary)
                    
                    TextField("Ingredient name", text: $newItemName)
                        .font(.ubuntuBody)
                        .foregroundColor(.textPrimary)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 30)
                .padding(.top, 50)
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .font(.ubuntuHeadline)
                            .foregroundColor(.textSecondary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                    }
                    
                    Button {
                        onAdd()
                        dismiss()
                    } label: {
                        Text("Add")
                            .font(.ubuntuHeadline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                LinearGradient(
                                    colors: [Color.primaryPurple, Color.primaryBlue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                    }
                    .disabled(newItemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
    }
}

struct CircularButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(12)
            .foregroundColor(.white)
            .background(Color.primaryPurple.opacity(0.45))
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}
