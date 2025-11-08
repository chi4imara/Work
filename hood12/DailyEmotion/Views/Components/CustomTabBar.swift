import SwiftUI

enum TabItem: String, CaseIterable {
    case newEntry = "New Entry"
    case calendar = "Calendar"
    case statistics = "Stats"
    case archive = "Archive"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .newEntry: return "plus.circle.fill"
        case .archive: return "archivebox.fill"
        case .calendar: return "calendar"
        case .statistics: return "chart.bar.fill"
        case .settings: return "gearshape.fill"
        }
    }
    
    var title: String {
        return self.rawValue
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack(spacing: 8) {
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
        .padding(.horizontal, 20)
        .frame(height: 80)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white.opacity(0.35))
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(AppColors.primaryText.opacity(0.1), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
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
                            .fill(AppColors.accentYellow)
                            .frame(width: 36, height: 36)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.primaryText.opacity(0.6))
                }
                
                Text(tab.title)
                    .font(.poppinsRegular(size: 10))
                    .foregroundColor(isSelected ? AppColors.accentYellow : AppColors.primaryText.opacity(0.6))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.newEntry))
    }
    .background(BackgroundView())
}
