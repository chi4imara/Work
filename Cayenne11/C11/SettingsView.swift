import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var appState: AppStateViewModel
    @Environment(\.requestReview) var requestReview

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
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("Settings")
                                .font(.playfairDisplay(32, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("App preferences and information")
                                .font(.playfairDisplay(16, weight: .regular))
                                .foregroundColor(AppColors.secondaryText)
                        }
                        .padding(.top, 20)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)
                        ], spacing: 16) {
                            
                            SettingsCard(
                                icon: "envelope.fill",
                                title: "Contact Us",
                                subtitle: "Get in touch",
                                color: AppColors.lightBlue,
                                action: {
                                    openURL("https://www.privacypolicies.com/live/23e22afd-94cc-43ce-9c92-bd8d5fb542f1")
                                }
                            )
                            
                            SettingsCard(
                                icon: "star.fill",
                                title: "Rate App",
                                subtitle: "Leave a review",
                                color: AppColors.orange,
                                action: {
                                    requestReview()
                                }
                            )
                        }
                        .padding(.horizontal, 24)
                        
                        SettingsCard(
                            icon: "shield.fill",
                            title: "Privacy Policy",
                            subtitle: "Data protection",
                            color: AppColors.success,
                            action: {
                                openURL("https://www.privacypolicies.com/live/23e22afd-94cc-43ce-9c92-bd8d5fb542f1")
                            }
                        )
                        .padding(.horizontal, 24)
                        
                        VStack(spacing: 8) {
                            Text("Strength Tracker")
                                .font(.playfairDisplay(18, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                    .padding(.bottom, 120)
                }
            }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(color)
                }
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.playfairDisplay(16, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(.playfairDisplay(12, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppColors.border, lineWidth: 1)
                    )
            )
        }
    }
}

struct StatisticsView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    
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
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("Statistics")
                                .font(.playfairDisplay(32, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("Your workout insights")
                                .font(.playfairDisplay(16, weight: .regular))
                                .foregroundColor(AppColors.secondaryText)
                        }
                        .padding(.top, 20)
                        
                        if viewModel.records.isEmpty {
                            EmptyStateView(
                                icon: "chart.bar",
                                title: "No Statistics",
                                message: "Start recording workouts to see your statistics."
                            )
                        } else {
                            VStack(spacing: 20) {
                                StatCard(
                                    title: "Total Workouts",
                                    value: "\(viewModel.records.count)",
                                    icon: "dumbbell.fill",
                                    color: AppColors.lightBlue
                                )
                                
                                StatCard(
                                    title: "Total Exercises",
                                    value: "\(viewModel.getExerciseGroups().count)",
                                    icon: "list.bullet",
                                    color: AppColors.orange
                                )
                                
                                StatCard(
                                    title: "Average Weight",
                                    value: String(format: "%.1f kg", averageWeight),
                                    icon: "scalemass.fill",
                                    color: AppColors.success
                                )
                                
                                StatCard(
                                    title: "Total Reps",
                                    value: "\(totalReps)",
                                    icon: "arrow.clockwise",
                                    color: AppColors.warning
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 120)
                }
            }
    }
    
    private var averageWeight: Double {
        guard !viewModel.records.isEmpty else { return 0 }
        let totalWeight = viewModel.records.reduce(0) { $0 + $1.weight }
        return totalWeight / Double(viewModel.records.count)
    }
    
    private var totalReps: Int {
        return viewModel.records.reduce(0) { $0 + $1.repetitions }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.playfairDisplay(14, weight: .semibold))
                    .foregroundColor(AppColors.secondaryText)
                
                Text(value)
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.border, lineWidth: 1)
                )
        )
    }
}

#Preview {
    SettingsView(appState: AppStateViewModel())
}
