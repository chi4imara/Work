import SwiftUI

struct BookingView: View {
    let salon: SPASalon
    let onBookingConfirmed: (Booking) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedService: SPAService?
    @State private var selectedDate = Date()
    @State private var selectedTimeSlot = "10:00 AM"
    @State private var masterName = "Sarah Johnson"
    @State private var showingConfirmation = false
    
    private let timeSlots = [
        "9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM",
        "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        salonInfoView
                        
                        serviceSelectionView
                        
                        dateSelectionView
                        
                        timeSelectionView
                        
                        masterInfoView
                        
                        bookButtonView
                        
                        Spacer(minLength: 100)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Book Appointment")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.primaryPurple)
                }
            }
            .preferredColorScheme(.dark)
        }
        .alert("Booking Confirmed!", isPresented: $showingConfirmation) {
            Button("OK") {
                if let service = selectedService {
                    let booking = Booking(
                        salonName: salon.name,
                        serviceName: service.name,
                        masterName: masterName,
                        date: combinedDateTime,
                        duration: service.duration,
                        price: service.price,
                        status: .scheduled
                    )
                    onBookingConfirmed(booking)
                }
                dismiss()
            }
        } message: {
            Text("Your appointment has been successfully booked. We'll send you a confirmation shortly.")
        }
    }
    
    private var combinedDateTime: Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        let timeComponents = timeComponents(from: selectedTimeSlot)
        
        var combined = DateComponents()
        combined.year = dateComponents.year
        combined.month = dateComponents.month
        combined.day = dateComponents.day
        combined.hour = timeComponents.hour
        combined.minute = timeComponents.minute
        
        return calendar.date(from: combined) ?? selectedDate
    }
    
    private func timeComponents(from timeString: String) -> (hour: Int, minute: Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        if let date = formatter.date(from: timeString) {
            let calendar = Calendar.current
            return (calendar.component(.hour, from: date), calendar.component(.minute, from: date))
        }
        return (10, 0)
    }
    
    private var salonInfoView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Rectangle()
                    .fill(ColorTheme.primaryPurple.opacity(0.3))
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        Image(systemName: "photo")
                            .font(.title2)
                            .foregroundColor(ColorTheme.secondaryText)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(salon.name)
                        .font(.playfairBold(size: 20))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < Int(salon.rating) ? "star.fill" : "star")
                                .font(.caption)
                                .foregroundColor(ColorTheme.accentOrange)
                        }
                        Text("(\(salon.reviewCount))")
                            .font(.playfairRegular(size: 14))
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                    
                    Text(salon.formattedDistance)
                        .font(.playfairRegular(size: 14))
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                Spacer()
            }
        }
        .padding(16)
        .background(ColorTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var serviceSelectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Select Service")
                .font(.playfairBold(size: 18))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 12) {
                ForEach(salon.availableServices) { service in
                    Button(action: {
                        if selectedService?.id == service.id {
                            selectedService = nil
                        } else {
                            selectedService = service
                        }
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(service.name)
                                    .font(.playfairSemiBold(size: 16))
                                    .foregroundColor(ColorTheme.primaryText)
                                
                                Text("\(service.duration) min • $\(Int(service.price))")
                                    .font(.playfairRegular(size: 14))
                                    .foregroundColor(ColorTheme.secondaryText)
                                
                                Text(service.description)
                                    .font(.playfairRegular(size: 12))
                                    .foregroundColor(ColorTheme.secondaryText)
                                    .lineLimit(2)
                            }
                            
                            Spacer()
                            
                            Image(systemName: selectedService?.id == service.id ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(ColorTheme.primaryPurple)
                                .font(.title2)
                        }
                        .padding(16)
                        .background(
                            selectedService?.id == service.id ? 
                            ColorTheme.primaryPurple.opacity(0.1) : ColorTheme.cardBackground
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    selectedService?.id == service.id ? 
                                    ColorTheme.primaryPurple : ColorTheme.cardBorder,
                                    lineWidth: 1
                                )
                        )
                    }
                }
            }
        }
    }
    
    private var dateSelectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Select Date")
                .font(.playfairBold(size: 18))
                .foregroundColor(ColorTheme.primaryText)
            
            DatePicker("", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .accentColor(ColorTheme.primaryPurple)
                .padding(16)
                .background(ColorTheme.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var timeSelectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Select Time")
                .font(.playfairBold(size: 18))
                .foregroundColor(ColorTheme.primaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                ForEach(timeSlots, id: \.self) { timeSlot in
                    Button(action: {
                        selectedTimeSlot = timeSlot
                    }) {
                        Text(timeSlot)
                            .font(.playfairSemiBold(size: 14))
                            .foregroundColor(
                                selectedTimeSlot == timeSlot ? ColorTheme.buttonText : ColorTheme.primaryText
                            )
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(
                                selectedTimeSlot == timeSlot ? 
                                ColorTheme.primaryPurple : ColorTheme.cardBackground
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(ColorTheme.cardBorder, lineWidth: 1)
                            )
                    }
                }
            }
            .padding(16)
            .background(ColorTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var masterInfoView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Master")
                .font(.playfairBold(size: 18))
                .foregroundColor(ColorTheme.primaryText)
            
            HStack {
                Circle()
                    .fill(ColorTheme.primaryPurple.opacity(0.3))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.title2)
                            .foregroundColor(ColorTheme.secondaryText)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(masterName)
                        .font(.playfairSemiBold(size: 16))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text("Senior Therapist")
                        .font(.playfairRegular(size: 14))
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    HStack(spacing: 2) {
                        ForEach(0..<5) { _ in
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundColor(ColorTheme.accentOrange)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(16)
            .background(ColorTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var bookButtonView: some View {
        VStack(spacing: 16) {
            if let service = selectedService {
                HStack {
                    Text("Total:")
                        .font(.playfairSemiBold(size: 18))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Spacer()
                    
                    Text("$\(Int(service.price))")
                        .font(.playfairBold(size: 24))
                        .foregroundColor(ColorTheme.primaryText)
                }
                .padding(.horizontal, 4)
            }
            
            Button(action: {
                showingConfirmation = true
            }) {
                Text("Confirm Booking")
                    .font(.playfairBold(size: 18))
                    .foregroundColor(ColorTheme.buttonText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        selectedService != nil ? 
                        ColorTheme.buttonPrimary : ColorTheme.buttonPrimary.opacity(0.5)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .disabled(selectedService == nil)
        }
    }
}

#Preview {
    BookingView(salon: SPASalon(
        name: "Serenity Spa",
        rating: 4.8,
        reviewCount: 127,
        distance: 0.8,
        imageURL: "spa1",
        availableServices: [
            SPAService(name: "Deep Tissue Massage", duration: 60, price: 120, category: .massage, description: "Relaxing massage"),
            SPAService(name: "Facial Treatment", duration: 45, price: 85, category: .facial, description: "Rejuvenating facial")
        ],
        priceRange: .premium,
        hasDiscount: true,
        discountPercentage: 15
    )) { _ in }
}
