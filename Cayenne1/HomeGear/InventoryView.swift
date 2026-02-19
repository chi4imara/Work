import SwiftUI

struct InventoryView: View {
    @EnvironmentObject var viewModel: InventoryViewModel
    @State private var showingAddItem = false
    @State private var selectedItem: InventoryItem?
    @State private var showingCategoryPicker = false
    @State private var showingStatusPicker = false
    
    var body: some View {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    filterView
                    
                    if viewModel.filteredItems.isEmpty {
                        emptyStateView
                    } else {
                        itemsList
                    }
                }
            }
        .sheet(isPresented: $showingAddItem) {
            AddItemView { item in
                viewModel.addItem(item)
            }
        }
        .sheet(item: $selectedItem) { item in
            ItemDetailView(viewModel: viewModel, itemId: item.id)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Inventory")
                .font(.playfairDisplay(32, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: { showingAddItem = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Add Item")
                        .font(.playfairDisplay(16, weight: .semibold))
                }
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(AppColors.buttonGradient)
                .cornerRadius(20)
                .shadow(color: AppColors.shadowColor, radius: 5, x: 0, y: 2)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var filterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(InventoryViewModel.FilterType.allCases, id: \.self) { filter in
                    FilterButton(
                        title: filter.displayName,
                        isSelected: viewModel.selectedFilter == filter
                    ) {
                        handleFilterTap(filter)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 15)
        .sheet(isPresented: $showingCategoryPicker) {
            CategoryFilterPickerView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingStatusPicker) {
            StatusFilterPickerView(viewModel: viewModel)
        }
    }
    
    private func handleFilterTap(_ filter: InventoryViewModel.FilterType) {
        switch filter {
        case .all:
            viewModel.applyFilter(.all)
        case .category:
            showingCategoryPicker = true
        case .status:
            showingStatusPicker = true
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 120, height: 120)
                    .shadow(color: AppColors.shadowColor, radius: 15, x: 0, y: 8)
                
                Image(systemName: "archivebox")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(AppColors.lightBlue)
            }
            
            VStack(spacing: 15) {
                Text("Add your first item to inventory")
                    .font(.playfairDisplay(24, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Start organizing your home inventory by adding tools, gadgets, and equipment")
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: { showingAddItem = true }) {
                HStack(spacing: 10) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .semibold))
                    Text("Add Item")
                        .font(.playfairDisplay(18, weight: .semibold))
                }
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .background(AppColors.orangeGradient)
                .cornerRadius(25)
                .shadow(color: AppColors.shadowColor, radius: 10, x: 0, y: 5)
            }
            
            Spacer()
        }
    }
    
    private var itemsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredItems) { item in
                    ItemCard(item: item) {
                        selectedItem = item
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.playfairDisplay(14, weight: .medium))
                .foregroundColor(isSelected ? AppColors.primaryText : AppColors.secondaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ? AppColors.lightBlue.opacity(0.8) : AppColors.borderColor
                )
                .cornerRadius(15)
        }
    }
}

struct ItemCard: View {
    let item: InventoryItem
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.name)
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                            .lineLimit(1)
                        
                        Text(item.category.displayName)
                            .font(.playfairDisplay(14, weight: .medium))
                            .foregroundColor(AppColors.accentText)
                    }
                    
                    Spacer()
                    
                    StatusBadge(status: item.status)
                }
                
                HStack {
                    Image(systemName: "location")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text(item.location)
                        .font(.playfairDisplay(14, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(1)
                    
                    Spacer()
                }
            }
            .padding(16)
            .background(AppColors.cardGradient)
            .cornerRadius(15)
            .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatusBadge: View {
    let status: ItemStatus
    
    var statusColor: Color {
        switch status {
        case .working: return AppColors.workingStatus
        case .needsCheck: return AppColors.needsCheckStatus
        case .broken: return AppColors.brokenStatus
        }
    }
    
    var body: some View {
        Text(status.displayName)
            .font(.playfairDisplay(12, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(statusColor)
            .cornerRadius(10)
    }
}

struct CategoryFilterPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: InventoryViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                List {
                    Button(action: {
                        viewModel.applyFilter(.all)
                        dismiss()
                    }) {
                        HStack {
                            Text("All Categories")
                                .font(.playfairDisplay(16, weight: .regular))
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                            
                            if viewModel.selectedFilter == .all {
                                Image(systemName: "checkmark")
                                    .foregroundColor(AppColors.lightBlue)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .listRowBackground(AppColors.cardGradient)
                    
                    ForEach(ItemCategory.allCases) { category in
                        Button(action: {
                            viewModel.applyFilter(.category, category: category)
                            dismiss()
                        }) {
                            HStack {
                                Text(category.displayName)
                                    .font(.playfairDisplay(16, weight: .regular))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Spacer()
                                
                                if viewModel.selectedFilter == .category && viewModel.selectedCategory == category {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(AppColors.lightBlue)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .listRowBackground(AppColors.cardGradient)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Filter by Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.accentText)
                }
            }
        }
    }
}

struct StatusFilterPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: InventoryViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                List {
                    Button(action: {
                        viewModel.applyFilter(.all)
                        dismiss()
                    }) {
                        HStack {
                            Text("All Statuses")
                                .font(.playfairDisplay(16, weight: .regular))
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                            
                            if viewModel.selectedFilter == .all {
                                Image(systemName: "checkmark")
                                    .foregroundColor(AppColors.lightBlue)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .listRowBackground(AppColors.cardGradient)
                    
                    ForEach(ItemStatus.allCases) { status in
                        Button(action: {
                            viewModel.applyFilter(.status, status: status)
                            dismiss()
                        }) {
                            HStack {
                                Text(status.displayName)
                                    .font(.playfairDisplay(16, weight: .regular))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Spacer()
                                
                                if viewModel.selectedFilter == .status && viewModel.selectedStatus == status {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(AppColors.lightBlue)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .listRowBackground(AppColors.cardGradient)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Filter by Status")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.accentText)
                }
            }
        }
    }
}

#Preview {
    InventoryView()
        .environmentObject(InventoryViewModel())
}
