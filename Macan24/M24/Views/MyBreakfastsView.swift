import SwiftUI

struct MyBreakfastsView: View {
    @EnvironmentObject var viewModel: BreakfastViewModel
    @State private var showingAddBreakfast = false
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 0) {
                    headerView
                    
                    searchBar
                    
                    if viewModel.filteredBreakfasts.isEmpty {
                        emptyStateView
                    } else {
                        breakfastsList
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddBreakfast) {
            AddBreakfastView(selectedTab: $selectedTab)
                .environmentObject(viewModel)
        }
        .onAppear {
            viewModel.updateFilteredBreakfasts()
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Breakfasts")
                .font(.playfairDisplay(size: 32, weight: .bold))
                .foregroundColor(AppColors.primaryBlue)
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    selectedTab = 2
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                    Text("Add Breakfast")
                        .font(.playfairDisplay(size: 16, weight: .medium))
                }
                .foregroundColor(AppColors.backgroundWhite)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        colors: [AppColors.primaryYellow, AppColors.accentOrange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(25)
                .shadow(color: AppColors.primaryYellow.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchBar: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.textGray.opacity(0.6))
                
                TextField("Search by name or category", text: $viewModel.searchText)
                    .font(.playfairDisplay(size: 16))
                    .onChange(of: viewModel.searchText) { _ in
                        viewModel.updateFilteredBreakfasts()
                    }
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                        viewModel.updateFilteredBreakfasts()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.textGray.opacity(0.6))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AppColors.backgroundWhite.opacity(0.9))
            .cornerRadius(25)
            .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
            
            Button(action: {
                withAnimation {
                    selectedTab = 3
                }
            }) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.primaryBlue)
                    .padding(8)
                    .background(AppColors.backgroundWhite.opacity(0.9))
                    .clipShape(Circle())
                    .shadow(color: AppColors.primaryBlue.opacity(0.2), radius: 5, x: 0, y: 2)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var breakfastsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.filteredBreakfasts) { breakfast in
                    NavigationLink(destination: BreakfastDetailView(breakfast: breakfast).environmentObject(viewModel)) {
                        BreakfastCardView(breakfast: breakfast)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "cup.and.saucer")
                .font(.system(size: 80))
                .foregroundColor(AppColors.primaryBlue.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("Your breakfast journal is empty")
                    .font(.playfairDisplay(size: 24, weight: .semibold))
                    .foregroundColor(AppColors.primaryBlue)
                
                Text("Add your first breakfast to get started")
                    .font(.playfairDisplay(size: 16))
                    .foregroundColor(AppColors.textGray)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                withAnimation {
                    selectedTab = 2
                }
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .bold))
                    Text("Add First Breakfast")
                        .font(.playfairDisplay(size: 18, weight: .medium))
                }
                .foregroundColor(AppColors.backgroundWhite)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [AppColors.primaryYellow, AppColors.accentOrange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(30)
                .shadow(color: AppColors.primaryYellow.opacity(0.4), radius: 12, x: 0, y: 6)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct BreakfastCardView: View {
    let breakfast: Breakfast
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(breakfast.name)
                        .font(.playfairDisplay(size: 20, weight: .semibold))
                        .foregroundColor(AppColors.primaryBlue)
                        .lineLimit(1)
                    
                    Text(breakfast.category.displayName)
                        .font(.playfairDisplay(size: 14, weight: .medium))
                        .foregroundColor(AppColors.primaryYellow)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(AppColors.primaryYellow.opacity(0.2))
                        .cornerRadius(12)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textGray.opacity(0.6))
            }
            
            HStack(spacing: 16) {
                HStack(spacing: 6) {
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.accentOrange)
                    
                    Text(breakfast.drink)
                        .font(.playfairDisplay(size: 14))
                        .foregroundColor(AppColors.textGray)
                        .lineLimit(1)
                }
                
                Spacer()
            }
            
            Text(breakfast.atmosphereDescription)
                .font(.playfairDisplay(size: 14))
                .foregroundColor(AppColors.textGray.opacity(0.8))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.backgroundWhite.opacity(0.95))
                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 4)
        )
    }
}

