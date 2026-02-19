import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: RitualViewModel
    @State private var showClearAlert = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Profile")
                        .font(.appTitle())
                        .foregroundColor(AppColors.textWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            ProfileStatCard(
                                title: "Total Rituals",
                                value: "\(viewModel.totalRituals)"
                            )
                            
                            ProfileStatCard(
                                title: "Days with Marked Rituals",
                                value: "\(viewModel.daysWithCompletions)"
                            )
                            
                            ProfileStatCard(
                                title: "Total Completions",
                                value: "\(viewModel.totalCompletions)"
                            )
                            
                            ProfileStatCard(
                                title: "Repeating Rituals",
                                value: "\(viewModel.repeatingRitualsCount)"
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        if !viewModel.mostFrequentRituals.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Your Top Rituals")
                                    .font(.appHeadline())
                                    .foregroundColor(AppColors.textWhite)
                                    .padding(.horizontal, 20)
                                
                                VStack(spacing: 12) {
                                    ForEach(Array(viewModel.mostFrequentRituals.enumerated()), id: \.element.id) { index, ritual in
                                        HStack(spacing: 12) {
                                            Text("\(index + 1)")
                                                .font(.appHeadline())
                                                .foregroundColor(AppColors.accentPurple)
                                                .frame(width: 30, height: 30)
                                                .background(AppColors.accentPurple.opacity(0.2))
                                                .clipShape(Circle())
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(ritual.title)
                                                    .font(.appBody())
                                                    .foregroundColor(AppColors.textWhite)
                                                
                                                Text("\(ritual.completionCount) completions")
                                                    .font(.appCaption())
                                                    .foregroundColor(AppColors.textSecondary)
                                            }
                                            
                                            Spacer()
                                        }
                                        .padding()
                                        .background(AppColors.cardBackground)
                                        .cornerRadius(12)
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Achievements")
                                .font(.appHeadline())
                                .foregroundColor(AppColors.textWhite)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                AchievementCard(
                                    icon: "star.fill",
                                    title: "First Ritual",
                                    description: viewModel.totalRituals > 0 ? "Completed" : "Add your first ritual",
                                    isCompleted: viewModel.totalRituals > 0
                                )
                                
                                AchievementCard(
                                    icon: "flame.fill",
                                    title: "Consistency",
                                    description: viewModel.daysWithCompletions >= 7 ? "Completed" : "Mark rituals for 7 days",
                                    isCompleted: viewModel.daysWithCompletions >= 7
                                )
                                
                                AchievementCard(
                                    icon: "trophy.fill",
                                    title: "Ritual Master",
                                    description: viewModel.totalCompletions >= 50 ? "Completed" : "Reach 50 total completions",
                                    isCompleted: viewModel.totalCompletions >= 50
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        Button(action: {
                            showClearAlert = true
                        }) {
                            Text("Clear All Rituals")
                                .font(.appButton())
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppColors.buttonBackground)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .alert("Clear All Rituals", isPresented: $showClearAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                viewModel.deleteAllRituals()
            }
        } message: {
            Text("Are you sure you want to delete all rituals? This action cannot be undone.")
        }
    }
}

struct ProfileStatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.appCaption())
                .foregroundColor(AppColors.textSecondary)
            
            Text(value)
                .font(.appTitle())
                .foregroundColor(AppColors.textWhite)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(12)
    }
}

struct AchievementCard: View {
    let icon: String
    let title: String
    let description: String
    let isCompleted: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(isCompleted ? AppColors.accentPurple : AppColors.textSecondary)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.appBody())
                    .foregroundColor(isCompleted ? AppColors.textWhite : AppColors.textSecondary)
                
                Text(description)
                    .font(.appCaption())
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            if isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.accentPurple)
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .opacity(isCompleted ? 1.0 : 0.6)
    }
}
