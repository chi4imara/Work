import SwiftUI

struct ProfileView: View {
    @ObservedObject var userViewModel: UserViewModel
    @State private var showingEditProfile = false
    @State private var showingResetAlert = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridPattern()
                .opacity(0.2)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    profileHeaderView
                    
                    goalsSection
                    
                    dietaryPreferencesSection
                    
                    allergiesSection
                    
                    notificationSettingsSection
                    
                    actionButtonsSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 180)
            }
        }
        .sheet(isPresented: $showingEditProfile, onDismiss: {
            userViewModel.persistUser()
        }) {
            EditProfileView(user: $userViewModel.user)
        }
        .alert("Reset Data", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                userViewModel.updateUser(User(
                    name: "",
                    email: "",
                    goals: [],
                    allergies: [],
                    favoriteIngredients: [],
                    dietaryPreferences: [],
                    notificationSettings: NotificationSettings()
                ))
            }
        } message: {
            Text("Are you sure you want to reset all profile data? This action cannot be undone.")
        }
    }
    
    private var profileHeaderView: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(AppColors.secondaryOrange.opacity(0.3))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "person.circle")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                VStack(spacing: 4) {
                    Text(userViewModel.user.name)
                        .font(AppFonts.title(24))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(userViewModel.user.email)
                        .font(AppFonts.body(16))
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            
            HStack(spacing: 0) {
                profileStatItem(
                    title: "Goals",
                    value: "\(userViewModel.user.goals.count)",
                    color: AppColors.primaryYellow
                )
                
                Divider()
                    .frame(height: 40)
                    .background(AppColors.cardBorder)
                
                profileStatItem(
                    title: "Preferences",
                    value: "\(userViewModel.user.dietaryPreferences.count)",
                    color: AppColors.secondaryGreen
                )
                
                Divider()
                    .frame(height: 40)
                    .background(AppColors.cardBorder)
                
                profileStatItem(
                    title: "Allergies",
                    value: "\(userViewModel.user.allergies.count)",
                    color: AppColors.secondaryPink
                )
            }
            .padding(.vertical, 16)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var goalsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Nutrition Goals")
                    .font(AppFonts.subtitle(18))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Button("Edit") {
                    showingEditProfile = true
                }
                .font(AppFonts.caption(14))
                .foregroundColor(AppColors.primaryYellow)
            }
            
            if userViewModel.user.goals.isEmpty {
                emptyStateView(
                    icon: "target",
                    title: "No goals set",
                    description: "Add nutrition goals to get personalized recommendations"
                )
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(userViewModel.user.goals, id: \.self) { goal in
                        goalChip(goal: goal)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var dietaryPreferencesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Dietary Preferences")
                    .font(AppFonts.subtitle(18))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Button("Edit") {
                    showingEditProfile = true
                }
                .font(AppFonts.caption(14))
                .foregroundColor(AppColors.primaryYellow)
            }
            
            if userViewModel.user.dietaryPreferences.isEmpty {
                emptyStateView(
                    icon: "leaf",
                    title: "No preferences set",
                    description: "Add dietary preferences to filter recipes"
                )
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(userViewModel.user.dietaryPreferences, id: \.self) { preference in
                        preferenceChip(preference: preference)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var allergiesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Allergies & Restrictions")
                    .font(AppFonts.subtitle(18))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Button("Edit") {
                    showingEditProfile = true
                }
                .font(AppFonts.caption(14))
                .foregroundColor(AppColors.primaryYellow)
            }
            
            if userViewModel.user.allergies.isEmpty {
                emptyStateView(
                    icon: "exclamationmark.triangle",
                    title: "No allergies listed",
                    description: "Add allergies to avoid harmful ingredients"
                )
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(userViewModel.user.allergies, id: \.self) { allergy in
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(AppColors.secondaryPink)
                            
                            Text(allergy)
                                .font(AppFonts.body(16))
                                .foregroundColor(AppColors.textPrimary)
                            
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var notificationSettingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Notification Settings")
                .font(AppFonts.subtitle(18))
                .foregroundColor(AppColors.textPrimary)
            
            VStack(spacing: 16) {
                notificationToggle(
                    title: "New Recipes",
                    description: "Get notified about new recipe recommendations",
                    isOn: .constant(userViewModel.user.notificationSettings.newRecipes)
                )
                
                notificationToggle(
                    title: "Meal Reminders",
                    description: "Reminders for planned meals",
                    isOn: .constant(userViewModel.user.notificationSettings.mealReminders)
                )
                
                notificationToggle(
                    title: "Nutrition Tips",
                    description: "Weekly nutrition tips and advice",
                    isOn: .constant(userViewModel.user.notificationSettings.nutritionTips)
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: 12) {
            Button {
                showingEditProfile = true
            } label: {
                Text("Edit Profile")
                    .font(AppFonts.button(16))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                            .fill(AppColors.primaryYellow)
                    )
            }
            
            HStack(spacing: 12) {
                Button {
                    exportUserData()
                } label: {
                    Text("Export Data")
                        .font(AppFonts.button(14))
                        .foregroundColor(AppColors.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                                .fill(AppColors.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                                        .stroke(AppColors.cardBorder, lineWidth: 1)
                                )
                        )
                }
                
                Button {
                    showingResetAlert = true
                } label: {
                    Text("Reset Data")
                        .font(AppFonts.button(14))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                                .fill(AppColors.secondaryPink)
                        )
                }
            }
        }
    }
    
    private func exportUserData() {
        let u = userViewModel.user
        var lines: [String] = [
            "CookHer - Profile Export",
            "Exported: \(Date().formatted())",
            "",
            "--- Profile ---",
            "Name: \(u.name)",
            "Email: \(u.email)",
            "",
            "--- Nutrition Goals ---"
        ]
        if u.goals.isEmpty {
            lines.append("None set")
        } else {
            lines.append(contentsOf: u.goals.map { "  - \($0.rawValue)" })
        }
        lines.append(contentsOf: ["", "--- Dietary Preferences ---"])
        if u.dietaryPreferences.isEmpty {
            lines.append("None set")
        } else {
            lines.append(contentsOf: u.dietaryPreferences.map { "  - \($0.rawValue)" })
        }
        lines.append(contentsOf: ["", "--- Allergies ---"])
        if u.allergies.isEmpty {
            lines.append("None set")
        } else {
            lines.append(contentsOf: u.allergies.map { "  - \($0)" })
        }
        lines.append(contentsOf: ["", "--- Notifications ---"])
        lines.append("New recipes: \(u.notificationSettings.newRecipes ? "On" : "Off")")
        lines.append("Meal reminders: \(u.notificationSettings.mealReminders ? "On" : "Off")")
        lines.append("Nutrition tips: \(u.notificationSettings.nutritionTips ? "On" : "Off")")
        
        let text = lines.joined(separator: "\n")
        ShareHelper.presentShareSheet(items: [text])
    }
    
    private func profileStatItem(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(value)
                .font(AppFonts.subtitle(18))
                .foregroundColor(AppColors.textPrimary)
            
            Text(title)
                .font(AppFonts.caption(12))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func goalChip(goal: User.NutritionGoal) -> some View {
        HStack {
            Image(systemName: iconForGoal(goal))
                .font(.system(size: 14))
                .foregroundColor(AppColors.primaryYellow)
            
            Text(goal.rawValue)
                .font(AppFonts.body(14))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground.opacity(0.7))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.cardBorder.opacity(0.7), lineWidth: 1)
                )
        )
    }
    
    private func preferenceChip(preference: User.DietaryPreference) -> some View {
        HStack {
            Image(systemName: iconForPreference(preference))
                .font(.system(size: 14))
                .foregroundColor(AppColors.secondaryGreen)
            
            Text(preference.rawValue)
                .font(AppFonts.body(14))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground.opacity(0.7))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.cardBorder.opacity(0.7), lineWidth: 1)
                )
        )
    }
    
    private func emptyStateView(icon: String, title: String, description: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(AppColors.textSecondary)
            
            Text(title)
                .font(AppFonts.subtitle(16))
                .foregroundColor(AppColors.textPrimary)
            
            Text(description)
                .font(AppFonts.caption(14))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
    
    private func notificationToggle(title: String, description: String, isOn: Binding<Bool>) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppFonts.body(16))
                    .foregroundColor(AppColors.textPrimary)
                
                Text(description)
                    .font(AppFonts.caption(14))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Toggle("", isOn: isOn)
                .tint(AppColors.primaryYellow)
        }
    }
    
    private func iconForGoal(_ goal: User.NutritionGoal) -> String {
        switch goal {
        case .weightLoss:
            return "arrow.down.circle"
        case .healthyEating:
            return "heart.circle"
        case .muscleGain:
            return "arrow.up.circle"
        case .maintenance:
            return "equal.circle"
        }
    }
    
    private func iconForPreference(_ preference: User.DietaryPreference) -> String {
        switch preference {
        case .vegetarian, .vegan:
            return "leaf"
        case .glutenFree:
            return "minus.circle"
        case .lowCarb, .keto:
            return "flame"
        case .paleo:
            return "figure.walk"
        }
    }
}

#Preview {
    ProfileView(userViewModel: UserViewModel())
}
