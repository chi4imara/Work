import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: PurchaseViewModel
    @State private var selectedDate = Date()
    
    private var selectedDatePurchases: [Purchase] {
        viewModel.purchasesForDate(selectedDate).filter { $0.isCompleted }
    }
    
    private var selectedDateTotal: Double {
        selectedDatePurchases.reduce(0) { $0 + ($1.actualAmount ?? $1.plannedAmount) }
    }
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    HStack {
                        Text("Purchase History")
                            .font(FontManager.playfairBold(size: 28))
                            .foregroundColor(Color.theme.primaryWhite)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text("Track your shopping progress over time")
                            .font(FontManager.playfairRegular(size: 16))
                            .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                ScrollView {
                    VStack(spacing: 20) {
                        CalendarView(
                            selectedDate: $selectedDate,
                            purchases: viewModel.completedPurchases()
                        )
                        .padding(.horizontal, 20)
                        
                        if !selectedDatePurchases.isEmpty {
                            SelectedDateDetailsView(
                                date: selectedDate,
                                purchases: selectedDatePurchases,
                                total: selectedDateTotal
                            )
                            .padding(.horizontal, 20)
                        }
                        
                        MonthlyStatsView(viewModel: viewModel, selectedDate: selectedDate)
                            .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date
    let purchases: [Purchase]
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    private var monthDays: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate) else {
            return []
        }
        
        let monthStart = monthInterval.start
        let monthEnd = monthInterval.end
        
        let firstWeekday = calendar.component(.weekday, from: monthStart)
        let daysFromPreviousMonth = firstWeekday - 1
        
        var days: [Date] = []
        
        if daysFromPreviousMonth > 0 {
            for i in (1...daysFromPreviousMonth).reversed() {
                if let date = calendar.date(byAdding: .day, value: -i, to: monthStart) {
                    days.append(date)
                }
            }
        }
        
        var currentDate = monthStart
        while currentDate < monthEnd {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        let remainingDays = max(0, 42 - days.count)
        for i in 0..<remainingDays {
            if let date = calendar.date(byAdding: .day, value: i, to: monthEnd) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func purchasesForDate(_ date: Date) -> [Purchase] {
        purchases.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color.theme.primaryYellow)
                        .font(.system(size: 18, weight: .medium))
                }
                
                Spacer()
                
                Text(dateFormatter.string(from: selectedDate))
                    .font(FontManager.playfairBold(size: 20))
                    .foregroundColor(Color.theme.primaryWhite)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.theme.primaryYellow)
                        .font(.system(size: 18, weight: .medium))
                }
            }
            
            HStack(spacing: 0) {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { weekday in
                    Text(weekday)
                        .font(FontManager.playfairSemiBold(size: 12))
                        .foregroundColor(Color.theme.primaryWhite.opacity(0.7))
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(monthDays, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        isCurrentMonth: calendar.isDate(date, equalTo: selectedDate, toGranularity: .month),
                        purchaseCount: purchasesForDate(date).count
                    ) {
                        selectedDate = date
                    }
                }
            }
        }
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private func previousMonth() {
        if let newDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    private func nextMonth() {
        if let newDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) {
            selectedDate = newDate
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let isCurrentMonth: Bool
    let purchaseCount: Int
    let onTap: () -> Void
    
    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text(dayFormatter.string(from: date))
                    .font(FontManager.playfairMedium(size: 14))
                    .foregroundColor(textColor)
                
                if purchaseCount > 0 {
                    Circle()
                        .fill(Color.theme.primaryYellow)
                        .frame(width: 6, height: 6)
                } else {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 6, height: 6)
                }
            }
            .frame(width: 40, height: 40)
            .background(backgroundColor)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(borderColor, lineWidth: isSelected ? 2 : 0)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var textColor: Color {
        if isSelected {
            return Color.theme.darkBlue
        } else if isCurrentMonth {
            return Color.theme.primaryWhite
        } else {
            return Color.theme.primaryWhite.opacity(0.4)
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return Color.theme.primaryYellow
        } else if purchaseCount > 0 {
            return Color.theme.primaryYellow.opacity(0.2)
        } else {
            return Color.clear
        }
    }
    
    private var borderColor: Color {
        return Color.theme.primaryYellow
    }
}

struct SelectedDateDetailsView: View {
    let date: Date
    let purchases: [Purchase]
    let total: Double
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(dateFormatter.string(from: date))
                    .font(FontManager.playfairBold(size: 18))
                    .foregroundColor(Color.theme.primaryWhite)
                
                Spacer()
                
