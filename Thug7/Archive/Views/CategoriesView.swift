import SwiftUI

struct CategoriesView: View {
    @ObservedObject private var placeStore = PlaceStore.shared
    @State private var selectedCategory: PlaceCategory?
    @State private var circleOffset: CGFloat = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if placeStore.totalPlacesCount() == 0 {
                        emptyStateView
                    } else {
                        categoriesContent
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(item: $selectedCategory) { category in
                CategoryPlacesView(category: category, placeStore: placeStore)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Categories")
                .font(AppTheme.titleFont)
                .foregroundColor(AppTheme.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 15)
    }
    
    private var categoriesContent: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(PlaceCategory.allCases, id: \.self) { category in
                    CategoryCardView(
                        category: category,
                        count: placeStore.placesCount(for: category),
                        onTap: {
                            selectedCategory = category
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "folder")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppTheme.textSecondary.opacity(0.5))
            
            VStack(spacing: 12) {
                Text("No Categories Yet")
                    .font(AppTheme.headlineFont)
                    .foregroundColor(AppTheme.textPrimary)
                
                Text("Categories will appear here once you add places")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

struct CategoryCardView: View {
    let category: PlaceCategory
    let count: Int
    let onTap: () -> Void
    
    private var categoryIcon: String {
        switch category {
        case .school:
            return "building.2"
        case .yard:
            return "house"
        case .trip:
            return "car"
        case .other:
            return "location"
        }
    }
    
    private var categoryColor: Color {
        switch category {
        case .school:
            return AppTheme.primaryBlue
        case .yard:
            return AppTheme.accentGreen
        case .trip:
            return AppTheme.accentOrange
        case .other:
            return AppTheme.accentPurple
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(categoryColor.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: categoryIcon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(categoryColor)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(category.displayName)
                        .font(AppTheme.headlineFont)
                        .foregroundColor(AppTheme.textPrimary)
                    
                    Text("\(count) \(count == 1 ? "place" : "places")")
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)
            }
            .padding(20)
            .cardStyle()
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(count == 0)
        .opacity(count == 0 ? 0.6 : 1.0)
    }
}

struct CategoryPlacesView: View {
    let category: PlaceCategory
    @ObservedObject var placeStore: PlaceStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedPlace: Place?
    @State private var showingAddPlace = false
    @State private var placeToDelete: Place?
    @State private var showingDeleteAlert = false
    @State private var circleOffset: CGFloat = 0
    
    private var categoryPlaces: [Place] {
        placeStore.places.filter { $0.category == category }
            .sorted { $0.dateAdded > $1.dateAdded }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if categoryPlaces.isEmpty {
                        emptyStateView
                    } else {
                        placesListContent
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddPlace) {
                AddEditPlaceView(placeStore: placeStore, preselectedCategory: category)
            }
            .sheet(item: $selectedPlace) { place in
                PlaceDetailView(placeId: place.id, placeStore: placeStore)
            }
            .alert("Delete Place", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    if let place = placeToDelete {
                        placeStore.deletePlace(place)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete this place? This action cannot be undone.")
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppTheme.primaryBlue)
            }
            
            Text(category.displayName)
                .font(AppTheme.titleFont)
                .foregroundColor(AppTheme.textPrimary)
            
            Spacer()
            
            Button(action: { showingAddPlace = true }) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppTheme.primaryBlue)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 15)
    }
    
    private var placesListContent: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(categoryPlaces) { place in
                    PlaceCardView(
                        place: place,
                        onTap: { selectedPlace = place },
                        onEdit: { 
                            selectedPlace = place
                            showingAddPlace = true
                        },
                        onDelete: {
                            placeToDelete = place
                            showingDeleteAlert = true
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "location.slash")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppTheme.textSecondary.opacity(0.5))
            
            VStack(spacing: 12) {
                Text("No Places in \(category.displayName)")
                    .font(AppTheme.headlineFont)
                    .foregroundColor(AppTheme.textPrimary)
                
                Text("There are no memories in this category yet")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button("Add Place") {
                showingAddPlace = true
            }
            .primaryButtonStyle()
            
            Spacer()
        }
    }
}

extension PlaceCategory: Identifiable {
    var id: String { self.rawValue }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}
