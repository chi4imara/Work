import SwiftUI

struct YearMonthsView: View {
    @ObservedObject var memoryStore: MemoryStore
    let yearDate: Date
    @Environment(\.presentationMode) var presentationMode
    
    private var yearTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: yearDate)
    }
    
    private var monthsData: [(month: Int, monthName: String, count: Int)] {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: yearDate)
        let yearMemories = memoryStore.memoriesForYear(yearDate)
        
        var months: [(month: Int, monthName: String, count: Int)] = []
        
        for month in 1...12 {
            let monthMemories = yearMemories.filter { memory in
                let memoryMonth = calendar.component(.month, from: memory.date)
                return memoryMonth == month
            }
            
            let monthName = calendar.monthSymbols[month - 1]
            months.append((month: month, monthName: monthName, count: monthMemories.count))
        }
        
        return months.sorted { $0.month > $1.month }
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.primaryBlue)
                    }
                    
                    Spacer()
                    
                    Text(yearTitle)
                        .font(.ubuntu(20, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    HStack {
                        Text("Back")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(.clear)
                        Image(systemName: "chevron.left")
                            .foregroundColor(.clear)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                
                if yearHasNoMemories {
                    emptyStateView
                } else {
                    monthsList
                }
            }
        }
    }
    
    private var yearHasNoMemories: Bool {
        monthsData.allSatisfy { $0.count == 0 }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryBlue.opacity(0.6))
            
            Text("No memories for this year")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Text("Start adding memories to see them here")
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var monthsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(monthsData, id: \.month) { monthData in
                    if monthData.count > 0 {
                        YearMonthCardView(
                            monthName: monthData.monthName,
                            count: monthData.count,
                            year: Calendar.current.component(.year, from: yearDate),
                            month: monthData.month,
                            memoryStore: memoryStore
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
}

struct YearMonthCardView: View {
    let monthName: String
    let count: Int
    let year: Int
    let month: Int
    @ObservedObject var memoryStore: MemoryStore
    @State private var showingMonthDetails = false
    
    private var monthDate: Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        return calendar.date(from: components) ?? Date()
    }
    
    var body: some View {
        Button(action: { showingMonthDetails = true }) {
            HStack(spacing: 16) {
                Image(systemName: "calendar")
                    .font(.system(size: 32))
                    .foregroundColor(AppColors.primaryBlue)
                    .frame(width: 50)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(monthName)
                        .font(.ubuntu(20, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("\(count) \(count == 1 ? "memory" : "memories")")
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
            .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingMonthDetails) {
            MonthDetailsView(memoryStore: memoryStore, monthDate: monthDate)
        }
    }
}

#Preview {
    YearMonthsView(memoryStore: MemoryStore(), yearDate: Date())
}
