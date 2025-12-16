import SwiftUI

struct QuickActionsView: View {
    @ObservedObject var journalViewModel: RepotJournalViewModel
    @State private var showingAddView = false
    @State private var showingQuickAdd = false
    @State private var showingFilterView = false
    @State private var animateButtons = false
    
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                    
                    mainActionsGrid
                    
                    quickStatsSection
                    
                    recentPlantsSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
        .sheet(isPresented: $showingAddView) {
            RepotFormView(viewModel: journalViewModel, editingRecord: nil)
        }
        .sheet(isPresented: $showingQuickAdd) {
            QuickAddView(journalViewModel: journalViewModel, showingQuickAdd: $showingQuickAdd, showingAddView: $showingAddView)
        }
        .sheet(isPresented: $showingFilterView) {
            FilterView(journalViewModel: journalViewModel)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                animateButtons = true
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Quick Actions")
                        .font(AppFonts.largeTitle(.bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("Fast access to common tasks")
                        .font(AppFonts.subheadline(.regular))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "bolt.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(AppColors.accentYellow)
            }
        }
        .padding(.top, 10)
    }
    
    private var mainActionsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            ActionCard(
                title: "Add Repotting",
                subtitle: "Full form",
                icon: "plus.circle.fill",
                color: AppColors.primaryBlue,
                action: { showingAddView = true },
                animationDelay: 0.1
            )
            
            ActionCard(
                title: "Quick Add",
                subtitle: "Fast entry",
                icon: "bolt.circle.fill",
                color: AppColors.accentYellow,
                action: { showingQuickAdd = true },
                animationDelay: 0.2
            )
            
            ActionCard(
                title: "View Plants",
                subtitle: "All plants",
                icon: "leaf.circle.fill",
                color: AppColors.accentPurple,
                action: { 
                    withAnimation {
                        selectedTab = 1
                    }
                },
                animationDelay: 0.4
            )
        }
        .opacity(animateButtons ? 1 : 0)
        .offset(y: animateButtons ? 0 : 20)
    }
    
    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Stats")
                .font(AppFonts.title2(.semiBold))
                .foregroundColor(AppColors.textPrimary)
            
            HStack(spacing: 16) {
                QuickStatCard(
                    title: "Total",
                    value: "\(journalViewModel.records.count)",
                    icon: "number.circle.fill",
                    color: AppColors.primaryBlue
                )
                
                QuickStatCard(
                    title: "Plants",
                    value: "\(uniquePlantCount)",
                    icon: "tree.circle.fill",
                    color: AppColors.accentGreen
                )
                
                QuickStatCard(
                    title: "This Month",
                    value: "\(thisMonthCount)",
                    icon: "calendar.circle.fill",
                    color: AppColors.accentYellow
                )
            }
        }
    }
    
    private var recentPlantsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Plants")
                .font(AppFonts.title2(.semiBold))
                .foregroundColor(AppColors.textPrimary)
            
            if recentPlants.isEmpty {
                EmptyPlantsCard()
            } else {
                VStack(spacing: 8) {
                    ForEach(Array(recentPlants.prefix(5))) { plant in
                        PlantQuickCard(plant: plant)
                    }
                }
            }
        }
    }
    
    private var uniquePlantCount: Int {
        Set(journalViewModel.records.map { $0.normalizedPlantName }).count
    }
    
    private var thisMonthCount: Int {
        let calendar = Calendar.current
        let now = Date()
        return journalViewModel.records.filter { record in
            calendar.isDate(record.repotDate, equalTo: now, toGranularity: .month)
        }.count
    }
    
    private var recentPlants: [PlantSummary] {
        let groupedRecords = Dictionary(grouping: journalViewModel.records) { $0.normalizedPlantName }
        
        return groupedRecords.compactMap { (plantName, records) in
            guard let firstRecord = records.first else { return nil }
            let lastDate = records.map { $0.repotDate }.max() ?? firstRecord.repotDate
            
            return PlantSummary(
                plantName: firstRecord.plantName,
                recordCount: records.count,
                lastRepotDate: lastDate
            )
        }.sorted { $0.lastRepotDate > $1.lastRepotDate }
    }
}

struct ActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    let animationDelay: Double
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                }
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(AppFonts.subheadline(.semiBold))
                        .foregroundColor(AppColors.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(AppFonts.caption(.regular))
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .shadow(color: color.opacity(0.1), radius: 8, x: 0, y: 4)
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(value)
                .font(AppFonts.title3(.bold))
                .foregroundColor(AppColors.textPrimary)
            
            Text(title)
                .font(AppFonts.caption(.medium))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(AppColors.surfaceBackground)
        .cornerRadius(12)
    }
}

struct PlantQuickCard: View {
    let plant: PlantSummary
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(AppColors.accentGreen.opacity(0.2))
                    .frame(width: 35, height: 35)
                
                Image(systemName: "leaf.fill")
                    .font(.caption)
                    .foregroundColor(AppColors.accentGreen)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(plant.plantName)
                    .font(AppFonts.subheadline(.semiBold))
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(1)
                
                Text("\(plant.recordCount) records")
                    .font(AppFonts.caption(.regular))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Text(DateFormatter.short.string(from: plant.lastRepotDate))
                .font(AppFonts.caption(.medium))
                .foregroundColor(AppColors.textTertiary)
        }
        .padding(12)
        .background(AppColors.surfaceBackground)
        .cornerRadius(12)
    }
}

struct EmptyPlantsCard: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "leaf.circle")
                .font(.system(size: 30))
                .foregroundColor(AppColors.textTertiary)
            
            Text("No plants yet")
                .font(AppFonts.subheadline(.medium))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(AppColors.surfaceBackground)
        .cornerRadius(12)
    }
}

extension DateFormatter {
    static let short: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}


