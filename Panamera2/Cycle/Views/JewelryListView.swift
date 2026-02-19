import SwiftUI

struct JewelryListView: View {
    @EnvironmentObject var store: JewelryStore
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var showingAddView = false
    
    var filteredItems: [JewelryItem] {
        var items = store.items
        
        if selectedCategory != "All" {
            items = items.filter { item in
                if let category = JewelryCategory(rawValue: selectedCategory) {
                    return item.category == category
                } else {
                    return item.category == .custom && item.customCategoryName == selectedCategory
                }
            }
        }
        
        if !searchText.isEmpty {
            items = items.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return items
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Jewelry")
                        .font(.bauhausBold(size: 28))
                        .foregroundColor(AppColors.primaryWhite)
                    
                    Spacer()
                    
                    Button(action: { showingAddView = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(AppColors.accentYellow)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(AppColors.primaryWhite)
                                    .shadow(radius: 5)
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(AppColors.darkGray)
                        
                        TextField("Search by name", text: $searchText)
                            .font(.bauhausRegular(size: 16))
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(AppColors.darkGray)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.cardBackground)
                    )
                    
                    CategoryPicker(selectedCategory: $selectedCategory, store: store)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                if filteredItems.isEmpty {
                    EmptyStateView(hasItems: !store.items.isEmpty)
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredItems) { item in
                                NavigationLink(destination: JewelryDetailView(itemId: item.id, store: store)) {
                                    JewelryCard(item: item, store: store)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddView) {
            AddJewelryView(store: store)
        }
    }
}

struct CategoryPicker: View {
    @Binding var selectedCategory: String
    let store: JewelryStore
    
    var allCategories: [String] {
        var categories = ["All"]
        categories.append(contentsOf: store.getAllCategories())
        return categories
    }
    
    var body: some View {
        Menu {
            ForEach(allCategories, id: \.self) { category in
                Button(category) {
                    selectedCategory = category
                }
            }
        } label: {
            HStack {
                Text("Category: \(selectedCategory)")
                    .font(.bauhausRegular(size: 16))
                    .foregroundColor(AppColors.darkGray)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .foregroundColor(AppColors.darkGray)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
            )
        }
    }
}

struct EmptyStateView: View {
    let hasItems: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(AppColors.accentYellow)
            
            Text(hasItems ? "No jewelry found" : "No jewelry added yet")
                .font(.bauhausBold(size: 20))
                .foregroundColor(AppColors.primaryWhite)
                .multilineTextAlignment(.center)
            
            if !hasItems {
                Text("Add your first piece of jewelry to get started")
                    .font(.bauhausRegular(size: 16))
                    .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    JewelryListView()
}
