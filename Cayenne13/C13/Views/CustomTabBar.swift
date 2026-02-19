import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    let tabs = [
        TabItem(icon: "plus.circle", title: "Add", tag: 0),
        TabItem(icon: "list.bullet.clipboard", title: "Collection", tag: 1),
        TabItem(icon: "chart.bar", title: "Wearing", tag: 2),
        TabItem(icon: "chart.bar.yaxis", title: "Statistics", tag: 3),
        TabItem(icon: "gearshape", title: "Settings", tag: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.tag) { tab in
                TabBarButton(
                    icon: tab.icon,
                    title: tab.title,
                    isSelected: selectedTab == tab.tag
                ) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = tab.tag
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 80)
        .background(
            ZStack {
                ColorManager.cardGradient
                
                Rectangle()
                    .fill(ColorManager.lightBlue.opacity(0.3))
                    .frame(height: 1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        )
        .cornerRadius(25, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -5)
        .padding(.horizontal, 20)
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: isSelected && icon != "chart.bar.yaxis" ? icon + ".fill" : icon)
                    .font(.system(size: isSelected ? 24 : 20, weight: .medium))
                    .foregroundColor(isSelected ? ColorManager.lightBlue : ColorManager.secondaryText)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(title)
                    .font(.playfairDisplay(size: 10, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? ColorManager.lightBlue : ColorManager.secondaryText)
            }
            .frame(maxWidth: .infinity)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TabItem {
    let icon: String
    let title: String
    let tag: Int
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
    CustomTabBar(selectedTab: .constant(0))
}
