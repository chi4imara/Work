import SwiftUI

struct CategoryManagementView: View {
    @EnvironmentObject var recipeManager: RecipeManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(RecipeCategory.allCases, id: \.self) { category in
                            CategoryManagementCard(
                                category: category,
                                recipeCount: recipeManager.getRecipes(for: category).count
                            )
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Manage Categories")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textPrimary)
                }
            }
        }
    }
}

struct CategoryManagementCard: View {
    let category: RecipeCategory
    let recipeCount: Int
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: category.icon)
                .font(.system(size: 50, weight: .light))
                .foregroundColor(category.color)
            
            VStack(spacing: 8) {
                Text(category.rawValue)
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("\(recipeCount) recipes")
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            if recipeCount == 0 {
                Text("No recipes yet")
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(AppColors.textSecondary.opacity(0.7))
                    .italic()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .cardStyle()
    }
}

#Preview {
    CategoryManagementView()
        .environmentObject(RecipeManager())
}
