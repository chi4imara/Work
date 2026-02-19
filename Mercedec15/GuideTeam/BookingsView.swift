import SwiftUI

struct BookingsView: View {
    @EnvironmentObject var viewModel: BookingsViewModel
    @State private var selectedSegment = 0
    @State private var showingBookingDetail = false
    @State private var showingAddBooking = false
    @State private var selectedBooking: Booking?
    
    private let segments = ["Upcoming", "Past", "All"]
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                segmentControlView
                
                if filteredBookings.isEmpty {
                    emptyStateView
                } else {
                    bookingsListView
                }
            }
        }
        .sheet(item: $selectedBooking) { booking in
            BookingDetailView(booking: booking) { updatedBooking in
                viewModel.updateBooking(updatedBooking)
            }
        }
        .sheet(isPresented: $showingAddBooking) {
            AddBookingView { booking in
                viewModel.addBooking(booking)
            }
        }
        .refreshable {
            viewModel.loadBookings()
        }
    }
    
    private var filteredBookings: [Booking] {
        let now = Date()
        switch selectedSegment {
        case 0:
            return viewModel.bookings.filter { $0.date > now && $0.status == .scheduled }
        case 1:
            return viewModel.bookings.filter { $0.date <= now || $0.status != .scheduled }
        default:
            return viewModel.bookings
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Bookings")
                    .font(.playfairBold(size: 28))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Manage your appointments")
                    .font(.playfairRegular(size: 16))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            Spacer()
            
            Button(action: { showingAddBooking = true }) {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundColor(ColorTheme.primaryText)
                    .padding(12)
                    .background(ColorTheme.cardBackground)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(ColorTheme.cardBorder, lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var segmentControlView: some View {
        Picker("Bookings", selection: $selectedSegment) {
            ForEach(0..<segments.count, id: \.self) { index in
                Text(segments[index])
                    .tag(index)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 10)
        .onAppear {
            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(ColorTheme.primaryPurple)
            UISegmentedControl.appearance().setTitleTextAttributes([
                .foregroundColor: UIColor.white
            ], for: .selected)
            UISegmentedControl.appearance().setTitleTextAttributes([
                .foregroundColor: UIColor(ColorTheme.primaryText)
            ], for: .normal)
        }
    }
    
    private var bookingsListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(filteredBookings) { booking in
                    BookingCardView(booking: booking) {
                        selectedBooking = booking
                        showingBookingDetail = true
                    } onCancel: {
                        viewModel.cancelBooking(booking)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: selectedSegment == 0 ? "calendar.badge.plus" : "calendar.badge.clock")
                .font(.system(size: 60))
                .foregroundColor(ColorTheme.secondaryText)
            
            VStack(spacing: 8) {
                Text(emptyStateTitle)
                    .font(.playfairBold(size: 22))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text(emptyStateMessage)
                    .font(.playfairRegular(size: 16))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            if selectedSegment == 0 {
                Button(action: { showingAddBooking = true }) {
                    Text("Add First Booking")
                        .font(.playfairSemiBold(size: 16))
                        .foregroundColor(ColorTheme.buttonText)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(ColorTheme.buttonPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            
            Spacer()
        }
    }
    
    private var emptyStateTitle: String {
        switch selectedSegment {
        case 0: return "No upcoming appointments"
        case 1: return "No past appointments"
        default: return "No appointments yet"
        }
    }
    
    private var emptyStateMessage: String {
        switch selectedSegment {
        case 0: return "Book your next relaxing SPA experience"
        case 1: return "Your completed appointments will appear here"
        default: return "Start your wellness journey by booking your first appointment"
        }
    }
}

struct BookingCardView: View {
    let booking: Booking
    let onTap: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(booking.salonName)
                            .font(.playfairBold(size: 18))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Text(booking.serviceName)
                            .font(.playfairRegular(size: 16))
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                    
                    Spacer()
                    
                    StatusBadge(status: booking.status)
                }
                
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(ColorTheme.primaryPurple)
                        Text(booking.formattedDate)
                            .font(.playfairRegular(size: 14))
                            .foregroundColor(ColorTheme.secondaryText)
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(ColorTheme.primaryPurple)
                        Text(booking.masterName)
                            .font(.playfairRegular(size: 14))
                            .foregroundColor(ColorTheme.secondaryText)
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(ColorTheme.primaryPurple)
                        Text("\(booking.duration) min")
                            .font(.playfairRegular(size: 14))
                            .foregroundColor(ColorTheme.secondaryText)
                        Spacer()
                        Text(booking.formattedPrice)
                            .font(.playfairBold(size: 16))
                            .foregroundColor(ColorTheme.primaryText)
                    }
                }
                
                if booking.status == .scheduled && booking.date > Date() {
                    HStack(spacing: 12) {
                        Button(action: onCancel) {
                            Text("Cancel")
                                .font(.playfairSemiBold(size: 14))
                                .foregroundColor(ColorTheme.statusError)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(ColorTheme.statusError.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                        Spacer()
                        
                        Button(action: onTap) {
                            Text("View Details")
                                .font(.playfairSemiBold(size: 14))
                                .foregroundColor(ColorTheme.primaryWhite)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(ColorTheme.primaryPurple.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
            }
            .padding(16)
            .background(ColorTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(ColorTheme.cardBorder, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatusBadge: View {
    let status: BookingStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.playfairSemiBold(size: 12))
            .foregroundColor(ColorTheme.primaryWhite)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(statusColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var statusColor: Color {
        switch status {
        case .scheduled:
            return ColorTheme.primaryBlue
        case .completed:
            return ColorTheme.statusSuccess
        case .cancelled:
            return ColorTheme.statusError
        case .missed:
            return ColorTheme.statusWarning
        }
    }
}

struct BookingDetailView: View {
    let booking: Booking
    let onUpdate: (Booking) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Booking Details")
                                .font(.playfairBold(size: 24))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            DetailRow(title: "Salon", value: booking.salonName)
                            DetailRow(title: "Service", value: booking.serviceName)
                            DetailRow(title: "Master", value: booking.masterName)
                            DetailRow(title: "Date & Time", value: booking.formattedDate)
                            DetailRow(title: "Duration", value: "\(booking.duration) minutes")
                            DetailRow(title: "Price", value: booking.formattedPrice)
                            DetailRow(title: "Status", value: booking.status.rawValue)
                        }
                        .padding(20)
                        .background(ColorTheme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        Spacer(minLength: 100)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Booking Details")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.primaryPurple)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.playfairSemiBold(size: 16))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            Text(value)
                .font(.playfairRegular(size: 16))
                .foregroundColor(ColorTheme.secondaryText)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    BookingsView()
        .environmentObject(BookingsViewModel())
}
