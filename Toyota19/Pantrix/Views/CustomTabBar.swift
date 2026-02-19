import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: AppState.Tab
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppState.Tab.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .frame(height: 80)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.appDarkBlue.opacity(0.9))
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: -5)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabBarButton: View {
    let tab: AppState.Tab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(Color.appOrange)
                            .frame(width: 40, height: 40)
                            .transition(.scale.combined(with: .opacity))
                    }
                    
                    Image(systemName: tab.systemImage)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? .appWhite : .appWhite.opacity(0.6))
                }
                
                Text(tab.rawValue)
                    .font(.appCaption2)
                    .foregroundColor(isSelected ? .appOrange : .appWhite.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.today))
    }
    .background(AppColors.backgroundGradient)
}