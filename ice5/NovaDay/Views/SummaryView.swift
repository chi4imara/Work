import SwiftUI

struct SummaryView: View {
    @ObservedObject var memoryStore: MemoryStore
    @State private var selectedPeriod: SummaryPeriod = .month
    @State private var selectedDate = Date()
    @State private var showingMonthDetails = false
    @State private var showingYearMonths = false
    
    enum SummaryPeriod: String, CaseIterable {
        case month = "Month"
        case year = "Year"
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Summary")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        periodSelector
                        
                        dateNavigation
                        
                        if selectedPeriod == .month {
                            monthlyStatsView
                        } else {
                            yearlyStatsView
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .sheet(isPresented: $showingMonthDetails) {
            MonthDetailsView(memoryStore: memoryStore, monthDate: selectedDate)
        }
        .sheet(isPresented: $showingYearMonths) {
            YearMonthsView(memoryStore: memoryStore, yearDate: selectedDate)
        }
    }
    
    private var periodSelector: some View {
        Picker("Period", selection: $selectedPeriod) {
            ForEach(SummaryPeriod.allCases, id: \.self) { period in
                Text(period.rawValue).tag(period)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(12)
        .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
    }
    
    private var dateNavigation: some View {
        HStack {
            Button(action: previousPeriod) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.primaryBlue)
            }
            
            Spacer()
            
            Text(periodTitle)
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Button(action: nextPeriod) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.primaryBlue)
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var monthlyStatsView: some View {
        let stats = memoryStore.monthlyStats(for: selectedDate)
        
        return VStack(spacing: 20) {
            StatCardView(
                title: "Recorded Days",
                value: "\(stats.recordedDays)",
                icon: "checkmark.circle.fill",
                color: AppColors.primaryBlue
            )
            
            StatCardView(
                title: "Missed Days",
                value: "\(stats.missedDays)",
                icon: "xmark.circle.fill",
                color: AppColors.textSecondary
            )
            
            StatCardView(
                title: "Most Frequent Mood",
                value: stats.mostFrequentMood,
                icon: "face.smiling.fill",
                color: AppColors.primaryYellow
            )
            
            Button(action: {
                showingMonthDetails = true
            }) {
                HStack {
                    Image(systemName: "calendar")
                    Text("Open Month")
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(AppColors.primaryBlue)
                .cornerRadius(20)
            }
        }
    }
    
    private var yearlyStatsView: some View {
        let stats = memoryStore.yearlyStats(for: selectedDate)
        
        return VStack(spacing: 20) {
            StatCardView(
                title: "Total Records",
                value: "\(stats.totalRecords)",
                icon: "doc.text.fill",
                color: AppColors.primaryBlue
            )
            
            StatCardView(
                title: "Best Month",
                value: stats.bestMonth,
                icon: "star.fill",
                color: AppColors.primaryYellow
            )
            
            Button(action: {
                showingYearMonths = true
            }) {
                HStack {
                    Image(systemName: "calendar.badge.plus")
                    Text("View All Months")
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(AppColors.primaryBlue)
                .cornerRadius(20)
            }
        }
    }
    
    private var periodTitle: String {
        let formatter = DateFormatter()
        if selectedPeriod == .month {
            formatter.dateFormat = "MMMM yyyy"
        } else {
            formatter.dateFormat = "yyyy"
        }
        return formatter.string(from: selectedDate)
    }
    
    private func previousPeriod() {
        let component: Calendar.Component = selectedPeriod == .month ? .month : .year
        selectedDate = Calendar.current.date(byAdding: component, value: -1, to: selectedDate) ?? selectedDate
    }
    
    private func nextPeriod() {
        let component: Calendar.Component = selectedPeriod == .month ? .month : .year
        selectedDate = Calendar.current.date(byAdding: component, value: 1, to: selectedDate) ?? selectedDate
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
                .frame(width: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                
                Text(value)
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
            }
            
            Spacer()
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
    }
}

#Preview {
    SummaryView(memoryStore: MemoryStore())
}
