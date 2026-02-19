import SwiftUI

struct CategorySelection: Identifiable {
    let id = UUID()
    let title: String
    let items: [InventoryItem]
}

struct CategoriesView: View {
    @EnvironmentObject var viewModel: InventoryViewModel
    @State private var selectedItem: InventoryItem?
    @State private var selectedCategory: CategorySelection?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                headerView
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 25) {
                        categoryTypeSection
                        
                        statusSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
            }
        }
        .sheet(item: $selectedCategory) { categorySelection in
            CategoryItemsView(
                viewModel: viewModel,
                title: categorySelection.title,
                items: categorySelection.items
            ) { item in
                selectedItem = item
            }
        }
        .sheet(item: $selectedItem) { item in
            ItemDetailView(viewModel: viewModel, itemId: item.id)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Categories")
                .font(.playfairDisplay(32, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
    }
    
    private var categoryTypeSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            SectionHeader(title: "By Type", icon: "folder.fill")
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(viewModel.getCategoryStats(), id: \.category) { stat in
                    CategoryCard(
                        title: stat.category.displayName,
                        count: stat.count,
                        icon: categoryIcon(for: stat.category),
                        color: AppColors.lightBlue
                    ) {
                        showCategoryItems(for: stat.category)
                    }
                }
            }
        }
    }
    
    private var statusSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            SectionHeader(title: "By Condition", icon: "checkmark.seal.fill")
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(viewModel.getStatusStats(), id: \.status) { stat in
                    CategoryCard(
                        title: stat.status.displayName,
                        count: stat.count,
                        icon: statusIcon(for: stat.status),
                        color: statusColor(for: stat.status)
                    ) {
                        showStatusItems(for: stat.status)
                    }
                }
            }
        }
    }
    
    private func showCategoryItems(for category: ItemCategory) {
        let items = viewModel.items.filter { $0.category == category }
        selectedCategory = CategorySelection(
            title: category.displayName,
            items: items
        )
    }
    
    private func showStatusItems(for status: ItemStatus) {
        let items = viewModel.items.filter { $0.status == status }
        selectedCategory = CategorySelection(
            title: status.displayName,
            items: items
        )
    }
    
    private func categoryIcon(for category: ItemCategory) -> String {
        switch category {
        case .tools: return "wrench.and.screwdriver"
        case .gadgets: return "iphone"
        case .parts: return "gearshape"
        case .equipment: return "desktopcomputer"
        case .accessories: return "cable.connector"
        case .other: return "archivebox"
        }
    }
    
    private func statusIcon(for status: ItemStatus) -> String {
        switch status {
        case .working: return "checkmark.circle.fill"
        case .needsCheck: return "exclamationmark.triangle.fill"
        case .broken: return "xmark.circle.fill"
        }
    }
    
    private func statusColor(for status: ItemStatus) -> Color {
        switch status {
        case .working: return AppColors.workingStatus
        case .needsCheck: return AppColors.needsCheckStatus
        case .broken: return AppColors.brokenStatus
        }
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(AppColors.lightBlue)
            
            Text(title)
                .font(.playfairDisplay(22, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
    }
}

struct CategoryCard: View {
    let title: String
    let count: Int
    let icon: String
    let color: Color
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(color)
                }
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.playfairDisplay(16, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(1)
                    
                    Text("\(count) item\(count == 1 ? "" : "s")")
                        .font(.playfairDisplay(14, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(AppColors.cardGradient)
            .cornerRadius(15)
            .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CategoryItemsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: InventoryViewModel
    let title: String
    let items: [InventoryItem]
    let onItemTap: (InventoryItem) -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                if items.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "archivebox")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(AppColors.lightBlue)
                        
                        Text("No items in this category")
                            .font(.playfairDisplay(20, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(items) { item in
                                ItemCard(item: item) {
                                    onItemTap(item)
                                    dismiss()
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.accentText)
                }
            }
        }
    }
}

#Preview {
    CategoriesView()
}
