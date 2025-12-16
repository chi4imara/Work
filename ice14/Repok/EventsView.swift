import SwiftUI

struct EventsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddEvent = false
    @State private var editingEvent: Event?
    @State private var showingDeleteAlert = false
    @State private var eventToDelete: Event?
    
    private var sortedEvents: [Event] {
        dataManager.events.sorted { $0.date < $1.date }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Events")
                            .font(.appTitle(28))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Button(action: { showingAddEvent = true }) {
                            Image(systemName: "plus")
                                .font(.appTitle(28))
                                .foregroundColor(AppColors.primaryText)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    if sortedEvents.isEmpty {
                        EmptyStateView(
                            icon: "calendar",
                            title: "No Events Yet",
                            subtitle: "Create events to organize your gifts by occasions",
                            buttonTitle: "Add Event",
                            buttonAction: { showingAddEvent = true }
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(sortedEvents) { event in
                                    EventCardView(
                                        event: event,
                                        onEdit: { editingEvent = event },
                                        onDelete: {
                                            eventToDelete = event
                                            showingDeleteAlert = true
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddEvent) {
                AddEditEventView(isPresented: $showingAddEvent)
            }
            .sheet(item: $editingEvent) { event in
                AddEditEventView(event: event, isPresented: .constant(true)) {
                    editingEvent = nil
                }
            }
            .alert("Delete Event?", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    if let event = eventToDelete {
                        dataManager.deleteEvent(event)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Related gifts will remain but the connection will be removed.")
            }
            .navigationBarHidden(true)
        }
    }
}

struct EventCardView: View {
    @EnvironmentObject var dataManager: DataManager
    let event: Event
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var showingGiftSelection = false
    
    private var relatedGifts: [Gift] {
        dataManager.getGiftsForEvent(event.id)
    }
    
    private var isUpcoming: Bool {
        event.date > Date()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.title)
                        .font(.appHeadline(20))
                        .foregroundColor(AppColors.secondaryText)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "calendar")
                            .foregroundColor(AppColors.primaryPurple)
                            .font(.system(size: 14))
                        
                        Text(DateFormatter.longDate.string(from: event.date))
                            .font(.appBody(14))
                            .foregroundColor(AppColors.secondaryText.opacity(0.8))
                        
                        if isUpcoming {
                            Text("• Upcoming")
                                .font(.appCaption(12))
                                .foregroundColor(AppColors.successGreen)
                        }
                    }
                }
                
                Spacer()
                
                Menu {
                    Button(action: onEdit) {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive, action: onDelete) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(AppColors.secondaryText.opacity(0.6))
                        .font(.system(size: 18))
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Gifts (\(relatedGifts.count))")
                        .font(.appHeadline(16))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Spacer()
                    
                    Button(action: { showingGiftSelection = true }) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(AppColors.primaryPurple)
                            .font(.system(size: 18))
                    }
                }
                
                if relatedGifts.isEmpty {
                    Text("No gifts added to this event")
                        .font(.appCaption(14))
                        .foregroundColor(AppColors.secondaryText.opacity(0.6))
                        .padding(.vertical, 8)
                } else {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 8) {
                        ForEach(relatedGifts) { gift in
                            NavigationLink(destination: GiftDetailView(gift: gift)) {
                                GiftMiniCardView(
                                    gift: gift,
                                    onRemove: {
                                        dataManager.removeGiftFromEvent(
                                            giftId: gift.id,
                                            eventId: event.id
                                        )
                                    }
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .swipeActions(edge: .trailing) {
            Button("Delete") {
                onDelete()
            }
            .tint(AppColors.deleteRed)
        }
        .swipeActions(edge: .leading) {
            Button("Edit") {
                onEdit()
            }
            .tint(AppColors.editBlue)
        }
        .sheet(isPresented: $showingGiftSelection) {
            GiftSelectionView(
                eventId: event.id,
                isPresented: $showingGiftSelection
            )
        }
    }
}

struct GiftMiniCardView: View {
    @EnvironmentObject var dataManager: DataManager
    let gift: Gift
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(gift.title)
                    .font(.appCaption(12))
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(1)
                
                Text(dataManager.getCategoryName(for: gift.categoryId))
                    .font(.system(size: 10))
                    .foregroundColor(AppColors.secondaryText.opacity(0.6))
            }
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .foregroundColor(AppColors.deleteRed)
                    .font(.system(size: 10))
            }
        }
        .padding(8)
        .background(AppColors.cardBackground.opacity(0.5))
        .cornerRadius(6)
    }
}

struct GiftSelectionView: View {
    @EnvironmentObject var dataManager: DataManager
    let eventId: UUID
    @Binding var isPresented: Bool
    
    @State private var searchText = ""
    @State private var showingAddGift = false
    
