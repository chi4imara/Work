import SwiftUI
import Combine

class SideBarStateManager: ObservableObject {
    @Published var selectedTab: TabItem = .stories
    @Published var isExpanded: Bool = true
    @Published var isVisible: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupAutoCollapse()
    }
    
    private func setupAutoCollapse() {
        Timer.publish(every: 3.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                if UIDevice.current.userInterfaceIdiom == .phone {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self?.isExpanded = false
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func selectTab(_ tab: TabItem) {
        withAnimation(.easeInOut(duration: 0.3)) {
            selectedTab = tab
        }
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    func toggleExpansion() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isExpanded.toggle()
        }
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    func hideSideBar() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isVisible = false
        }
    }
    
    func showSideBar() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isVisible = true
        }
    }
}
