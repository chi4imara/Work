import SwiftUI

struct AdaptiveSideBar: View {
    @Binding var selectedTab: TabItem
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var isExpanded = false
    let onToggleVisibility: (() -> Void)?
    
    init(selectedTab: Binding<TabItem>, onToggleVisibility: (() -> Void)? = nil) {
        self._selectedTab = selectedTab
        self.onToggleVisibility = onToggleVisibility
    }
    
    private var isCompact: Bool {
        horizontalSizeClass == .compact
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if isCompact {
                CompactSideBar(selectedTab: $selectedTab, onToggleVisibility: onToggleVisibility)
            } else {
                CustomSideBar(selectedTab: $selectedTab, onToggleVisibility: onToggleVisibility)
            }
        }
    }
    
    private var sidebarToggleButton: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            onToggleVisibility?()
        }) {
            ZStack {
                Circle()
                    .fill(Color.cardBackground)
                    .frame(width: 44, height: 44)
                    .shadow(color: .shadowColor, radius: 8, x: 0, y: 4)
                
                Image(systemName: "sidebar.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.primaryBlue)
            }
        }
    }
}

struct CompactSideBar: View {
    @Binding var selectedTab: TabItem
    @State private var isExpanded = false
    let onToggleVisibility: (() -> Void)?
    
    init(selectedTab: Binding<TabItem>, onToggleVisibility: (() -> Void)? = nil) {
        self._selectedTab = selectedTab
        self.onToggleVisibility = onToggleVisibility
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                VStack(spacing: 4) {
                    sidebarToggleButton
                        .padding(.bottom, 6)
                    
                    ForEach(TabItem.allCases, id: \.self) { tab in
                        CompactTabItem(
                            tab: tab,
                            isSelected: selectedTab == tab
                        ) {
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                            
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedTab = tab
                            }
                        }
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 16)
            }
            .frame(width: 70)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.cardBackground)
                    .shadow(color: .shadowColor, radius: 10, x: 0, y: 5)
            )
            .padding(.leading, 15)
            .padding(.vertical, 20)
            
            Spacer()
        }
    }
    private var sidebarToggleButton: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            onToggleVisibility?()
        }) {
            ZStack {
                Circle()
                    .fill(Color.cardBackground)
                    .frame(width: 44, height: 44)
                    .shadow(color: .shadowColor, radius: 8, x: 0, y: 4)
                
                Image(systemName: "sidebar.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.primaryBlue)
            }
        }
    }
}

struct CompactTabItem: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.primaryBlue : Color.clear)
                    .frame(width: 50, height: 50)
                    .scaleEffect(isSelected ? 1.0 : 0.9)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
                
                Image(systemName: tab.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isSelected ? .white : .textSecondary)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ZStack {
        BackgroundView()
        
        HStack {
            AdaptiveSideBar(
                selectedTab: .constant(.stories),
                onToggleVisibility: {
                    print("Toggle sidebar")
                }
            )
            
            Spacer()
        }
    }
}
