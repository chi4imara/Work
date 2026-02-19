import SwiftUI

struct EditProfileView: View {
    @Binding var user: User
    @Environment(\.dismiss) private var dismiss
    
    @State private var tempUser: User
    @State private var newAllergy = ""
    @State private var showingAllergyAlert = false
    
    init(user: Binding<User>) {
        self._user = user
        self._tempUser = State(initialValue: user.wrappedValue)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                GridPattern()
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        basicInfoSection
                        
                        goalsSection
                        
                        dietaryPreferencesSection
                        
                        allergiesSection
                        
                        notificationSettingsSection
                        
                        Button(action: {
                            user = tempUser
                            dismiss()
                        }) {
                            Text("Save")
                                .font(AppFonts.button(18))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                                        .fill(AppColors.primaryYellow)
                                )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(AppColors.textPrimary)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    user = tempUser
                    dismiss()
                }
                .foregroundColor(AppColors.primaryYellow)
            }
        }
        .alert("Add Allergy", isPresented: $showingAllergyAlert) {
            TextField("Allergy name", text: $newAllergy)
            Button("Add") {
                if !newAllergy.isEmpty {
                    tempUser.allergies.append(newAllergy)
                    newAllergy = ""
                }
            }
            Button("Cancel", role: .cancel) {
                newAllergy = ""
            }
        }
    }
    
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Basic Information")
                .font(AppFonts.subtitle(18))
                .foregroundColor(AppColors.textPrimary)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name")
                        .font(AppFonts.body(14))
                        .foregroundColor(AppColors.textSecondary)
                    
                    TextField("Enter your name", text: $tempUser.name)
                        .font(AppFonts.body(16))
                        .foregroundColor(AppColors.textPrimary)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AppColors.cardBackground.opacity(0.7))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AppColors.cardBorder.opacity(0.7), lineWidth: 1)
                                )
                        )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(AppFonts.body(14))
                        .foregroundColor(AppColors.textSecondary)
                    
                    TextField("Enter your email", text: $tempUser.email)
                        .font(AppFonts.body(16))
                        .foregroundColor(AppColors.textPrimary)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AppColors.cardBackground.opacity(0.7))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AppColors.cardBorder.opacity(0.7), lineWidth: 1)
                                )
                        )
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
    
    private var goalsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Nutrition Goals")
                .font(AppFonts.subtitle(18))
                .foregroundColor(AppColors.textPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(User.NutritionGoal.allCases, id: \.self) { goal in
                    Button(action: {
                        if tempUser.goals.contains(goal) {
                            tempUser.goals.removeAll { $0 == goal }
                        } else {
                            tempUser.goals.append(goal)
                        }
                    }) {
                        HStack {
                            Image(systemName: iconForGoal(goal))
                                .font(.system(size: 14))
                                .foregroundColor(tempUser.goals.contains(goal) ? .black : AppColors.textPrimary)
                            
                            Text(goal.rawValue)
                                .font(AppFonts.body(14))
                                .foregroundColor(tempUser.goals.contains(goal) ? .black : AppColors.textPrimary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(tempUser.goals.contains(goal) ? AppColors.primaryYellow : AppColors.cardBackground.opacity(0.7))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(tempUser.goals.contains(goal) ? AppColors.primaryYellow : AppColors.cardBorder.opacity(0.7), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
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
            Text("Dietary Preferences")
                .font(AppFonts.subtitle(18))
                .foregroundColor(AppColors.textPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(User.DietaryPreference.allCases, id: \.self) { preference in
                    Button(action: {
                        if tempUser.dietaryPreferences.contains(preference) {
                            tempUser.dietaryPreferences.removeAll { $0 == preference }
                        } else {
                            tempUser.dietaryPreferences.append(preference)
                        }
                    }) {
                        HStack {
                            Image(systemName: iconForPreference(preference))
                                .font(.system(size: 14))
                                .foregroundColor(tempUser.dietaryPreferences.contains(preference) ? .black : AppColors.textPrimary)
                            
                            Text(preference.rawValue)
                                .font(AppFonts.body(14))
                                .foregroundColor(tempUser.dietaryPreferences.contains(preference) ? .black : AppColors.textPrimary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(tempUser.dietaryPreferences.contains(preference) ? AppColors.secondaryGreen : AppColors.cardBackground.opacity(0.7))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(tempUser.dietaryPreferences.contains(preference) ? AppColors.secondaryGreen : AppColors.cardBorder.opacity(0.7), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
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
                
                Button("Add") {
                    showingAllergyAlert = true
                }
                .font(AppFonts.caption(14))
                .foregroundColor(AppColors.primaryYellow)
            }
            
            if tempUser.allergies.isEmpty {
                Text("No allergies added")
                    .font(AppFonts.body(16))
                    .foregroundColor(AppColors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 8) {
                    ForEach(Array(tempUser.allergies.enumerated()), id: \.offset) { index, allergy in
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(AppColors.secondaryPink)
                            
                            Text(allergy)
                                .font(AppFonts.body(16))
                                .foregroundColor(AppColors.textPrimary)
                            
                            Spacer()
                            
                            Button(action: {
                                tempUser.allergies.remove(at: index)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(AppColors.secondaryPink)
                            }
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AppColors.cardBackground.opacity(0.5))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AppColors.cardBorder.opacity(0.5), lineWidth: 1)
                                )
                        )
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
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("New Recipes")
                            .font(AppFonts.body(16))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("Get notified about new recipe recommendations")
                            .font(AppFonts.caption(14))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $tempUser.notificationSettings.newRecipes)
                        .tint(AppColors.primaryYellow)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Meal Reminders")
                            .font(AppFonts.body(16))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("Reminders for planned meals")
                            .font(AppFonts.caption(14))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $tempUser.notificationSettings.mealReminders)
                        .tint(AppColors.primaryYellow)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Nutrition Tips")
                            .font(AppFonts.body(16))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("Weekly nutrition tips and advice")
                            .font(AppFonts.caption(14))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $tempUser.notificationSettings.nutritionTips)
                        .tint(AppColors.primaryYellow)
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
    EditProfileView(user: .constant(User(
        name: "John Doe",
        email: "john@example.com",
        goals: [.healthyEating],
        allergies: [],
        favoriteIngredients: [],
        dietaryPreferences: [],
        notificationSettings: NotificationSettings()
    )))
}
