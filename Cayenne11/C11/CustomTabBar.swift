import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: AppTab
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = tab
                        }
                    }
                )
            }
        }
        .frame(height: 80)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(AppColors.border, lineWidth: 1)
                )
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 15)
    }
}

struct TabBarButton: View {
    let tab: AppTab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(AppColors.lightBlue)
                            .frame(width: 32, height: 32)
                            .transition(.scale.combined(with: .opacity))
                    }
                    
                    Image(systemName: tab.iconName)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isSelected ? AppColors.primaryText : AppColors.secondaryText)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                .animation(.easeInOut(duration: 0.3), value: isSelected)
                
                Text(tab.title)
                    .font(.playfairDisplay(10, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.lightBlue : AppColors.secondaryText)
                    .animation(.easeInOut(duration: 0.3), value: isSelected)
            }
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
}

struct MainTabView: View {
    @StateObject private var workoutViewModel = WorkoutViewModel()
    @StateObject private var appState = AppStateViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    AppColors.deepBlue,
                    AppColors.darkBlue
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            Group {
                switch appState.selectedTab {
                case .newRecord:
                    NewRecordView(viewModel: workoutViewModel)
                case .history:
                    HistoryView(viewModel: workoutViewModel)
                case .exercises:
                    ExercisesView(viewModel: workoutViewModel)
                case .statistics:
                    StatisticsView(viewModel: workoutViewModel)
                case .settings:
                    SettingsView(appState: appState)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $appState.selectedTab)
            }
        }
        .sheet(isPresented: $workoutViewModel.isShowingRecordSaved) {
            if let savedRecord = workoutViewModel.savedRecord {
                RecordSavedView(record: savedRecord, viewModel: workoutViewModel)
            }
        }
    }
}

#Preview {
    MainTabView()
}
