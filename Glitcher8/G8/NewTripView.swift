import SwiftUI

struct NewTripView: View {
    @ObservedObject var viewModel: TripViewModel
    @State private var tripType = ""
    @State private var selectedDate = Date()
    @State private var route = ""
    @State private var duration = ""
    @State private var groupComposition = ""
    @State private var comment = ""
    @State private var showingSavedView = false
    @State private var savedTrip: Trip?
    
    var body: some View {
        NavigationView {
            ZStack {
                RadialGradientBackground()

                ScrollView {
                    VStack(spacing: 20) {
                        Text("New Entry")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(.pureWhite)
                            .padding(.top, 20)
                        
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
                        
                        Button(action: saveTrip) {
                            Text("Save")
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
        }
        .sheet(isPresented: $showingSavedView) {
            if let trip = savedTrip {
                TripSavedView(trip: trip, isPresented: $showingSavedView) {
                    clearForm()
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
    
    private func saveTrip() {
        guard isFormValid else { return }
        
        let tripTypeEnum = TripType.allCases.first { $0.rawValue.lowercased() == tripType.lowercased() } ?? .other
        
        let newTrip = Trip(
            type: tripTypeEnum,
            date: selectedDate,
            route: route,
            duration: duration,
            groupComposition: groupComposition,
            comment: comment
        )
        
        viewModel.addTrip(newTrip)
        savedTrip = newTrip
        showingSavedView = true
    }
    
    private func clearForm() {
        tripType = ""
        selectedDate = Date()
        route = ""
        duration = ""
        groupComposition = ""
        comment = ""
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(.pureWhite)
            
            ZStack(alignment: .leading) {
                TextField("", text: $text)
                    .font(.ubuntu(16))
                    .foregroundColor(.darkBlue)
                    .padding(16)
                    .background(Color.pureWhite.opacity(0.9))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.lightBlue.opacity(0.3), lineWidth: 1)
                    )
                
                if text.isEmpty {
                    Text(placeholder)
                        .font(.ubuntu(16))
                        .foregroundColor(Color.gray.opacity(0.6))
                        .padding(.horizontal, 16)
                        .allowsHitTesting(false)
                }
            }
        }
    }
}

#Preview {
    NewTripView(viewModel: TripViewModel())
}
