import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var inventoryViewModel: InventoryViewModel
    @ObservedObject var notesViewModel: NotesViewModel
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    headerView
                    
                    if inventoryViewModel.items.isEmpty {
                        emptyStateView
                    } else {
                        statisticsCards
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 100, height: 100)
                    .shadow(color: AppColors.shadowColor, radius: 15, x: 0, y: 8)
                
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(AppColors.lightBlue)
            }
            
            Text("Statistics")
                .font(.playfairDisplay(28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Text("No statistics available")
                .font(.playfairDisplay(20, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            Text("Add items to see statistics")
                .font(.playfairDisplay(16, weight: .regular))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(.top, 100)
    }
    
    private var statisticsCards: some View {
        VStack(spacing: 20) {
            totalItemsCard
            
            categoryDistributionCard
            
            statusDistributionCard
            
            notesStatisticsCard
            
            storageLocationsCard
        }
    }
    
    private var totalItemsCard: some View {
        StatisticsCard(
            title: "Total Items",
            value: "\(inventoryViewModel.items.count)",
            icon: "archivebox.fill",
            color: AppColors.lightBlue
        )
    }
    
    private var categoryDistributionCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "folder.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.orange)
                
                Text("By Category")
                    .font(.playfairDisplay(20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                ForEach(inventoryViewModel.getCategoryStats(), id: \.category) { stat in
                    CategoryStatRow(
                        category: stat.category.displayName,
                        count: stat.count,
                        total: inventoryViewModel.items.count
                    )
                }
            }
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(20)
        .shadow(color: AppColors.shadowColor, radius: 10, x: 0, y: 5)
    }
    
    private var statusDistributionCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.workingStatus)
                
                Text("By Condition")
                    .font(.playfairDisplay(20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                ForEach(inventoryViewModel.getStatusStats(), id: \.status) { stat in
                    StatusStatRow(
                        status: stat.status.displayName,
                        count: stat.count,
                        total: inventoryViewModel.items.count,
                        color: statusColor(for: stat.status)
                    )
                }
            }
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(20)
        .shadow(color: AppColors.shadowColor, radius: 10, x: 0, y: 5)
    }
    
    private var notesStatisticsCard: some View {
        StatisticsCard(
            title: "Total Notes",
            value: "\(notesViewModel.notes.count)",
            icon: "note.text",
            color: AppColors.accentText
        )
    }
    
    private var storageLocationsCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "location.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.lightBlue)
                
                Text("Storage Locations")
                    .font(.playfairDisplay(20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            
            let locations = getUniqueLocations()
            
            if locations.isEmpty {
                Text("No locations specified")
                    .font(.playfairDisplay(14, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
            } else {
                VStack(spacing: 10) {
                    ForEach(locations.prefix(5), id: \.self) { location in
                        LocationStatRow(
                            location: location,
                            count: getItemCount(for: location)
                        )
                    }
                    
                    if locations.count > 5 {
                        Text("+ \(locations.count - 5) more")
                            .font(.playfairDisplay(14, weight: .medium))
                            .foregroundColor(AppColors.accentText)
                            .padding(.top, 5)
                    }
                }
            }
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(20)
        .shadow(color: AppColors.shadowColor, radius: 10, x: 0, y: 5)
    }
    
    private func getUniqueLocations() -> [String] {
        Array(Set(inventoryViewModel.items.map { $0.location })).sorted()
    }
    
    private func getItemCount(for location: String) -> Int {
        inventoryViewModel.items.filter { $0.location == location }.count
    }
    
    private func statusColor(for status: ItemStatus) -> Color {
        switch status {
        case .working: return AppColors.workingStatus
        case .needsCheck: return AppColors.needsCheckStatus
        case .broken: return AppColors.brokenStatus
        }
    }
}

struct StatisticsCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
                
                Text(value)
                    .font(.playfairDisplay(32, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
            }
            
            Spacer()
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(20)
        .shadow(color: AppColors.shadowColor, radius: 10, x: 0, y: 5)
    }
}

struct CategoryStatRow: View {
    let category: String
    let count: Int
    let total: Int
    
    private var percentage: Double {
        total > 0 ? Double(count) / Double(total) : 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(category)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Text("\(count)")
                    .font(.playfairDisplay(16, weight: .bold))
                    .foregroundColor(AppColors.accentText)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.borderColor)
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.orangeGradient)
                        .frame(width: geometry.size.width * percentage, height: 8)
                }
            }
            .frame(height: 8)
        }
    }
}

struct StatusStatRow: View {
    let status: String
    let count: Int
    let total: Int
    let color: Color
    
    private var percentage: Double {
        total > 0 ? Double(count) / Double(total) : 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                HStack(spacing: 8) {
                    Circle()
                        .fill(color)
                        .frame(width: 10, height: 10)
                    
                    Text(status)
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                }
                
                Spacer()
                
                Text("\(count)")
                    .font(.playfairDisplay(16, weight: .bold))
                    .foregroundColor(color)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.borderColor)
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * percentage, height: 8)
                }
            }
            .frame(height: 8)
        }
    }
}

struct LocationStatRow: View {
    let location: String
    let count: Int
    
    var body: some View {
        HStack {
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppColors.lightBlue)
            
            Text(location)
                .font(.playfairDisplay(16, weight: .regular))
                .foregroundColor(AppColors.primaryText)
                .lineLimit(1)
            
            Spacer()
            
            Text("\(count) item\(count == 1 ? "" : "s")")
                .font(.playfairDisplay(14, weight: .medium))
                .foregroundColor(AppColors.accentText)
        }
    }
}
