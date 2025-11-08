import SwiftUI

struct FavoritesView: View {
    @ObservedObject var eventStore: EventStore
    @State private var isMultiSelectMode = false
    @State private var selectedEvents: Set<UUID> = []
    @State private var showingFilterMenu = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                FavoritesHeaderView(
                    isMultiSelectMode: $isMultiSelectMode,
                    selectedEvents: $selectedEvents,
                    showingFilterMenu: $showingFilterMenu
                )
                
                SearchAndFiltersView(eventStore: eventStore)
                
                if filteredFavoriteEvents.isEmpty {
                    EmptyFavoritesView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredFavoriteEvents) { event in
                                FavoriteEventItemView(
                                    event: event,
                                    eventStore: eventStore,
                                    isMultiSelectMode: isMultiSelectMode,
                                    isSelected: selectedEvents.contains(event.id)
                                ) {
                                    toggleSelection(for: event)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
            
            if isMultiSelectMode && !selectedEvents.isEmpty {
                VStack {
                    Spacer()
                    FavoritesBottomBar(
                        selectedCount: selectedEvents.count,
                        onRemoveFromFavorites: removeSelectedFromFavorites,
                        onCancel: cancelMultiSelect
                    )
                }
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .sheet(isPresented: $showingFilterMenu) {
            FilterSheetView(eventStore: eventStore)
        }
    }
    
    private var filteredFavoriteEvents: [Event] {
        let favorites = eventStore.favoriteEvents
        return favorites.filter { event in
            let matchesSearch = eventStore.searchText.isEmpty || event.title.localizedCaseInsensitiveContains(eventStore.searchText)
            let matchesType = eventStore.selectedEventTypes.contains(event.type)
            return matchesSearch && matchesType
        }
    }
    
    
    private func toggleSelection(for event: Event) {
        if selectedEvents.contains(event.id) {
            selectedEvents.remove(event.id)
        } else {
            selectedEvents.insert(event.id)
        }
        
        if selectedEvents.isEmpty {
            isMultiSelectMode = false
        }
    }
    
    private func removeSelectedFromFavorites() {
        for eventId in selectedEvents {
            if let event = eventStore.events.first(where: { $0.id == eventId }) {
                eventStore.toggleFavorite(event)
            }
        }
        cancelMultiSelect()
    }
    
    private func cancelMultiSelect() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isMultiSelectMode = false
            selectedEvents.removeAll()
        }
    }
}

struct FavoritesHeaderView: View {
    @Binding var isMultiSelectMode: Bool
    @Binding var selectedEvents: Set<UUID>
    @Binding var showingFilterMenu: Bool
    
    var body: some View {
        HStack {
            Text("Favorite Events")
                .font(FontManager.title)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            if !isMultiSelectMode {
                Button(action: { showingFilterMenu = true }) {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            if isMultiSelectMode {
                Button("Cancel") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isMultiSelectMode = false
                        selectedEvents.removeAll()
                    }
                }
                .font(FontManager.subheadline)
                .foregroundColor(AppColors.accent)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
}

struct FavoriteEventItemView: View {
    let event: Event
    @ObservedObject var eventStore: EventStore
    let isMultiSelectMode: Bool
    let isSelected: Bool
    let onToggleSelection: () -> Void
    @State private var showingDetails = false
    @State private var offset: CGSize = .zero
    @State private var showingRemoveAlert = false
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                
                HStack {
                    Image(systemName: "star.slash.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                    Text("Remove")
                        .font(FontManager.small)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .background(AppColors.warning)
                .cornerRadius(16)
                .opacity(offset.width < -50 ? 1 : 0)
            }
            
            HStack(spacing: 16) {
                if isMultiSelectMode {
                    Button(action: onToggleSelection) {
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 24))
                            .foregroundColor(isSelected ? AppColors.accent : AppColors.secondaryText.opacity(0.5))
                    }
                }
                
                HStack(spacing: 16) {
                    ZStack {
                        Image(systemName: event.type.icon)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(AppColors.accent)
                            .frame(width: 40, height: 40)
                            .background(AppColors.accent.opacity(0.1))
                            .cornerRadius(20)
                        
                        VStack {
                            HStack {
                                Spacer()
                                Image(systemName: "star.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(AppColors.accent)
                            }
                            Spacer()
                        }
                        .frame(width: 40, height: 40)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(event.title)
                            .font(FontManager.subheadline)
                            .foregroundColor(AppColors.primaryText)
                            .lineLimit(1)
                        
                        HStack {
                            Text(event.type.displayName)
                                .font(FontManager.small)
                                .foregroundColor(AppColors.background)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(AppColors.accent.opacity(0.8))
                                .cornerRadius(8)
                            
                            Spacer()
                        }
                        
                        Text(event.dateString)
                            .font(FontManager.small)
                            .foregroundColor(AppColors.secondaryText.opacity(0.7))
                        
                        if !event.shortNote.isEmpty {
                            Text(event.shortNote)
                                .font(FontManager.small)
                                .foregroundColor(AppColors.secondaryText.opacity(0.8))
                                .lineLimit(2)
                        }
                    }
                    
                    Spacer()
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.cardGradient)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                )
            }
        }
        .onTapGesture {
            if !isMultiSelectMode {
                showingDetails = true
            } else {
                onToggleSelection()
            }
        }
        .onLongPressGesture {
            if !isMultiSelectMode {
                withAnimation(.easeInOut(duration: 0.3)) {
                    onToggleSelection()
                }
            }
        }
        .sheet(isPresented: $showingDetails) {
            EventDetailView(event: event, eventStore: eventStore)
        }
        .alert("Remove from Favorites", isPresented: $showingRemoveAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    eventStore.toggleFavorite(event)
                }
            }
        } message: {
            Text("This event will be removed from your favorites list.")
        }
    }
}

struct EmptyFavoritesView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "star")
                .font(.system(size: 80))
                .foregroundColor(AppColors.accent.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("No favorite events")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Mark events as favorites to see them here")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.secondaryText.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 12) {
                Text("Swipe right on any event or tap the star icon to add it to favorites")
                    .font(FontManager.small)
                    .foregroundColor(AppColors.secondaryText.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                HStack(spacing: 8) {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.accent)
                    
                    Text("Swipe gesture")
                        .font(FontManager.small)
                        .foregroundColor(AppColors.accent)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(AppColors.accent.opacity(0.1))
                .cornerRadius(16)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 40)
    }
}

struct FavoritesBottomBar: View {
    let selectedCount: Int
    let onRemoveFromFavorites: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        HStack {
            Button("Cancel") {
                onCancel()
            }
            .font(FontManager.subheadline)
            .foregroundColor(AppColors.secondaryText)
            
            Spacer()
            
            Text("\(selectedCount) selected")
                .font(FontManager.body)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button("Remove from Favorites") {
                onRemoveFromFavorites()
            }
            .font(FontManager.subheadline)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(AppColors.warning)
            .cornerRadius(20)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.cardBackground)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: -5)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 100)
    }
}


#Preview {
    FavoritesView(eventStore: EventStore())
}
