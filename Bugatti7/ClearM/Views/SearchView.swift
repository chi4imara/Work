import SwiftUI

struct SearchView: View {
    @ObservedObject var eventStore: EventStore
    @State private var searchText = ""
    @State private var selectedEventDetail: EventDetailSheetItem?
    
    private var filteredEvents: [Event] {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if trimmed.isEmpty {
            return eventStore.events
        }
        return eventStore.events.filter {
            $0.title.lowercased().contains(trimmed) ||
            $0.shortFormattedDate.lowercased().contains(trimmed)
        }
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Search")
                        .font(AppFonts.title(32))
                        .foregroundColor(AppColors.primaryWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                searchField
                
                if eventStore.events.isEmpty {
                    emptyState
                } else if filteredEvents.isEmpty {
                    noResultsState
                } else {
                    searchResultsList
                }
            }
        }
        .sheet(item: $selectedEventDetail) { item in
            EventDetailView(eventId: item.eventId, eventStore: eventStore)
        }
    }
    
    private var searchField: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(AppColors.primaryWhite.opacity(0.6))
            
            TextField("Search events by name or date", text: $searchText)
                .font(AppFonts.body(16))
                .foregroundColor(AppColors.primaryWhite)
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(AppColors.primaryWhite.opacity(0.6))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                .fill(AppColors.primaryWhite.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                        .stroke(AppColors.primaryWhite.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyState: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(AppColors.primaryWhite.opacity(0.5))
            
            Text("No events to search. Add events in the Events tab.")
                .font(AppFonts.body(16))
                .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
    
    private var noResultsState: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(AppColors.primaryWhite.opacity(0.5))
            
            Text("No events match your search.")
                .font(AppFonts.body(16))
                .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
    
    private var searchResultsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredEvents) { event in
                    EventRowView(event: event) {
                        selectedEventDetail = EventDetailSheetItem(eventId: event.id)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 20)
        }
    }
}
