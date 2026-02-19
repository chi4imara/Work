import SwiftUI

struct SPAListView: View {
    @EnvironmentObject var viewModel: SPAListViewModel
    @EnvironmentObject var bookingsVM: BookingsViewModel
    @State private var showingFilters = false
    @State private var showingBooking = false
    @State private var showingAddSalon = false
    @State private var selectedSalon: SPASalon?
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchBarView
                
                if viewModel.filteredSalons.isEmpty {
                    emptyStateView
                } else {
                    salonListView
                }
            }
        }
        .sheet(isPresented: $showingFilters) {
            FilterView(filterOptions: $viewModel.filterOptions) { filters in
                viewModel.updateFilters(filters)
            }
        }
        .sheet(item: $selectedSalon) { salon in
            BookingView(salon: salon) { booking in
                bookingsVM.addBooking(booking)
            }
        }
        .sheet(isPresented: $showingAddSalon) {
            AddSalonView { salon in
                viewModel.addSalon(salon)
            }
        }
        .refreshable {
            viewModel.refreshSalons()
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Near You")
                    .font(.playfairBold(size: 28))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Discover amazing SPA experiences")
                    .font(.playfairRegular(size: 16))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: { showingAddSalon = true }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(ColorTheme.primaryText)
                        .padding(12)
                        .background(ColorTheme.cardBackground)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(ColorTheme.cardBorder, lineWidth: 1)
                        )
                }
                
                Button(action: { showingFilters = true }) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.title2)
                        .foregroundColor(ColorTheme.primaryText)
                        .padding(12)
                        .background(ColorTheme.cardBackground)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(ColorTheme.cardBorder, lineWidth: 1)
                        )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(ColorTheme.secondaryText)
            
            TextField("Search salons...", text: $viewModel.searchText)
                .font(.playfairRegular(size: 16))
                .foregroundColor(ColorTheme.primaryText)
                .onChange(of: viewModel.searchText) { _ in
                    viewModel.applyFilters()
                }
        }
        .padding(16)
        .background(ColorTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(ColorTheme.cardBorder, lineWidth: 1)
        )
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 10)
    }
    
    private var salonListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.filteredSalons) { salon in
                    SalonCardView(salon: salon) {
                        selectedSalon = salon
                        showingBooking = true
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "location.slash")
                .font(.system(size: 60))
                .foregroundColor(ColorTheme.secondaryText)
            
            VStack(spacing: 8) {
                Text("No SPA salons found")
                    .font(.playfairBold(size: 22))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Try adjusting your filters or search in a different area")
                    .font(.playfairRegular(size: 16))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: { viewModel.resetFilters() }) {
                Text("Reset Filters")
                    .font(.playfairSemiBold(size: 16))
                    .foregroundColor(ColorTheme.buttonText)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(ColorTheme.buttonPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Spacer()
        }
    }
}

struct SalonCardView: View {
    let salon: SPASalon
    let onBookTapped: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LoadedImageView(filename: salon.imageURL.isEmpty ? nil : salon.imageURL) {
                VStack {
                    Image(systemName: "photo")
                        .font(.system(size: 40))
                        .foregroundColor(ColorTheme.secondaryText)
                    Text("SPA Image")
                        .font(.playfairRegular(size: 14))
                        .foregroundColor(ColorTheme.secondaryText)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .frame(height: 180)
                .background(ColorTheme.primaryPurple.opacity(0.3))
            }
            .frame(height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(salon.name)
                            .font(.playfairBold(size: 20))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        HStack(spacing: 8) {
                            HStack(spacing: 2) {
                                ForEach(0..<5) { index in
                                    Image(systemName: index < Int(salon.rating) ? "star.fill" : "star")
                                        .font(.caption)
                                        .foregroundColor(ColorTheme.accentOrange)
                                }
                            }
                            
                            Text("\(salon.formattedRating) (\(salon.reviewCount) reviews)")
                                .font(.playfairRegular(size: 14))
                                .foregroundColor(ColorTheme.secondaryText)
                        }
                    }
                    
                    Spacer()
                    
                    if salon.hasDiscount {
                        Text("-\(salon.discountPercentage ?? 0)%")
                            .font(.playfairBold(size: 14))
                            .foregroundColor(ColorTheme.primaryWhite)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(ColorTheme.accentPink)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                }
                
                HStack {
                    Text(salon.formattedDistance)
                        .font(.playfairRegular(size: 14))
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    Spacer()
                    
                    Text(salon.priceRange.rawValue)
                        .font(.playfairSemiBold(size: 16))
                        .foregroundColor(ColorTheme.primaryText)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(salon.availableServices.prefix(3)) { service in
                            Text(service.name)
                                .font(.playfairRegular(size: 12))
                                .foregroundColor(ColorTheme.primaryText)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(ColorTheme.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding(.horizontal, 1)
                }
                
                Button(action: onBookTapped) {
                    Text("Book Now")
                        .font(.playfairSemiBold(size: 16))
                        .foregroundColor(ColorTheme.buttonText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(ColorTheme.buttonPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(16)
        }
        .background(ColorTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.cardBorder, lineWidth: 1)
        )
    }
}

#Preview {
    SPAListView()
        .environmentObject(SPAListViewModel())
        .environmentObject(BookingsViewModel())
}
