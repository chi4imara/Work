import SwiftUI

enum SheetItem: Identifiable {
    case addPlace
    case editPlace(Place)
    case filterSheet
    
    var id: String {
        switch self {
        case .addPlace:
            return "addPlace"
        case .editPlace(let place):
            return "editPlace_\(place.id)"
        case .filterSheet:
            return "filterSheet"
        }
    }
}

struct HomeView: View {
    @ObservedObject var viewModel: PlacesViewModel
    @State private var showingFilters = false
    @State private var showingSortOptions = false
    @State private var placeToDelete: Place?
    @State private var showingDeleteAlert = false
    @State private var placeToEdit: Place?
    @State private var sheetItem: SheetItem?
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.filteredPlaces.isEmpty {
                    emptyStateView
                } else {
                    placesList
                }
            }
        }
        .sheet(item: $sheetItem) { item in
            switch item {
            case .addPlace:
                AddEditPlaceView(viewModel: viewModel)
            case .editPlace(let place):
                AddEditPlaceView(viewModel: viewModel, placeToEdit: place)
            case .filterSheet:
                FilterSheetView(viewModel: viewModel)
            }
        }
        .confirmationDialog("Options", isPresented: $showingFilters) {
            Button("Filter...") {
                sheetItem = .filterSheet
            }
            Button("Sort...") {
                showingSortOptions = true
            }
            Button("Cancel", role: .cancel) { }
        }
        .onChange(of: showingFilters) { isShowing in
            print("Showing filters: \(isShowing)")
        }
        .confirmationDialog("Sort By", isPresented: $showingSortOptions) {
            Button("Date Added") {
                viewModel.sortByDate = true
                viewModel.updateFilteredPlaces()
            }
            Button("Alphabetically") {
                viewModel.sortByDate = false
                viewModel.updateFilteredPlaces()
            }
            Button("Cancel", role: .cancel) { }
        }
        .alert("Delete Place", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let place = placeToDelete {
                    viewModel.deletePlace(place)
                }
            }
        } message: {
            Text("Are you sure you want to delete this place? This action cannot be undone.")
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Home")
                    .font(FontManager.largeTitle)
                    .foregroundColor(ColorTheme.primaryText)
                
                if viewModel.showOnlyFavorites || viewModel.selectedCategory != "All" {
                    HStack(spacing: 8) {
                        if viewModel.showOnlyFavorites {
                            Text("Favorites")
                                .font(FontManager.caption)
                                .foregroundColor(ColorTheme.primaryBlue)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(ColorTheme.lightBlue.opacity(0.3))
                                .cornerRadius(8)
                        }
                        
                        if viewModel.selectedCategory != "All" {
                            Text(viewModel.selectedCategory)
                                .font(FontManager.caption)
                                .foregroundColor(ColorTheme.primaryBlue)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(ColorTheme.lightBlue.opacity(0.3))
                                .cornerRadius(8)
                        }
                        
                        Button("Reset") {
                            viewModel.resetFilters()
                        }
                        .font(FontManager.caption)
                        .foregroundColor(ColorTheme.accentOrange)
                    }
                }
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: { 
                    print("Add button tapped")
                    sheetItem = .addPlace
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(ColorTheme.primaryBlue)
                        .clipShape(Circle())
                        .shadow(color: ColorTheme.primaryBlue.opacity(0.3), radius: 4, x: 0, y: 2)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: { 
                    print("Ellipsis button tapped")
                    showingFilters = true 
                }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(ColorTheme.primaryBlue)
                        .frame(width: 40, height: 40)
                        .background(ColorTheme.backgroundWhite)
                        .clipShape(Circle())
                        .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var placesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredPlaces) { place in
                    NavigationLink(destination: PlaceDetailView(viewModel: viewModel, place: place)) {
                        PlaceCardView(place: place)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .contextMenu {
                        Button("Edit") {
                            sheetItem = .editPlace(place)
                        }
                        Button("Delete", role: .destructive) {
                            placeToDelete = place
                            showingDeleteAlert = true
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("Delete") {
                            placeToDelete = place
                            showingDeleteAlert = true
                        }
                        .tint(.red)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        Button("Edit") {
                            sheetItem = .editPlace(place)
                        }
                        .tint(ColorTheme.primaryBlue)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "location.circle")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.lightBlue)
            
            VStack(spacing: 12) {
                Text(viewModel.places.isEmpty ? "No Places Yet" : "No Results")
                    .font(FontManager.title2)
                    .foregroundColor(ColorTheme.primaryText)
                
                Text(viewModel.places.isEmpty ? 
                     "Start building your collection of power spots" : 
                     "Try adjusting your filters")
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                if viewModel.places.isEmpty {
                    sheetItem = .addPlace
                } else {
                    viewModel.resetFilters()
                }
            }) {
                Text(viewModel.places.isEmpty ? "Add First Place" : "Reset Filters")
                    .font(FontManager.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(ColorTheme.primaryBlue)
                    .cornerRadius(12)
                    .shadow(color: ColorTheme.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: PlacesViewModel())
    }
}
