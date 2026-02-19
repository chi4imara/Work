import SwiftUI

struct TripDetailsView: View {
    let trip: Trip
    @ObservedObject var viewModel: TripViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                GradientBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Color.lightBlue.opacity(0.2))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: trip.type.icon)
                                    .font(.system(size: 35))
                                    .foregroundColor(.lightBlue)
                            }
                            
                            Text(trip.type.displayName)
                                .font(.ubuntu(28, weight: .bold))
                                .foregroundColor(.pureWhite)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 16) {
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
                        
                        VStack(spacing: 16) {
                            Button(action: {
                                showingEditView = true
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 16))
                                    Text("Edit")
                                        .font(.ubuntu(16, weight: .medium))
                                }
                                .foregroundColor(.darkBlue)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.lightBlue)
                                .cornerRadius(25)
                            }
                            
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                        .font(.system(size: 16))
                                    Text("Delete Entry")
                                        .font(.ubuntu(16, weight: .medium))
                                }
                                .foregroundColor(.pureWhite)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.softRed)
                                .cornerRadius(25)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
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
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.pureWhite)
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            EditTripView(trip: trip, viewModel: viewModel) {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .alert("Delete Entry", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteTrip(trip)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this entry? This action cannot be undone.")
        }
    }
}

#Preview {
    TripDetailsView(
        trip: Trip(
            type: .hiking,
            date: Date(),
            route: "Eagle Pass",
            duration: "2 days",
            groupComposition: "Sergey and me",
            comment: "Great weather and amazing views!"
        ),
        viewModel: TripViewModel()
    )
}
