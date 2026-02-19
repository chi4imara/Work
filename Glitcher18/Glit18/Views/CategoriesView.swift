import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var dataManager: DataManager
    
    private var categoriesWithCounts: [(category: String, count: Int)] {
        dataManager.getCategoriesWithCounts()
    }
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Categories")
                        .font(.playfairDisplay(size: 28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                if categoriesWithCounts.isEmpty {
                    EmptyCategoriesView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(categoriesWithCounts, id: \.category) { item in
                                CategoryCard(categoryName: item.category, count: item.count)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

struct CategoryCard: View {
    let categoryName: String
    let count: Int
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationLink(destination: CategoryDetailView(categoryName: categoryName)
            .environmentObject(dataManager)) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.accentGradient)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: categoryIcon(for: categoryName))
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.deepPurple)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(categoryName)
                        .font(.playfairDisplay(size: 18, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(1)
                    
                    Text("\(count) item\(count == 1 ? "" : "s")")
                        .font(.playfairDisplay(size: 14, weight: .medium))
                        .foregroundColor(AppColors.accentYellow)
                }
                
                Spacer()
                
                Text("\(count)")
                    .font(.playfairDisplay(size: 16, weight: .bold))
                    .foregroundColor(AppColors.deepPurple)
                    .frame(width: 32, height: 32)
                    .background(AppColors.accentYellow)
                    .clipShape(Circle())
                
                Image(systemName: "chevron.right")
                    .foregroundColor(AppColors.secondaryText)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(16)
            .glassCard()
        }
        .buttonStyle(PlainButtonStyle())
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
            return "folder.fill"
        }
    }
}

struct CategoryDetailView: View {
    let categoryName: String
    @EnvironmentObject var dataManager: DataManager
    
    private var categoryAccessories: [Accessory] {
        dataManager.accessories.filter { $0.category == categoryName }
            .sorted { $0.createdAt > $1.createdAt }
    }
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(categoryAccessories) { accessory in
                        NavigationLink(destination: AccessoryDetailView(accessoryId: accessory.id)
                            .environmentObject(dataManager)) {
                            AccessoryCard(accessory: accessory)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
        }
        .navigationTitle(categoryName)
        .navigationBarTitleDisplayMode(.large)
        .preferredColorScheme(.dark)
    }
}

struct EmptyCategoriesView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "folder.fill")
                    .font(.system(size: 40))
                    .foregroundColor(AppColors.accentYellow)
            }
            
            VStack(spacing: 12) {
                Text("No categories yet")
                    .font(.playfairDisplay(size: 24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Categories are created automatically when you add accessories.")
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
    CategoriesView()
        .environmentObject(DataManager.shared)
}
