import SwiftUI

struct CustomSidebar: View {
    @Binding var selectedTab: TabItem
    @Binding var isOpen: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("JoyJournal")
                            .font(FontManager.title)
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isOpen = false
                            }
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(ColorTheme.secondaryText)
                        }
                    }
                    
                    Divider()
                        .background(ColorTheme.lightBlue.opacity(0.3))
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                VStack(spacing: 8) {
                    ForEach(TabItem.allCases, id: \.self) { tab in
                        SidebarButton(
                            tab: tab,
                            isSelected: selectedTab == tab
                        ) {
                            selectedTab = tab
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isOpen = false
                            }
                        }
                    }
                }
                .padding(.horizontal, 12)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                        .background(ColorTheme.lightBlue.opacity(0.3))
                }
            }
            .frame(width: 280)
            .background(
                ZStack {
                    WebPatternBackground()
                    Rectangle()
                        .fill(Color.clear)
                        .background(WebPatternBackground())
                    
                    Rectangle()
                        .fill(ColorTheme.lightBlue.opacity(0.3))
                        .frame(width: 1)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            )
            .shadow(color: ColorTheme.primaryBlue.opacity(0.15), radius: 20, x: 5, y: 0)
            
            if isOpen {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isOpen = false
                        }
                    }
            }
        }
        .offset(x: isOpen ? 0 : -280)
        .animation(.easeInOut(duration: 0.3), value: isOpen)
    }
}

struct SidebarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                    .font(.system(size: 20, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? ColorTheme.sidebarSelected : ColorTheme.sidebarUnselected)
                    .frame(width: 24, height: 24)
                
                Text(tab.title)
                    .font(FontManager.body)
                    .foregroundColor(isSelected ? ColorTheme.sidebarSelected : ColorTheme.sidebarUnselected)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? ColorTheme.primaryBlue.opacity(0.1) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? ColorTheme.primaryBlue.opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
    }
}

enum TabItem: String, CaseIterable {
    case home = "home"
    case planner = "planner"
    case analytics = "analytics"
    case settings = "settings"
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .planner:
            return "Planner"
        case .analytics:
            return "Analytics"
        case .settings:
            return "Settings"
        }
    }
    
    var icon: String {
        switch self {
        case .home:
            return "house"
        case .planner:
            return "calendar"
        case .analytics:
            return "chart.bar"
        case .settings:
            return "gearshape"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .home:
            return "house.fill"
        case .planner:
            return "calendar.circle.fill"
        case .analytics:
            return "chart.bar.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
}


