import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var viewModel: PhotoshootViewModel
    @State private var selectedCategory: ScenarioCategory? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                StaticBackground()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if selectedCategory == nil {
                        categoriesGrid
                    } else {
                        filteredScenariosView
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        HStack {
            if selectedCategory != nil {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedCategory = nil
                        viewModel.selectedCategory = nil
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.appPrimary)
                }
            }
            
            Text(selectedCategory?.rawValue ?? "Categories")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(.appPrimaryText)
            
            Spacer()
            
            if selectedCategory != nil {
                Text("\(viewModel.filteredScenarios.count)")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.appSecondaryText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.appLightGray)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .animation(.easeInOut(duration: 0.3), value: selectedCategory)
    }
    
    private var categoriesGrid: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(ScenarioCategory.allCases, id: \.self) { category in
                    CategoryCard(
                        category: category,
                        count: viewModel.scenariosByCategory[category]?.count ?? 0
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedCategory = category
                            viewModel.selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 10)
        }
    }
    
    private var filteredScenariosView: some View {
        VStack(spacing: 16) {
            if viewModel.filteredScenarios.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.filteredScenarios) { scenario in
                            NavigationLink(destination: ScenarioDetailView(scenario: scenario)) {
                                ScenarioCard(scenario: scenario)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .padding(.top, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: selectedCategory?.icon ?? "folder")
                .font(.system(size: 80))
                .foregroundColor(.appLightBlue)
            
            VStack(spacing: 8) {
                Text("No scenarios in this category")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(.appPrimaryText)
                
                Text("Create your first \(selectedCategory?.rawValue.lowercased() ?? "") photoshoot scenario")
                    .font(.ubuntu(16))
                    .foregroundColor(.appSecondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct CategoryCard: View {
    let category: ScenarioCategory
    let count: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.appLightBlue,
                                    Color.appPrimary
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 4) {
                    Text(category.rawValue)
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(.appPrimaryText)
                    
                    Text("\(count) scenario\(count == 1 ? "" : "s")")
                        .font(.ubuntu(14))
                        .foregroundColor(.appSecondaryText)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .appPrimary.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    CategoriesView()
}
