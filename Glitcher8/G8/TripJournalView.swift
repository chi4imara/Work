import SwiftUI

struct TripJournalView: View {
    @ObservedObject var viewModel: TripViewModel
    @State private var selectedTrip: Trip?
    @State private var showingTripDetails = false
    
    var body: some View {
        NavigationView {
            ZStack {
                RadialGradientBackground()

                VStack(spacing: 0) {
                    Text("Trip Journal")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(.pureWhite)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                    
                    if viewModel.trips.isEmpty {
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: "book.closed")
                                .font(.system(size: 60))
                                .foregroundColor(.pureWhite.opacity(0.6))
                            
                            Text("You haven't added any entries yet.")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(.pureWhite.opacity(0.8))
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 40)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.trips.sorted(by: { $0.date > $1.date })) { trip in
                                    TripRowView(trip: trip) {
                                        selectedTrip = trip
                                        showingTripDetails = true
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 100)
                        }
                    }
                }
            }
        }
        .sheet(item: $selectedTrip) { trip in
            TripDetailsView(trip: trip, viewModel: viewModel)
        }
    }
}

struct TripRowView: View {
    let trip: Trip
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.lightBlue.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: trip.type.icon)
                        .font(.system(size: 20))
                        .foregroundColor(.lightBlue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(trip.type.displayName)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(.pureWhite)
                    
                    Text(trip.formattedDate)
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(.pureWhite.opacity(0.7))
                    
                    Text(trip.route)
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(.pureWhite.opacity(0.8))
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack {
                    Text("Open")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(.darkBlue)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.brightOrange)
                        .cornerRadius(20)
                    
                    Spacer()
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.pureWhite.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.lightBlue.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    TripJournalView(viewModel: {
        let vm = TripViewModel()
        vm.addTrip(Trip(
            type: .hiking,
            date: Date(),
            route: "Eagle Pass",
            duration: "2 days",
            groupComposition: "Sergey and me",
            comment: "Great weather!"
        ))
        return vm
    }())
}
