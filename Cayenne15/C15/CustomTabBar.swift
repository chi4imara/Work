import SwiftUI

enum TabItem: String, CaseIterable {
    case add = "Add"
    case history = "History"
    case statistics = "Statistics"
    case analytics = "Analytics"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .add:
            return "plus.circle.fill"
        case .history:
            return "clock.fill"
        case .statistics:
            return "chart.bar.fill"
        case .analytics:
            return "chart.line.uptrend.xyaxis"
        case .settings:
            return "gearshape.fill"
        }
    }
    
    var title: String {
        return self.rawValue
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    selectedTab = tab
                }
            }
        }
        .frame(height: 80)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(ColorManager.darkBlue)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: -5)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(ColorManager.accentGradient)
                            .frame(width: 40, height: 40)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: isSelected ? 20 : 18, weight: .medium))
                        .foregroundColor(isSelected ? ColorManager.white : ColorManager.secondaryText)
                }
                
                Text(tab.title)
                    .font(FontManager.playfairRegular(size: 10))
                    .foregroundColor(isSelected ? ColorManager.accentText : ColorManager.secondaryText)
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.3), value: isSelected)
    }
}

struct MainTabView: View {
    @StateObject private var recordsViewModel = CarRecordsViewModel()
    @State private var selectedTab: TabItem = .add
    @State private var showingRecordSaved = false
    @State private var savedRecord: CarRecord?
    
    var body: some View {
        ZStack {
            ColorManager.primaryGradient
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case .add:
                    AddRecordView(recordsViewModel: recordsViewModel) { record in
                        savedRecord = record
                        showingRecordSaved = true
                    }
                case .history:
                    HistoryView(recordsViewModel: recordsViewModel)
                case .statistics:
                    StatisticsView(recordsViewModel: recordsViewModel)
                case .analytics:
                    AnalyticsView(recordsViewModel: recordsViewModel)
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .sheet(isPresented: $showingRecordSaved) {
            if let record = savedRecord {
                RecordSavedView(record: record) {
                    showingRecordSaved = false
                    savedRecord = nil
                }
            }
        }
    }
}

struct ExtraView: View {
    var body: some View {
        VStack {
            Text("Extra Features")
                .font(FontManager.playfairBold(size: 24))
                .foregroundColor(ColorManager.primaryText)
            
            Text("Coming Soon...")
                .font(FontManager.playfairRegular(size: 16))
                .foregroundColor(ColorManager.secondaryText)
        }
    }
}

#Preview {
    MainTabView()
}
