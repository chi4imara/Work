import SwiftUI

struct ContentView: View {
    @StateObject private var recipeViewModel = RecipeViewModel()
    @StateObject private var mealPlanViewModel = MealPlanViewModel()
    @StateObject private var userViewModel = UserViewModel()
    @AppStorage("onboardingCompleted") private var onboardingCompleted = false
    @State private var isLoading = true
    @State private var selectedTab: TabItem = .home
    @State private var showingAddRecipe = false
    
    var body: some View {
        ZStack {
            if !onboardingCompleted {
                OnboardingView(onComplete: {
                    withAnimation(.easeOut(duration: 0.4)) {
                        onboardingCompleted = true
                    }
                })
            } else {
                NavigationStack {
                    mainAppView
                        .navigationBarHidden(true)
                }
            }
        }
    }
    
    private var mainAppView: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
                Group {
                    switch selectedTab {
                    case .home:
                        HomeView(recipeViewModel: recipeViewModel)
                    case .menu:
                        MenuView(recipeViewModel: recipeViewModel, mealPlanViewModel: mealPlanViewModel)
                    case .progress:
                        NutritionProgressView(mealPlanViewModel: mealPlanViewModel, recipeViewModel: recipeViewModel)
                    case .profile:
                        ProfileView(userViewModel: userViewModel)
                    case .settings:
                        SettingsView(
                            recipeViewModel: recipeViewModel,
                            mealPlanViewModel: mealPlanViewModel,
                            userViewModel: userViewModel
                        )
                    }
                }
                
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    Button(action: { showingAddRecipe = true }) {
                        ZStack {
                            Circle()
                                .fill(AppColors.primaryYellow)
                                .frame(width: 60, height: 60)
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.trailing, 30)
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(isPresented: $showingAddRecipe) {
            AddRecipeView(onSave: { recipe in
                recipeViewModel.addRecipe(recipe)
                showingAddRecipe = false
            })
        }
    }
}

#Preview {
    ContentView()
}
