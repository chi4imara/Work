import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        TabItem(icon: "folder", title: "Ideas", index: 0),
        TabItem(icon: "calendar", title: "Calendar", index: 1),
        TabItem(icon: "note.text", title: "Notes", index: 2),
        TabItem(icon: "chart.bar", title: "Statistics", index: 3),
        TabItem(icon: "gearshape", title: "Settings", index: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.index) { tab in
                TabBarButton(
                    icon: tab.icon,
                    title: tab.title,
                    isSelected: selectedTab == tab.index
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab.index
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.primaryWhite)
                .shadow(color: Color.theme.shadowColor, radius: 10, x: 0, y: -5)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
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
                Image(systemName: icon)
                    .font(.system(size: isSelected ? 20 : 18, weight: .medium))
                    .foregroundColor(isSelected ? Color.theme.primaryBlue : Color.theme.secondaryText)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(title)
                    .font(.playfairDisplay(10, weight: .medium))
                    .foregroundColor(isSelected ? Color.theme.primaryBlue : Color.theme.secondaryText)
                    .opacity(isSelected ? 1.0 : 0.7)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? Color.theme.lightBlue.opacity(0.3) : Color.clear)
                    .scaleEffect(isSelected ? 1.0 : 0.8)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct TabItem {
    let icon: String
    let title: String
    let index: Int
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(0))
    }
    .background(Color.theme.primaryGradient)
}
