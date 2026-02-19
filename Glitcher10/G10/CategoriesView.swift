import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: ShoppingViewModel
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("Categories")
                        .font(FontManager.ubuntu(size: 28, weight: .bold))
                        .foregroundColor(ColorManager.white)
                    
                    if !viewModel.categories.isEmpty {
                        Text("\(viewModel.categories.count) categories")
                            .font(FontManager.ubuntu(size: 16))
                            .foregroundColor(ColorManager.white.opacity(0.7))
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
                
                if !viewModel.categories.isEmpty {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.categories, id: \.id) { category in
                                NavigationLink(destination: CategoryItemsView(categoryName: category.name, viewModel: viewModel)) {
                                    CategoryCard(category: category)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                } else {
                    EmptyStateView(
                        iconName: "folder",
                        title: "No Categories Yet",
                        description: "Categories are not created yet.",
                        actionTitle: "Add First Item",
                        action: {
                            viewModel.selectedTab = .add
                        }
                    )
                }
            }
        }
    }
}

struct CategoryCard: View {
    let category: Category
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorManager.lightBlue.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: categoryIcon(for: category.name))
                    .font(.system(size: 24))
                    .foregroundColor(ColorManager.lightBlue)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(category.name)
                    .font(FontManager.ubuntu(size: 20, weight: .medium))
                    .foregroundColor(ColorManager.white)
                
                Text("\(category.itemCount) \(category.itemCount == 1 ? "item" : "items")")
                    .font(FontManager.ubuntu(size: 14))
                    .foregroundColor(ColorManager.orange)
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(ColorManager.white.opacity(0.6))
                
                Text("Open")
                    .font(FontManager.ubuntu(size: 12))
                    .foregroundColor(ColorManager.white.opacity(0.6))
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorManager.lightBlue.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: ColorManager.darkBlue.opacity(0.3), radius: 8, x: 0, y: 4)
    }
    
    private func categoryIcon(for category: String) -> String {
        switch category.lowercased() {
        case "oils", "oil":
            return "drop.fill"
        case "parts", "part":
            return "gearshape.fill"
        case "tools", "tool":
            return "wrench.fill"
        case "materials", "material":
            return "cube.fill"
        default:
            return "tag.fill"
        }
    }
}

struct CategoryItemsView: View {
    @Environment(\.dismiss) var dismiss
    let categoryName: String
    @ObservedObject var viewModel: ShoppingViewModel
    
    private var categoryItems: [ShoppingItem] {
        viewModel.getItemsForCategory(categoryName)
    }
    
    private var itemCount: Int {
        categoryItems.count
    }
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text(categoryName)
                        .font(FontManager.ubuntu(size: 28, weight: .bold))
                        .foregroundColor(ColorManager.white)
                    
                    Text("\(itemCount) \(itemCount == 1 ? "item" : "items")")
                        .font(FontManager.ubuntu(size: 16))
                        .foregroundColor(ColorManager.white.opacity(0.7))
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(categoryItems, id: \.id) { item in
                            NavigationLink(destination: ItemDetailView(itemId: item.id, viewModel: viewModel)) {
                                CategoryItemCard(item: item)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Categories")
                    }
                    .font(FontManager.ubuntu(size: 16))
                    .foregroundColor(ColorManager.lightBlue)
                }
            }
        }
    }
}

struct CategoryItemCard: View {
    let item: ShoppingItem
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(item.name)
                    .font(FontManager.ubuntu(size: 18, weight: .medium))
                    .foregroundColor(ColorManager.white)
                    .lineLimit(2)
                
                HStack(spacing: 12) {
                    Label(item.quantity, systemImage: "number")
                        .font(FontManager.ubuntu(size: 14))
                        .foregroundColor(ColorManager.orange)
                    
                    if !item.comment.isEmpty {
                        Label("Has note", systemImage: "text.bubble")
                            .font(FontManager.ubuntu(size: 14))
                            .foregroundColor(ColorManager.lightBlue.opacity(0.7))
                    }
                }
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(ColorManager.white.opacity(0.6))
                
                Text("Open")
                    .font(FontManager.ubuntu(size: 12))
                    .foregroundColor(ColorManager.white.opacity(0.6))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorManager.lightBlue.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: ColorManager.darkBlue.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    CategoriesView(viewModel: ShoppingViewModel())
}
