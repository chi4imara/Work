import SwiftUI

struct PlacesListView: View {
    @ObservedObject private var placeStore = PlaceStore.shared
    @State private var showingAddPlace = false
    @State private var showingFilters = false
    @State private var showingSortOptions = false
    @State private var selectedPlace: Place?
    @State private var placeToDelete: Place?
    @State private var selectedPlaceForDetail: Place?
    @State private var showingDeleteAlert = false
    @State private var circleOffset: CGFloat = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if placeStore.filteredPlaces.isEmpty {
                        emptyStateView
                    } else {
                        placesListContent
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddPlace) {
                AddEditPlaceView(placeStore: placeStore)
            }
            .sheet(isPresented: $showingFilters) {
                FilterView(placeStore: placeStore)
            }
            .actionSheet(isPresented: $showingSortOptions) {
                sortActionSheet
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
            Text("Childhood Places")
                .font(AppTheme.titleFont)
                .foregroundColor(AppTheme.textPrimary)
            
            Spacer()
            
            HStack(spacing: 15) {
                Button(action: { showingAddPlace = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppTheme.primaryBlue)
                }
                
                Button(action: { showingSortOptions = true }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppTheme.primaryBlue)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 15)
    }
    
    private var placesListContent: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(placeStore.filteredPlaces) { place in
                    PlaceCardView(
                        place: place,
                        onTap: { selectedPlaceForDetail = place },
                        onEdit: {
                            selectedPlace = place
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
        .sheet(item: $selectedPlace) { item in
            AddEditPlaceView(placeStore: placeStore, editingPlace: item)
        }
        .sheet(item: $selectedPlaceForDetail ) { item in
            PlaceDetailView(placeId: item.id, placeStore: placeStore)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "doc.text")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppTheme.textSecondary.opacity(0.5))
            
            VStack(spacing: 12) {
                Text("No Places Yet")
                    .font(AppTheme.headlineFont)
                    .foregroundColor(AppTheme.textPrimary)
                
                Text("Here will appear memories of your childhood places")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button {
                showingAddPlace = true
            } label: {
                Text("Add First Place")
                    .primaryButtonStyle()
            }
            
            Spacer()
        }
    }
    
    private var sortActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Options"),
            buttons: [
                .default(Text("Filter...")) {
                    showingFilters = true
                },
                .default(Text("Sort: Newest First")) {
                    placeStore.sortOrder = .newestFirst
                    placeStore.applyFilters()
                },
                .default(Text("Sort: Oldest First")) {
                    placeStore.sortOrder = .oldestFirst
                    placeStore.applyFilters()
                },
                .default(Text("Sort: Alphabetical")) {
                    placeStore.sortOrder = .alphabetical
                    placeStore.applyFilters()
                },
                .cancel()
            ]
        )
    }
}

struct PlaceCardView: View {
    let place: Place
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var showingDeleteAlert = false
    @State private var showingEditAlert = false
    @State private var isSwiped = false
    
    private let swipeThreshold: CGFloat = 80
    private let maxSwipeDistance: CGFloat = 120
    private let buttonWidth: CGFloat = 80
    
