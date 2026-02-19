import SwiftUI

struct EditProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Name")
                                .font(FontManager.ubuntu(18, weight: .medium))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            TextField("Enter your name", text: Binding(
                                get: { viewModel.userProfile.name },
                                set: { viewModel.updateName($0) }
                            ))
                            .font(FontManager.ubuntu(16, weight: .regular))
                            .foregroundColor(ColorTheme.primaryText)
                            .padding(16)
                            .background(ColorTheme.cardBackground)
                            .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Email")
                                .font(FontManager.ubuntu(18, weight: .medium))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            TextField("Enter your email", text: Binding(
                                get: { viewModel.userProfile.email },
                                set: { viewModel.updateEmail($0) }
                            ))
                            .font(FontManager.ubuntu(16, weight: .regular))
                            .foregroundColor(ColorTheme.primaryText)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding(16)
                            .background(ColorTheme.cardBackground)
                            .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Goals")
                                .font(FontManager.ubuntu(18, weight: .medium))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(viewModel.availableGoals, id: \.self) { goal in
                                    GoalToggleButton(
                                        goal: goal,
                                        isSelected: viewModel.userProfile.goals.contains(goal),
                                        action: { viewModel.toggleGoal(goal) }
                                    )
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Diet Type")
                                .font(FontManager.ubuntu(18, weight: .medium))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(DietType.allCases, id: \.self) { dietType in
                                    DietTypeButton(
                                        dietType: dietType,
                                        isSelected: viewModel.userProfile.dietType == dietType,
                                        action: { viewModel.updateDietType(dietType) }
                                    )
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.accentText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.saveProfile()
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.accentText)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct GoalToggleButton: View {
    let goal: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(goal)
                .font(FontManager.ubuntu(12, weight: .medium))
                .foregroundColor(isSelected ? ColorTheme.buttonText : ColorTheme.primaryText)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(isSelected ? ColorTheme.accentGreen : ColorTheme.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(ColorTheme.accentGreen, lineWidth: isSelected ? 0 : 1)
                )
        }
    }
}

struct DietTypeButton: View {
    let dietType: DietType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(dietType.displayName)
                .font(FontManager.ubuntu(12, weight: .medium))
                .foregroundColor(isSelected ? ColorTheme.buttonText : ColorTheme.primaryText)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(isSelected ? ColorTheme.primaryYellow : ColorTheme.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(ColorTheme.primaryYellow, lineWidth: isSelected ? 0 : 1)
                )
        }
    }
}

#Preview {
    EditProfileView(viewModel: ProfileViewModel())
}
