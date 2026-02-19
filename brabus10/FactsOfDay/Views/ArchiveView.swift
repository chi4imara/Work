import SwiftUI

struct ArchiveView: View {
    @ObservedObject var viewModel: EventsViewModel
    @State private var selectedMonth: String?
    @State private var searchText = ""
    
    var filteredEvents: [Event] {
        let archived = viewModel.archivedEvents
        
        if searchText.isEmpty {
            return archived
        } else {
            return archived.filter { event in
                event.text.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var groupedEvents: [(key: String, value: [Event])] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        var grouped: [String: [Event]] = [:]
        for event in filteredEvents {
            let key = formatter.string(from: event.timestamp)
            grouped[key, default: []].append(event)
        }
        
        return grouped.sorted { $0.key > $1.key }
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Archive")
                        .font(.custom("PlayfairDisplay-Bold", size: 32))
                        .foregroundColor(ColorTheme.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.archivedEvents.isEmpty {
                    EmptyArchiveView()
                } else {
                    VStack(spacing: 16) {
                        SearchBar(text: $searchText)
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                        
                        ScrollView {
                            LazyVStack(spacing: 20) {
                                ForEach(groupedEvents, id: \.key) { monthData in
                                    MonthSection(
                                        month: monthData.key,
                                        events: monthData.value,
                                        viewModel: viewModel
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                            .padding(.bottom, 120)
                        }
                    }
                }
            }
        }
    }
}

struct EmptyArchiveView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "archivebox.fill")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorTheme.primaryBlue.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No archived events")
                    .font(.custom("PlayfairDisplay-Medium", size: 18))
                    .foregroundColor(ColorTheme.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Events from previous days will appear here")
                    .font(.custom("PlayfairDisplay-Regular", size: 16))
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(ColorTheme.textSecondary)
            
            TextField("Search events...", text: $text)
                .font(.custom("PlayfairDisplay-Regular", size: 16))
                .foregroundColor(ColorTheme.textPrimary)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(ColorTheme.textSecondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(ColorTheme.cardBackground)
        .cornerRadius(12)
        .shadow(color: ColorTheme.shadowColor, radius: 2, x: 0, y: 1)
    }
}

struct MonthSection: View {
    let month: String
    let events: [Event]
    @ObservedObject var viewModel: EventsViewModel
    @State private var isExpanded = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack {
                    Text(month)
                        .font(.custom("PlayfairDisplay-SemiBold", size: 20))
                        .foregroundColor(ColorTheme.textPrimary)
                    
                    Spacer()
                    
                    Text("\(events.count) event\(events.count == 1 ? "" : "s")")
                        .font(.custom("PlayfairDisplay-Regular", size: 14))
                        .foregroundColor(ColorTheme.textSecondary)
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(ColorTheme.cardBackground)
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(spacing: 8) {
                    ForEach(events) { event in
                        NavigationLink(destination: EventDetailView(eventId: event.id, viewModel: viewModel)) {
                            ArchiveEventCard(event: event)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}

struct ArchiveEventCard: View {
    let event: Event
    
    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 4) {
                Text(event.formattedTime)
                    .font(.custom("PlayfairDisplay-SemiBold", size: 14))
                    .foregroundColor(ColorTheme.primaryBlue)
                
                Text(event.formattedDate)
                    .font(.custom("PlayfairDisplay-Regular", size: 12))
                    .foregroundColor(ColorTheme.textSecondary)
            }
            .frame(width: 80)
            
            Text(event.text)
                .font(.custom("PlayfairDisplay-Regular", size: 16))
                .foregroundColor(ColorTheme.textPrimary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(ColorTheme.textSecondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(ColorTheme.cardBackground)
        .cornerRadius(10)
        .shadow(color: ColorTheme.shadowColor, radius: 2, x: 0, y: 1)
    }
}
