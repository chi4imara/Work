import SwiftUI

enum TabItem: String, CaseIterable {
    case collection = "Collection"
    case statistics = "Statistics"
    case notes = "Notes"
    case info = "Info"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .collection:
            return "handbag"
        case .statistics:
            return "chart.bar"
        case .notes:
            return "note.text"
        case .info:
            return "info.circle"
        case .settings:
            return "gearshape"
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
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.white.opacity(0.98))
                .shadow(color: AppColors.shadowColor.opacity(0.4), radius: 20, x: 0, y: -5)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(AppColors.primaryYellow.opacity(0.3), lineWidth: 1.5)
                )
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(AppColors.primaryYellow.opacity(0.2))
                            .frame(width: 44, height: 44)
                            .scaleEffect(isSelected ? 1.0 : 0.8)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: isSelected ? 22 : 18, weight: isSelected ? .semibold : .medium))
                        .foregroundColor(isSelected ? AppColors.primaryYellow : AppColors.darkText.opacity(0.6))
                        .scaleEffect(isSelected ? 1.15 : 1.0)
                        .shadow(color: isSelected ? Color.clear : Color.black.opacity(0.1), radius: 1, x: 0, y: 0.5)
                }
                
                Text(tab.title)
                    .font(FontManager.ubuntu(isSelected ? .bold : .medium, size: isSelected ? 11 : 10))
                    .foregroundColor(isSelected ? AppColors.primaryYellow : AppColors.darkText.opacity(0.7))
                    .opacity(isSelected ? 1.0 : 1.0)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? AppColors.primaryYellow.opacity(0.15) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            CustomTabBar(selectedTab: .constant(.collection))
        }
        .background(BackgroundView())
    }
}
