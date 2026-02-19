import SwiftUI

struct TodayView: View {
    @ObservedObject var practiceViewModel: PracticeViewModel
    @State private var showingAddPractice = false
    @State private var completedPracticeId: UUID?
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour >= 18 || hour < 6 {
            return "Good Evening"
        } else if hour >= 12 {
            return "Good Afternoon"
        } else {
            return "Evening Rest"
        }
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    headerSection
                    
                    todaysPracticesSection
                    
                    progressSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 120)
            }
        }
        .sheet(isPresented: $showingAddPractice) {
            AddPracticeView(practiceViewModel: practiceViewModel)
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(greeting)
                        .font(.appTitle)
                        .foregroundColor(AppColors.primaryNavy)
                    
                    Text("Choose a practice for relaxation")
                        .font(.bodyText)
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Button(action: { showingAddPractice = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(AppColors.primaryOrange)
                }
            }
        }
    }
    
    private var todaysPracticesSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Today's Practices")
                .font(.screenTitle)
                .foregroundColor(AppColors.primaryNavy)
            
            let todaysPractices = practiceViewModel.getTodaysPractices()
            
            if todaysPractices.isEmpty {
                EmptyStateView(
                    title: "No practices for today",
                    subtitle: "Add your first practice and start evening recovery",
                    buttonTitle: "Add Practice",
                    action: { showingAddPractice = true }
                )
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(todaysPractices) { practice in
                        PracticeCardView(
                            practice: practice,
                            isCompleted: completedPracticeId == practice.id,
                            onComplete: {
                                practiceViewModel.completePractice(practice)
                                withAnimation(.spring()) {
                                    completedPracticeId = practice.id
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    completedPracticeId = nil
                                }
                            },
                            onToggleFavorite: {
                                practiceViewModel.toggleFavorite(practice)
                            }
                        )
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Progress")
                .font(.screenTitle)
                .foregroundColor(AppColors.primaryNavy)
            
            VStack(spacing: 12) {
                ProgressCardView(
                    title: "Current Streak",
                    value: "\(practiceViewModel.streakData.currentStreak)",
                    subtitle: "days in a row",
                    icon: "flame.fill",
                    color: AppColors.primaryOrange
                )
                
                ProgressCardView(
                    title: "Total Days",
                    value: "\(practiceViewModel.streakData.totalDays)",
                    subtitle: "days practiced",
                    icon: "calendar",
                    color: AppColors.lightBlue
                )
                
                let todaysCompleted = practiceViewModel.getTodaysCompletedPractices()
                ProgressCardView(
                    title: "Today",
                    value: "\(todaysCompleted.count)",
                    subtitle: "practices completed",
                    icon: "checkmark.circle.fill",
                    color: AppColors.softGreen
                )
            }
        }
    }
}

struct PracticeCardView: View {
    let practice: Practice
    let isCompleted: Bool
    let onComplete: () -> Void
    let onToggleFavorite: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: practice.type.icon)
                .font(.system(size: 24))
                .foregroundColor(AppColors.primaryOrange)
                .frame(width: 40, height: 40)
                .background(AppColors.primaryOrange.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(practice.name)
                    .font(.cardTitle)
                    .foregroundColor(AppColors.primaryNavy)
                
                HStack {
                    Text(practice.type.rawValue)
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(1)
                    
                    Text("•")
                        .font(.caption)
                        .foregroundColor(AppColors.mediumGray)
                    
                    Text("\(practice.duration) min")
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            Spacer()
            
            HStack(spacing: 10) {
                Button(action: onToggleFavorite) {
                    Image(systemName: practice.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 18))
                        .foregroundColor(practice.isFavorite ? AppColors.primaryOrange : AppColors.mediumGray)
                }
                
                Button(action: onComplete) {
                    if isCompleted {
                        HStack(spacing: 5) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .bold))
                            Text("Done")
                                .font(.smallCaption)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 13)
                        .padding(.vertical, 6)
                        .background(AppColors.softGreen)
                        .cornerRadius(15)
                    } else {
                        Text("I Did It")
                            .font(.smallCaption)
                            .foregroundColor(AppColors.primaryOrange)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(AppColors.primaryOrange.opacity(0.1))
                            .cornerRadius(15)
                    }
                }
                .disabled(isCompleted)
            }
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.primaryNavy.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct ProgressCardView: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
                
                HStack(alignment: .bottom, spacing: 4) {
                    Text(value)
                        .font(.playfairBold(size: 24))
                        .foregroundColor(AppColors.primaryNavy)
                    
                    Text(subtitle)
                        .font(.smallCaption)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.primaryNavy.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct EmptyStateView: View {
    let title: String
    let subtitle: String
    let buttonTitle: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "moon.stars")
                .font(.system(size: 60))
                .foregroundColor(AppColors.mediumGray)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.cardTitle)
                    .foregroundColor(AppColors.primaryNavy)
                
                Text(subtitle)
                    .font(.bodyText)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: action) {
                Text(buttonTitle)
                    .font(.buttonText)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(AppColors.primaryOrange)
                    .cornerRadius(20)
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.primaryNavy.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView(practiceViewModel: PracticeViewModel())
    }
}
