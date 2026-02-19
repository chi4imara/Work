import SwiftUI

enum TabItem: String, CaseIterable {
    case devices = "Devices"
    case characteristics = "Characteristics"
    case analytics = "Analytics"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .devices:
            return "laptopcomputer.and.iphone"
        case .characteristics:
            return "chart.bar.fill"
        case .analytics:
            return "chart.line.uptrend.xyaxis"
        case .settings:
            return "gearshape.fill"
        }
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
            ZStack {
                AppColors.cardGradient
                
                Rectangle()
                    .fill(AppColors.accentBlue.opacity(0.3))
                    .frame(height: 1)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        )
        .cornerRadius(20, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
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
                            .fill(AppColors.accentBlue)
                            .frame(width: 40, height: 40)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: isSelected ? 20 : 18, weight: .medium))
                        .foregroundColor(isSelected ? .white : AppColors.secondaryText)
                }
                
                Text(tab.rawValue)
                    .font(FontManager.playfairDisplay(size: 10, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.accentBlue : AppColors.secondaryText)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
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
