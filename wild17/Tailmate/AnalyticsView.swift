import SwiftUI

struct AnalyticsView: View {
    @ObservedObject var dataManager = DataManager.shared
    @State private var selectedPeriod: TimePeriod = .week
    @State private var showingPeriodPicker = false
    @State private var showingDayDetails = false
    @State private var selectedDate = Date()
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Care Analytics")
                        .font(.ubuntu(30, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 25) {
                        periodSelectorSection
                        
                        totalStatsSection
                        
                        regularitySection
                        
                        topDaysSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }
            }
        }
        .sheet(isPresented: $showingDayDetails) {
            DayDetailsView(date: selectedDate)
        }
        .confirmationDialog("Select Period", isPresented: $showingPeriodPicker, titleVisibility: .visible) {
            ForEach(TimePeriod.allCases, id: \.self) { period in
                Button(period.displayName) {
                    selectedPeriod = period
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
    
    private var periodSelectorSection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Analysis Period")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: { showingPeriodPicker = true }) {
                    HStack(spacing: 8) {
                        Text(selectedPeriod.displayName)
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(.white)
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                }
            }
        }
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
    }
    
    private var totalStatsSection: some View {
        let analytics = dataManager.getPeriodAnalytics(for: selectedPeriod)
        
        return VStack(spacing: 20) {
            HStack {
                Text("Total Summary")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                AnalyticsCard(
                    title: "Feedings",
                    value: "\(analytics.totalFeedings)",
                    icon: "fork.knife",
                    color: Color.theme.accentOrange
                )
                
                AnalyticsCard(
                    title: "Walks",
                    value: "\(analytics.totalWalks)",
                    icon: "figure.walk",
                    color: Color.theme.accentGreen
                )
                
                AnalyticsCard(
                    title: "Vitamin Days",
                    value: "\(analytics.vitaminDays)",
                    icon: "pills",
                    color: Color.theme.accentYellow
                )
                
                AnalyticsCard(
                    title: "Vet Visits",
                    value: "\(analytics.veterinarianVisits)",
                    icon: "cross.case",
                    color: Color.theme.accentRed
                )
            }
            
            HStack {
                Text("Total Actions: \(analytics.totalActions)")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.top, 10)
        }
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
    }
    
    private var regularitySection: some View {
        let analytics = dataManager.getPeriodAnalytics(for: selectedPeriod)
        
        return VStack(spacing: 20) {
            HStack {
                Text("Regularity")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            VStack(spacing: 15) {
                RegularityRow(
                    title: "Feedings",
                    value: String(format: "%.1f per day", analytics.averageFeedingsPerDay),
                    icon: "fork.knife",
                    color: Color.theme.accentOrange
                )
                
                RegularityRow(
                    title: "Walks",
                    value: String(format: "%.1f per day", analytics.averageWalksPerDay),
                    icon: "figure.walk",
                    color: Color.theme.accentGreen
                )
                
                RegularityRow(
                    title: "Vitamins",
                    value: String(format: "%.0f%% of days", analytics.vitaminPercentage),
                    icon: "pills",
                    color: Color.theme.accentYellow
                )
                
                RegularityRow(
                    title: "Veterinarian",
                    value: "\(analytics.veterinarianVisits) visits",
                    icon: "cross.case",
                    color: Color.theme.accentRed
                )
            }
        }
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
    }
    
    private var topDaysSection: some View {
        let analytics = dataManager.getPeriodAnalytics(for: selectedPeriod)
        
        return VStack(spacing: 20) {
            HStack {
                Text("Most Active Days")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            if analytics.topDays.isEmpty {
                EmptyAnalyticsView(selectedPeriod: selectedPeriod) {
                    selectedPeriod = .month
                }
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(Array(analytics.topDays.enumerated()), id: \.offset) { index, dayAnalytics in
                        TopDayRow(
                            rank: index + 1,
                            dayAnalytics: dayAnalytics,
                            onTapped: {
                                selectedDate = dayAnalytics.date
                                showingDayDetails = true
                            }
                        )
                    }
                }
            }
        }
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
    }
}

struct AnalyticsCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
                
                Spacer()
                
                Text(value)
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(.white)
            }
            
            HStack {
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
}

struct RegularityRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(title)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(.white)
            
            Spacer()
            
            Text(value)
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

struct TopDayRow: View {
    let rank: Int
    let dayAnalytics: DayAnalytics
    let onTapped: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Text("#\(rank)")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 30, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(DateFormatter.dayMonthYear.string(from: dayAnalytics.date))
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(.white)
                
                Text("\(dayAnalytics.totalEvents) events")
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                ForEach(Array(dayAnalytics.eventTypes.sorted(by: { $0.rawValue < $1.rawValue })), id: \.self) { eventType in
                    Image(systemName: eventType.iconName)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(eventTypeColor(eventType))
                }
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .onTapGesture {
            onTapped()
        }
    }
    
    private func eventTypeColor(_ eventType: EventType) -> Color {
        switch eventType {
        case .feeding:
            return Color.theme.accentOrange
        case .walk:
            return Color.theme.accentGreen
        case .vitamins:
            return Color.theme.accentYellow
        case .veterinarian:
            return Color.theme.accentRed
        }
    }
}

struct EmptyAnalyticsView: View {
    let selectedPeriod: TimePeriod
    let onShowMonth: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 40))
                .foregroundColor(.white.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("Insufficient data for analytics")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.white)
                
                Text("Add more events to see detailed analytics")
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            if selectedPeriod != .month {
                Button {
                    onShowMonth()
                } label: {
                    Text("Show Month")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.theme.primaryPurple)
                        .cornerRadius(16)
                }
            }
        }
        .padding(30)
    }
}

#Preview {
    AnalyticsView()
}
