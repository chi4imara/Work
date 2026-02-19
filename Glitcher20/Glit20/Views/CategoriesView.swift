import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var viewModel: WardrobeViewModel

    var body: some View {
        ZStack {
            AppColorScheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Categories")
                        .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                        .foregroundColor(Color.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.categories.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Image(systemName: "folder")
                            .font(.system(size: 60))
                            .foregroundColor(Color.textSecondary)
                        
                        Text("Categories will appear after adding items.")
                            .font(FontManager.playfairDisplay(size: 18))
                            .foregroundColor(Color.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.categories) { category in
                                NavigationLink(destination: CategoryItemsView(category: category, viewModel: viewModel)) {
                                    CategoryCardView(category: category)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

struct CategoryCardView: View {
    let category: Category
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(category.name)
                    .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                    .foregroundColor(Color.textPrimary)
                
                Text("\(category.itemCount) items")
                    .font(FontManager.playfairDisplay(size: 14))
                    .foregroundColor(Color.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.title2)
                .foregroundColor(Color.primaryYellow)
        }
        .padding()
        .background(AppColorScheme.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
}

#Preview {
    CategoriesView()
}
