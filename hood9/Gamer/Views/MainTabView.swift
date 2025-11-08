import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .collection
    @State private var showSidebar = false
    
    enum Tab {
        case collection, journal, statistics, settings
    }
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .collection:
                    CollectionView()
                case .journal:
                    JournalView()
                case .statistics:
                    StatisticsView()
                case .settings:
                    SettingsView()
                }
            }
            
            VStack {
                HStack {
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            showSidebar.toggle()
                        }
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [AppColors.primaryBlue, AppColors.secondaryBlue],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: AppColors.primaryBlue.opacity(0.4), radius: 8, x: 0, y: 4)
                            )
                    }
                    .padding(.leading, 20)
                    .padding(.top)
                    
                    Spacer()
                }
                
                Spacer()
            }
            
            if showSidebar {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            showSidebar = false
                        }
                    }
                
                HStack {
                    CustomSidebar(selectedTab: $selectedTab, showSidebar: $showSidebar)
                        .transition(.move(edge: .leading))
                    
                    Spacer()
                }
                .zIndex(1)
            }
        }
    }
}

struct CustomSidebar: View {
    @Binding var selectedTab: MainTabView.Tab
    @Binding var showSidebar: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "dice.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [AppColors.lightBlue, AppColors.primaryBlue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            showSidebar = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppColors.secondaryText)
                            .frame(width: 32, height: 32)
                            .background(Circle().fill(Color.white.opacity(0.3)))
                    }
                }
                
                Text("Board Game Log")
                    .font(AppFonts.bold(size: 22))
                    .foregroundColor(.white)
                
                Text("Track & Analyze")
                    .font(AppFonts.regular(size: 14))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(24)
            
            VStack(spacing: 8) {
                SidebarMenuItem(
                    icon: "square.grid.2x2.fill",
                    title: "Collection",
                    isSelected: selectedTab == .collection
                ) {
                    selectTab(.collection)
                }
                
                Divider()
                    .overlay {
                        Color.white
                    }
                    .frame(maxWidth: .infinity)
                
                SidebarMenuItem(
                    icon: "book.fill",
                    title: "Journal",
                    isSelected: selectedTab == .journal
                ) {
                    selectTab(.journal)
                }
                
                Divider()
                    .overlay {
                        Color.white
                    }
                    .frame(maxWidth: .infinity)
                
                SidebarMenuItem(
                    icon: "chart.bar.fill",
                    title: "Statistics",
                    isSelected: selectedTab == .statistics
                ) {
                    selectTab(.statistics)
                }
                
                Divider()
                    .overlay {
                        Color.white
                    }
                    .frame(maxWidth: .infinity)
                
                SidebarMenuItem(
                    icon: "gearshape.fill",
                    title: "Settings",
                    isSelected: selectedTab == .settings
                ) {
                    selectTab(.settings)
                }
            }
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .frame(width: 280)
        .background(
            LinearGradient(
                colors: [AppColors.primaryBlue, AppColors.secondaryBlue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .shadow(radius: 20)
    }
    
    private func selectTab(_ tab: MainTabView.Tab) {
        selectedTab = tab
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            showSidebar = false
        }
    }
}

struct SidebarMenuItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? AppColors.primaryBlue : .white)
                    .frame(width: 24)
                
                Text(title)
                    .font(AppFonts.medium(size: 16))
                    .foregroundColor(isSelected ? AppColors.primaryBlue : .white)
                
                Spacer()
                
                if isSelected {
                    Circle()
                        .fill(AppColors.accentOrange)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                isSelected ?
                Color.white.opacity(0.95) :
                Color.clear
            )
            .cornerRadius(12)
        }
    }
}

