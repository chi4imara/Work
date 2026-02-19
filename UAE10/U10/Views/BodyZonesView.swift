import SwiftUI

struct BodyZonesView: View {
    @EnvironmentObject var measurementStore: MeasurementStore
    @State private var expandedZone: BodyZone?
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Body Zones")
                            .font(.ubuntu(32, weight: .bold))
                            .foregroundColor(AppColors.white)
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    
                    
                    if measurementStore.measurements.isEmpty {
                        EmptyBodyZonesView()
                        
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 15) {
                                ForEach(BodyZone.allCases, id: \.self) { zone in
                                    BodyZoneCard(
                                        zone: zone,
                                        isExpanded: expandedZone == zone
                                    ) {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            expandedZone = expandedZone == zone ? nil : zone
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                            .padding(.bottom, 120)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct EmptyBodyZonesView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "figure.arms.open")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.lightBlue.opacity(0.6))
            
            VStack(spacing: 15) {
                Text("No Measurements Yet")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.white)
                
                Text("Add some measurements to see your body zones progress")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

struct BodyZoneCard: View {
    @EnvironmentObject var measurementStore: MeasurementStore
    let zone: BodyZone
    let isExpanded: Bool
    let onTap: () -> Void
    
    private var latestValue: Double {
        guard let latest = measurementStore.latestMeasurement else { return 0 }
        return zone.getValue(from: latest)
    }
    
    private var latestDate: Date? {
        measurementStore.latestMeasurement?.date
    }
    
    private var zoneIcon: String {
        switch zone {
        case .weight:
            return "scalemass"
        case .chest:
            return "figure.arms.open"
        case .arms:
            return "figure.strengthtraining.traditional"
        case .shoulders:
            return "figure.flexibility"
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: onTap) {
                HStack(spacing: 15) {
                    Image(systemName: zoneIcon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(AppColors.lightBlue)
                        .frame(width: 40)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(zone.rawValue)
                            .font(.ubuntu(18, weight: .bold))
                            .foregroundColor(AppColors.white)
                        
                        if let date = latestDate {
                            Text("Last updated: \(formatDate(date))")
                                .font(.ubuntu(12))
                                .foregroundColor(AppColors.white.opacity(0.6))
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack(alignment: .bottom, spacing: 2) {
                            Text(latestValue > 0 ? String(format: "%.1f", latestValue) : "—")
                                .font(.ubuntu(20, weight: .bold))
                                .foregroundColor(AppColors.orange)
                            
                            if latestValue > 0 {
                                Text(zone.unit)
                                    .font(.ubuntu(12))
                                    .foregroundColor(AppColors.white.opacity(0.6))
                            }
                        }
                        
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppColors.white.opacity(0.6))
                    }
                }
                .padding(20)
            }
            
            if isExpanded {
                VStack(spacing: 10) {
                    Divider()
                        .background(AppColors.white.opacity(0.2))
                    
                    ZoneMeasurementsList(zone: zone)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .background(AppColors.cardGradient)
        .cornerRadius(20)
        .shadow(color: AppColors.darkBlue.opacity(0.3), radius: 8, x: 0, y: 4)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            formatter.dateStyle = .short
            return formatter.string(from: date)
        }
    }
}

struct ZoneMeasurementsList: View {
    @EnvironmentObject var measurementStore: MeasurementStore
    let zone: BodyZone
    
    private var zoneMeasurements: [Measurement] {
        measurementStore.measurements.filter { measurement in
            zone.getValue(from: measurement) > 0
        }
    }
    
    var body: some View {
        if zoneMeasurements.isEmpty {
            Text("No measurements for this zone")
                .font(.ubuntu(14))
                .foregroundColor(AppColors.white.opacity(0.6))
                .padding(.vertical, 10)
        } else {
            LazyVStack(spacing: 8) {
                ForEach(zoneMeasurements.prefix(5)) { measurement in
                    NavigationLink(destination: MeasurementDetailView(measurement: measurement)) {
                        ZoneMeasurementRow(measurement: measurement, zone: zone)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                if zoneMeasurements.count > 5 {
                    Text("+ \(zoneMeasurements.count - 5) more measurements")
                        .font(.ubuntu(12))
                        .foregroundColor(AppColors.lightBlue)
                        .padding(.top, 5)
                }
            }
        }
    }
}

struct ZoneMeasurementRow: View {
    let measurement: Measurement
    let zone: BodyZone
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(formatDate(measurement.date))
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(AppColors.white)
                
                Text("\(String(format: "%.1f", zone.getValue(from: measurement))) \(zone.unit)")
                    .font(.ubuntu(12))
                    .foregroundColor(AppColors.white.opacity(0.7))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(AppColors.lightBlue.opacity(0.6))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(AppColors.darkBlue.opacity(0.3))
        .cornerRadius(10)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    BodyZonesView()
        .environmentObject(MeasurementStore())
}
