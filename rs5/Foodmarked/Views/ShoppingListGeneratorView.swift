import SwiftUI

struct ShoppingListGeneratorView: View {
    @EnvironmentObject var productStore: ProductStore
    @State private var selectedCategories: Set<ProductCategory> = []
    @State private var showingGeneratedList = false
    @State private var generatedList: [Product] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("🛒 Shopping List Generator")
                    .font(.playfairDisplay(size: 20, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
            }
            
            Text("Select categories to include in your shopping list")
                .font(.playfairDisplay(size: 13, weight: .regular))
                .foregroundColor(ColorManager.secondaryText)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(ProductCategory.allCases, id: \.self) { category in
                        CategoryChip(
                            category: category,
                            isSelected: selectedCategories.contains(category),
                            count: productStore.products.filter { $0.category == category && $0.status == .suitable }.count
                        ) {
                            if selectedCategories.contains(category) {
                                selectedCategories.remove(category)
                            } else {
                                selectedCategories.insert(category)
                            }
                        }
                    }
                }
            }
            
            Button(action: generateShoppingList) {
                HStack {
                    Image(systemName: "list.bullet.rectangle")
                    Text("Generate Shopping List")
                }
                .font(.playfairDisplay(size: 16, weight: .semibold))
                .foregroundColor(ColorManager.whiteText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(selectedCategories.isEmpty ? AnyShapeStyle(ColorManager.secondaryText.opacity(0.3)) : AnyShapeStyle(ColorManager.buttonGradient))
                )
            }
            .disabled(selectedCategories.isEmpty)
            
            if !generatedList.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Generated List (\(generatedList.count) items)")
                        .font(.playfairDisplay(size: 14, weight: .semibold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(Array(generatedList.enumerated()), id: \.element.id) { index, product in
                                HStack(spacing: 12) {
                                    Text("\(index + 1).")
                                        .font(.playfairDisplay(size: 14, weight: .medium))
                                        .foregroundColor(ColorManager.secondaryText)
                                        .frame(width: 30)
                                    
                                    Text(product.category.icon)
                                        .font(.system(size: 18))
                                    
                                    Text(product.name)
                                        .font(.playfairDisplay(size: 14, weight: .medium))
                                        .foregroundColor(ColorManager.primaryText)
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(ColorManager.lightBlue.opacity(0.3))
                                )
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
                .shadow(color: ColorManager.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .sheet(isPresented: $showingGeneratedList) {
            NavigationView {
                ShoppingListView(products: generatedList)
            }
        }
    }
    
    private func generateShoppingList() {
        var list: [Product] = []
        
        for category in selectedCategories {
            let categoryProducts = productStore.suitableProducts.filter { $0.category == category }
            list.append(contentsOf: categoryProducts)
        }
        
        generatedList = list.sorted { first, second in
            if first.category != second.category {
                return first.category.rawValue < second.category.rawValue
            }
            return first.name < second.name
        }
        
        showingGeneratedList = true
    }
}

struct CategoryChip: View {
    let category: ProductCategory
    let isSelected: Bool
    let count: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(category.icon)
                    .font(.system(size: 16))
                
                Text(category.rawValue)
                    .font(.playfairDisplay(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? ColorManager.whiteText : ColorManager.primaryText)
                
                if count > 0 {
                    Text("(\(count))")
                        .font(.playfairDisplay(size: 11, weight: .regular))
                        .foregroundColor(isSelected ? ColorManager.whiteText.opacity(0.8) : ColorManager.secondaryText)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? AnyShapeStyle(category.color) : AnyShapeStyle(ColorManager.cardGradient))
                    .overlay(
                        Capsule()
                            .stroke(isSelected ? Color.clear : category.color.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
}

struct ShoppingListView: View {
    let products: [Product]
    @Environment(\.presentationMode) var presentationMode
    @State private var shareText = ""
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 8) {
                        Text("Shopping List")
                            .font(.playfairDisplay(size: 28, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Text("\(products.count) items")
                            .font(.playfairDisplay(size: 14, weight: .regular))
                            .foregroundColor(ColorManager.secondaryText)
                    }
                    .padding(.top, 20)
                    
                    let grouped = Dictionary(grouping: products) { $0.category }
                    ForEach(Array(grouped.keys.sorted(by: { $0.rawValue < $1.rawValue })), id: \.self) { category in
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(category.icon)
                                    .font(.system(size: 20))
                                Text(category.rawValue)
                                    .font(.playfairDisplay(size: 18, weight: .semibold))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                Spacer()
                                
                                Text("\(grouped[category]?.count ?? 0) items")
                                    .font(.playfairDisplay(size: 14, weight: .medium))
                                    .foregroundColor(ColorManager.secondaryText)
                            }
                            
                            ForEach(grouped[category] ?? [], id: \.id) { product in
                                HStack {
                                    Circle()
                                        .fill(ColorManager.suitableGreen)
                                        .frame(width: 8, height: 8)
                                    
                                    Text(product.name)
                                        .font(.playfairDisplay(size: 15, weight: .medium))
                                        .foregroundColor(ColorManager.primaryText)
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(ColorManager.cardGradient)
                                )
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(ColorManager.cardGradient)
                                .shadow(color: ColorManager.primaryBlue.opacity(0.1), radius: 2, x: 0, y: 1)
                        )
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 30)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(ColorManager.primaryBlue)
            }
        }
        .sheet(isPresented: .constant(false)) {
            ShareSheet(activityItems: [shareText])
        }
    }
    
    private func shareList() {
        var text = "My Shopping List\n\n"
        
        let grouped = Dictionary(grouping: products) { $0.category }
        for category in grouped.keys.sorted(by: { $0.rawValue < $1.rawValue }) {
            text += "\(category.icon) \(category.rawValue)\n"
            for product in grouped[category] ?? [] {
                text += "  • \(product.name)\n"
            }
            text += "\n"
        }
        
        shareText = text
    }
}
