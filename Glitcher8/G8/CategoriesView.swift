import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: TripViewModel
    @State private var selectedTripType: TripType?
    @State private var showingCategoryTrips = false
    
    var body: some View {
        ZStack {
            RadialGradientBackground()
            
            VStack(spacing: 0) {
                Text("Trip Categories")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(.pureWhite)
                    .padding(.vertical, 30)
                
                let categories = viewModel.getTripCategories()
                
                if categories.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "folder")
                            .font(.system(size: 60))
                            .foregroundColor(.pureWhite.opacity(0.6))
                        
                        Text("Categories not created yet.")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(.pureWhite.opacity(0.8))
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(categories, id: \.type) { category in
                                CategoryRowView(category: category) {
                                    selectedTripType = category.type
                                    showingCategoryTrips = true
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(item: $selectedTripType) { tripType in
            CategoryTripsView(tripType: tripType, viewModel: viewModel)
        }
    }
}

struct CategoryRowView: View {
    let category: TripCategory
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [Color.lightBlue.opacity(0.3), Color.brightOrange.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: category.type.icon)
                        .font(.system(size: 24))
                        .foregroundColor(.pureWhite)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.type.displayName)
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(.pureWhite)
                    
                    Text("\(category.count) records")
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(.pureWhite.opacity(0.7))
                }
                
                Spacer()
                
                VStack {
                    Text("Open")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(.darkBlue)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.lightBlue)
                        .cornerRadius(20)
                    
                    Spacer()
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.pureWhite.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.lightBlue.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CategoryTripsView: View {
    @Environment(\.dismiss) var dismiss
    let tripType: TripType
    @ObservedObject var viewModel: TripViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTrip: Trip?
    @State private var showingTripDetails = false
    
    var category: TripCategory {
        let trips = viewModel.getTrips(for: tripType)
        return TripCategory(type: tripType, trips: trips)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                GradientBackground()
                
                VStack(spacing: 0) {
                    VStack(spacing: 8) {
                        Text(category.type.displayName)
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(.pureWhite)
                        
                        Text("\(category.count) records")
                            .font(.ubuntu(16, weight: .regular))
                            .foregroundColor(.pureWhite.opacity(0.7))
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(category.trips.sorted(by: { $0.date > $1.date })) { trip in
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.pureWhite)
                    }
                }
            }
        }
        .sheet(item: $selectedTrip) { trip in
            TripDetailsView(trip: trip, viewModel: viewModel)
        }
    }
}

#Preview {
    CategoriesView(viewModel: {
        let vm = TripViewModel()
        vm.addTrip(Trip(
            type: .hiking,
            date: Date(),
            route: "Eagle Pass",
            duration: "2 days",
            groupComposition: "Sergey and me",
            comment: "Great weather!"
        ))
        vm.addTrip(Trip(
            type: .fishing,
            date: Date(),
            route: "Lake Karasye",
            duration: "1 day",
            groupComposition: "Solo trip",
            comment: "Good catch!"
        ))
        return vm
    }())
}
