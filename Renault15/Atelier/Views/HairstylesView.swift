import SwiftUI

struct HairstylesView: View {
    @EnvironmentObject var viewModel: HairstyleViewModel
    @State private var showingNewHairstyle = false
    @State private var showingNewCategory = false
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    greetingSection
                    
                    categoriesSection
                    
                    todaysLookSection
                    
                    lookDiarySection
                    
                    if viewModel.hairstyles.isEmpty {
                        emptyStateSection
                    }
                }
                .padding(.horizontal, AppDimensions.screenPadding)
                .padding(.top, 10)
                .padding(.bottom, 30)
            }
        }
        .sheet(isPresented: $showingNewHairstyle) {
            NewHairstyleView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingNewCategory) {
            NewCategoryView(viewModel: viewModel)
        }
    }
    
    private var greetingSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.getGreeting())
                        .font(AppFonts.title)
                        .foregroundColor(AppColors.primaryWhite)
                    
                    Text("What's today's look?")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                }
                Spacer()
            }
        }
    }
    
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Hairstyle Categories")
                    .font(AppFonts.subtitle)
                    .foregroundColor(AppColors.primaryWhite)
                Spacer()
                Button("Add Category") {
                    showingNewCategory = true
                }
                .font(AppFonts.caption)
                .foregroundColor(AppColors.primaryYellow)
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(HairstyleCategory.allCases, id: \.self) { category in
                    CategoryCard(
                        title: category.displayName,
                        count: viewModel.getHairstyles(for: category).count,
                        icon: getCategoryIcon(for: category)
                    )
                }
            }
        }
    }
    
    private var todaysLookSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Look")
                .font(AppFonts.subtitle)
                .foregroundColor(AppColors.primaryWhite)
            
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.primaryWhite.opacity(0.2))
                .frame(height: 120)
                .overlay(
                    VStack {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 30))
                            .foregroundColor(AppColors.primaryYellow)
                        Text("Try on a hairstyle")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.primaryWhite)
                    }
                )
        }
    }
    
    private var lookDiarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Look Diary")
                    .font(AppFonts.subtitle)
                    .foregroundColor(AppColors.primaryWhite)
                Spacer()
                Button(action: {
                    showingNewHairstyle = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.primaryYellow)
                }
            }
            
            if !viewModel.hairstyles.isEmpty {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(viewModel.hairstyles.prefix(4)) { hairstyle in
                        NavigationLink(destination: HairstyleDetailView(hairstyleId: hairstyle.id).environmentObject(viewModel)) {
                            HairstyleCard(hairstyle: hairstyle)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
    
    private var emptyStateSection: some View {
        VStack(spacing: 20) {
            Image(systemName: "scissors")
                .font(.system(size: 60))
                .foregroundColor(AppColors.primaryYellow.opacity(0.7))
            
            Text("Add your first hairstyle and try a new style")
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Button {
                showingNewHairstyle = true
            } label: {
                Text("Add Hairstyle")
                    .font(AppFonts.button)
                    .foregroundColor(AppColors.darkBlue)
                    .frame(width: 200, height: AppDimensions.buttonHeight)
                    .background(AppColors.primaryYellow)
                    .cornerRadius(AppDimensions.cornerRadius)
            }
        }
        .padding(.top, 40)
    }
    
    private func getCategoryIcon(for category: HairstyleCategory) -> String {
        switch category {
        case .cuts: return "scissors"
        case .styling: return "comb"
        case .color: return "paintbrush"
        case .braids: return "link"
        }
    }
}

struct CategoryCard: View {
    let title: String
    let count: Int
    let icon: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
            .fill(AppColors.primaryWhite.opacity(0.2))
            .frame(height: 100)
            .overlay(
                VStack(spacing: 8) {
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.primaryYellow)
                    
                    Text(title)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.primaryWhite)
                    
                    Text("\(count)")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.primaryWhite.opacity(0.7))
                }
            )
    }
}

struct HairstyleCard: View {
    let hairstyle: Hairstyle
    
    var body: some View {
        RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
            .fill(AppColors.primaryWhite.opacity(0.2))
            .frame(height: 100)
            .overlay(
                VStack(spacing: 6) {
                    Text(hairstyle.name)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.primaryWhite)
                        .lineLimit(2)
                    
                    Text(hairstyle.category.displayName)
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.primaryYellow)
                }
                .padding(8)
            )
    }
}

#Preview {
    HairstylesView()
        .environmentObject(HairstyleViewModel())
}
