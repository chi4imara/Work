import SwiftUI

struct MeasurementsView: View {
    @EnvironmentObject var measurementStore: MeasurementStore
    @State private var showingAddMeasurement = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Measurements")
                            .font(.ubuntu(32, weight: .bold))
                            .foregroundColor(AppColors.white)
                        
                        Spacer()
                        
                        Button(action: {
                            showingAddMeasurement = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundColor(AppColors.lightBlue)
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    
                    if measurementStore.measurements.isEmpty {
                        EmptyStateView {
                            showingAddMeasurement = true
                        }
                        
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 20) {
                                if let latest = measurementStore.latestMeasurement {
                                    LatestMeasurementCard(measurement: latest)
                                }
                                
                                MeasurementsList()
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
        .sheet(isPresented: $showingAddMeasurement) {
            AddMeasurementView()
        }
    }
}

struct EmptyStateView: View {
    let onAddTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "list.clipboard")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.lightBlue.opacity(0.6))
            
            VStack(spacing: 15) {
                Text("Add Your First Measurement")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.white)
                
                Text("Start tracking your body progress by adding your first measurement")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: onAddTapped) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                    Text("Add Measurement")
                        .font(.ubuntu(18, weight: .medium))
                }
                .foregroundColor(AppColors.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 16)
                .background(AppColors.buttonGradient)
                .cornerRadius(25)
            }
            
            Spacer()
        }
    }
}

struct LatestMeasurementCard: View {
    let measurement: Measurement
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Latest Measurement")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.white)
                
                Spacer()
                
                Text(formatDate(measurement.date))
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.white.opacity(0.7))
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                MeasurementValueCard(title: "Weight", value: measurement.weight, unit: "kg")
                MeasurementValueCard(title: "Chest", value: measurement.chest, unit: "cm")
                MeasurementValueCard(title: "Arms", value: measurement.arms, unit: "cm")
                MeasurementValueCard(title: "Shoulders", value: measurement.shoulders, unit: "cm")
            }
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(20)
        .shadow(color: AppColors.darkBlue.opacity(0.3), radius: 10, x: 0, y: 5)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }
}

struct MeasurementValueCard: View {
    let title: String
    let value: Double
    let unit: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.ubuntu(12, weight: .medium))
                .foregroundColor(AppColors.white.opacity(0.7))
            
            HStack(alignment: .bottom, spacing: 2) {
                Text(String(format: "%.1f", value))
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.lightBlue)
                
                Text(unit)
                    .font(.ubuntu(12))
                    .foregroundColor(AppColors.white.opacity(0.6))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(AppColors.darkBlue.opacity(0.3))
        .cornerRadius(12)
    }
}

struct MeasurementsList: View {
    @EnvironmentObject var measurementStore: MeasurementStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("All Measurements")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.white)
                .padding(.horizontal, 5)
            
            LazyVStack(spacing: 10) {
                ForEach(measurementStore.measurements) { measurement in
                    NavigationLink(destination: MeasurementDetailView(measurement: measurement)) {
                        MeasurementRowView(measurement: measurement)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

struct MeasurementRowView: View {
    let measurement: Measurement
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(formatDate(measurement.date))
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.white)
                
                Text("Weight: \(String(format: "%.1f", measurement.weight)) kg")
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.white.opacity(0.7))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.lightBlue)
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(15)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    MeasurementsView()
        .environmentObject(MeasurementStore())
}
