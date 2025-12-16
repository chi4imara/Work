import SwiftUI

struct SummaryMainView: View {
    @EnvironmentObject var itemsViewModel: ItemsViewModel
    @State private var selectedMonth = Date()
    @State private var showingMonthPicker = false
    @State private var selectedItem: Item?
    
    private var summary: MonthlySummary {
        itemsViewModel.getMonthlySummary(for: selectedMonth)
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                    
                    monthSelectorView
                    
                    if !summary.hasData {
                        emptyStateView
                    } else {
                        summaryContentView
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
            Text("Monthly Summary")
                .font(AppTypography.title1)
                .foregroundColor(AppColors.primaryPurple)
            
            Text("Evaluate your shopping mindfulness")
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
                
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.system(size: 50))
                    .foregroundColor(AppColors.primaryPurple)
            }
            
            VStack(spacing: 12) {
                Text("Month not completed yet")
                    .font(AppTypography.title3)
                    .foregroundColor(AppColors.primaryPurple)
                
                Text("Or no purchased items yet. Continue maintaining your list to see results.")
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.darkGray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var summaryContentView: some View {
        VStack(spacing: 24) {
            statisticsOverviewView
            
            if !summary.consciousItems.isEmpty {
                consciousItemsSection
            }
            
            if !summary.impulsiveItems.isEmpty {
                impulsiveItemsSection
            }
            
            if !summary.unpurchasedNecessaryItems.isEmpty {
                unpurchasedNecessarySection
            }
        }
    }
    
    private var statisticsOverviewView: some View {
        VStack(spacing: 16) {
            Text("Final Statistics")
                .font(AppTypography.title3)
                .foregroundColor(AppColors.primaryPurple)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 16) {
                consciousnessChartView
                
                HStack {
                    Text("Total Spent")
                        .font(AppTypography.headline)
                        .foregroundColor(AppColors.darkGray)
                    
                    Spacer()
                    
                    Text("$\(Int(summary.totalSpent))")
                        .font(AppTypography.title2)
                        .foregroundColor(AppColors.primaryPurple)
                        .fontWeight(.bold)
                }
            }
            .padding(20)
            .cardStyle()
        }
    }
    
    private var consciousnessChartView: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Shopping Mindfulness")
                    .font(AppTypography.subheadline)
                    .foregroundColor(AppColors.darkGray)
                
                Spacer()
            }
            
            VStack(spacing: 8) {
                HStack {
                    Text("Conscious")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.successGreen)
                        .frame(width: 70, alignment: .leading)
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(AppColors.neutralGray.opacity(0.2))
                                .frame(height: 8)
                                .cornerRadius(4)
                            
                            Rectangle()
                                .fill(AppColors.successGreen)
                                .frame(width: geometry.size.width * (summary.consciousPercentage / 100), height: 8)
                                .cornerRadius(4)
                                .animation(.easeInOut(duration: 0.8), value: summary.consciousPercentage)
                        }
                    }
                    .frame(height: 8)
                    
                    Text("\(Int(summary.consciousPercentage))%")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.successGreen)
                        .fontWeight(.medium)
                        .frame(width: 40, alignment: .trailing)
                }
                
                HStack {
                    Text("Impulsive")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.errorRed)
                        .frame(width: 70, alignment: .leading)
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(AppColors.neutralGray.opacity(0.2))
                                .frame(height: 8)
                                .cornerRadius(4)
                            
                            Rectangle()
                                .fill(AppColors.errorRed)
                                .frame(width: geometry.size.width * (summary.impulsivePercentage / 100), height: 8)
                                .cornerRadius(4)
                                .animation(.easeInOut(duration: 0.8), value: summary.impulsivePercentage)
                        }
                    }
                    .frame(height: 8)
                    
                    Text("\(Int(summary.impulsivePercentage))%")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.errorRed)
                        .fontWeight(.medium)
                        .frame(width: 40, alignment: .trailing)
                }
            }
        }
    }
    
    private var consciousItemsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("What Really Helped")
                    .font(AppTypography.title3)
                    .foregroundColor(AppColors.primaryPurple)
                
                Spacer()
                
                Text("\(summary.consciousItems.count) items")
                    .font(AppTypography.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(AppColors.successGreen)
                    .cornerRadius(8)
            }
            
            VStack(spacing: 8) {
                ForEach(summary.consciousItems) { item in
                    SummaryItemRow(
                        item: item,
                        badgeColor: AppColors.successGreen,
                        badgeText: "Conscious"
                    ) {
                        selectedItem = item
                    }
                }
            }
            .padding(16)
            .cardStyle()
        }
    }
    
    private var impulsiveItemsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Impulsive Purchases")
                    .font(AppTypography.title3)
                    .foregroundColor(AppColors.primaryPurple)
                
                Spacer()
                
                Text("\(summary.impulsiveItems.count) items")
                    .font(AppTypography.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(AppColors.errorRed)
                    .cornerRadius(8)
            }
            
            VStack(spacing: 8) {
                ForEach(summary.impulsiveItems) { item in
                    SummaryItemRow(
                        item: item,
                        badgeColor: AppColors.errorRed,
                        badgeText: "Impulsive"
                    ) {
                        selectedItem = item
                    }
                }
            }
            .padding(16)
            .cardStyle()
        }
    }
    
    private var unpurchasedNecessarySection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Not Purchased, But Needed")
                    .font(AppTypography.title3)
                    .foregroundColor(AppColors.primaryPurple)
                
                Spacer()
                
                Text("\(summary.unpurchasedNecessaryItems.count) items")
                    .font(AppTypography.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(AppColors.warningOrange)
                    .cornerRadius(8)
            }
            
            VStack(spacing: 8) {
                ForEach(summary.unpurchasedNecessaryItems) { item in
                    SummaryItemRow(
                        item: item,
                        badgeColor: AppColors.warningOrange,
                        badgeText: "Needed"
                    ) {
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

struct SummaryItemRow: View {
    let item: Item
    let badgeColor: Color
    let badgeText: String
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(AppTypography.callout)
                        .foregroundColor(AppColors.darkGray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Text(badgeText)
                            .font(AppTypography.caption2)
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(badgeColor)
                            .cornerRadius(6)
                        
                        Text(item.priority.displayName)
                            .font(AppTypography.caption2)
                            .foregroundColor(AppColors.neutralGray)
                        
                        Spacer()
                    }
                }
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(Int(item.estimatedPrice))")
                        .font(AppTypography.callout)
                        .foregroundColor(badgeColor)
                        .fontWeight(.medium)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.neutralGray)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    SummaryMainView()
        .environmentObject(ItemsViewModel())
}
