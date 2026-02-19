import SwiftUI

struct BookingSheet: View {
    let session: Session
    var onConfirm: ((Session) -> Void)? = nil
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDate = Date()
    @State private var selectedTimeSlot = "Morning"
    @State private var notes = ""
    @State private var showingConfirmation = false
    
    let timeSlots = ["Morning", "Afternoon", "Evening"]
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        sessionInfoSection
                        
                        dateSelectionSection
                        
                        timeSlotSection
                        
                        notesSection
                        
                        priceSummarySection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Book Session")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
                }
            }
            .safeAreaInset(edge: .bottom) {
                bookingButton
            }
        }
        .alert("Booking Confirmed!", isPresented: $showingConfirmation) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your massage session has been successfully booked. You'll receive a confirmation email shortly.")
        }
    }
    
    private var sessionInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Session Details")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Circle()
                        .fill(ColorTheme.primaryBlue.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Text(String(session.master.name.prefix(1)))
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(ColorTheme.primaryBlue)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(session.master.name)
                            .font(.ubuntu(16, weight: .bold))
                            .foregroundColor(ColorTheme.textPrimary)
                        
                        HStack(spacing: 4) {
                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(ColorTheme.primaryYellow)
                                
                                Text(String(format: "%.1f", session.master.rating))
                                    .font(.ubuntu(12, weight: .medium))
                                    .foregroundColor(ColorTheme.textSecondary)
                            }
                            
                            Text("•")
                                .foregroundColor(ColorTheme.textSecondary)
                            
                            Text("\(session.master.reviewCount) reviews")
                                .font(.ubuntu(12, weight: .regular))
                                .foregroundColor(ColorTheme.textSecondary)
                        }
                        
                        Text("\(session.master.experience) years experience")
                            .font(.ubuntu(12, weight: .regular))
                            .foregroundColor(ColorTheme.textSecondary)
                    }
                    
                    Spacer()
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(session.title)
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(ColorTheme.textPrimary)
                    
                    HStack(spacing: 16) {
                        Label(session.type.rawValue, systemImage: session.type.icon)
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(session.type.color)
                        
                        Label(session.duration.displayName, systemImage: "clock")
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(ColorTheme.textSecondary)
                        
                        Label(session.location.rawValue, systemImage: session.location.icon)
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(ColorTheme.textSecondary)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorTheme.cardGradient)
                    .shadow(color: ColorTheme.shadowColor, radius: 5, x: 0, y: 2)
            )
        }
    }
    
    private var dateSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select Date")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            DatePicker("", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                .datePickerStyle(.graphical)
                .accentColor(ColorTheme.primaryBlue)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorTheme.cardGradient)
                        .shadow(color: ColorTheme.shadowColor, radius: 5, x: 0, y: 2)
                )
        }
    }
    
    private var timeSlotSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Preferred Time")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            HStack(spacing: 12) {
                ForEach(timeSlots, id: \.self) { slot in
                    Button(action: {
                        selectedTimeSlot = slot
                    }) {
                        Text(slot)
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(selectedTimeSlot == slot ? .white : ColorTheme.textSecondary)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(selectedTimeSlot == slot ? ColorTheme.primaryBlue : ColorTheme.cardBackground)
                                    .shadow(color: ColorTheme.shadowColor, radius: selectedTimeSlot == slot ? 5 : 2, x: 0, y: 2)
                            )
                    }
                    .animation(.spring(response: 0.3), value: selectedTimeSlot)
                }
                
                Spacer()
            }
        }
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Special Requests (Optional)")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            TextField("Any specific areas to focus on or preferences...", text: $notes, axis: .vertical)
                .font(.ubuntu(14, weight: .regular))
                .foregroundColor(ColorTheme.textPrimary)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorTheme.cardGradient)
                        .shadow(color: ColorTheme.shadowColor, radius: 5, x: 0, y: 2)
                )
                .lineLimit(3...6)
        }
    }
    
    private var priceSummarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Price Summary")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            VStack(spacing: 8) {
                HStack {
                    Text("\(session.type.rawValue) (\(session.duration.displayName))")
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(ColorTheme.textSecondary)
                    
                    Spacer()
                    
                    Text(session.formattedPrice)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorTheme.textPrimary)
                }
                
                Divider()
                
                HStack {
                    Text("Total")
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(ColorTheme.textPrimary)
                    
                    Spacer()
                    
                    Text(session.formattedPrice)
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(ColorTheme.primaryBlue)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorTheme.cardGradient)
                    .shadow(color: ColorTheme.shadowColor, radius: 5, x: 0, y: 2)
            )
        }
    }
    
    private var bookingButton: some View {
        VStack(spacing: 12) {
            Button(action: {
                let newSession = Session(
                    title: session.title,
                    master: session.master,
                    type: session.type,
                    duration: session.duration,
                    date: selectedDate,
                    price: session.price,
                    status: .scheduled,
                    notes: notes,
                    location: session.location
                )
                onConfirm?(newSession)
                showingConfirmation = true
            }) {
                Text("Confirm Booking")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(ColorTheme.buttonGradient)
                    )
                    .shadow(color: ColorTheme.shadowColor, radius: 10, x: 0, y: 5)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
        .background(
            Rectangle()
                .fill(ColorTheme.backgroundWhite.opacity(0.95))
                .blur(radius: 10)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    let master = Master(
        name: "Preview Master",
        rating: 4.8,
        reviewCount: 10,
        specialties: [.relaxation],
        experience: 5,
        pricePerHour: 100,
        availability: ["Morning"],
        bio: "Preview bio",
        imageUrl: "",
        isVerified: true
    )
    return BookingSheet(session: Session(
        title: "Preview Session",
        master: master,
        type: .relaxation,
        duration: .sixty,
        date: Date(),
        price: 100,
        status: .scheduled,
        notes: "",
        location: .salon
    ))
}
