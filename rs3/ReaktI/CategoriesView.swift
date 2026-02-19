import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var reactionsViewModel: ReactionsViewModel
    @State private var selectedCategory: ReactionType? = nil
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                categoriesGrid
            }
        }
        .sheet(item: $selectedCategory) { category in
            CategoryReactionsView(
                category: category,
                reactions: reactionsViewModel.reactions.filter { $0.type == category }
            )
            .environmentObject(reactionsViewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Categories")
                .font(.ibmPlexMono(28, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var categoriesGrid: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                ForEach(ReactionType.allCases, id: \.id) { type in
                    CategoryCard(
                        type: type,
                        count: reactionsViewModel.reactions.filter { $0.type == type }.count,
                        action: {
                            selectedCategory = type
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
}

struct CategoryCard: View {
    let type: ReactionType
    let count: Int
    let action: () -> Void
    
    private var typeColor: Color {
        switch type {
        case .movie: return AppColors.primaryBlue
        case .food: return AppColors.accentOrange
        case .place: return AppColors.accentGreen
        case .person: return AppColors.accentPurple
        case .other: return AppColors.primaryYellow
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(typeColor.opacity(0.1))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: type.iconName)
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(typeColor)
                }
                
                VStack(spacing: 8) {
                    Text(type.rawValue)
                        .font(.ibmPlexMono(18, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("\(count) reactions")
                        .font(.ibmPlexMono(14, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .padding(20)
            .background(AppColors.cardGradient)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.2), value: count)
    }
}
