import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabType
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabType.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = tab
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(AppColors.primaryAccent.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 4)
        )
        .padding(.horizontal, 16)
    }
}

struct TabBarButton: View {
    let tab: TabType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Image(systemName: tab.iconName)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.primaryAccent : AppColors.primaryText.opacity(0.5))
                
                Text(tab.rawValue)
                    .font(.ubuntu(9, weight: isSelected ? .medium : .light))
                    .foregroundColor(isSelected ? AppColors.primaryText : AppColors.primaryText.opacity(0.5))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .contentShape(Rectangle())
        }
        .buttonStyle(TabBarButtonStyle())
    }
}

struct TabBarButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview {
    ZStack {
        BackgroundView()
        
        VStack {
            Spacer()
            CustomTabBar(selectedTab: .constant(.today))
        }
    }
}
