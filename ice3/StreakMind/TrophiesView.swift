import SwiftUI

struct TrophiesView: View {
    @ObservedObject var habitStore: HabitStore
    @State private var showingDeleteAlert = false
    @State private var habitToDelete: Habit?
    
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            if habitStore.trophyHabits.isEmpty {
                emptyStateView
            } else {
                mainContentView
            }
        }
        .navigationBarHidden(true)
        .alert("Remove from Trophies", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                if let habit = habitToDelete {
                    habitStore.removeFromTrophies(habit.id)
                }
            }
        } message: {
            Text("This will remove the habit from trophies but keep the habit itself.")
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.accentYellow)
            
            Text("No Trophies Yet")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(AppColors.textWhite)
            
            Text("You don't have any achievements yet. Keep going — your first trophies will appear here")
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(AppColors.textWhite.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                withAnimation {
                    selectedTab = 0
                }
            }) {
                Text("Go to Streaks")
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(AppColors.primaryPurple)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(AppColors.accentYellow)
                    .cornerRadius(25)
            }
            .padding(.horizontal, 40)
        }
    }
    
    private var mainContentView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 10) {
                Text("Trophies")
                    .font(.ubuntu(32, weight: .bold))
                    .foregroundColor(AppColors.textWhite)
                
                Text("Your greatest achievements")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.textWhite.opacity(0.8))
            }
            .padding(.top, 60)
            .padding(.bottom, 30)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(habitStore.trophyHabits) { habit in
                        trophyCardView(habit: habit)
                    }
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
        }
    }
    
    private func trophyCardView(habit: Habit) -> some View {
        VStack(spacing: 20) {
            VStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(AppColors.accentYellow)
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(AppColors.primaryPurple)
                }
                
                Image(systemName: habit.category.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(habit.category.color)
            }
            
            VStack(spacing: 8) {
                Text(habit.name)
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.textWhite)
                    .multilineTextAlignment(.center)
                
                Text("\(habit.maxStreak) days")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.accentYellow)
                
                Text("Max streak")
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(AppColors.textWhite.opacity(0.7))
            }
            
            VStack(spacing: 5) {
                Text(achievementTitle(for: habit.maxStreak))
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(AppColors.accentYellow)
                
                Text(achievementSubtitle(for: habit.maxStreak))
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(AppColors.textWhite.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
            
            if habit.currentStreak > 0 {
                VStack(spacing: 2) {
                    Text("Current: \(habit.currentStreak) days")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.textWhite.opacity(0.8))
                    
                    if habit.currentStreak == habit.maxStreak {
                        Text("New record!")
                            .font(.ubuntu(12, weight: .bold))
                            .foregroundColor(AppColors.successGreen)
                    }
                }
            }
        }
        .frame(width: 250)
        .frame(maxHeight: .infinity)
        .padding(25)
        .background(AppColors.cardGradient)
        .cornerRadius(25)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(AppColors.accentYellow.opacity(0.3), lineWidth: 2)
        )
        .shadow(color: AppColors.accentYellow.opacity(0.2), radius: 10, x: 0, y: 5)
        .onLongPressGesture {
            habitToDelete = habit
            showingDeleteAlert = true
        }
    }
    
    private func achievementTitle(for streak: Int) -> String {
        switch streak {
        case 7..<14:
            return "First Week!"
        case 14..<30:
            return "Two Weeks Strong!"
        case 30..<60:
            return "Monthly Champion!"
        case 60..<100:
            return "Two Month Hero!"
        case 100..<365:
            return "Century Club!"
        case 365...:
            return "Year Master!"
        default:
            return "Achievement!"
        }
    }
    
    private func achievementSubtitle(for streak: Int) -> String {
        switch streak {
        case 7..<14:
            return "You've made it through your first week"
        case 14..<30:
            return "Two weeks of dedication"
        case 30..<60:
            return "A full month of success"
        case 60..<100:
            return "Two months of commitment"
        case 100..<365:
            return "100 days of excellence"
        case 365...:
            return "A full year of achievement"
        default:
            return "Keep up the great work"
        }
    }
}

