import SwiftUI

struct CustomSideBar: View {
    @Binding var selectedTab: TabItem
    @Binding var isShowingSidebar: Bool
    
    var body: some View {
        ZStack {
            if isShowingSidebar {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isShowingSidebar = false
                        }
                    }
            }
            
            HStack {
                if isShowingSidebar {
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "trophy.fill")
                                    .font(.title2)
                                    .foregroundColor(AppColors.primaryYellow)
                                
                                Text("Small Wins")
                                    .font(AppFonts.title2)
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Spacer()
                                
                                Button {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isShowingSidebar = false
                                    }
                                } label: {
                                    Image(systemName: "xmark")
                                        .font(.title3)
                                        .foregroundColor(AppColors.textSecondary)
                                }
                            }
                            .padding(.top, 50)
                            
                            Divider()
                                .background(AppColors.cardBorder)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        
                        VStack(spacing: 8) {
                            ForEach(TabItem.allCases, id: \.self) { tab in
                                SideBarMenuItem(
                                    tab: tab,
                                    isSelected: selectedTab == tab
                                ) {
                                    selectedTab = tab
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isShowingSidebar = false
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                        
                        Spacer()
                    }
                    .frame(width: 280)
                    .background(
                        RoundedRectangle(cornerRadius: 0)
                            .fill(AppColors.cardBackground)
                            .background(.ultraThinMaterial)
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isShowingSidebar = false
                        }
                    }
                    .ignoresSafeArea()
                    .transition(.move(edge: .leading))
                }
                
                Spacer()
            }
        }
    }
}

struct SideBarMenuItem: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: tab.iconName)
                    .font(.title3)
                    .foregroundColor(isSelected ? AppColors.primaryYellow : AppColors.textSecondary)
                    .frame(width: 24)
                
                Text(tab.title)
                    .font(AppFonts.body)
                    .foregroundColor(isSelected ? AppColors.textPrimary : AppColors.textSecondary)
                
                Spacer()
                
                if isSelected {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(AppColors.primaryYellow)
                        .frame(width: 4, height: 20)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColors.buttonSecondary : Color.clear)
            )
        }
    }
}

enum TabItem: String, CaseIterable {
    case feed = "feed"
    case categories = "categories"
    case insights = "insights"
    case settings = "settings"
    
    var title: String {
        switch self {
        case .feed:
            return "Feed"
        case .categories:
            return "Categories"
        case .insights:
            return "Insights"
        case .settings:
            return "Settings"
        }
    }
    
    var iconName: String {
        switch self {
        case .feed:
            return "list.bullet"
        case .categories:
            return "folder.fill"
        case .insights:
            return "chart.line.uptrend.xyaxis"
        case .settings:
            return "gearshape.fill"
        }
    }
}

#Preview {
    CustomSideBar(
        selectedTab: .constant(.feed),
        isShowingSidebar: .constant(true)
    )
}
