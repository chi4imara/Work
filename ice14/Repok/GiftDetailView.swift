import SwiftUI

struct GiftDetailView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    let gift: Gift
    
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var showingEventSelection = false
    @State private var relatedEvents: [Event] = []
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(gift.title)
                            .font(.appTitle(28))
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.leading)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Information")
                                .font(.appHeadline(18))
                                .foregroundColor(AppColors.accentText)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                if !gift.person.isEmpty {
                                    InfoRow(title: "For", value: gift.person)
                                }
                                
                                InfoRow(
                                    title: "Category",
                                    value: dataManager.getCategoryName(for: gift.categoryId),
                                    icon: dataManager.getCategoryIcon(for: gift.categoryId)
                                )
                                
                                InfoRow(title: "Status", value: gift.status.displayName)
                                
                                InfoRow(
                                    title: "Added",
                                    value: DateFormatter.longDate.string(from: gift.createdAt)
                                )
                                
                                if gift.updatedAt != gift.createdAt {
                                    InfoRow(
                                        title: "Updated",
                                        value: DateFormatter.longDate.string(from: gift.updatedAt)
                                    )
                                }
                            }
                        }
                        .padding(16)
                        .background(AppColors.cardBackground.opacity(0.9))
                        .cornerRadius(12)
                        
                        if !gift.note.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Note")
                                    .font(.appHeadline(18))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Text(gift.note)
                                    .font(.appBody(16))
                                    .foregroundColor(AppColors.secondaryText)
                                    .padding(16)
                                    .frame(maxWidth: .infinity)
                                    .background(AppColors.cardBackground.opacity(0.9))
                                    .cornerRadius(12)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Related Events")
                                    .font(.appHeadline(18))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Spacer()
                                
                                Button(action: { showingEventSelection = true }) {
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(AppColors.primaryText)
                                        .font(.system(size: 20))
                                }
                            }
                            
                            if relatedEvents.isEmpty {
                                Text("No events linked to this gift")
                                    .font(.appBody(14))
                                    .foregroundColor(Color.black.opacity(0.6))
                                    .padding(16)
                                    .background(AppColors.cardBackground.opacity(0.7))
                                    .cornerRadius(12)
                            } else {
                                VStack(spacing: 8) {
                                    ForEach(relatedEvents) { event in
                                        EventLinkRow(
                                            event: event,
                                            onRemove: {
                                                dataManager.removeGiftFromEvent(
                                                    giftId: gift.id,
                                                    eventId: event.id
                                                )
                                                loadRelatedEvents()
                                            }
                                        )
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .navigationTitle("Gift Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: { showingEditSheet = true }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive, action: { showingDeleteAlert = true }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(AppColors.primaryText)
                }
            }
        }
        .onAppear {
            loadRelatedEvents()
        }
        .sheet(isPresented: $showingEditSheet) {
            AddEditGiftView(gift: gift, isPresented: $showingEditSheet)
        }
        .sheet(isPresented: $showingEventSelection) {
            EventSelectionView(
                giftId: gift.id,
                isPresented: $showingEventSelection,
                onEventSelected: {
                    loadRelatedEvents()
                }
            )
        }
        .alert("Delete Gift?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                dataManager.deleteGift(gift)
                presentationMode.wrappedValue.dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action cannot be undone. The gift will be removed from all events.")
        }
    }
    
    private func loadRelatedEvents() {
        relatedEvents = dataManager.getEventsForGift(gift.id)
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    let icon: String?
    
    init(title: String, value: String, icon: String? = nil) {
        self.title = title
        self.value = value
        self.icon = icon
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.appBody(14))
                .foregroundColor(AppColors.secondaryText.opacity(0.7))
                .frame(width: 80, alignment: .leading)
            
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(AppColors.primaryPurple)
                        .font(.system(size: 14))
                }
                
                Text(value)
                    .font(.appBody(14))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
        }
    }
}

struct EventLinkRow: View {
    let event: Event
    let onRemove: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.appBody(14))
                    .foregroundColor(AppColors.secondaryText)
                
                Text(DateFormatter.longDate.string(from: event.date))
                    .font(.appCaption(12))
                    .foregroundColor(AppColors.secondaryText.opacity(0.7))
            }
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(AppColors.deleteRed)
                    .font(.system(size: 16))
            }
        }
        .padding(12)
        .background(AppColors.cardBackground.opacity(0.9))
        .cornerRadius(8)
    }
}

struct EventSelectionView: View {
    @EnvironmentObject var dataManager: DataManager
    let giftId: UUID
    @Binding var isPresented: Bool
    let onEventSelected: () -> Void
    
    @State private var showingAddEvent = false
    
    var availableEvents: [Event] {
        let linkedEventIds = dataManager.getEventsForGift(giftId).map { $0.id }
        return dataManager.events.filter { !linkedEventIds.contains($0.id) }
            .sorted { $0.date < $1.date }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack {
                    if availableEvents.isEmpty {
                        EmptyStateView(
                            icon: "calendar",
                            title: "No Available Events",
                            subtitle: "Create an event to link with this gift",
                            buttonTitle: "Create Event",
                            buttonAction: { showingAddEvent = true }
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(availableEvents) { event in
                                    Button(action: {
                                        dataManager.addGiftToEvent(giftId: giftId, eventId: event.id)
                                        onEventSelected()
                                        isPresented = false
                                    }) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(event.title)
                                                    .font(.appHeadline(16))
                                                    .foregroundColor(AppColors.secondaryText)
                                                
                                                Text(DateFormatter.longDate.string(from: event.date))
                                                    .font(.appCaption(14))
                                                    .foregroundColor(AppColors.secondaryText.opacity(0.7))
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "plus.circle")
                                                .foregroundColor(AppColors.primaryPurple)
                                        }
                                        .padding(16)
                                        .background(AppColors.cardBackground)
                                        .cornerRadius(12)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                }
            }
            .navigationTitle("Select Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("New Event") {
                        showingAddEvent = true
                    }
                    .foregroundColor(AppColors.primaryText)
                }
            }
        }
        .sheet(isPresented: $showingAddEvent) {
            AddEditEventView(isPresented: $showingAddEvent)
        }
    }
}

extension DateFormatter {
    static let longDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}
