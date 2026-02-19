import SwiftUI

struct AddBookingView: View {
    @Environment(\.dismiss) private var dismiss
    let onSave: (Booking) -> Void
    
    @State private var salonName = ""
    @State private var serviceName = ""
    @State private var masterName = ""
    @State private var date = Date()
    @State private var duration = "60"
    @State private var price = "80"
    @State private var status: BookingStatus = .scheduled
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        TextField("Salon name", text: $salonName)
                            .font(.playfairRegular(size: 16))
                            .foregroundColor(ColorTheme.primaryText)
                            .padding(16)
                            .background(ColorTheme.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        TextField("Service name", text: $serviceName)
                            .font(.playfairRegular(size: 16))
                            .foregroundColor(ColorTheme.primaryText)
                            .padding(16)
                            .background(ColorTheme.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        TextField("Master name", text: $masterName)
                            .font(.playfairRegular(size: 16))
                            .foregroundColor(ColorTheme.primaryText)
                            .padding(16)
                            .background(ColorTheme.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        DatePicker("Date & Time", selection: $date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .accentColor(ColorTheme.primaryPurple)
                            .padding(16)
                            .background(ColorTheme.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        HStack(spacing: 16) {
                            TextField("Duration (min)", text: $duration)
                                .font(.playfairRegular(size: 16))
                                .foregroundColor(ColorTheme.primaryText)
                                .keyboardType(.numberPad)
                                .padding(16)
                                .background(ColorTheme.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            TextField("Price", text: $price)
                                .font(.playfairRegular(size: 16))
                                .foregroundColor(ColorTheme.primaryText)
                                .keyboardType(.decimalPad)
                                .padding(16)
                                .background(ColorTheme.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        Picker("Status", selection: $status) {
                            ForEach(BookingStatus.allCases, id: \.self) { s in
                                Text(s.rawValue).tag(s)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .accentColor(ColorTheme.primaryWhite)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Add Booking")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.primaryPurple)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveBooking()
                    }
                    .foregroundColor(ColorTheme.primaryPurple)
                    .fontWeight(.semibold)
                    .disabled(salonName.trimmingCharacters(in: .whitespaces).isEmpty || serviceName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private func saveBooking() {
        let dur = Int(duration) ?? 60
        let pr = Double(price) ?? 80
        let booking = Booking(
            salonName: salonName.trimmingCharacters(in: .whitespaces),
            serviceName: serviceName.trimmingCharacters(in: .whitespaces),
            masterName: masterName.trimmingCharacters(in: .whitespaces).isEmpty ? "—" : masterName.trimmingCharacters(in: .whitespaces),
            date: date,
            duration: dur,
            price: pr,
            status: status
        )
        onSave(booking)
        dismiss()
    }
}

#Preview {
    AddBookingView { _ in }
}
