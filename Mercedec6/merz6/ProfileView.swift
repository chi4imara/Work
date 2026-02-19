import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var newAllergy = ""
    @State private var newPreference = ""
    
    var body: some View {
        ZStack {
            AppGradients.primaryBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    headerSection
                    
                    profileInfoSection
                    
                    allergiesSection
                    
                    preferencesSection
                    
                    settingsSection
                    
                    saveButton
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.top, AppSpacing.sm)
                .padding(.bottom, 120)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: AppSpacing.sm) {
            ZStack {
                Circle()
                    .fill(AppColors.cardBackground)
                    .frame(width: 100, height: 100)
                    .overlay(
                        Circle()
                            .stroke(AppColors.cardBorder, lineWidth: 2)
                    )
                
                Image(systemName: "person.fill")
                    .font(.system(size: 40))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Text("Profile")
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.primaryText)
        }
    }
    
    private var profileInfoSection: some View {
        VStack(spacing: AppSpacing.md) {
            profileInfoRow(title: "Name", value: $viewModel.userProfile.name, placeholder: "Enter your name")
            profileInfoRow(title: "Email", value: $viewModel.userProfile.email, placeholder: "Enter your email")
            
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Daily Calorie Goal")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                
                HStack {
                    TextField("2000", value: $viewModel.userProfile.dailyCalorieGoal, format: .number)
                        .keyboardType(.numberPad)
                        .textFieldStyle(CustomTextFieldStyle())
                    
                    Text("cal")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.large)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.large)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var allergiesSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Allergies")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
            
            HStack {
                TextField("Add allergy", text: $newAllergy)
                    .textFieldStyle(CustomTextFieldStyle())
                
                Button("Add") {
                    viewModel.addAllergy(newAllergy)
                    newAllergy = ""
                }
                .disabled(newAllergy.isEmpty)
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: AppRadius.medium)
                        .fill(newAllergy.isEmpty ? AppColors.cardBackground : AppColors.accentYellow)
                )
            }
            
            if !viewModel.userProfile.allergies.isEmpty {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppSpacing.sm) {
                    ForEach(viewModel.userProfile.allergies, id: \.self) { allergy in
                        allergyTag(allergy) {
                            viewModel.removeAllergy(allergy)
                        }
                    }
                }
            } else {
                Text("No allergies added")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, AppSpacing.md)
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.large)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.large)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Dietary Preferences")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
            
            HStack {
                TextField("Add preference", text: $newPreference)
                    .textFieldStyle(CustomTextFieldStyle())
                
                Button("Add") {
                    viewModel.addPreference(newPreference)
                    newPreference = ""
                }
                .disabled(newPreference.isEmpty)
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: AppRadius.medium)
                        .fill(newPreference.isEmpty ? AppColors.cardBackground : AppColors.accentYellow)
                )
            }
            
            if !viewModel.userProfile.preferences.isEmpty {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppSpacing.sm) {
                    ForEach(viewModel.userProfile.preferences, id: \.self) { preference in
                        preferenceTag(preference) {
                            viewModel.removePreference(preference)
                        }
                    }
                }
            } else {
                Text("No preferences added")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, AppSpacing.md)
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.large)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.large)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Notification Settings")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
            
            Toggle("Enable Notifications", isOn: $viewModel.userProfile.notificationsEnabled)
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryText)
                .toggleStyle(SwitchToggleStyle(tint: AppColors.accentYellow))
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.large)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.large)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var saveButton: some View {
        VStack(spacing: AppSpacing.sm) {
            Button(action: {
                viewModel.saveProfile()
            }) {
                Text("Save Profile")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: AppRadius.medium)
                            .fill(AppColors.accentYellow)
                    )
            }
            
            if viewModel.showSaveSuccess {
                Text("Profile saved successfully!")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.success)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: viewModel.showSaveSuccess)
    }
    
    private func profileInfoRow(title: String, value: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(title)
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
            
            TextField(placeholder, text: value)
                .textFieldStyle(CustomTextFieldStyle())
        }
    }
    
    private func allergyTag(_ allergy: String, onRemove: @escaping () -> Void) -> some View {
        HStack {
            Text(allergy)
                .font(AppFonts.caption)
                .foregroundColor(AppColors.primaryText)
                .lineLimit(1)
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
                    .foregroundColor(AppColors.error)
            }
        }
        .padding(.horizontal, AppSpacing.sm)
        .padding(.vertical, AppSpacing.xs)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.small)
                .fill(AppColors.error.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.small)
                        .stroke(AppColors.error.opacity(0.5), lineWidth: 1)
                )
        )
    }
    
    private func preferenceTag(_ preference: String, onRemove: @escaping () -> Void) -> some View {
        HStack {
            Text(preference)
                .font(AppFonts.caption)
                .foregroundColor(AppColors.primaryText)
                .lineLimit(1)
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
                    .foregroundColor(AppColors.success)
            }
        }
        .padding(.horizontal, AppSpacing.sm)
        .padding(.vertical, AppSpacing.xs)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.small)
                .fill(AppColors.success.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.small)
                        .stroke(AppColors.success.opacity(0.5), lineWidth: 1)
                )
        )
    }
}

#Preview {
    ProfileView()
}
