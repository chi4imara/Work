import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var outfitViewModel: OutfitViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    HStack {
                        Text("Categories")
                            .font(.lumierepolis(28, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    if outfitViewModel.outfits.isEmpty {
                        EmptyCategoriesView()
                        
                        Spacer()
                    } else {
                        CategoryListView()
                            .environmentObject(outfitViewModel)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct EmptyCategoriesView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "square.grid.2x2")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(.textSecondary.opacity(0.5))
                
                VStack(spacing: 8) {
                    Text("Categories will appear after adding outfits")
                        .font(.lumierepolis(22, weight: .bold))
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("Organize your outfits by occasion")
                        .font(.lumierepolis(16, weight: .light))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct CategoryListView: View {
    @EnvironmentObject var outfitViewModel: OutfitViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(OutfitCategory.allCases, id: \.self) { category in
                    NavigationLink(destination: CategoryOutfitsView(category: category)
                        .environmentObject(outfitViewModel)) {
                        CategoryCardView(
                            category: category,
                            count: outfitViewModel.getCategoryCount(category)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
}

struct CategoryCardView: View {
    let category: OutfitCategory
    let count: Int
    
    private var categoryIcon: String {
        switch category {
        case .casual:
            return "tshirt.fill"
        case .outing:
            return "suitcase.fill"
        case .travel:
            return "airplane"
        }
    }
    
    private var categoryColor: Color {
        switch category {
        case .casual:
            return .primaryYellow
        case .outing:
            return .accentOrange
        case .travel:
            return .accentPink
        }
    }
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(categoryColor.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: categoryIcon)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(categoryColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.displayName)
                    .font(.lumierepolis(20, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Text("\(count) outfit\(count == 1 ? "" : "s")")
                    .font(.lumierepolis(14, weight: .light))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.textSecondary.opacity(0.6))
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cardBackground.opacity(0.3))
                .shadow(color: .shadowColor, radius: 5, x: 0, y: 2)
        )
    }
}

struct CategoryOutfitsView: View {
    @EnvironmentObject var outfitViewModel: OutfitViewModel
    @Environment(\.dismiss) private var dismiss
    
    let category: OutfitCategory
    
    private var categoryOutfits: [Outfit] {
        outfitViewModel.getOutfitsByCategory(category)
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .bold))
                            Text("Back")
                                .font(.lumierepolis(16))
                        }
                        .foregroundColor(.textPrimary)
                    }
                    
                    Spacer()
                    
                    Text(category.displayName)
                        .font(.lumierepolis(24, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .bold))
                            Text("Back")
                                .font(.lumierepolis(16))
                        }
                        .foregroundColor(.textPrimary)
                    }
                    .disabled(true)
                    .opacity(0)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                if categoryOutfits.isEmpty {
                    EmptyCategoryView(category: category)
                    
                    Spacer()
                } else {
                    OutfitGridView(outfits: categoryOutfits)
                        .environmentObject(outfitViewModel)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct EmptyCategoryView: View {
    let category: OutfitCategory
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "tshirt")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(.textSecondary.opacity(0.5))
                
                VStack(spacing: 8) {
                    Text("No outfits in this category yet")
                        .font(.lumierepolis(22, weight: .bold))
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("Add some \(category.displayName.lowercased()) outfits to see them here")
                        .font(.lumierepolis(16, weight: .light))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    CategoriesView()
        .environmentObject(OutfitViewModel())
        .background(AppColors.backgroundGradient)
}
