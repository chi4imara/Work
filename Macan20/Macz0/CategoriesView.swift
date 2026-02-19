import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: CosmeticViewModel
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.products.isEmpty {
                    emptyStateView
                } else {
                    categoriesList
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Categories")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(ColorTheme.white)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "square.grid.3x3")
                .font(.system(size: 60))
                .foregroundColor(ColorTheme.textSecondary)
            
            Text("Categories will appear after adding at least one product.")
                .font(.ubuntu(18))
                .foregroundColor(ColorTheme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var categoriesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.categoryCounts, id: \.0) { type, count in
                    CategoryCardView(
                        type: type,
                        count: count,
                        onTap: {
                            viewModel.filterByType(type)
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedTab = 0
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

struct CategoryCardView: View {
    let type: ProductType
    let count: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(ColorTheme.lightBlue.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: iconForType(type))
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(ColorTheme.lightBlue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(type.displayName)
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(ColorTheme.white)
                    
                    Text("\(count) product\(count == 1 ? "" : "s")")
                        .font(.ubuntu(14))
                        .foregroundColor(ColorTheme.textSecondary)
                }
                
                Spacer()
                
                Text("\(count)")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(ColorTheme.white)
                    .frame(minWidth: 30, minHeight: 30)
                    .background(ColorTheme.accent)
                    .clipShape(Circle())
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(ColorTheme.textSecondary)
            }
            .padding(20)
            .background(ColorTheme.cardGradient)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func iconForType(_ type: ProductType) -> String {
        switch type {
        case .lipstick:
            return "paintbrush"
        case .eyeshadow:
            return "eye"
        case .nailPolish:
            return "hand.raised"
        case .other:
            return "sparkles"
        }
    }
}

#Preview {
    CategoriesView(viewModel: CosmeticViewModel(), selectedTab: .constant(1))
}
