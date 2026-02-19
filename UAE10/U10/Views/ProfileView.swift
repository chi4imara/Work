import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var measurementStore: MeasurementStore
    
    private var totalMeasurements: Int {
        measurementStore.measurements.count
    }
    
    private var trackingDays: Int {
        guard let firstDate = measurementStore.measurements.last?.date,
              let lastDate = measurementStore.measurements.first?.date else {
            return 0
        }
        return Calendar.current.dateComponents([.day], from: firstDate, to: lastDate).day ?? 0
    }
    
    private var averageFrequency: String {
        guard totalMeasurements > 1, trackingDays > 0 else {
            return "—"
        }
        let frequency = Double(trackingDays) / Double(totalMeasurements)
        return String(format: "%.1f days", frequency)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        ProfileHeaderView()
                        
                        ProfileStatsSection(
                            totalMeasurements: totalMeasurements,
                            trackingDays: trackingDays,
                            averageFrequency: averageFrequency
                        )
                        
                        if !measurementStore.measurements.isEmpty {
                            RecentActivitySection()
                        }
                        
                        QuickActionsSection()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ProfileHeaderView: View {
    var body: some View {
        VStack(spacing: 20) {
            Circle()
                .fill(AppColors.buttonGradient)
                .frame(width: 100, height: 100)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 50, weight: .medium))
                        .foregroundColor(AppColors.white)
                )
            
            VStack(spacing: 8) {
                Text("Fitness Enthusiast")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.white)
                
                Text("Tracking progress since today")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.white.opacity(0.7))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(AppColors.cardGradient)
        .cornerRadius(20)
        .shadow(color: AppColors.darkBlue.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

struct ProfileStatsSection: View {
    let totalMeasurements: Int
    let trackingDays: Int
    let averageFrequency: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Your Progress")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.white)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
                ProfileStatCard(
                    title: "Measurements",
                    value: "\(totalMeasurements)",
                    icon: "list.clipboard",
                    color: AppColors.lightBlue
                )
                
                ProfileStatCard(
                    title: "Days Tracking",
                    value: "\(trackingDays)",
                    icon: "calendar",
                    color: AppColors.orange
                )
                
                ProfileStatCard(
                    title: "Avg. Frequency",
                    value: averageFrequency,
                    icon: "clock",
                    color: AppColors.success
                )
            }
        }
    }
}

struct ProfileStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(AppColors.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Text(title)
                    .font(.ubuntu(10, weight: .medium))
                    .foregroundColor(AppColors.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(AppColors.cardGradient)
        .cornerRadius(15)
        .shadow(color: AppColors.darkBlue.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct RecentActivitySection: View {
    @EnvironmentObject var measurementStore: MeasurementStore
    
    private var recentMeasurements: [Measurement] {
        Array(measurementStore.measurements.prefix(3))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Recent Activity")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.white)
            
            VStack(spacing: 10) {
                ForEach(recentMeasurements) { measurement in
                    RecentActivityRow(measurement: measurement)
                }
            }
            .padding(20)
            .background(AppColors.cardGradient)
            .cornerRadius(15)
            .shadow(color: AppColors.darkBlue.opacity(0.2), radius: 5, x: 0, y: 2)
        }
    }
}

struct RecentActivityRow: View {
    let measurement: Measurement
    
    var body: some View {
        HStack {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppColors.success)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Added measurement")
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(AppColors.white)
                
                Text(formatDate(measurement.date))
                    .font(.ubuntu(12))
                    .foregroundColor(AppColors.white.opacity(0.6))
            }
            
            Spacer()
            
            Text("Weight: \(String(format: "%.1f", measurement.weight)) kg")
                .font(.ubuntu(12))
                .foregroundColor(AppColors.white.opacity(0.7))
        }
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

struct QuickActionsSection: View {
    @State private var showingAddMeasurement = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Quick Actions")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.white)
            
            VStack(spacing: 12) {
                QuickActionButton(
                    icon: "plus.circle",
                    title: "Add New Measurement",
                    subtitle: "Record your latest progress"
                ) {
                    showingAddMeasurement = true
                }
                
                QuickActionButton(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "View Progress Charts",
                    subtitle: "See your improvement over time"
                ) {
                }
            }
            .padding(20)
            .background(AppColors.cardGradient)
            .cornerRadius(15)
            .shadow(color: AppColors.darkBlue.opacity(0.2), radius: 5, x: 0, y: 2)
        }
        .sheet(isPresented: $showingAddMeasurement) {
            AddMeasurementView()
        }
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.lightBlue)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.white)
                    
                    Text(subtitle)
                        .font(.ubuntu(12))
                        .foregroundColor(AppColors.white.opacity(0.6))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.white.opacity(0.4))
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ProfileView()
        .environmentObject(MeasurementStore())
}
