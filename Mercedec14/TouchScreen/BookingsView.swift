import SwiftUI

struct BookingsView: View {
    @EnvironmentObject var appState: AppStateManager
    @EnvironmentObject var viewModel: BookingsViewModel
    @State private var showingAddSession = false
    @State private var selectedSession: Session?
    
    var body: some View {
        ZStack {
            Color.clear
            
            VStack(spacing: 0) {
                headerSection
                
                if viewModel.bookedSessions.isEmpty {
                    emptyStateView
                } else {
                    sessionsListView
                }
            }
        }
        .sheet(isPresented: $showingAddSession) {
            AddSessionView(onSave: { session in
                viewModel.addBooking(session)
            })
            .environmentObject(appState)
        }
        .sheet(item: $selectedSession) { session in
            SessionDetailsSheet(sessionId: session.id, viewModel: viewModel)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("My Bookings")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                
                Spacer()
                
                Button(action: { showingAddSession = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(ColorTheme.buttonGradient)
                        )
                        .shadow(color: ColorTheme.shadowColor, radius: 5, x: 0, y: 2)
                }
            }
            
            HStack(spacing: 12) {
                Menu {
                    ForEach(BookingsViewModel.SortOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            viewModel.selectedSortOption = option
                            viewModel.applySortingAndFiltering()
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text("Sort: \(viewModel.selectedSortOption.rawValue)")
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(ColorTheme.textSecondary)
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(ColorTheme.textSecondary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(ColorTheme.cardBackground)
                            .shadow(color: ColorTheme.shadowColor, radius: 2, x: 0, y: 1)
                    )
                }
                
                Menu {
                    Button("All") {
                        viewModel.selectedFilterStatus = nil
                        viewModel.applySortingAndFiltering()
                    }
                    
                    ForEach(SessionStatus.allCases, id: \.self) { status in
                        Button(status.rawValue) {
                            viewModel.selectedFilterStatus = status
                            viewModel.applySortingAndFiltering()
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text("Status: \(viewModel.selectedFilterStatus?.rawValue ?? "All")")
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(ColorTheme.textSecondary)
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(ColorTheme.textSecondary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(ColorTheme.cardBackground)
                            .shadow(color: ColorTheme.shadowColor, radius: 2, x: 0, y: 1)
                    )
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorTheme.textSecondary.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("No bookings yet")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                
                Text("You haven't booked any massage sessions yet. Start your wellness journey today!")
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: { showingAddSession = true }) {
                Text("Add First Booking")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(ColorTheme.buttonGradient)
                    )
                    .shadow(color: ColorTheme.shadowColor, radius: 5, x: 0, y: 2)
            }
            
            Spacer()
        }
    }
    
    private var sessionsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.displayedSessions) { session in
                    BookingCard(session: session) {
                        selectedSession = session
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 120)
        }
    }
}

struct BookingCard: View {
    let session: Session
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(session.title)
                            .font(.ubuntu(16, weight: .bold))
                            .foregroundColor(ColorTheme.textPrimary)
                            .multilineTextAlignment(.leading)
                        
