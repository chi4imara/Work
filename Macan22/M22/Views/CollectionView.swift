import SwiftUI

struct CollectionView: View {
    @ObservedObject var viewModel: ScentViewModel
    @Binding var selectedTab: TabItem
    @State private var showingAddScent = false
    @State private var showingFilters = false
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            AppBackground()
            
            VStack(spacing: 0) {
                headerView
                
                searchFilterBar
                
                if viewModel.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else if !viewModel.hasFilteredResults && viewModel.isFiltered {
                    noResultsView
                    
                    Spacer()
                } else {
                    scentsList
                }
            }
        }
        .sheet(isPresented: $showingAddScent) {
            AddScentView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.applyFilters()
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Candle Scents")
                    .font(.playfairDisplay(.bold, size: 28))
                    .foregroundColor(AppColors.white)
                
                if viewModel.isFiltered {
                    Text("\(viewModel.filteredScents.count) of \(viewModel.scents.count) scents")
                        .font(.playfairDisplay(.regular, size: 14))
                        .foregroundColor(AppColors.white.opacity(0.7))
                } else {
                    Text("\(viewModel.scents.count) scents in collection")
                        .font(.playfairDisplay(.regular, size: 14))
                        .foregroundColor(AppColors.white.opacity(0.7))
                }
            }
            
            Spacer()
            
            Button(action: {
                showingAddScent = true
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .semibold))
                    Text("Add Scent")
                        .font(.playfairDisplay(.semiBold, size: 14))
                }
                .foregroundColor(AppColors.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(AppColors.yellowGradient)
                .cornerRadius(20)
                .shadow(color: AppColors.yellow.opacity(0.3), radius: 8, x: 0, y: 2)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var searchFilterBar: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.white.opacity(0.6))
                    .font(.system(size: 16))
                
                TextField("Search by scent or brand", text: $searchText)
                    .font(.playfairDisplay(.regular, size: 16))
                    .foregroundColor(AppColors.white)
                    .onChange(of: searchText) { newValue in
                        viewModel.updateSearchText(newValue)
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        viewModel.updateSearchText("")
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.white.opacity(0.6))
                            .font(.system(size: 16))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AppColors.cardGradient)
            .cornerRadius(25)
            
            Button(action: {
                withAnimation {
                    selectedTab = .filters
                }
            }) {
                ZStack {
                    Circle()
                        .fill(viewModel.filter.isActive ? AppColors.yellowGradient : AppColors.cardGradient)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "line.3.horizontal.decrease")
                        .foregroundColor(AppColors.white)
                        .font(.system(size: 16, weight: .medium))
                    
                    if viewModel.filter.isActive {
                        Circle()
                            .fill(AppColors.error)
                            .frame(width: 8, height: 8)
                            .offset(x: 12, y: -12)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "flame")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(AppColors.yellow)
            }
            
            VStack(spacing: 12) {
                Text("Collection is empty")
                    .font(.playfairDisplay(.bold, size: 24))
                    .foregroundColor(AppColors.white)
                
                Text("Add your first scent to get started.")
                    .font(.playfairDisplay(.regular, size: 16))
                    .foregroundColor(AppColors.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                showingAddScent = true
            }) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Add First Scent")
                        .font(.playfairDisplay(.semiBold, size: 16))
                }
                .foregroundColor(AppColors.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(AppColors.buttonGradient)
                .cornerRadius(25)
                .shadow(color: AppColors.yellow.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var noResultsView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50, weight: .light))
                .foregroundColor(AppColors.white.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("No matching scents")
                    .font(.playfairDisplay(.bold, size: 20))
                    .foregroundColor(AppColors.white)
                
                Text("No scents match the selected parameters.")
                    .font(.playfairDisplay(.regular, size: 16))
                    .foregroundColor(AppColors.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                viewModel.clearFilters()
                searchText = ""
            }) {
                Text("Clear Filters")
                    .font(.playfairDisplay(.semiBold, size: 16))
                    .foregroundColor(AppColors.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(AppColors.cardGradient)
                    .cornerRadius(20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var scentsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.filteredScents) { scent in
                    NavigationLink(destination: ScentDetailView(scent: scent, viewModel: viewModel)) {
                        ScentCardView(scent: scent)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
}

struct ScentCardView: View {
    let scent: Scent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(scent.name)
                        .font(.playfairDisplay(.bold, size: 18))
                        .foregroundColor(AppColors.white)
                        .lineLimit(2)
                    
                    if !scent.brand.isEmpty {
                        Text(scent.brand)
                            .font(.playfairDisplay(.medium, size: 14))
                            .foregroundColor(AppColors.yellow)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Image(systemName: scent.season.icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.yellow)
                    
                    Text(scent.season.displayName)
                        .font(.playfairDisplay(.medium, size: 12))
                        .foregroundColor(AppColors.white.opacity(0.7))
                }
            }
            
            if !scent.description.isEmpty {
                Text(scent.description)
                    .font(.playfairDisplay(.regular, size: 14))
                    .foregroundColor(AppColors.white.opacity(0.8))
                    .lineLimit(3)
            }
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.deepBlue.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}
