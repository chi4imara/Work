import SwiftUI
import StoreKit

struct ProfileView: View {
    @EnvironmentObject var viewModel: ExerciseViewModel
    @State private var showingResetAlert = false
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Profile")
                    .font(.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                
                ScrollView {
                    VStack(spacing: 24) {
                        StatisticsSection(viewModel: viewModel)
                        
                        ActionsSection(
                            showingResetAlert: $showingResetAlert,
                            requestReview: { requestReview() }
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100) 
                }
            }
        }
        .alert("Reset All Data", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.resetAllData()
            }
        } message: {
            Text("Are you sure you want to delete all data? This action cannot be undone.")
        }
    }
}

struct StatisticsSection: View {
    @ObservedObject var viewModel: ExerciseViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Statistics")
                .font(.playfairDisplay(size: 20, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ProfileStatCard(
                    title: "Total Exercises",
                    value: "\(viewModel.totalExercises)",
                    icon: "dumbbell",
                    color: AppColors.lightBlue
                )
                
                ProfileStatCard(
                    title: "Total Records",
                    value: "\(viewModel.totalRecords)",
                    icon: "chart.bar.fill",
                    color: AppColors.orange
                )
            }
            
            ProfileStatCard(
                title: "Most Frequent Training Day",
                value: viewModel.mostFrequentTrainingDay,
                icon: "calendar",
                color: AppColors.purple,
                isWide: true
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
        )
    }
}

struct ProfileStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    var isWide: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(color.opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.playfairDisplay(size: 12, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
                
                Text(value)
                    .font(.playfairDisplay(size: 16, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
            }
            
            if !isWide {
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.secondaryBackground.opacity(0.5))
        )
    }
}

struct ActionsSection: View {
    @Binding var showingResetAlert: Bool
    let requestReview: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Actions")
                .font(.playfairDisplay(size: 20, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                ActionButton(
                    title: "Rate App",
                    icon: "star.fill",
                    color: AppColors.orange,
                    action: requestReview
                )
                
                ActionButton(
                    title: "Privacy Policy",
                    icon: "shield.fill",
                    color: AppColors.green,
                    action: {
                        if let url = URL(string: "https://google.com") {
                            UIApplication.shared.open(url)
                        }
                    }
                )
                
                ActionButton(
                    title: "Contact Us",
                    icon: "envelope.fill",
                    color: AppColors.lightBlue,
                    action: {
                        if let url = URL(string: "https://google.com") {
                            UIApplication.shared.open(url)
                        }
                    }
                )
                
                ActionButton(
                    title: "Reset All Data",
                    icon: "trash.fill",
                    color: AppColors.dangerButton,
                    action: {
                        showingResetAlert = true
                    }
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
        )
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.secondaryBackground.opacity(0.5))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ProfileView()
        .environmentObject(ExerciseViewModel())
}
