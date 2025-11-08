import SwiftUI

enum SideBarTab: String, CaseIterable {
    case plants = "plants"
    case addPlant = "add_plant"
    case guide = "guide"
    case history = "history"
    case settings = "settings"
    
    var title: String {
        switch self {
        case .plants:
            return "My Plants"
        case .guide:
            return "Guide"
        case .history:
            return "History"
        case .settings:
            return "Settings"
        case .addPlant:
            return "Add Plant"
        }
    }
    
    var iconName: String {
        switch self {
        case .plants:
            return "leaf.fill"
        case .guide:
            return "book.fill"
        case .history:
            return "clock.fill"
        case .settings:
            return "gearshape.fill"
        case .addPlant:
            return "plus.circle.fill"
        }
    }
}

struct SideBarView: View {
    @Binding var selectedTab: SideBarTab
    @Binding var showingSidebar: Bool
    @ObservedObject var appViewModel: AppViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    Image(systemName: "leaf.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(AppTheme.primaryYellow)
                    
                    Text("NutriyaPlan")
                        .font(.screenTitle)
                        .foregroundColor(AppTheme.primaryWhite)
                }
                .padding(.top, 60)
                .padding(.bottom, 20)
                
                VStack(spacing: 8) {
                    ForEach(SideBarTab.allCases, id: \.self) { tab in
                        SideBarItemView(
                            tab: tab,
                            isSelected: selectedTab == tab,
                            action: {
                                selectedTab = tab
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showingSidebar = false
                                }
                            }
                        )
                        
                        if tab != .settings {
                            Divider()
                                .overlay {
                                    Color.white
                                }
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                        .overlay {
                            Color.white
                        }
                        .padding(.leading, -20)
                        .frame(maxWidth: .infinity)
                    
                    Text("Plants: \(appViewModel.plants.count)")
                        .font(.appCaption)
                        .foregroundColor(AppTheme.primaryWhite.opacity(0.7))
                    
                    Text("Total Fertilizations: \(appViewModel.getTotalFertilizations())")
                        .font(.appCaption)
                        .foregroundColor(AppTheme.primaryWhite.opacity(0.7))
                }
                .padding(.bottom, 40)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            }
            .frame(width: 280)
            .background(
                LinearGradient(
                    colors: [
                        AppTheme.darkBlue.opacity(0.95),
                        AppTheme.primaryBlue.opacity(0.9)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                GridBackgroundView()
                    .opacity(0.1)
            )
            
            if showingSidebar {
                Color.black.opacity(0.01)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                showingSidebar = false
            }
        }
    }
}

struct SideBarItemView: View {
    let tab: SideBarTab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: tab.iconName)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? AppTheme.darkBlue : AppTheme.primaryWhite)
                    .frame(width: 24)
                
                Text(tab.title)
                    .font(.buttonMedium)
                    .foregroundColor(isSelected ? AppTheme.darkBlue : AppTheme.primaryWhite)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppTheme.primaryYellow : Color.clear)
                    .shadow(color: isSelected ? AppTheme.shadowColor : Color.clear, radius: 5, x: 0, y: 2)
            )
            .padding(.horizontal, 16)
        }
    }
}

struct MainAppView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var selectedTab: SideBarTab = .plants
    @State private var showingSidebar = false
    @State private var selectedPlant: Plant?
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .plants:
                    PlantsListView(
                        appViewModel: appViewModel,
                        onPlantTap: { plant in
                            selectedPlant = plant
                        },
                        onMenuTap: { showingSidebar = true },
                        showingSidebar: $showingSidebar
                    )
                case .addPlant:
                    QuickAddPlantView(appViewModel: appViewModel, plant: nil, showingSidebar: $showingSidebar) {
                        selectedTab = .plants
                    }
                case .guide:
                    FertilizerGuideView(appViewModel: appViewModel, showingSidebar: $showingSidebar)
                case .history:
                    HistoryView(appViewModel: appViewModel, showingSidebar: $showingSidebar)
                case .settings:
                    SettingsView(appViewModel: appViewModel, showingSidebar: $showingSidebar)
                }
            }
            .disabled(showingSidebar)
            
            if showingSidebar {
                SideBarView(
                    selectedTab: $selectedTab,
                    showingSidebar: $showingSidebar,
                    appViewModel: appViewModel
                )
                .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading).combined(with: .opacity)))
                .zIndex(1)
            }
        }
        .sheet(item: $selectedPlant) { plant in
            PlantDetailsView(
                appViewModel: appViewModel,
                plantId: plant.id,
                onBack: {
                    selectedPlant = nil
                }
            )
        }
        .animation(.easeInOut(duration: 0.3), value: showingSidebar)
    }
}


#Preview {
    MainAppView()
}
