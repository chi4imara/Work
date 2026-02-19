import SwiftUI

struct WardrobeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingAddItem = false
    @State private var searchText = ""
    @State private var selectedCategory: WardrobeItem.ClothingCategory? = nil
    
    private var filteredItems: [WardrobeItem] {
        var items = appState.wardrobeItems
        
        if let category = selectedCategory {
            items = items.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            items = items.filter { 
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.color.localizedCaseInsensitiveContains(searchText) ||
                $0.notes.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return items
    }
    
    private var itemsByCategory: [WardrobeItem.ClothingCategory: [WardrobeItem]] {
        Dictionary(grouping: filteredItems, by: { $0.category })
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HeaderView()
                
                SearchAndFilterView()
                
                if filteredItems.isEmpty {
                    EmptyStateView()
                } else {
                    ItemsGridView()
                }
            }
        }
        .sheet(isPresented: $showingAddItem) {
            AddWardrobeItemView()
                .environmentObject(appState)
        }
    }
    
    @ViewBuilder
    private func HeaderView() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Wardrobe")
                    .font(.ubuntu(32, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(appState.wardrobeItems.count) items")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Button(action: { showingAddItem = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(AppColors.yellow)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    @ViewBuilder
    private func SearchAndFilterView() -> some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.secondaryText)
                
                TextField("Search items...", text: $searchText)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.primaryText)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
            .cornerRadius(12)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    CategoryFilterButton(
                        title: "All",
                        isSelected: selectedCategory == nil
                    ) {
                        selectedCategory = nil
                    }
                    
                    ForEach(WardrobeItem.ClothingCategory.allCases, id: \.self) { category in
                        CategoryFilterButton(
                            title: category.rawValue,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = selectedCategory == category ? nil : category
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
            .padding(.horizontal, -20)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    @ViewBuilder
    private func ItemsGridView() -> some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(filteredItems) { item in
                    WardrobeItemDetailCard(itemId: item.id)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    @ViewBuilder
    private func EmptyStateView() -> some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: searchText.isEmpty ? "tshirt" : "magnifyingglass")
                    .font(.system(size: 64))
                    .foregroundColor(AppColors.secondaryText)
                
                VStack(spacing: 8) {
                    Text(searchText.isEmpty ? "No Items Yet" : "No Results Found")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(searchText.isEmpty ? 
                         "Start building your wardrobe by adding your first item" :
                         "Try adjusting your search or filters")
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                }
                
                if searchText.isEmpty {
                    Button("Add First Item") {
                        showingAddItem = true
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
            .padding(40)
            
            Spacer()
        }
    }
}

struct CategoryFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(isSelected ? AppColors.accentText : AppColors.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? AppColors.yellow : AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? AppColors.yellow : AppColors.cardBorder, lineWidth: 1)
                )
                .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct WardrobeItemDetailCard: View {
    let itemId: UUID
    @EnvironmentObject var appState: AppState
    @State private var showingDetail = false
    
    private var item: WardrobeItem? {
        appState.wardrobeItem(byId: itemId)
    }
    
    var body: some View {
        Group {
            if let item = item {
                Button(action: { showingDetail = true }) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: item.category.icon)
                                .font(.system(size: 28))
                                .foregroundColor(AppColors.yellow)
                            Spacer()
                            if item.isFavorite {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(AppColors.pink)
                            }
                        }
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.name)
                                .font(.ubuntu(16, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                                .lineLimit(2)
                            HStack {
                                Text(item.color)
                                    .font(.ubuntu(12))
                                    .foregroundColor(AppColors.secondaryText)
                                Spacer()
                                Text("Size \(item.size)")
                                    .font(.ubuntu(12))
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            Text(item.category.rawValue)
                                .font(.ubuntu(10, weight: .medium))
                                .foregroundColor(AppColors.yellow)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(AppColors.yellow.opacity(0.2))
                                .cornerRadius(8)
                        }
                        Spacer()
                    }
                    .padding(16)
                    .frame(height: 160)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .cardStyle()
                }
                .buttonStyle(PlainButtonStyle())
                .sheet(isPresented: $showingDetail) {
                    ItemDetailView(itemId: itemId)
                        .environmentObject(appState)
                }
            }
        }
    }
}

struct ItemDetailView: View {
    let itemId: UUID
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    private var item: WardrobeItem? {
        appState.wardrobeItem(byId: itemId)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                if let item = item {
                    ScrollView {
                        VStack(spacing: 24) {
                            ZStack {
                                Circle()
                                    .fill(AppColors.cardBackground)
                                    .frame(width: 120, height: 120)
                                Image(systemName: item.category.icon)
                                    .font(.system(size: 48))
                                    .foregroundColor(AppColors.yellow)
                            }
                            .padding(.top, 20)
                            
                            VStack(spacing: 16) {
                                Text(item.name)
                                    .font(.ubuntu(28, weight: .bold))
                                    .foregroundColor(AppColors.primaryText)
                                    .multilineTextAlignment(.center)
                                
                                VStack(spacing: 12) {
                                    DetailRow(label: "Category", value: item.category.rawValue)
                                    DetailRow(label: "Size", value: item.size)
                                    DetailRow(label: "Color", value: item.color)
                                    
                                    if !item.notes.isEmpty {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Notes")
                                                .font(.ubuntu(16, weight: .medium))
                                                .foregroundColor(AppColors.primaryText)
                                            Text(item.notes)
                                                .font(.ubuntu(14))
                                                .foregroundColor(AppColors.secondaryText)
                                                .padding(16)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .background(AppColors.cardBackground)
                                                .cornerRadius(12)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            Spacer(minLength: 100)
                        }
                    }
                } else {
                    VStack(spacing: 16) {
                        Text("Item not found")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        Button("Done") { dismiss() }
                            .buttonStyle(SecondaryButtonStyle())
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.yellow)
                }
            }
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Text(value)
                .font(.ubuntu(16))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    WardrobeView()
        .environmentObject(AppState())
}
