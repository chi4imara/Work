import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var store: JewelryStore

    var categoryCounts: [(String, Int)] {
        store.getCategoryCounts()
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Categories")
                        .font(.bauhausBold(size: 28))
                        .foregroundColor(AppColors.primaryWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if categoryCounts.isEmpty {
                    EmptyCategoriesView()
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(categoryCounts, id: \.0) { category, count in
                                NavigationLink(destination: CategoryJewelryView(categoryName: category, store: store)) {
                                    CategoryRow(categoryName: category, count: count)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
    }
}

struct CategoryRow: View {
    let categoryName: String
    let count: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(categoryName)
                    .font(.bauhausBold(size: 18))
                    .foregroundColor(AppColors.darkGray)
                
                Text("\(count) item\(count == 1 ? "" : "s")")
                    .font(.bauhausRegular(size: 14))
                    .foregroundColor(AppColors.darkGray.opacity(0.7))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColors.darkGray.opacity(0.5))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

struct EmptyCategoriesView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 60))
                .foregroundColor(AppColors.accentYellow)
            
            Text("No categories yet")
                .font(.bauhausBold(size: 20))
                .foregroundColor(AppColors.primaryWhite)
                .multilineTextAlignment(.center)
            
            Text("Categories will appear after adding jewelry")
                .font(.bauhausRegular(size: 16))
                .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    CategoriesView()
}
