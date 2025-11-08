import SwiftUI

struct CustomSideBar: View {
    @Binding var selectedTab: AppTab
    @Binding var isShowingSidebar: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                HStack {
                    Text("DreamSign")
                        .font(AppFonts.bold(24))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isShowingSidebar = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                    }
                }
                
                Divider()
                    .background(AppColors.primaryText.opacity(0.3))
            }
            .padding(.horizontal, 24)
            .padding(.top, 60)
            .padding(.bottom, 16)
            
            VStack(spacing: 8) {
                ForEach(AppTab.allCases, id: \.self) { tab in
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
            .padding(.horizontal, 16)
            
            Spacer()
            
            VStack(spacing: 12) {
                Text("Record Your Dreams")
                    .font(AppFonts.light(14))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .frame(width: 280)
    }
}

struct SideBarMenuItem: View {
    let tab: AppTab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: tab.iconName)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.yellow : AppColors.primaryText)
                    .frame(width: 24, height: 24)
                
                Text(tab.title)
                    .font(AppFonts.medium(16))
                    .foregroundColor(isSelected ? AppColors.yellow : AppColors.primaryText)
                
                Spacer()
                
                if isSelected {
                    Circle()
                        .fill(AppColors.yellow)
                        .frame(width: 6, height: 6)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColors.yellow.opacity(0.1) : Color.clear)
            )
        }
    }
}

enum AppTab: String, CaseIterable {
    case dreams = "dreams"
    case tags = "tags"
    case summary = "summary"
    case settings = "settings"
    
    var title: String {
        switch self {
        case .dreams:
            return "Dreams"
        case .tags:
            return "Tags"
        case .summary:
            return "Summary"
        case .settings:
            return "Settings"
        }
    }
    
    var iconName: String {
        switch self {
        case .dreams:
            return "moon.stars.fill"
        case .tags:
            return "tag.fill"
        case .summary:
            return "chart.bar.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
}

#Preview {
    CustomSideBar(
        selectedTab: .constant(.dreams),
        isShowingSidebar: .constant(true)
    )
}
