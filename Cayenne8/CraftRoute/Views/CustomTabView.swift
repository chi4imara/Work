import SwiftUI

struct CustomTabView: View {
    @ObservedObject var appViewModel: AppViewModel
    @StateObject private var projectsViewModel = ProjectsViewModel()
    
    private let tabs = [
        TabItem(title: "Projects", icon: "folder.fill", tag: 0),
        TabItem(title: "Tools", icon: "hammer.fill", tag: 1),
        TabItem(title: "Materials", icon: "cube.box.fill", tag: 2),
        TabItem(title: "Analytics", icon: "chart.bar.fill", tag: 3),
        TabItem(title: "Settings", icon: "gearshape.fill", tag: 4)
    ]
    
    var body: some View {
        ZStack {
            ColorManager.primaryGradient
                .ignoresSafeArea()
            
            Group {
                switch appViewModel.selectedTab {
                case 0:
                    ProjectsView(viewModel: projectsViewModel)
                case 1:
                    ToolsView(viewModel: projectsViewModel)
                case 2:
                    MaterialsView(viewModel: projectsViewModel)
                case 3:
                    AnalyticsView(viewModel: projectsViewModel)
                case 4:
                    SettingsView()
                default:
                    ProjectsView(viewModel: projectsViewModel)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(
                    selectedTab: $appViewModel.selectedTab,
                    tabs: tabs
                )
            }
        }
    }
}

struct TabItem {
    let title: String
    let icon: String
    let tag: Int
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    let tabs: [TabItem]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.tag) { tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = tab.tag
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(selectedTab == tab.tag ? ColorManager.accentOrange : ColorManager.secondaryText)
                            .scaleEffect(selectedTab == tab.tag ? 1.1 : 1.0)
                        
                        Text(tab.title)
                            .font(.ubuntu(10, weight: .medium))
                            .foregroundColor(selectedTab == tab.tag ? ColorManager.accentOrange : ColorManager.tertiaryText)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedTab == tab.tag ? ColorManager.cardBackground : Color.clear)
                            .animation(.easeInOut(duration: 0.3), value: selectedTab)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(ColorManager.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(ColorManager.separatorColor, lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 15)
    }
}

#Preview {
    CustomTabView(appViewModel: AppViewModel())
}