    private var availableGifts: [Gift] {
        let linkedGiftIds = dataManager.getGiftsForEvent(eventId).map { $0.id }
        var gifts = dataManager.gifts.filter { !linkedGiftIds.contains($0.id) }
        
        if !searchText.isEmpty {
            gifts = gifts.filter { 
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.person.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return gifts.sorted { $0.createdAt > $1.createdAt }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    SearchBar(text: $searchText)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    
                    if availableGifts.isEmpty {
                        EmptyStateView(
                            icon: "gift",
                            title: searchText.isEmpty ? "No Available Gifts" : "No Results Found",
                            subtitle: searchText.isEmpty ? 
                                "Create a gift to add to this event" : 
                                "Try adjusting your search",
                            buttonTitle: searchText.isEmpty ? "Create Gift" : "Clear Search",
                            buttonAction: {
                                if searchText.isEmpty {
                                    showingAddGift = true
                                } else {
                                    searchText = ""
                                }
                            }
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(availableGifts) { gift in
                                    Button(action: {
                                        dataManager.addGiftToEvent(giftId: gift.id, eventId: eventId)
                                        isPresented = false
                                    }) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(gift.title)
                                                    .font(.appHeadline(16))
                                                    .foregroundColor(AppColors.secondaryText)
                                                
                                                if !gift.person.isEmpty {
                                                    Text("For: \(gift.person)")
                                                        .font(.appCaption(14))
                                                        .foregroundColor(AppColors.secondaryText.opacity(0.7))
                                                }
                                                
                                                HStack(spacing: 8) {
                                                    Image(systemName: dataManager.getCategoryIcon(for: gift.categoryId))
                                                        .foregroundColor(AppColors.primaryPurple)
                                                        .font(.system(size: 12))
                                                    
                                                    Text(dataManager.getCategoryName(for: gift.categoryId))
                                                        .font(.appCaption(12))
                                                        .foregroundColor(AppColors.secondaryText.opacity(0.7))
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "plus.circle")
                                                .foregroundColor(AppColors.primaryPurple)
                                                .font(.system(size: 20))
                                        }
                                        .padding(16)
                                        .background(AppColors.cardBackground)
                                        .cornerRadius(12)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        }
                    }
                }
            }
            .navigationTitle("Select Gift")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("New Gift") {
                        showingAddGift = true
                    }
                    .foregroundColor(AppColors.primaryText)
                }
            }
        }
        .sheet(isPresented: $showingAddGift) {
            AddEditGiftView(isPresented: $showingAddGift)
        }
    }
}

struct AddEditEventView: View {
    @EnvironmentObject var dataManager: DataManager
    @Binding var isPresented: Bool
    let onDismiss: (() -> Void)?
    
    let event: Event?
    
    @State private var title = ""
    @State private var date = Date()
    @State private var showingValidationError = false
    @State private var validationMessage = ""
    
    private var isEditing: Bool {
        event != nil
    }
    
    private var navigationTitle: String {
        isEditing ? "Edit Event" : "New Event"
    }
    
    init(event: Event? = nil, isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil) {
        self.event = event
        self._isPresented = isPresented
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Event Name *")
                            .font(.appHeadline(16))
                            .foregroundColor(AppColors.primaryText)
                        
                        TextField("Enter event name", text: $title)
                            .font(.appBody(16))
                            .foregroundColor(AppColors.secondaryText)
                            .padding(12)
                            .background(AppColors.cardBackground)
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date *")
                            .font(.appHeadline(16))
                            .foregroundColor(AppColors.primaryText)
                        
                        DatePicker("Select date", selection: $date, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .padding(12)
                            .background(AppColors.cardBackground)
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveEvent()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
            }
        }
        .onAppear {
            setupInitialValues()
        }
        .alert("Validation Error", isPresented: $showingValidationError) {
            Button("OK") { }
        } message: {
            Text(validationMessage)
        }
    }
    
    private func setupInitialValues() {
        if let event = event {
            title = event.title
            date = event.date
        }
    }
    
    private func saveEvent() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedTitle.isEmpty {
            validationMessage = "Please enter an event name"
            showingValidationError = true
            return
        }
        
        if trimmedTitle.count > 80 {
            validationMessage = "Event name must be 80 characters or less"
            showingValidationError = true
            return
        }
        
        if let existingEvent = event {
            var updatedEvent = existingEvent
            updatedEvent.title = trimmedTitle
            updatedEvent.date = date
            dataManager.updateEvent(updatedEvent)
        } else {
            let newEvent = Event(title: trimmedTitle, date: date)
            dataManager.addEvent(newEvent)
        }
        
        dismiss()
    }
    
    private func dismiss() {
        if let onDismiss = onDismiss {
            onDismiss()
        } else {
            isPresented = false
        }
    }
}
