import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: HobbyIdeaViewModel
    @State private var selectedCategory: HobbyCategory?
    @State private var showingCategoryDetails = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Categories")
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                
                if viewModel.ideas.isEmpty {
                    emptyStateView
                } else {
                    categoriesList
                }
            }
        }
        
        .sheet(item: Binding<CategoryWrapper?>(
            get: { selectedCategory.map(CategoryWrapper.init) },
            set: { selectedCategory = $0?.category }
        )) { wrapper in
            CategoryDetailView(viewModel: viewModel, category: wrapper.category)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "folder")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryYellow)
            
            VStack(spacing: 16) {
                Text("No categories yet")
                    .font(.playfairDisplay(24, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Add some ideas to see them organized by categories")
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var categoriesList: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(HobbyCategory.allCases, id: \.self) { category in
                    CategoryCard(
                        category: category,
                        count: viewModel.getCategoryCount(for: category)
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
}

struct CategoryWrapper: Identifiable {
    let id = UUID()
    let category: HobbyCategory
}

struct CategoryCard: View {
    let category: HobbyCategory
    let count: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 16) {
                Image(systemName: category.icon)
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(AppColors.primaryYellow)
                
                Text(category.displayName)
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                if count > 0 {
                    Text("\(count) ideas")
                        .font(.playfairDisplay(14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                } else {
                    Text("No ideas yet")
                        .font(.playfairDisplay(14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText.opacity(0.7))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.cardGradient)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(count == 0)
        .opacity(count == 0 ? 0.6 : 1.0)
    }
}

struct CategoryDetailView: View {
    @ObservedObject var viewModel: HobbyIdeaViewModel
    let category: HobbyCategory
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedIdea: HobbyIdea?
    
    private var categoryIdeas: [HobbyIdea] {
        viewModel.getIdeas(for: category).sorted { $0.dateCreated > $1.dateCreated }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 4) {
                            Image(systemName: category.icon)
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(AppColors.primaryYellow)
                            
                            Text(category.displayName)
                                .font(.playfairDisplay(24, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                        }
                        
                        Spacer()
                        
                        Color.clear
                            .frame(width: 24, height: 24)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    if categoryIdeas.isEmpty {
                        emptyCategoryView
                    } else {
                        categoryIdeasList
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(item: Binding<IdeaIDWrapper?>(
            get: { selectedIdea.map(IdeaIDWrapper.init) },
            set: { selectedIdea = $0?.idea }
        )) { wrapper in
            IdeaDetailsView(viewModel: viewModel, ideaId: wrapper.id)
        }
    }
    
    private var emptyCategoryView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: category.icon)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryYellow.opacity(0.6))
            
            Text("This category is empty")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var categoryIdeasList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(categoryIdeas) { idea in
                    HistoryIdeaCard(idea: idea) {
                        selectedIdea = idea
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
}

#Preview {
    CategoriesView(viewModel: HobbyIdeaViewModel())
}
