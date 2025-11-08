import SwiftUI

struct MainContainerView: View {
    @StateObject private var storiesViewModel = StoriesViewModel()
    @StateObject private var statisticsViewModel: StatisticsViewModel
    @State private var selectedTab: TabItem = .stories
    @State private var sidebarExpanded = true
    @State private var sidebarVisible = false
    
    init() {
        let storiesVM = StoriesViewModel()
        self._storiesViewModel = StateObject(wrappedValue: storiesVM)
        self._statisticsViewModel = StateObject(wrappedValue: StatisticsViewModel(storiesViewModel: storiesVM))
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            mainContentView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(alignment: .topLeading) {
                    if !sidebarVisible {
                        sidebarToggleButton
                            .padding(.horizontal, 20)
                            .padding(.vertical, 15)
                    }
                }
            
            HStack {
                if sidebarVisible {
                    AdaptiveSideBar(
                        selectedTab: $selectedTab,
                        onToggleVisibility: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0)) {
                                sidebarVisible = false
                            }
                        }
                    )
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.3, anchor: .topLeading)
                            .combined(with: .opacity)
                            .combined(with: .move(edge: .leading)),
                        removal: .scale(scale: 0.3, anchor: .topLeading)
                            .combined(with: .opacity)
                            .combined(with: .move(edge: .leading))
                    ))
                }
                
                Spacer()
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0), value: sidebarVisible)
    }
    
    @ViewBuilder
    private var mainContentView: some View {
        Group {
            switch selectedTab {
            case .stories:
                StoriesListView(
                    viewModel: storiesViewModel,
                    sidebarToggleButton: sidebarToggleButton
                )
                .id("stories")
                
            case .tags:
                TagsView(
                    viewModel: storiesViewModel,
                    sidebarToggleButton: sidebarToggleButton
                )
                .id("tags")
                
            case .statistics:
                StatisticsView(
                    statisticsViewModel: statisticsViewModel,
                    storiesViewModel: storiesViewModel,
                    sidebarToggleButton: sidebarToggleButton
                )
                .id("statistics")
                
            case .settings:
                SettingsView(sidebarToggleButton: sidebarToggleButton)
                    .id("settings")
            }
        }
        .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        ))
        
        .animation(.easeInOut(duration: 0.3), value: selectedTab)
    }
    
    private var sidebarToggleButton: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0)) {
                sidebarVisible = true
            }
        }) {
            ZStack {
                Circle()
                    .fill(Color.cardBackground)
                    .frame(width: 44, height: 44)
                    .shadow(color: .shadowColor, radius: 8, x: 0, y: 4)
                
                Image(systemName: "sidebar.right")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.primaryBlue)
            }
        }
    }
}

#Preview {
    MainContainerView()
}
