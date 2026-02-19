import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var procedureStore: ProcedureStore
    
    private var categoriesWithCounts: [(category: ProcedureCategory, count: Int)] {
        procedureStore.categoriesWithCounts()
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Categories")
                        .font(.bellGothic(28, weight: .bold))
                        .foregroundColor(AppColors.primaryWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if categoriesWithCounts.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "folder")
                            .font(.system(size: 60))
                            .foregroundColor(AppColors.primaryWhite.opacity(0.6))
                        
                        Text("Categories will appear after adding procedures.")
                            .font(.bellGothic(18, weight: .regular))
                            .foregroundColor(AppColors.primaryWhite)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(categoriesWithCounts, id: \.category) { item in
                                NavigationLink(destination: CategoryProceduresView(category: item.category)
                                    .environmentObject(procedureStore)) {
                                    CategoryCardView(category: item.category, count: item.count)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                        .padding(.bottom, 120)
                    }
                }                
            }
        }
    }
}

struct CategoryCardView: View {
    let category: ProcedureCategory
    let count: Int
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: category.icon)
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(AppColors.accentYellow)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(AppColors.primaryWhite.opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.displayName)
                    .font(.bellGothic(20, weight: .bold))
                    .foregroundColor(AppColors.darkGray)
                
                Text("\(count) \(count == 1 ? "record" : "records")")
                    .font(.bellGothic(14, weight: .regular))
                    .foregroundColor(AppColors.darkGray.opacity(0.7))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppColors.darkGray.opacity(0.4))
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}

#Preview {
    CategoriesView()
        .environmentObject(ProcedureStore())
        .primaryBackground()
}
