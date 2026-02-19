import SwiftUI

struct EditTripView: View {
    let trip: Trip
    @ObservedObject var viewModel: TripViewModel
    let onSave: () -> Void
    
    @Environment(\.presentationMode) var presentationMode
    @State private var tripType: String
    @State private var selectedDate: Date
    @State private var route: String
    @State private var duration: String
    @State private var groupComposition: String
    @State private var comment: String
    
    init(trip: Trip, viewModel: TripViewModel, onSave: @escaping () -> Void) {
        self.trip = trip
        self.viewModel = viewModel
        self.onSave = onSave
        
        _tripType = State(initialValue: trip.type.rawValue)
        _selectedDate = State(initialValue: trip.date)
        _route = State(initialValue: trip.route)
        _duration = State(initialValue: trip.duration)
        _groupComposition = State(initialValue: trip.groupComposition)
        _comment = State(initialValue: trip.comment)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                GradientBackground()
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Edit Entry")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(.pureWhite)
                            .padding(.vertical, 30)
                        
                        VStack(spacing: 16) {
                            CustomTextField(
                                title: "Trip Type",
                                text: $tripType,
                                placeholder: "Hiking, Fishing, Outdoor Trip..."
                            )
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Date")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.pureWhite)
                                
                                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .colorScheme(.dark)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.pureWhite.opacity(0.1))
                                    )
                            }
                            
                            CustomTextField(
                                title: "Route / Place",
                                text: $route,
                                placeholder: "Lake Karasye, Eagle Pass, Birch River..."
                            )
                            
                            CustomTextField(
                                title: "Duration",
                                text: $duration,
                                placeholder: "1 day, 2 days, 3 hours..."
                            )
                            
                            CustomTextField(
                                title: "Group Composition",
                                text: $groupComposition,
                                placeholder: "Sergey and me, Group of 5 people..."
                            )
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Comment")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.pureWhite)
                                
                                TextEditor(text: $comment)
                                    .font(.ubuntu(16))
                                    .foregroundColor(.darkBlue)
                                    .scrollContentBackground(.hidden)
                                    .padding(12)
                                    .frame(minHeight: 100)
                                    .background(Color.pureWhite.opacity(0.9))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.lightBlue.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Button(action: saveChanges) {
                            Text("Save Changes")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(.darkBlue)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    LinearGradient(
                                        colors: [Color.lightBlue, Color.brightOrange],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(28)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .disabled(!isFormValid)
                        .opacity(isFormValid ? 1.0 : 0.6)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(.pureWhite)
                    }
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        return viewModel.isValidTrip(
            type: tripType,
            route: route,
            duration: duration,
            groupComposition: groupComposition
        )
    }
    
    private func saveChanges() {
        guard isFormValid else { return }
        
        let tripTypeEnum = TripType.allCases.first { $0.rawValue.lowercased() == tripType.lowercased() } ?? .other
        
        var updatedTrip = trip
        updatedTrip.type = tripTypeEnum
        updatedTrip.date = selectedDate
        updatedTrip.route = route
        updatedTrip.duration = duration
        updatedTrip.groupComposition = groupComposition
        updatedTrip.comment = comment
        
        viewModel.updateTrip(updatedTrip)
        onSave()
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditTripView(
        trip: Trip(
            type: .hiking,
            date: Date(),
            route: "Eagle Pass",
            duration: "2 days",
            groupComposition: "Sergey and me",
            comment: "Great weather!"
        ),
        viewModel: TripViewModel(),
        onSave: {}
    )
}
