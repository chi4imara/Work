import SwiftUI

struct AccessoriesView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var searchText = ""
    @State private var selectedCategory = "All Categories"
    @State private var showingAddAccessory = false
    
    private var filteredAccessories: [Accessory] {
        dataManager.filteredAccessories(searchText: searchText, selectedCategory: selectedCategory)
    }
    
    private var availableCategories: [String] {
        var categories = ["All Categories"]
        categories.append(contentsOf: dataManager.categories.map { $0.name })
        return categories
    }
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                HStack {
                    Text("Accessories")
                        .font(.playfairDisplay(size: 28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddAccessory = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(AppColors.accentYellow)
                            .font(.system(size: 24, weight: .semibold))
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(AppColors.secondaryText)
                        
                        TextField("Search by name", text: $searchText)
                            .font(.playfairDisplay(size: 16))
                            .foregroundColor(AppColors.primaryText)
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(AppColors.secondaryText)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(AppColors.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Menu {
                        ForEach(availableCategories, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                HStack {
                                    Text(category)
                                    if selectedCategory == category {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Text("Category: \(selectedCategory)")
                                .font(.playfairDisplay(size: 16, weight: .medium))
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .foregroundColor(AppColors.accentYellow)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(AppColors.cardGradient)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.cardBorder, lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
                
                if filteredAccessories.isEmpty {
                    EmptyStateView()
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredAccessories) { accessory in
                                NavigationLink(destination: AccessoryDetailView(accessoryId: accessory.id)
                                    .environmentObject(dataManager)) {
                                    AccessoryCard(accessory: accessory)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddAccessory) {
            AddAccessoryView()
        }
    }
}

struct AccessoryCard: View {
    let accessory: Accessory
    @EnvironmentObject var dataManager: DataManager
    
    private var outfitCount: Int {
        accessory.outfitIds.count
    }
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.accentGradient)
                    .frame(width: 50, height: 50)
                
                Image(systemName: categoryIcon(for: accessory.category))
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.deepPurple)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(accessory.name)
                    .font(.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(1)
                
                Text(accessory.category)
                    .font(.playfairDisplay(size: 14, weight: .medium))
                    .foregroundColor(AppColors.accentYellow)
                
                Text("Fits with: \(outfitCount) outfit\(outfitCount == 1 ? "" : "s")")
                    .font(.playfairDisplay(size: 12, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(AppColors.secondaryText)
                .font(.system(size: 14, weight: .medium))
        }
        .padding(16)
        .glassCard()
    }
    
    private func categoryIcon(for category: String) -> String {
        switch category.lowercased() {
        case "earrings":
            return "ear"
        case "rings":
            return "circle"
        case "bracelets":
            return "oval"
        case "necklaces":
            return "link"
        case "watches":
            return "clock"
        default:
            return "sparkles"
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 40))
                    .foregroundColor(AppColors.accentYellow)
            }
            
            VStack(spacing: 12) {
                Text("List is empty")
                    .font(.playfairDisplay(size: 24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add your first accessory.")
                    .font(.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    AccessoriesView()
        .environmentObject(DataManager.shared)
}