                Text(String(format: "$%.2f", total))
                    .font(FontManager.playfairBold(size: 18))
                    .foregroundColor(Color.theme.primaryYellow)
            }
            
            VStack(spacing: 8) {
                ForEach(purchases) { purchase in
                    HStack {
                        Image(systemName: purchase.category.icon)
                            .foregroundColor(Color.theme.primaryYellow)
                            .frame(width: 20)
                        
                        Text(purchase.name)
                            .font(FontManager.playfairRegular(size: 14))
                            .foregroundColor(Color.theme.primaryWhite)
                        
                        Spacer()
                        
                        Text(String(format: "$%.2f", purchase.actualAmount ?? purchase.plannedAmount))
                            .font(FontManager.playfairSemiBold(size: 14))
                            .foregroundColor(Color.theme.primaryYellow)
                    }
                    .padding(.vertical, 4)
                }
            }
            
            if purchases.count > 3 {
                Text("and \(purchases.count - 3) more purchases...")
                    .font(FontManager.playfairRegular(size: 12))
                    .foregroundColor(Color.theme.primaryWhite.opacity(0.6))
            }
        }
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct MonthlyStatsView: View {
    @ObservedObject var viewModel: PurchaseViewModel
    let selectedDate: Date
    
    private var monthlyTotal: Double {
        let calendar = Calendar.current
        let monthPurchases = viewModel.completedPurchases().filter { 
            calendar.isDate($0.date, equalTo: selectedDate, toGranularity: .month)
        }
        return monthPurchases.reduce(0) { $0 + ($1.actualAmount ?? $1.plannedAmount) }
    }
    
    private var monthlyPurchaseCount: Int {
        let calendar = Calendar.current
        return viewModel.completedPurchases().filter { 
            calendar.isDate($0.date, equalTo: selectedDate, toGranularity: .month)
        }.count
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Monthly Overview")
                    .font(FontManager.playfairBold(size: 18))
                    .foregroundColor(Color.theme.primaryWhite)
                Spacer()
            }
            
            HStack(spacing: 20) {
                StatCard(title: "Total Spent", value: String(format: "$%.0f", monthlyTotal))
                StatCard(title: "Purchases", value: "\(monthlyPurchaseCount)")
            }
            
            CategoryBreakdownView(viewModel: viewModel, selectedDate: selectedDate)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(FontManager.playfairBold(size: 24))
                .foregroundColor(Color.theme.primaryYellow)
            
            Text(title)
                .font(FontManager.playfairRegular(size: 12))
                .foregroundColor(Color.theme.primaryWhite.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.theme.cardGradient)
        .cornerRadius(12)
    }
}

struct CategoryBreakdownView: View {
    @ObservedObject var viewModel: PurchaseViewModel
    let selectedDate: Date
    
    private var categoryStats: [(PurchaseCategory, Double, Int)] {
        let calendar = Calendar.current
        let monthPurchases = viewModel.completedPurchases().filter { 
            calendar.isDate($0.date, equalTo: selectedDate, toGranularity: .month)
        }
        
        let grouped = Dictionary(grouping: monthPurchases, by: { $0.category })
        return PurchaseCategory.allCases.compactMap { category in
            let purchases = grouped[category] ?? []
            let total = purchases.reduce(0) { $0 + ($1.actualAmount ?? $1.plannedAmount) }
            return total > 0 ? (category, total, purchases.count) : nil
        }.sorted { $0.1 > $1.1 }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Category Breakdown")
                    .font(FontManager.playfairSemiBold(size: 16))
                    .foregroundColor(Color.theme.primaryWhite)
                Spacer()
            }
            
            if categoryStats.isEmpty {
                Text("No purchases this month")
                    .font(FontManager.playfairRegular(size: 14))
                    .foregroundColor(Color.theme.primaryWhite.opacity(0.6))
                    .padding()
            } else {
                VStack(spacing: 8) {
                    ForEach(categoryStats, id: \.0) { category, total, count in
                        HStack {
                            Image(systemName: category.icon)
                                .foregroundColor(Color.theme.primaryYellow)
                                .frame(width: 20)
                            
                            Text(category.rawValue)
                                .font(FontManager.playfairRegular(size: 14))
                                .foregroundColor(Color.theme.primaryWhite)
                            
                            Spacer()
                            
                            Text("\(count) items")
                                .font(FontManager.playfairRegular(size: 12))
                                .foregroundColor(Color.theme.primaryWhite.opacity(0.7))
                            
                            Text(String(format: "$%.0f", total))
                                .font(FontManager.playfairSemiBold(size: 14))
                                .foregroundColor(Color.theme.primaryYellow)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct MonthPickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack {
                    DatePicker("Select Month", selection: $selectedDate, displayedComponents: [.date])
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .colorScheme(.dark)
                    
                    Button("Done") {
                        dismiss()
                    }
                    .font(FontManager.playfairSemiBold(size: 18))
                    .foregroundColor(Color.theme.darkBlue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.theme.primaryYellow)
                    .cornerRadius(28)
                    .padding(.horizontal, 40)
                    .padding(.top, 20)
                }
                .padding()
            }
            .navigationTitle("Select Month")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.primaryYellow)
                }
            }
        }
    }
}

#Preview {
    HistoryView(viewModel: PurchaseViewModel())
}
