import SwiftUI

struct CustomSideBar: View {
    @Binding var selectedTab: TabItem
    @State private var isExpanded = false
    let onToggleVisibility: (() -> Void)?
    
    init(selectedTab: Binding<TabItem>, onToggleVisibility: (() -> Void)? = nil) {
        self._selectedTab = selectedTab
        self.onToggleVisibility = onToggleVisibility
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            VStack(spacing: 8) {
                ForEach(Array(TabItem.allCases.enumerated()), id: \.element) { index, tab in
                    SideBarTabItem(
                        tab: tab,
                        isSelected: selectedTab == tab,
                        isExpanded: isExpanded,
                        index: index
                    ) {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                        
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = tab
                        }
                    }
                }
            }
            .padding(.horizontal, isExpanded ? 16 : 8)
            .padding(.vertical, 20)
            
            Spacer()
            
            expandButton
        }
        .frame(width: isExpanded ? 200 : 80)
        .background(
            RoundedRectangle(cornerRadius: isExpanded ? 20 : 40)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.cardBackground,
                            Color.cardBackground.opacity(0.95)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .shadowColor, radius: 15, x: 0, y: 8)
                .overlay(
                    RoundedRectangle(cornerRadius: isExpanded ? 20 : 40)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.primaryBlue.opacity(0.3),
                                    Color.lightBlue.opacity(0.1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .padding(.leading, 20)
        .padding(.vertical, 20)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isExpanded = true
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            HStack {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.primaryBlue, Color.lightBlue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: isExpanded ? 50 : 40, height: isExpanded ? 50 : 40)
                    
                    Image(systemName: "book.fill")
                        .font(.system(size: isExpanded ? 24 : 20, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                if isExpanded {
                    Button(action: {
                        onToggleVisibility?()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.textSecondary)
                            .frame(width: 28, height: 28)
                            .background(Color.backgroundGray)
                            .clipShape(Circle())
                    }
                    .transition(.opacity.combined(with: .scale))
                }
            }
            
            if isExpanded {
                Text("MyMoments")
                    .font(.nunitoBold(size: 16))
                    .foregroundColor(.textPrimary)
                    .transition(.opacity.combined(with: .scale))
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 10)
        .padding(.horizontal, 16)
    }
    
    private var expandButton: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            
            withAnimation(.easeInOut(duration: 0.3)) {
                isExpanded.toggle()
            }
        }) {
            Image(systemName: isExpanded ? "chevron.left" : "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.textSecondary)
                .frame(width: 32, height: 32)
                .background(Color.backgroundGray)
                .clipShape(Circle())
        }
        .padding(.bottom, 20)
    }
}

struct SideBarTabItem: View {
    let tab: TabItem
    let isSelected: Bool
    let isExpanded: Bool
    let index: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color.primaryBlue : Color.clear)
                        .frame(width: 44, height: 44)
                        .scaleEffect(isSelected ? 1.0 : 0.9)
                        .animation(.easeInOut(duration: 0.2), value: isSelected)
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? .white : .textSecondary)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: isSelected)
                }
                
                if isExpanded {
                    Text(tab.title)
                        .font(.nunitoMedium(size: 16))
                        .foregroundColor(isSelected ? .textPrimary : .textSecondary)
                        .transition(.opacity.combined(with: .move(edge: .leading)))
                        .animation(.easeInOut(duration: 0.3).delay(Double(index) * 0.05), value: isExpanded)
                }
                
                Spacer()
            }
            .padding(.horizontal, isExpanded ? 12 : 0)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.primaryBlue.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

enum TabItem: CaseIterable {
    case stories
    case tags
    case statistics
    case settings
    
    var title: String {
        switch self {
        case .stories: return "Stories"
        case .tags: return "Tags"
        case .statistics: return "Statistics"
        case .settings: return "Settings"
        }
    }
    
    var icon: String {
        switch self {
        case .stories: return "book.fill"
        case .tags: return "tag.fill"
        case .statistics: return "chart.bar.fill"
        case .settings: return "gear.circle.fill"
        }
    }
}

#Preview {
    ZStack {
        BackgroundView()
        
        HStack {
            CustomSideBar(selectedTab: .constant(.stories))
            
            Spacer()
        }
    }
}
