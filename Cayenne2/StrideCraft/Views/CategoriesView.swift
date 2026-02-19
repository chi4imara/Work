import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var viewModel: ShoesViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.primaryBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        HStack {
                            Text("Categories")
                                .font(.ubuntu(28, weight: .bold))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("By Type")
                                .font(.ubuntu(20, weight: .bold))
                                .foregroundColor(ColorTheme.primaryText)
                                .padding(.horizontal, 20)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(ShoeCategory.allCases, id: \.self) { category in
                                    NavigationLink(destination: CategoryDetailView(category: category).environmentObject(viewModel)) {
                                        CategoryCard(
                                            title: category.displayName,
                                            count: viewModel.getCategoryCount(category),
                                            icon: categoryIcon(category),
                                            color: ColorTheme.lightBlue
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("By Condition")
                                .font(.ubuntu(20, weight: .bold))
                                .foregroundColor(ColorTheme.primaryText)
                                .padding(.horizontal, 20)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(ShoeCondition.allCases, id: \.self) { condition in
                                    NavigationLink(destination: ConditionDetailView(condition: condition).environmentObject(viewModel)) {
                                        CategoryCard(
                                            title: condition.displayName,
                                            count: viewModel.getConditionCount(condition),
                                            icon: conditionIcon(condition),
                                            color: conditionColor(condition)
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func categoryIcon(_ category: ShoeCategory) -> String {
        switch category {
        case .sneakers:
            return "shoe.2"
        case .boots:
            return "shoe"
        case .dress:
            return "shoe.2.fill"
        case .summer:
            return "sun.max"
        case .winter:
            return "snowflake"
        case .other:
            return "ellipsis"
        }
    }
    
    private func conditionIcon(_ condition: ShoeCondition) -> String {
        switch condition {
        case .excellent:
            return "star.fill"
        case .good:
            return "checkmark.circle.fill"
        case .average:
            return "minus.circle.fill"
        case .poor:
            return "xmark.circle.fill"
        }
    }
    
    private func conditionColor(_ condition: ShoeCondition) -> Color {
        switch condition {
        case .excellent:
            return ColorTheme.success
        case .good:
            return ColorTheme.lightBlue
        case .average:
            return ColorTheme.warning
        case .poor:
            return ColorTheme.error
        }
    }
}

struct CategoryCard: View {
    let title: String
    let count: Int
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30, weight: .medium))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("\(count)")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(color)
            }
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
    }
}

struct CategoryDetailView: View {
    @EnvironmentObject var viewModel: ShoesViewModel
    @Environment(\.presentationMode) var presentationMode
    let category: ShoeCategory
    
    var shoes: [Shoe] {
        viewModel.getShoesByCategory(category)
    }
    
    var body: some View {
        ZStack {
            ColorTheme.primaryBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if shoes.isEmpty {
                    emptyStateView
                } else {
                    shoesList
                }
            }
        }
        .navigationTitle(category.displayName)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorTheme.primaryButton)
            }
        )
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "shoe.2")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorTheme.secondaryText)
            
            Text("No shoes in this category")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(ColorTheme.secondaryText)
            
            Spacer()
        }
    }
    
    private var shoesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(shoes) { shoe in
                    NavigationLink(destination: ShoeDetailView(shoe: shoe).environmentObject(viewModel)) {
                        ShoeCardView(shoe: shoe)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
    }
}

struct ConditionDetailView: View {
    @EnvironmentObject var viewModel: ShoesViewModel
    @Environment(\.presentationMode) var presentationMode
    let condition: ShoeCondition
    
    var shoes: [Shoe] {
        viewModel.getShoesByCondition(condition)
    }
    
    var body: some View {
        ZStack {
            ColorTheme.primaryBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if shoes.isEmpty {
                    emptyStateView
                } else {
                    shoesList
                }
            }
        }
        .navigationTitle(condition.displayName)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorTheme.primaryButton)
            }
        )
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "shoe.2")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorTheme.secondaryText)
            
            Text("No shoes in this condition")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(ColorTheme.secondaryText)
            
            Spacer()
        }
    }
    
    private var shoesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(shoes) { shoe in
                    NavigationLink(destination: ShoeDetailView(shoe: shoe).environmentObject(viewModel)) {
                        ShoeCardView(shoe: shoe)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
    }
}

#Preview {
    CategoriesView()
        .environmentObject(ShoesViewModel())
}
