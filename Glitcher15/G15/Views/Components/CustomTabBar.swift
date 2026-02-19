import SwiftUI

enum TabItem: Int, CaseIterable {
    case items = 0
    case categories = 1
    case add = 2
    case statistics = 3
    case settings = 4
    
    
    var title: String {
        switch self {
        case .items: return "Items"
        case .categories: return "Categories"
        case .add: return ""
        case .settings: return "Settings"
        case .statistics: return "Statistics"
        }
    }
    
    var icon: String {
        switch self {
        case .items: return "list.bullet"
        case .categories: return "folder"
        case .add: return "plus"
        case .settings: return "gearshape"
        case .statistics: return "chart.bar"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.rawValue) { tab in
                TabBarButton(
                    tab: tab,
                    selectedTab: $selectedTab,
                    isSelected: selectedTab == tab
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(AppColors.yellow.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabBarButton: View {
    let tab: TabItem
    @Binding var selectedTab: TabItem
    let isSelected: Bool
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab
            }
        }) {
            VStack(spacing: 4) {
                ZStack {
                    if tab == .add {
                        Circle()
                            .fill(AppColors.accentGradient)
                            .frame(width: 50, height: 50)
                            .scaleEffect(isPressed ? 0.9 : 1.0)
                            .shadow(color: AppColors.yellow.opacity(0.3), radius: 8, x: 0, y: 4)
                        
                        Image(systemName: tab.icon)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                    } else {
                        if isSelected {
                            Circle()
                                .fill(AppColors.yellow.opacity(0.2))
                                .frame(width: 40, height: 40)
                        }
                        
                        Image(systemName: tab.icon)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(isSelected ? AppColors.yellow : AppColors.secondaryText)
                            .scaleEffect(isPressed ? 0.9 : 1.0)
                    }
                }
                
                if tab != .add {
                    Text(tab.title)
                        .font(FontManager.playfairMedium(size: 10))
                        .foregroundColor(isSelected ? AppColors.yellow : AppColors.secondaryText)
                        .opacity(isSelected ? 1.0 : 0.7)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
}

#Preview {
    ZStack {
        AppColors.primaryGradient
            .ignoresSafeArea()
        
        VStack {
            Spacer()
            CustomTabBar(selectedTab: .constant(.items))
        }
    }
}
