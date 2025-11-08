import SwiftUI

enum TabItem: String, CaseIterable {
    case calendar = "Calendar"
    case analytics = "Analytics"
    case notes = "Notes"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .calendar: return "calendar"
        case .analytics: return "chart.line.uptrend.xyaxis"
        case .notes: return "note.text"
        case .settings: return "gearshape"
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
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.backgroundWhite)
                .shadow(
                    color: Color.primaryBlue.opacity(0.15),
                    radius: 10,
                    x: 0,
                    y: -5
                )
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
                Image(systemName: tab.icon)
                    .font(.system(size: 20, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? Color.primaryBlue : Color.textSecondary)
                
                Text(tab.title)
                    .font(FontManager.small)
                    .foregroundColor(isSelected ? Color.primaryBlue : Color.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? Color.lightBlue.opacity(0.2) : Color.clear)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.calendar))
    }
    .background(Color.backgroundGray)
}
