import SwiftUI

struct TripSavedView: View {
    let trip: Trip
    @Binding var isPresented: Bool
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            ScrollView {
                VStack(spacing: 30) {
                    ZStack {
                        Circle()
                            .fill(Color.softGreen.opacity(0.2))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.softGreen)
                    }
                    .padding(.top, 40)
                    
                    Text("Entry Saved")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(.pureWhite)
                    
                    VStack(spacing: 16) {
                        TripDetailRow(title: "Trip Type", value: trip.type.displayName, icon: trip.type.icon)
                        TripDetailRow(title: "Date", value: trip.formattedDate, icon: "calendar")
                        TripDetailRow(title: "Route / Place", value: trip.route, icon: "location")
                        TripDetailRow(title: "Duration", value: trip.duration, icon: "clock")
                        TripDetailRow(title: "Group Composition", value: trip.groupComposition, icon: "person.2")
                        TripDetailRow(
                            title: "Comment",
                            value: trip.hasComment ? trip.comment : "No comment added.",
                            icon: "text.bubble"
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    Button(action: {
                        isPresented = false
                        onDismiss()
                    }) {
                        Text("Done")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(.darkBlue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.pureWhite)
                            .cornerRadius(28)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 50)
                }
                .padding(.bottom, 100)
            }
        }
    }
}

struct TripDetailRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.lightBlue)
                    .frame(width: 20)
                
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(.pureWhite.opacity(0.8))
            }
            
            Text(value)
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(.pureWhite)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.pureWhite.opacity(0.1))
        )
    }
}

#Preview {
    TripSavedView(
        trip: Trip(
            type: .hiking,
            date: Date(),
            route: "Eagle Pass",
            duration: "2 days",
            groupComposition: "Sergey and me",
            comment: "Great weather and amazing views!"
        ),
        isPresented: .constant(true),
        onDismiss: {}
    )
}