                        Text("with \(session.master.name)")
                            .font(.ubuntu(14, weight: .regular))
                            .foregroundColor(ColorTheme.textSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(session.status.rawValue)
                            .font(.ubuntu(12, weight: .bold))
                            .foregroundColor(session.status.color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(session.status.color.opacity(0.1))
                            )
                        
                        Text(session.formattedPrice)
                            .font(.ubuntu(14, weight: .bold))
                            .foregroundColor(ColorTheme.primaryBlue)
                    }
                }
                
                HStack(spacing: 16) {
                    Label(session.formattedDate, systemImage: "calendar")
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                    
                    Label(session.type.rawValue, systemImage: session.type.icon)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(session.type.color)
                    
                    Label(session.duration.displayName, systemImage: "clock")
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                }
                
                HStack(spacing: 8) {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(ColorTheme.primaryYellow)
                        
                        Text(String(format: "%.1f", session.master.rating))
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(ColorTheme.textSecondary)
                    }
                    
                    if session.master.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 12))
                            .foregroundColor(ColorTheme.primaryBlue)
                    }
                    
                    Spacer()
                    
                    if session.status == .completed && session.userRating == nil {
                        Text("Rate session")
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(ColorTheme.primaryBlue)
                    }
                }
                
                if !session.notes.isEmpty {
                    Text(session.notes)
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(ColorTheme.textSecondary)
                        .lineLimit(2)
                        .padding(.top, 4)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.cardGradient)
                    .shadow(color: ColorTheme.shadowColor, radius: 6, x: 0, y: 3)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SessionDetailsSheet: View {
    let sessionId: UUID
    @ObservedObject var viewModel: BookingsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingReschedule = false
    @State private var rescheduleDate = Date()
    @State private var showingCancelAlert = false
    @State private var newNote = ""
    @State private var userRating = 0
    
    private var resolvedSession: Session? {
        viewModel.bookedSessions.first { $0.id == sessionId }
    }
    
    var body: some View {
        Group {
            if let session = resolvedSession {
                sessionDetailsContent(session: session)
            } else {
                Text("Session not found")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.textSecondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .alert("Cancel Session", isPresented: $showingCancelAlert) {
            Button("Cancel Session", role: .destructive) {
                if let session = resolvedSession {
                    viewModel.cancelSession(session)
                }
                dismiss()
            }
            Button("Keep Session", role: .cancel) { }
        } message: {
            Text("Are you sure you want to cancel this session? This action cannot be undone.")
        }
    }
    
    private func sessionDetailsContent(session: Session) -> some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        sessionDetailsSection(session: session)
                        if session.status == .scheduled {
                            actionButtonsSection(session: session)
                        }
                        if session.status == .completed {
                            ratingSection(session: session)
                        }
                        notesSection(session: session)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .onAppear {
                userRating = session.userRating ?? 0
            }
            .sheet(isPresented: $showingReschedule) {
                rescheduleSheet(session: session)
            }
            .navigationTitle("Session Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
                }
            }
        }
        .alert("Cancel Session", isPresented: $showingCancelAlert) {
            Button("Cancel Session", role: .destructive) {
                viewModel.cancelSession(session)
                dismiss()
            }
            Button("Keep Session", role: .cancel) { }
        } message: {
            Text("Are you sure you want to cancel this session? This action cannot be undone.")
        }
    }
    
    private func sessionDetailsSection(session: Session) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Session Information")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            VStack(alignment: .leading, spacing: 12) {
                Text(session.title)
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                
                HStack {
                    Text("Status:")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                    
                    Text(session.status.rawValue)
                        .font(.ubuntu(14, weight: .bold))
                        .foregroundColor(session.status.color)
                }
                
                HStack {
                    Text("Date & Time:")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                    
                    Text(session.formattedDate)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorTheme.textPrimary)
                }
                
                HStack {
                    Text("Duration:")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                    
                    Text(session.duration.displayName)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorTheme.textPrimary)
                }
                
                HStack {
                    Text("Price:")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                    
                    Text(session.formattedPrice)
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(ColorTheme.primaryBlue)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorTheme.cardGradient)
                    .shadow(color: ColorTheme.shadowColor, radius: 5, x: 0, y: 2)
            )
        }
    }
    
    private func actionButtonsSection(session: Session) -> some View {
        VStack(spacing: 12) {
            Button {
                viewModel.markAsCompleted(session)
            } label: {
                Text("Mark as Completed")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(ColorTheme.successGreen)
                    )
            }
            
            Button {
                rescheduleDate = session.date
                showingReschedule = true
            } label: {
                Text("Reschedule Session")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(ColorTheme.primaryBlue)
                    )
            }
            
            Button {
                showingCancelAlert = true
            } label: {
                Text("Cancel Session")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.errorRed)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(ColorTheme.errorRed, lineWidth: 1)
                    )
            }
        }
    }
    
    private func ratingSection(session: Session) -> some View {
        let alreadyRated = session.userRating != nil
        let displayRating = session.userRating ?? userRating
        
        return VStack(alignment: .leading, spacing: 12) {
            Text(alreadyRated ? "Your Rating" : "Rate Your Session")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            HStack {
                ForEach(1...5, id: \.self) { star in
                    Group {
                        if alreadyRated {
                            Image(systemName: star <= displayRating ? "star.fill" : "star")
                                .font(.system(size: 24))
                                .foregroundColor(star <= displayRating ? ColorTheme.primaryYellow : ColorTheme.textSecondary.opacity(0.3))
                        } else {
                            Button(action: {
                                userRating = star
                                viewModel.addRating(session, rating: star)
                            }) {
                                Image(systemName: star <= userRating ? "star.fill" : "star")
                                    .font(.system(size: 24))
                                    .foregroundColor(star <= userRating ? ColorTheme.primaryYellow : ColorTheme.textSecondary.opacity(0.3))
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorTheme.cardGradient)
                    .shadow(color: ColorTheme.shadowColor, radius: 5, x: 0, y: 2)
            )
        }
    }
    
    private func notesSection(session: Session) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Session Notes")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            TextField("Add your notes about this session...", text: $newNote, axis: .vertical)
                .font(.ubuntu(14, weight: .regular))
                .foregroundColor(ColorTheme.textPrimary)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorTheme.cardGradient)
                        .shadow(color: ColorTheme.shadowColor, radius: 5, x: 0, y: 2)
                )
                .lineLimit(3...6)
                .onAppear {
                    newNote = session.notes
                }
                .onChange(of: newNote) { note in
                    viewModel.addNote(session, note: note)
                }
        }
    }
    
    private func rescheduleSheet(session: Session) -> some View {
        VStack(spacing: 24) {
            Text("Choose New Date & Time")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            DatePicker("", selection: $rescheduleDate, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(.graphical)
                .labelsHidden()
            
            HStack(spacing: 16) {
                Button {
                    showingReschedule = false
                } label: {
                    Text("Cancel")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(ColorTheme.cardGradient)
                        )
                }
                
                Button {
                    viewModel.rescheduleSession(session, newDate: rescheduleDate)
                    showingReschedule = false
                } label: {
                    Text("Confirm")
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(ColorTheme.primaryBlue)
                        )
                }
            }
        }
        .padding(20)
        .presentationDetents([.medium, .large])
    }
}

#Preview {
    BookingsView()
}
