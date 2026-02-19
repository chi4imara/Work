import SwiftUI

struct HomeView: View {
    @ObservedObject var appViewModel: AppViewModel
    @StateObject private var viewModel: HomeViewModel
    @State private var showingFilters = false
    
    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
        self._viewModel = StateObject(wrappedValue: HomeViewModel(appViewModel: appViewModel))
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                HStack {
                    Text("Today's Activities")
                        .font(.playfair(32, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Button(action: { appViewModel.showAddActivitySheet = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.playfair(24, weight: .semibold))
                                .foregroundColor(ColorTheme.primaryBlue)
                        }
                        
                        Button(action: { showingFilters.toggle() }) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.playfair(24, weight: .semibold))
                                .foregroundColor(ColorTheme.primaryBlue)
                        }
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 20) {
                        headerSection
                        filtersSection
                        activitiesGrid
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showingFilters) {
            FiltersView(filters: $viewModel.selectedFilters) {
                viewModel.updateRecommendations()
            }
        }
        .onChange(of: appViewModel.activities.count) { _ in
            viewModel.updateRecommendations()
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Choose leisure activities based on your mood and time")
                .font(.playfair(16))
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private var filtersSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ActivityType.allCases, id: \.self) { type in
                    FilterChip(
                        title: type.rawValue,
                        icon: type.icon,
                        isSelected: viewModel.selectedFilters.activityTypes.contains(type)
                    ) {
                        if viewModel.selectedFilters.activityTypes.contains(type) {
                            viewModel.selectedFilters.activityTypes.remove(type)
                        } else {
                            viewModel.selectedFilters.activityTypes.insert(type)
                        }
                        viewModel.updateRecommendations()
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.horizontal, -16)
    }
    
    private var activitiesGrid: some View {
        Group {
            if viewModel.recommendedActivities.isEmpty {
                emptyStateView
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(viewModel.recommendedActivities) { activity in
                        ActivityCard(activity: activity) {
                            viewModel.scheduleActivity(activity)
                        }
                    }
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        Group {
            if appViewModel.activities.isEmpty {
                HStack {
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 50))
                            .foregroundColor(ColorTheme.secondaryText)
                        
                        Text("You have no activities yet")
                            .font(.playfair(18, weight: .medium))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Text("Add your first activity to get started")
                            .font(.playfair(14))
                            .foregroundColor(ColorTheme.secondaryText)
                            .multilineTextAlignment(.center)
                        
                        Button {
                            appViewModel.showAddActivitySheet = true
                        } label: {
                            Text("Add Activity")
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(ColorTheme.buttonGradient)
                                .foregroundColor(ColorTheme.primaryText)
                                .font(.playfair(16, weight: .medium))
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    
                    Spacer()
                }
            } else {
                HStack {
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(ColorTheme.secondaryText)
                        
                        Text("No suitable activities found")
                            .font(.playfair(18, weight: .medium))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Button {
                            viewModel.resetFilters()
                        } label: {
                            Text("Reset Filters")
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(ColorTheme.buttonGradient)
                                .foregroundColor(ColorTheme.primaryText)
                                .font(.playfair(16, weight: .medium))
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        
                        Text("Try a short walk to relieve fatigue")
                            .font(.playfair(14))
                            .foregroundColor(ColorTheme.secondaryText)
                            .italic()
                        
                        Button("Add New Activity") {
                            appViewModel.showAddActivitySheet = true
                        }
                        .font(.playfair(14))
                        .foregroundColor(ColorTheme.primaryBlue)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    
                    Spacer()
                }
            }
        }
    }
    
    private var refreshButton: some View {
        Button(action: viewModel.updateRecommendations) {
            HStack {
                Image(systemName: "arrow.clockwise")
                Text("Update Selection")
            }
            .font(.playfair(16, weight: .medium))
            .foregroundColor(ColorTheme.primaryText)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(ColorTheme.buttonGradient)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .shadow(color: ColorTheme.primaryYellow.opacity(0.3), radius: 8, x: 0, y: 4)
        }
    }
}

struct ActivityCard: View {
    let activity: Activity
    let onSchedule: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: activity.type.icon)
                    .font(.system(size: 24))
                    .foregroundColor(ColorTheme.primaryBlue)
                
                Spacer()
                
                Text("\(activity.duration) min")
                    .font(.playfair(12))
                    .foregroundColor(ColorTheme.secondaryText)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(ColorTheme.lightBlue.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(activity.name)
                    .font(.playfair(16, weight: .semibold))
                    .foregroundColor(ColorTheme.primaryText)
                    .lineLimit(2)
                
                Text(activity.type.rawValue)
                    .font(.playfair(12))
                    .foregroundColor(ColorTheme.secondaryText)
                
                Text(activity.description)
                    .font(.playfair(12))
                    .foregroundColor(ColorTheme.secondaryText)
                    .lineLimit(3)
            }
            
            Spacer()
            
            Button(action: onSchedule) {
                Text("Schedule")
                    .font(.playfair(14, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(ColorTheme.buttonGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .padding(16)
        .frame(height: 200)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 6, x: 0, y: 3)
        )
    }
}

struct FilterChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                Text(title)
                    .font(.playfair(14))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(
                isSelected ? ColorTheme.primaryBlue : ColorTheme.backgroundWhite
            )
            .foregroundColor(
                isSelected ? ColorTheme.lightText : ColorTheme.primaryText
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(ColorTheme.primaryBlue.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

struct FiltersView: View {
    @Binding var filters: ActivityFilters
    let onApply: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        activityTypesSection
                        goalsSection
                        durationSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        filters = ActivityFilters()
                        onApply()
                    }
                    .foregroundColor(ColorTheme.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        onApply()
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.primaryBlue)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private var activityTypesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Activity Types")
                .font(.playfair(18, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(ActivityType.allCases, id: \.self) { type in
                    FilterChip(
                        title: type.rawValue,
                        icon: type.icon,
                        isSelected: filters.activityTypes.contains(type)
                    ) {
                        if filters.activityTypes.contains(type) {
                            filters.activityTypes.remove(type)
                        } else {
                            filters.activityTypes.insert(type)
                        }
                    }
                }
            }
        }
    }
    
    private var goalsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Goals")
                .font(.playfair(18, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(ActivityGoal.allCases, id: \.self) { goal in
                    FilterChip(
                        title: goal.rawValue,
                        icon: "target",
                        isSelected: filters.goals.contains(goal)
                    ) {
                        if filters.goals.contains(goal) {
                            filters.goals.remove(goal)
                        } else {
                            filters.goals.insert(goal)
                        }
                    }
                }
            }
        }
    }
    
    private var durationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Maximum Duration")
                .font(.playfair(18, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 8) {
                Slider(
                    value: Binding(
                        get: { Double(filters.maxDuration) },
                        set: { filters.maxDuration = Int($0) }
                    ),
                    in: 0...180,
                    step: 15
                )
                .accentColor(ColorTheme.primaryBlue)
                
                HStack {
                    Text("Any duration")
                        .font(.playfair(12))
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    Spacer()
                    
                    Text(filters.maxDuration == 0 ? "No limit" : "\(filters.maxDuration) min")
                        .font(.playfair(12))
                        .foregroundColor(ColorTheme.primaryText)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorTheme.cardGradient)
            )
        }
    }
}

#Preview {
    HomeView(appViewModel: AppViewModel())
}
