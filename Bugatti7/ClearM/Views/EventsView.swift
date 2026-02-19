import SwiftUI

struct EventsView: View {
    @ObservedObject var eventStore: EventStore
    @State private var showingAddEvent = false
    @State private var selectedEventDetail: EventDetailSheetItem?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Events")
                        .font(AppFonts.title(32))
                        .foregroundColor(AppColors.primaryWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if eventStore.events.isEmpty {
                    EmptyEventsView(showingAddEvent: $showingAddEvent)
                } else {
                    EventsListView(
                        events: eventStore.events,
                        onSelectEventId: { id in
                            selectedEventDetail = EventDetailSheetItem(eventId: id)
                        }
                    )
                }
            }
            VStack {
                Spacer()
                
                AddEventButton(showingAddEvent: $showingAddEvent)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
            }
        }
        .sheet(isPresented: $showingAddEvent) {
            AddEventView(eventStore: eventStore)
        }
        .sheet(item: $selectedEventDetail) { item in
            EventDetailView(eventId: item.eventId, eventStore: eventStore)
        }
    }
}

struct EmptyEventsView: View {
    @Binding var showingAddEvent: Bool
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.primaryWhite.opacity(0.1))
                    .frame(width: 100, height: 100)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(AppColors.primaryYellow)
            }
            
            VStack(spacing: 16) {
                Text("Important events will appear here. Add the first one to start your timeline.")
                    .font(AppFonts.body(18))
                    .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

struct EventsListView: View {
    let events: [Event]
    let onSelectEventId: (UUID) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(events) { event in
                    EventRowView(event: event) {
                        onSelectEventId(event.id)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 100)
        }
    }
}

struct EventRowView: View {
    let event: Event
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Circle()
                    .fill(AppColors.primaryYellow)
                    .frame(width: 8, height: 8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.title)
                        .font(AppFonts.headline(16))
                        .foregroundColor(AppColors.primaryWhite)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    Text(event.shortFormattedDate)
                        .font(AppFonts.caption(14))
                        .foregroundColor(AppColors.primaryWhite.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.primaryWhite.opacity(0.5))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                    .fill(AppColors.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                            .stroke(AppColors.primaryWhite.opacity(0.1), lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0) { pressing in
            isPressed = pressing
        } perform: {
            action()
        }
    }
}

struct AddEventButton: View {
    @Binding var showingAddEvent: Bool
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            showingAddEvent = true
        }) {
            HStack {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.primaryBlack)
                
                Text("Add event")
                    .font(AppFonts.headline(18))
                    .foregroundColor(AppColors.primaryBlack)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(AppColors.primaryYellow)
            .cornerRadius(AppConstants.cornerRadius)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0) { pressing in
            isPressed = pressing
        } perform: {
            showingAddEvent = true
        }
    }
}
