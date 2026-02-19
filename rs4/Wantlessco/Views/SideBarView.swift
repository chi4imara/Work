import SwiftUI

enum NavigationTab: String, CaseIterable {
    case home = "Home"
    case categories = "Categories"
    case about = "Calendar"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .categories: return "folder.fill"
        case .statistics: return "chart.bar.fill"
        case .settings: return "gearshape.fill"
        case .about: return "calendar.circle.fill"
        }
    }
}

struct SideBarView: View {
    @Binding var selectedTab: NavigationTab
    @Binding var showSidebar: Bool
    
    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Circle()
                                .fill(AppColors.primaryPurple)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Wantless")
                                    .font(.ubuntu(20, weight: .bold))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Text("Track your desires")
                                    .font(.ubuntu(14))
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            
                            Spacer()
                        }
                        
                        Divider()
                            .background(AppColors.cardBorder)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 60)
                    .padding(.bottom, 20)
                    
                    VStack(spacing: 8) {
                        ForEach(NavigationTab.allCases, id: \.self) { tab in
                            SideBarItem(
                                tab: tab,
                                isSelected: selectedTab == tab
                            ) {
                                selectedTab = tab
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showSidebar = false
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    
                    Spacer()
                }
                .frame(width: 280)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            AppColors.primaryBlue.opacity(0.95),
                            AppColors.primaryPurple.opacity(0.95)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                
                Spacer()
            }
            .onTapGesture {
                withAnimation {
                    showSidebar = false
                }
            }
        }
    }
}

struct SideBarItem: View {
    let tab: NavigationTab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: tab.icon)
                    .font(.title3)
                    .foregroundColor(isSelected ? AppColors.primaryPurple : AppColors.primaryText)
                    .frame(width: 24)
                
                Text(tab.rawValue)
                    .font(.ubuntu(16, weight: isSelected ? .medium : .regular))
                    .foregroundColor(isSelected ? AppColors.primaryPurple : AppColors.primaryText)
                
                Spacer()
                
                if isSelected {
                    Circle()
                        .fill(AppColors.primaryPurple)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColors.primaryText.opacity(0.15) : Color.clear)
            )
        }
    }
}
