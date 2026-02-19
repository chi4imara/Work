import SwiftUI

struct EventsView: View {
    @ObservedObject var appViewModel: AppViewModel
    @StateObject private var viewModel: EventsViewModel
    @State private var showingSortOptions = false
    
    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
        self._viewModel = StateObject(wrappedValue: EventsViewModel(appViewModel: appViewModel))
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                HStack {
                    Text("My Events")
                        .font(.playfair(32, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Spacer()
                    
                    Menu {
                        sortingMenu
                        filterMenu
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.playfair(24, weight: .bold))
                            .foregroundColor(ColorTheme.primaryBlue)
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
                
                if viewModel.sortedEvents.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    eventsList
                }
            }
        }
        .sheet(item: $viewModel.selectedEvent) { event in
            EventDetailView(event: event, viewModel: viewModel)
        }
    }
    
    private var eventsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.sortedEvents) { event in
                    EventCard(event: event, viewModel: viewModel)
                        .onTapGesture {
                            viewModel.selectedEvent = event
                        }
                }
            }
            .padding()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(ColorTheme.secondaryText)
            
            VStack(spacing: 8) {
                Text("You haven't scheduled any activities yet")
                    .font(.playfair(20, weight: .semibold))
                    .foregroundColor(ColorTheme.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Start planning your leisure time to maintain work-life balance")
                    .font(.playfair(16))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                appViewModel.showAddActivitySheet = true
            } label: {
                Text("Add First Activity")
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(ColorTheme.buttonGradient)
                    .foregroundColor(ColorTheme.primaryText)
                    .font(.playfair(16, weight: .medium))
            }
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .shadow(color: ColorTheme.primaryYellow.opacity(0.3), radius: 8, x: 0, y: 4)
            
            VStack(spacing: 8) {
                SwiftUI.ProgressView(value: 0.0, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: ColorTheme.primaryBlue))
                    .frame(height: 8)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                
                Text("0% of weekly goal completed")
                    .font(.playfair(12))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding(.horizontal, 32)
    }
    
    private var sortingMenu: some View {
        Section("Sort by") {
            ForEach(EventSortOption.allCases, id: \.self) { option in
                Button {
                    viewModel.sortOption = option
                } label: {
                    HStack {
                        Text(option.rawValue)
                        if viewModel.sortOption == option {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }
    }
    
    private var filterMenu: some View {
        Section("Filter by status") {
            Button("All") {
                viewModel.filterStatus = nil
            }
            
            ForEach(EventStatus.allCases, id: \.self) { status in
                Button {
                    viewModel.filterStatus = status
                } label: {
                    HStack {
                        Text(status.rawValue)
                        if viewModel.filterStatus == status {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }
    }
}

struct EventCard: View {
    let event: LeisureEvent
    let viewModel: EventsViewModel
    @State private var showingActionSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.activity.name)
                        .font(.playfair(18, weight: .semibold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text(event.activity.type.rawValue)
                        .font(.playfair(14))
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    StatusBadge(status: event.status)
                    
                    Text(formatDate(event.scheduledDate))
                        .font(.playfair(12))
                        .foregroundColor(ColorTheme.secondaryText)
                }
            }
            
            HStack {
                Image(systemName: event.activity.type.icon)
                    .foregroundColor(ColorTheme.primaryBlue)
                
                Text("\(event.activity.duration) minutes")
                    .font(.playfair(14))
                    .foregroundColor(ColorTheme.secondaryText)
                
                Spacer()
                
                Text(event.activity.goal.rawValue)
                    .font(.playfair(12))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(ColorTheme.lightBlue.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .foregroundColor(ColorTheme.primaryText)
            }
            
            if !event.notes.isEmpty {
                Text(event.notes)
                    .font(.playfair(14))
                    .foregroundColor(ColorTheme.secondaryText)
                    .lineLimit(2)
                    .padding(.top, 4)
            }
            
            if let rating = event.rating {
                HStack {
                    Text("Rating:")
                        .font(.playfair(12))
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= rating ? "star.fill" : "star")
                                .foregroundColor(ColorTheme.primaryYellow)
                                .font(.system(size: 12))
                        }
                    }
                }
            }
            
            HStack(spacing: 12) {
                if event.status == .scheduled {
                    actionButton("Complete", systemImage: "checkmark.circle", color: ColorTheme.accentGreen) {
                        viewModel.updateEventStatus(event, status: .completed)
                    }
                    
                    actionButton("Cancel", systemImage: "xmark.circle", color: ColorTheme.secondaryText) {
                        viewModel.updateEventStatus(event, status: .cancelled)
                    }
                }
                
                actionButton("Edit", systemImage: "pencil", color: ColorTheme.primaryBlue) {
                    viewModel.selectedEvent = event
                }
                
                if event.status == .completed {
                    actionButton("Add Note", systemImage: "note.text", color: ColorTheme.accentOrange) {
                        viewModel.selectedEvent = event
                        viewModel.showingAddNote = true
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 6, x: 0, y: 3)
        )
    }
    
    private func actionButton(_ title: String, systemImage: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.system(size: 12))
                Text(title)
                    .font(.playfair(12))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct StatusBadge: View {
    let status: EventStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.playfair(12, weight: .medium))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.2))
            .foregroundColor(statusColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var statusColor: Color {
        switch status {
        case .scheduled:
            return ColorTheme.primaryBlue
        case .completed:
            return ColorTheme.accentGreen
        case .missed:
            return Color.red
        case .cancelled:
            return ColorTheme.secondaryText
        }
    }
}

struct EventDetailView: View {
    let event: LeisureEvent
    let viewModel: EventsViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var notes = ""
    @State private var rating: Int = 0
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        eventHeader
                        eventDetails
                        notesSection
                        ratingSection
                        deleteSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Event Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.addNote(to: event, note: notes, rating: rating > 0 ? rating : nil)
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.primaryBlue)
                    .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            notes = event.notes
            rating = event.rating ?? 0
        }
        .alert("Delete Event", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deleteEvent(event)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this event? This action cannot be undone.")
        }
    }
    
    private var eventHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: event.activity.type.icon)
                    .font(.system(size: 32))
                    .foregroundColor(ColorTheme.primaryBlue)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.activity.name)
                        .font(.playfair(24, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text(event.activity.type.rawValue)
                        .font(.playfair(16))
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                Spacer()
                
                StatusBadge(status: event.status)
            }
            
            Text(event.activity.description)
                .font(.playfair(16))
                .foregroundColor(ColorTheme.secondaryText)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
        )
    }
    
    private var eventDetails: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Event Details")
                .font(.playfair(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 12) {
                detailRow("Duration", value: "\(event.activity.duration) minutes")
                detailRow("Goal", value: event.activity.goal.rawValue)
                detailRow("Scheduled", value: formatDate(event.scheduledDate))
                detailRow("Status", value: event.status.rawValue)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
        )
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notes & Impressions")
                .font(.playfair(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            TextEditor(text: $notes)
                .font(.playfair(16))
                .frame(minHeight: 100)
                .padding()
                .background(ColorTheme.backgroundWhite)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(ColorTheme.lightBlue, lineWidth: 1)
                )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
        )
    }
    
    private var ratingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Rating")
                .font(.playfair(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            HStack {
                ForEach(1...5, id: \.self) { star in
                    Button {
                        rating = star
                    } label: {
                        Image(systemName: star <= rating ? "star.fill" : "star")
                            .foregroundColor(star <= rating ? ColorTheme.primaryYellow : ColorTheme.secondaryText)
                            .font(.system(size: 24))
                    }
                }
                
                Spacer()
                
                if rating > 0 {
                    Text("\(rating)/5")
                        .font(.playfair(16, weight: .medium))
                        .foregroundColor(ColorTheme.primaryText)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
        )
    }
    
    private var deleteSection: some View {
        Button {
            showingDeleteAlert = true
        } label: {
            Text("Delete Event")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.1))
                .foregroundColor(.red)
                .font(.playfair(16, weight: .medium))
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func detailRow(_ title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.playfair(16))
                .foregroundColor(ColorTheme.secondaryText)
            
            Spacer()
            
            Text(value)
                .font(.playfair(16, weight: .medium))
                .foregroundColor(ColorTheme.primaryText)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    EventsView(appViewModel: AppViewModel())
}
