import SwiftUI

enum TabItem: String, CaseIterable {
    case people = "People"
    case ideas = "Ideas"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .people:
            return "person.3.fill"
        case .ideas:
            return "list.bullet"
        case .statistics:
            return "chart.bar.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
    
    var selectedIcon: String {
        return icon
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                }
            
                    Spacer()
            }
            
        }
        .frame(height: 80)
        .background(
            ZStack {
                Rectangle()
                    .fill(AppColors.cardBackground)
                    .background(.ultraThinMaterial)
                
                Rectangle()
                    .fill(AppColors.cardBorder)
                    .frame(height: 1)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        )
        .cornerRadius(25, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
        .padding(.horizontal, 20)
        .padding(.bottom, 6)
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
                            .fill(AppColors.primaryYellow)
                            .frame(width: 40, height: 40)
                            .scaleEffect(isSelected ? 1.0 : 0.8)
                    }
                    
                    Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.textSecondary)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                .frame(height: 40)
                
                Text(tab.rawValue)
                    .font(AppFonts.caption1)
                    .foregroundColor(isSelected ? AppColors.primaryYellow : AppColors.textTertiary)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.people))
    }
    .background(BackgroundView())
}
