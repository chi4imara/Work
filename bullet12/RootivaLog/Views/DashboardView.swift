import SwiftUI

struct DashboardView: View {
    @ObservedObject var journalViewModel: RepotJournalViewModel
    @State private var showingAddView = false
    @State private var showingQuickAdd = false
    @State private var animateCards = false
    
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                    
                    quickStatsGrid
                    
                    recentActivitySection
                    
                    tipsSection
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
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Plant Care")
                        .font(AppFonts.largeTitle(.bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("Track your green friends")
                        .font(AppFonts.subheadline(.regular))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(AppColors.accentGreen.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "leaf.fill")
                        .font(.title2)
                        .foregroundColor(AppColors.accentGreen)
                }
            }
        }
        .padding(.top, 10)
    }
    
    private var quickStatsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            DashboardStatCard(
                title: "Total Plants",
                value: "\(uniquePlantCount)",
                icon: "tree.circle.fill",
                color: AppColors.accentGreen,
                animationDelay: 0.1
            )
            
            DashboardStatCard(
                title: "Repottings",
                value: "\(journalViewModel.records.count)",
                icon: "arrow.triangle.2.circlepath.circle.fill",
                color: AppColors.primaryBlue,
                animationDelay: 0.2
            )
            
            DashboardStatCard(
                title: "This Month",
                value: "\(thisMonthCount)",
                icon: "calendar.circle.fill",
                color: AppColors.accentYellow,
                animationDelay: 0.3
            )
            
            DashboardStatCard(
                title: "Needs Care",
                value: "\(needsCareCount)",
                icon: "exclamationmark.triangle.fill",
                color: AppColors.accentOrange,
                animationDelay: 0.4
            )
        }
        .opacity(animateCards ? 1 : 0)
        .offset(y: animateCards ? 0 : 20)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                animateCards = true
            }
        }
    }
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Activity")
                    .font(AppFonts.title2(.semiBold))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Button("View All") {
                    withAnimation {
                        selectedTab = 1
                    }
                }
                .font(AppFonts.caption(.semiBold))
                .foregroundColor(AppColors.primaryBlue)
            }
            
            if journalViewModel.records.isEmpty {
                EmptyActivityCard()
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(journalViewModel.records.prefix(3))) { record in
                        ActivityCard(record: record)
                    }
                }
            }
        }
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(AppFonts.title2(.semiBold))
                .foregroundColor(AppColors.textPrimary)
            
            HStack(spacing: 16) {
                QuickActionButton(
                    title: "Add Repotting",
                    icon: "plus.circle.fill",
                    color: AppColors.primaryBlue,
                    action: { showingAddView = true }
                )
                
                QuickActionButton(
                    title: "Quick Add",
                    icon: "bolt.circle.fill",
                    color: AppColors.accentYellow,
                    action: { showingQuickAdd = true }
                )
            }
        }
    }
    
    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Plant Care Tips")
                .font(AppFonts.title2(.semiBold))
                .foregroundColor(AppColors.textPrimary)
            
            VStack(spacing: 12) {
                TipCard(
                    title: "Watering Schedule",
                    description: "Check soil moisture before watering",
                    icon: "drop.circle.fill",
                    color: AppColors.primaryBlue
                )
                
                TipCard(
                    title: "Light Requirements",
                    description: "Most plants need bright, indirect light",
                    icon: "sun.max.circle.fill",
                    color: AppColors.accentYellow
                )
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
    
    private var needsCareCount: Int {
        let sixMonthsAgo = Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date()
        let plantLastRepot = Dictionary(grouping: journalViewModel.records) { $0.normalizedPlantName }
            .compactMapValues { records in
                records.map { $0.repotDate }.max()
            }
        
        return plantLastRepot.values.filter { $0 < sixMonthsAgo }.count
    }
}

struct DashboardStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let animationDelay: Double
    
    @State private var animateValue = false
    
    var body: some View {
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
                Text(value)
                    .font(AppFonts.title(.bold))
                    .foregroundColor(AppColors.textPrimary)
                    .scaleEffect(animateValue ? 1.1 : 1.0)
                
                Text(title)
                    .font(AppFonts.caption(.medium))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: color.opacity(0.1), radius: 8, x: 0, y: 4)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(animationDelay)) {
                animateValue = true
            }
        }
    }
}

struct ActivityCard: View {
    let record: RepotRecord
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryBlue.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.caption)
                    .foregroundColor(AppColors.primaryBlue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(record.plantName)
                    .font(AppFonts.subheadline(.semiBold))
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(1)
                
                Text(DateFormatter.relative.string(from: record.repotDate))
                    .font(AppFonts.caption(.regular))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
        }
        .padding(12)
        .background(AppColors.surfaceBackground)
        .cornerRadius(12)
    }
}

struct EmptyActivityCard: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "leaf.circle")
                .font(.system(size: 40))
                .foregroundColor(AppColors.textTertiary)
            
            Text("No recent activity")
                .font(AppFonts.subheadline(.medium))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(AppColors.surfaceBackground)
        .cornerRadius(12)
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(AppFonts.caption(.semiBold))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .shadow(color: color.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TipCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppFonts.subheadline(.semiBold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text(description)
                    .font(AppFonts.caption(.regular))
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(12)
        .background(AppColors.surfaceBackground)
        .cornerRadius(12)
    }
}

extension DateFormatter {
    static let relative: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
}


