import SwiftUI

struct AnalysisMainView: View {
    @EnvironmentObject var itemsViewModel: ItemsViewModel
    @State private var selectedMonth = Date()
    @State private var showingMonthPicker = false
    @State private var selectedItem: Item?
    
    private var analysis: MonthlyAnalysis {
        itemsViewModel.getMonthlyAnalysis(for: selectedMonth)
    }
    
    var body: some View {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerView
                        
                        monthSelectorView
                        
                        if analysis.totalItems == 0 {
                            emptyStateView
                        } else {
                            analysisContentView
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                    .padding(.bottom, 80)
                }
            }
        .sheet(isPresented: $showingMonthPicker) {
            MonthPickerView(selectedMonth: $selectedMonth)
        }
        .sheet(item: $selectedItem) { item in
            ItemDetailsView(itemId: item.id)
                .environmentObject(itemsViewModel)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Purchase Analysis")
                .font(AppTypography.title1)
                .foregroundColor(AppColors.primaryPurple)
            
            Text("Track your spending patterns")
                .font(AppTypography.callout)
                .foregroundColor(AppColors.neutralGray)
        }
    }
    
    private var monthSelectorView: some View {
        Button(action: { showingMonthPicker = true }) {
            HStack {
                Text(formatMonth(selectedMonth))
                    .font(AppTypography.headline)
                    .foregroundColor(AppColors.darkGray)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.neutralGray)
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.primaryPurple.opacity(0.3), lineWidth: 1)
            )
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.lightPurple.opacity(0.3))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "chart.bar.xaxis")
                    .font(.system(size: 50))
                    .foregroundColor(AppColors.primaryPurple)
            }
            
            VStack(spacing: 12) {
                Text("Not enough data for analysis")
                    .font(AppTypography.title3)
                    .foregroundColor(AppColors.primaryPurple)
                    .multilineTextAlignment(.center)
                
                Text("Add at least one purchase and mark it as bought to see your analysis.")
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.darkGray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var analysisContentView: some View {
        VStack(spacing: 20) {
            overviewCardsView
            
            priorityAnalysisView
            
            if !analysis.impulsiveItems.isEmpty {
                impulsivePurchasesView
            }
        }
    }
    
    private var overviewCardsView: some View {
        VStack(spacing: 16) {
            Text("Monthly Overview")
                .font(AppTypography.title3)
                .foregroundColor(AppColors.primaryPurple)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                OverviewCard(
                    title: "Total Items",
                    value: "\(analysis.totalItems)",
                    color: AppColors.blueText
                )
                
                OverviewCard(
                    title: "Purchased",
                    value: "\(analysis.purchasedItems)",
                    color: AppColors.successGreen
                )
                
                OverviewCard(
                    title: "Planned Amount",
                    value: "$\(Int(analysis.plannedAmount))",
                    color: AppColors.warningOrange
                )
                
                OverviewCard(
                    title: "Actually Spent",
                    value: "$\(Int(analysis.actualSpent))",
                    color: AppColors.primaryPurple
                )
            }
        }
    }
    
    private var priorityAnalysisView: some View {
        VStack(spacing: 16) {
            Text("By Priority")
                .font(AppTypography.title3)
                .foregroundColor(AppColors.primaryPurple)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                PriorityAnalysisRow(
                    priority: .high,
                    totalItems: analysis.highPriorityItems,
                    purchasedItems: analysis.highPriorityPurchased
                )
                
                PriorityAnalysisRow(
                    priority: .medium,
                    totalItems: analysis.mediumPriorityItems,
                    purchasedItems: analysis.mediumPriorityPurchased
                )
                
                PriorityAnalysisRow(
                    priority: .low,
                    totalItems: analysis.lowPriorityItems,
                    purchasedItems: analysis.lowPriorityPurchased
                )
            }
            .padding(16)
            .cardStyle()
        }
    }
    
    private var impulsivePurchasesView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Impulsive Purchases")
                    .font(AppTypography.title3)
                    .foregroundColor(AppColors.primaryPurple)
                
                Spacer()
                
                Text("\(analysis.impulsiveItems.count) items")
                    .font(AppTypography.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(AppColors.errorRed)
                    .cornerRadius(8)
            }
            
            VStack(spacing: 8) {
                ForEach(analysis.impulsiveItems) { item in
                    ImpulsiveItemRow(item: item) {
                        selectedItem = item
                    }
                }
            }
            .padding(16)
            .cardStyle()
        }
    }
    
    private func formatMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

