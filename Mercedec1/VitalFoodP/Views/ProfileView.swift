import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingEditProfile = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Circle()
                            .fill(ColorTheme.primaryYellow)
                            .frame(width: 100, height: 100)
                            .overlay(
                                Text(viewModel.userProfile.name.isEmpty ? "U" : String(viewModel.userProfile.name.prefix(1)).uppercased())
                                    .font(FontManager.ubuntu(36, weight: .bold))
                                    .foregroundColor(ColorTheme.buttonText)
                            )
                        
                        VStack(spacing: 4) {
                            Text(viewModel.userProfile.name.isEmpty ? "User" : viewModel.userProfile.name)
                                .font(FontManager.ubuntu(24, weight: .bold))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            if !viewModel.userProfile.email.isEmpty {
                                Text(viewModel.userProfile.email)
                                    .font(FontManager.ubuntu(16, weight: .regular))
                                    .foregroundColor(ColorTheme.secondaryText)
                            }
                        }
                        
                        Button(action: { showingEditProfile = true }) {
                            Text("Edit Profile")
                                .font(FontManager.ubuntu(14, weight: .medium))
                                .foregroundColor(ColorTheme.buttonText)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(ColorTheme.buttonBackground)
                                .cornerRadius(16)
                        }
                    }
                    .padding(.top, 20)
                    
                    ProfileSection(title: "Goals") {
                        if viewModel.userProfile.goals.isEmpty {
                            Text("No goals set")
                                .font(FontManager.ubuntu(16, weight: .regular))
                                .foregroundColor(ColorTheme.secondaryText)
                        } else {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(viewModel.userProfile.goals, id: \.self) { goal in
                                    Text(goal)
                                        .font(FontManager.ubuntu(12, weight: .medium))
                                        .foregroundColor(ColorTheme.buttonText)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .frame(maxWidth: .infinity)
                                        .background(ColorTheme.accentGreen)
                                        .cornerRadius(16)
                                }
                            }
                        }
                    }
                    
                    ProfileSection(title: "Diet Type") {
                        HStack {
                            Image(systemName: "leaf.fill")
                                .font(.system(size: 16))
                                .foregroundColor(ColorTheme.accentGreen)
                            
                            Text(viewModel.userProfile.dietType.displayName)
                                .font(FontManager.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            Spacer()
                        }
                    }
                    
                    ProfileSection(title: "Notifications") {
                        HStack {
                            Image(systemName: viewModel.userProfile.notifications ? "bell.fill" : "bell.slash.fill")
                                .font(.system(size: 16))
                                .foregroundColor(viewModel.userProfile.notifications ? ColorTheme.accentGreen : ColorTheme.accentOrange)
                            
                            Text(viewModel.userProfile.notifications ? "Enabled" : "Disabled")
                                .font(FontManager.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            Spacer()
                            
                            Toggle("", isOn: Binding(
                                get: { viewModel.userProfile.notifications },
                                set: { viewModel.updateNotifications($0) }
                            ))
                            .tint(ColorTheme.primaryYellow)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(viewModel: viewModel)
        }
    }
}

struct ProfileSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(FontManager.ubuntu(20, weight: .medium))
                .foregroundColor(ColorTheme.primaryText)
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.cardBorder, lineWidth: 1)
        )
    }
}

struct StatRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(title)
                .font(FontManager.ubuntu(16, weight: .regular))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            Text(value)
                .font(FontManager.ubuntu(16, weight: .bold))
                .foregroundColor(ColorTheme.accentText)
        }
    }
}

#Preview {
    ProfileView()
}
