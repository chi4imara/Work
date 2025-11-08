import SwiftUI

struct AllEventsView: View {
    @ObservedObject var eventStore: EventStore
    @State private var showingAddEvent = false
    @State private var showingFilterMenu = false
    @State private var showingSortMenu = false
    @State private var isMultiSelectMode = false
    @State private var selectedEvents: Set<UUID> = []
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                EventsHeaderView(
                    eventStore: eventStore,
                    showingAddEvent: $showingAddEvent,
                    showingFilterMenu: $showingFilterMenu,
                    showingSortMenu: $showingSortMenu,
                    isMultiSelectMode: $isMultiSelectMode,
                    selectedEvents: $selectedEvents
                )
                
                SearchAndFiltersView(eventStore: eventStore)
                
                if eventStore.filteredEvents.isEmpty {
                    EmptyEventsListView(showingAddEvent: $showingAddEvent)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(eventStore.filteredEvents) { event in
                                EventListItemView(
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
            
            if isMultiSelectMode && !selectedEvents.isEmpty {
                VStack {
                    Spacer()
                    MultiSelectBottomBar(
                        selectedCount: selectedEvents.count,
                        onArchiveSelected: archiveSelectedEvents,
                        onCancel: cancelMultiSelect
                    )
                }
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .sheet(isPresented: $showingAddEvent) {
            AddEditEventView(eventStore: eventStore)
        }
        .sheet(isPresented: $showingFilterMenu) {
            FilterSheetView(eventStore: eventStore)
        }
        .actionSheet(isPresented: $showingSortMenu) {
            ActionSheet(
                title: Text("Sort Events"),
                buttons: FilterHelpers.createSortButtons(eventStore: eventStore)
            )
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
    
    private func archiveSelectedEvents() {
        for eventId in selectedEvents {
            if let event = eventStore.events.first(where: { $0.id == eventId }) {
                eventStore.archiveEvent(event)
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

struct EventsHeaderView: View {
    @ObservedObject var eventStore: EventStore
    @Binding var showingAddEvent: Bool
    @Binding var showingFilterMenu: Bool
    @Binding var showingSortMenu: Bool
    @Binding var isMultiSelectMode: Bool
    @Binding var selectedEvents: Set<UUID>
    
    var body: some View {
        HStack {
            Text("All Events")
                .font(FontManager.title)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            if !isMultiSelectMode {
                Button(action: { showingAddEvent = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(AppColors.accent)
                }
                
                Button(action: { showingSortMenu = true }) {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Button(action: { showingFilterMenu = true }) {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
            } else {
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


struct EventListItemView: View {
    let event: Event
    @ObservedObject var eventStore: EventStore
    let isMultiSelectMode: Bool
    let isSelected: Bool
    let onToggleSelection: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            if isMultiSelectMode {
                Button(action: onToggleSelection) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24))
                        .foregroundColor(isSelected ? AppColors.accent : AppColors.secondaryText.opacity(0.5))
                }
            }
            
            EventCardView(event: event, eventStore: eventStore)
        }
        .onLongPressGesture {
            if !isMultiSelectMode {
                withAnimation(.easeInOut(duration: 0.3)) {
                    onToggleSelection()
                }
            }
        }
    }
}

struct EmptyEventsListView: View {
    @Binding var showingAddEvent: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "list.bullet.clipboard")
                .font(.system(size: 80))
                .foregroundColor(AppColors.accent.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("No events found")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Create your first event to get started")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.secondaryText.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            Button("Add Event") {
                showingAddEvent = true
            }
            .font(FontManager.subheadline)
            .foregroundColor(AppColors.background)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(AppColors.accent)
            .cornerRadius(25)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 40)
    }
}

struct MultiSelectBottomBar: View {
    let selectedCount: Int
    let onArchiveSelected: () -> Void
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
            
            Button("Archive Selected") {
                onArchiveSelected()
            }
            .font(FontManager.subheadline)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(AppColors.error)
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
    AllEventsView(eventStore: EventStore())
}