struct OverviewCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(AppTypography.caption)
                .foregroundColor(AppColors.neutralGray)
                .multilineTextAlignment(.center)
            
            Text(value)
                .font(AppTypography.title2)
                .foregroundColor(color)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
        .cardStyle()
    }
}

struct PriorityAnalysisRow: View {
    let priority: Priority
    let totalItems: Int
    let purchasedItems: Int
    
    private var percentage: Double {
        guard totalItems > 0 else { return 0 }
        return Double(purchasedItems) / Double(totalItems)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                HStack(spacing: 8) {
                    Circle()
                        .fill(AppColors.priorityColor(for: priority))
                        .frame(width: 12, height: 12)
                    
                    Text(priority.displayName)
                        .font(AppTypography.subheadline)
                        .foregroundColor(AppColors.darkGray)
                }
                
                Spacer()
                
                Text("\(purchasedItems) of \(totalItems)")
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.neutralGray)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(AppColors.neutralGray.opacity(0.2))
                        .frame(height: 4)
                        .cornerRadius(2)
                    
                    Rectangle()
                        .fill(AppColors.priorityColor(for: priority))
                        .frame(width: geometry.size.width * percentage, height: 4)
                        .cornerRadius(2)
                        .animation(.easeInOut(duration: 0.5), value: percentage)
                }
            }
            .frame(height: 4)
        }
    }
}

struct ImpulsiveItemRow: View {
    let item: Item
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(item.name)
                    .font(AppTypography.callout)
                    .foregroundColor(AppColors.darkGray)
                
                Spacer()
                
                Text("$\(Int(item.estimatedPrice))")
                    .font(AppTypography.callout)
                    .foregroundColor(AppColors.errorRed)
                    .fontWeight(.medium)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.neutralGray)
            }
            .padding(.vertical, 4)
        }
    }
}

struct MonthPickerView: View {
    @Binding var selectedMonth: Date
    @Environment(\.dismiss) private var dismiss
    
    private let months: [Date] = {
        let calendar = Calendar.current
        let now = Date()
        var months: [Date] = []
        
        for i in 0..<12 {
            if let month = calendar.date(byAdding: .month, value: -i, to: now) {
                months.append(month)
            }
        }
        
        return months
    }()
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Select Month")
                        .font(AppTypography.title2)
                        .foregroundColor(AppColors.primaryPurple)
                        .padding(.top, 20)
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(months, id: \.self) { month in
                                MonthOptionView(
                                    month: month,
                                    isSelected: Calendar.current.isDate(selectedMonth, equalTo: month, toGranularity: .month)
                                ) {
                                    selectedMonth = month
                                    dismiss()
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .foregroundColor(AppColors.primaryPurple)
                .fontWeight(.semibold)
            }
        }
    }
}

struct MonthOptionView: View {
    let month: Date
    let isSelected: Bool
    let action: () -> Void
    
    private func formatMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(formatMonth(month))
                    .font(AppTypography.headline)
                    .foregroundColor(AppColors.darkGray)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.primaryPurple)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColors.lightPurple.opacity(0.3) : AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? AppColors.primaryPurple.opacity(0.5) : AppColors.neutralGray.opacity(0.2),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AnalysisMainView()
        .environmentObject(ItemsViewModel())
}
