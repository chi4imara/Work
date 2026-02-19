import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var viewModel: ItemsViewModel
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.items.isEmpty {
                    emptyStateView
                } else {
                    categoriesGridView
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Categories")
                .font(.playfairDisplay(32, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.primaryBlue.opacity(0.6))
            
            Text("No items to categorize yet. Add some items to see them organized by categories.")
                .font(.playfairDisplay(18, weight: .medium))
                .foregroundColor(ColorTheme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var categoriesGridView: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(ItemCategory.allCases, id: \.self) { category in
                    CategoryCardView(
                        category: category,
                        itemCount: getItemCount(for: category),
                        items: getItems(for: category)
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
    
    private func getItemCount(for category: ItemCategory) -> Int {
        viewModel.items.filter { $0.category == category }.count
    }
    
    private func getItems(for category: ItemCategory) -> [Item] {
        viewModel.items.filter { $0.category == category }
    }
}

struct CategoryCardView: View {
    let category: ItemCategory
    let itemCount: Int
    let items: [Item]
    @State private var showingCategoryDetail = false
    
    var body: some View {
        Button(action: {
            if itemCount > 0 {
                showingCategoryDetail = true
            }
        }) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(ColorTheme.lightBlue.opacity(0.3))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(ColorTheme.primaryBlue)
                }
                
                VStack(spacing: 4) {
                    Text(category.displayName)
                        .font(.playfairDisplay(16, weight: .semibold))
                        .foregroundColor(ColorTheme.textPrimary)
                        .lineLimit(1)
                    
                    Text("\(itemCount) item\(itemCount == 1 ? "" : "s")")
                        .font(.playfairDisplay(12, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                }
                
                Spacer()
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.cardGradient)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                itemCount > 0 ? ColorTheme.lightBlue : ColorTheme.textSecondary.opacity(0.2),
                                lineWidth: 1
                            )
                    }
                    .shadow(
                        color: itemCount > 0 ? ColorTheme.primaryBlue.opacity(0.1) : Color.clear,
                        radius: itemCount > 0 ? 5 : 0,
                        x: 0,
                        y: 2
                    )
            )
            .opacity(itemCount > 0 ? 1.0 : 0.6)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(itemCount == 0)
        .sheet(isPresented: $showingCategoryDetail) {
            CategoryDetailView(category: category, items: items)
        }
    }
}

struct CategoryDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let category: ItemCategory
    let items: [Item]
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 0) {
                    HStack {
                        Button("Done") {
                        }
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(.clear)
                        .disabled(true)
                        
                        Spacer()
                        
                        Text(category.displayName)
                            .font(.playfairDisplay(24, weight: .bold))
                            .foregroundColor(ColorTheme.textPrimary)
                        
                        Spacer()
                        
                        Button("Done") {
                            dismiss()
                        }
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(ColorTheme.primaryBlue)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(items) { item in
                                NavigationLink(destination: ItemDetailView(itemId: item.id)) {
                                    ItemRowView(item: item)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    CategoriesView()
}