    var body: some View {
        ZStack {
            if offset.width > 0 {
                HStack {
                    Button(action: {
                        showingEditAlert = true
                    }) {
                        VStack {
                            Image(systemName: "pencil")
                                .font(.system(size: 20))
                            Text("Edit")
                                .font(AppTheme.captionFont)
                        }
                        .foregroundColor(.white)
                        .frame(width: buttonWidth)
                        .frame(maxHeight: .infinity)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AppTheme.accentGreen)
                .cornerRadius(12)
                
            } else if offset.width < 0 {
                HStack {
                    Spacer()
                    Button(action: {
                        showingDeleteAlert = true
                    }) {
                        VStack {
                            Image(systemName: "trash")
                                .font(.system(size: 20))
                            Text("Delete")
                                .font(AppTheme.captionFont)
                        }
                        .foregroundColor(.white)
                        .frame(width: buttonWidth)
                        .frame(maxHeight: .infinity)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.red)
                .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(place.name)
                        .font(AppTheme.headlineFont)
                        .foregroundColor(AppTheme.textPrimary)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Text(place.dateAdded, style: .date)
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.textSecondary)
                }
                
                Text(place.category.displayName)
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.primaryBlue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(AppTheme.lightBlue.opacity(0.3))
                    .cornerRadius(12)
                
                if !place.description.isEmpty {
                    Text(place.description)
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.textSecondary)
                        .lineLimit(2)
                }
            }
            .padding(16)
            .cardStyle()
            .offset(x: offset.width, y: 0)
            .contentShape(Rectangle())
            .highPriorityGesture(
                DragGesture(minimumDistance: 20, coordinateSpace: .local)
                    .onChanged { value in
                        withAnimation(.interactiveSpring(response: 0.3)) {
                            offset.width = value.translation.width
                            if abs(offset.width) > maxSwipeDistance {
                                offset.width = offset.width > 0 ? maxSwipeDistance : -maxSwipeDistance
                            }
                        }
                    }
                    .onEnded { value in
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            if value.translation.width > swipeThreshold {
                                offset.width = maxSwipeDistance
                                isSwiped = true
                                showingEditAlert = true
                            } else if value.translation.width < -swipeThreshold {
                                offset.width = -maxSwipeDistance
                                isSwiped = true
                                showingDeleteAlert = true
                            } else {
                                resetCard()
                            }
                        }
                    }
            )
            .onTapGesture {
                if isSwiped {
                    resetCard()
                } else {
                    onTap()
                }
            }
        }
        .alert("Edit Place", isPresented: $showingEditAlert) {
            Button("Cancel", role: .cancel) {
                resetCard()
            }
            Button("Edit", role: .none) {
                onEdit()
                resetCard()
            }
        } message: {
            Text("Do you want to edit this place?")
        }
        .alert("Delete Place", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {
                resetCard()
            }
            Button("Delete", role: .destructive) {
                onDelete()
                resetCard()
            }
        } message: {
            Text("Are you sure you want to delete this place? This action cannot be undone.")
        }
        .onChange(of: showingEditAlert) { showing in
            if !showing && isSwiped {
                resetCard()
            }
        }
        .onChange(of: showingDeleteAlert) { showing in
            if !showing && isSwiped {
                resetCard()
            }
        }
        .animation(.spring(), value: offset)
    }
    
    private func resetCard() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            offset = .zero
            isSwiped = false
        }
    }
}

struct FilterView: View {
    @ObservedObject var placeStore: PlaceStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var circleOffset: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ForEach(0..<6, id: \.self) { index in
                    Circle()
                        .fill(AppTheme.lightBlue.opacity(0.3))
                        .frame(width: CGFloat.random(in: 50...120))
                        .position(
                            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                            y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                        )
                        .offset(x: circleOffset * CGFloat(index % 2 == 0 ? 1 : -1))
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 3...6))
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.5),
                            value: circleOffset
                        )
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Categories")
                            .font(AppTheme.headlineFont)
                            .foregroundColor(AppTheme.textPrimary)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                            ForEach(PlaceCategory.allCases, id: \.self) { category in
                                Button(action: {
                                    if placeStore.selectedCategories.contains(category) {
                                        placeStore.selectedCategories.remove(category)
                                    } else {
                                        placeStore.selectedCategories.insert(category)
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: placeStore.selectedCategories.contains(category) ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(placeStore.selectedCategories.contains(category) ? AppTheme.primaryBlue : AppTheme.textSecondary)
                                        
                                        Text(category.displayName)
                                            .font(AppTheme.bodyFont)
                                            .foregroundColor(AppTheme.textPrimary)
                                        
                                        Spacer()
                                    }
                                    .padding(12)
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Period")
                            .font(AppTheme.headlineFont)
                            .foregroundColor(AppTheme.textPrimary)
                        
                        ForEach(PlaceStore.FilterPeriod.allCases, id: \.self) { period in
                            Button(action: {
                                placeStore.filterPeriod = period
                            }) {
                                HStack {
                                    Image(systemName: placeStore.filterPeriod == period ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(placeStore.filterPeriod == period ? AppTheme.primaryBlue : AppTheme.textSecondary)
                                    
                                    Text(period.rawValue)
                                        .font(AppTheme.bodyFont)
                                        .foregroundColor(AppTheme.textPrimary)
                                    
                                    Spacer()
                                }
                                .padding(12)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(8)
                            }
                        }
                    }
                    
                    HStack(spacing: 15) {
                        Button {
                            placeStore.resetFilters()
                        } label: {
                            Text("Reset")
                                .font(AppTheme.buttonFont)
                                .foregroundColor(AppTheme.primaryBlue)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius)
                                        .stroke(AppTheme.primaryBlue, lineWidth: 2)
                                )
                                .cornerRadius(AppTheme.buttonCornerRadius)
                        }
                        
                        
                        Button {
                            placeStore.applyFilters()
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Apply")
                                .font(AppTheme.buttonFont)
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(AppTheme.buttonGradient)
                                .cornerRadius(AppTheme.buttonCornerRadius)
                                .shadow(color: AppTheme.buttonShadow, radius: 4, x: 0, y: 2)
                        }
                    }
                    
                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct PlacesListView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesListView()
    }
}
