import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: AccessoryViewModel
    @State private var showingFilters = false
    @State private var showingARTryOn = false
    @State private var accessoryIdForARTryOn: UUID?
    
    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: AppConstants.sectionSpacing) {
                        headerSection
                        filtersSection
                        if viewModel.filteredAccessories.isEmpty {
                            emptyStateView
                        } else {
                            accessoriesGrid
                        }
                    }
                    .padding(.horizontal, AppConstants.cardPadding)
                }
                .refreshable {
                    viewModel.refreshRecommendations()
                }
                
                if viewModel.isLoading {
                    loadingOverlay
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingFilters) {
                FiltersView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingARTryOn) {
                if let id = accessoryIdForARTryOn {
                    ARTryOnView(accessoryId: id)
                }
            }
            .onChange(of: showingARTryOn) { newValue in
                if !newValue { accessoryIdForARTryOn = nil }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(AppColors.textBlue.opacity(0.6))
            
            Text("No matching accessories")
                .font(.playfairDisplay(22, weight: .semibold))
                .foregroundColor(AppColors.textBlue)
            
            Text("Try gold jewelry with evening looks")
                .font(.playfairDisplay(14, weight: .medium))
                .foregroundColor(AppColors.darkGray)
                .multilineTextAlignment(.center)
            
            Button("Clear Filters") {
                viewModel.clearFilters()
            }
            .font(.playfairDisplay(16, weight: .semibold))
            .foregroundColor(AppColors.primaryYellow)
            .padding(.top, 8)
        }
        .padding(.vertical, 40)
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("Recommended for you")
                .font(.playfairDisplay(32, weight: .bold))
                .foregroundColor(AppColors.textBlue)
                .multilineTextAlignment(.center)
            
            Text("Choose the perfect accessory for any occasion")
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(AppColors.darkGray)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
    
    private var filtersSection: some View {
        HStack {
            Button(action: { showingFilters = true }) {
                HStack {
                    Image(systemName: "slider.horizontal.3")
                    Text("Filters")
                        .font(.playfairDisplay(16, weight: .medium))
                }
                .foregroundColor(AppColors.textBlue)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(AppColors.backgroundWhite)
                .cornerRadius(20)
                .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 2)
            }
            
            Spacer()
        }
    }
    
    private var accessoriesGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ], spacing: 16) {
            ForEach(viewModel.filteredAccessories) { accessory in
                NavigationLink(destination: AccessoryDetailView(accessoryId: accessory.id)) {
                    AccessoryCard(accessory: accessory) {
                        accessoryIdForARTryOn = accessory.id
                        showingARTryOn = true
                    } onFavorite: {
                        viewModel.toggleFavorite(for: accessory)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(AppColors.primaryYellow)
                
                Text("Updating recommendations...")
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(AppColors.textBlue)
                    .padding(.top, 16)
            }
            .padding(24)
            .background(AppColors.backgroundWhite)
            .cornerRadius(16)
            .shadow(radius: 10)
        }
    }
}

struct AccessoryCard: View {
    let accessory: Accessory
    let onTryOn: () -> Void
    let onFavorite: () -> Void
    @State private var isPulsing = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topTrailing) {
                AccessoryPhotoView(accessory: accessory, height: 120, cornerRadius: 12, iconSize: 40)
                
                Button(action: onFavorite) {
                    Image(systemName: accessory.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(accessory.isFavorite ? AppColors.accentPink : AppColors.darkGray)
                        .font(.system(size: 20))
                }
                .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(accessory.name)
                    .font(.playfairDisplay(14, weight: .semibold))
                    .foregroundColor(AppColors.textBlue)
                    .lineLimit(2)
                
                Text(accessory.brand)
                    .font(.playfairDisplay(12, weight: .medium))
                    .foregroundColor(AppColors.darkGray)
                
                HStack {
                    Text(accessory.category.rawValue)
                        .font(.playfairDisplay(10, weight: .medium))
                        .foregroundColor(accessory.style.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(accessory.style.color.opacity(0.1))
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    Text("$\(Int(accessory.price))")
                        .font(.playfairDisplay(14, weight: .bold))
                        .foregroundColor(AppColors.textBlue)
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.cardGradient)
        .cornerRadius(AppConstants.cornerRadius)
        .shadow(color: .gray.opacity(0.2), radius: AppConstants.shadowRadius, x: 0, y: 4)
    }
}

#Preview {
    HomeView()
        .environmentObject(AccessoryViewModel())
}
