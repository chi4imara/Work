import SwiftUI

struct WearingView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedSneaker: Sneaker?
    @State private var showingSneakerDates = false
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Wearing")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                
                let sneakersWithWearing = dataManager.getSneakersWithWearingData()
                
                if sneakersWithWearing.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "chart.bar")
                            .font(.system(size: 60))
                            .foregroundColor(ColorManager.secondaryText)
                        
                        Text("No wearing information.")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(ColorManager.secondaryText)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(sneakersWithWearing) { sneaker in
                                WearingStatsCard(
                                    sneaker: sneaker
                                ) {
                                    selectedSneaker = sneaker
                                    showingSneakerDates = true
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(item: $selectedSneaker) { sneaker in
            SneakerWearingDatesView(sneaker: sneaker)
        }
    }
}

struct WearingStatsCard: View {
    let sneaker: Sneaker
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(sneaker.model)
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
                .lineLimit(2)
            
            HStack {
                Text("Days worn:")
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(ColorManager.secondaryText)
                
                Spacer()
                
                Text("\(sneaker.wearingCount)")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(ColorManager.lightBlue)
            }
            
            Button(action: onTap) {
                Text("Open")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(
                        LinearGradient(
                            colors: [ColorManager.lightBlue, ColorManager.orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
            }
        }
        .padding(20)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
    }
}

struct SneakerWearingDatesView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    
    let sneaker: Sneaker
    @State private var selectedDate: WearingDate?
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Button("Close") {
                            dismiss()
                        }
                        .font(.ubuntu(16))
                        .foregroundColor(ColorManager.lightBlue)
                        
                        Spacer()
                        
                        Text("Wearing Dates")
                            .font(.ubuntu(20, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Spacer()
                        
                        Text("Close")
                            .font(.ubuntu(16))
                            .foregroundColor(.clear)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                    
                    Text(sneaker.model)
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                    
                    if sneaker.wearingDates.isEmpty {
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Text("No wearing dates recorded.")
                                .font(.ubuntu(16))
                                .foregroundColor(ColorManager.secondaryText)
                            
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(sneaker.wearingDates) { wearingDate in
                                    HStack {
                                        Text(dateFormatter.string(from: wearingDate.date))
                                            .font(.ubuntu(16))
                                            .foregroundColor(ColorManager.primaryText)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            selectedDate = wearingDate
                                        }) {
                                            Text("Open")
                                                .font(.ubuntu(14, weight: .medium))
                                                .foregroundColor(ColorManager.lightBlue)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(ColorManager.lightBlue.opacity(0.1))
                                                .cornerRadius(8)
                                        }
                                    }
                                    .padding(16)
                                    .background(ColorManager.cardGradient)
                                    .cornerRadius(12)
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 100)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(item: $selectedDate) { _ in
            SneakerDetailView(sneaker: sneaker)
        }
    }
}

#Preview {
    WearingView()
        .environmentObject(DataManager.shared)
}
