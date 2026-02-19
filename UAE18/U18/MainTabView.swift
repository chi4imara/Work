import SwiftUI

enum TabItem: String, CaseIterable {
    case workouts = "Workouts"
    case progress = "Progress"
    case exercises = "Exercises"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .workouts:
            return "list.clipboard"
        case .progress:
            return "chart.line.uptrend.xyaxis"
        case .exercises:
            return "figure.strengthtraining.traditional"
        case .settings:
            return "gearshape"
        }
    }
    
    var title: String {
        return self.rawValue
    }
}

struct MainTabView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var selectedTab: TabItem = .workouts
    
    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case .workouts:
                    WorkoutListView()
                case .progress:
                    ProgressView()
                case .exercises:
                    ExercisesView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 15)
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: isSelected ? 20 : 18, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.orange : AppColors.primaryText.opacity(0.6))
                
                Text(tab.title)
                    .font(.ubuntu(.medium, size: 10))
                    .foregroundColor(isSelected ? AppColors.orange : AppColors.primaryText.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? AppColors.orange.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MainTabView()
        .environmentObject(WorkoutManager())
}
