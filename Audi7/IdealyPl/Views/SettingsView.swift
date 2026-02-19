import SwiftUI

struct SettingsView: View {
    @ObservedObject var ideasViewModel: IdeasViewModel
    @ObservedObject var settingsViewModel: SettingsViewModel
    @State private var showingClearAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Settings")
                    .font(.ubuntu(32, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            
            ScrollView {
                VStack(spacing: 20) {
                    SettingsSection(title: "App") {
                        SettingsRow(
                            icon: "star.fill",
                            title: "Rate App",
                            action: {
                                settingsViewModel.requestAppReview()
                            }
                        )
                        
                        SettingsRow(
                            icon: "trash.fill",
                            title: "Clear all ideas",
                            isDestructive: true,
                            action: {
                                showingClearAlert = true
                            }
                        )
                    }
                    
                    SettingsSection(title: "Support") {
                        SettingsRow(
                            icon: "envelope.fill",
                            title: "Contact us",
                            action: {
                                settingsViewModel.openContactEmail()
                            }
                        )
                        
                        SettingsRow(
                            icon: "shield.fill",
                            title: "Privacy Policy",
                            action: {
                                settingsViewModel.openPrivacyPolicy()
                            }
                        )
                    }
                    
                    SettingsSection(title: "Statistics") {
                        VStack(spacing: 16) {
                            StatRow(title: "Total Ideas", value: "\(ideasViewModel.ideas.count)")
                            StatRow(title: "Total Characters", value: "\(totalCharacters)")
                            StatRow(title: "Average Length", value: "\(averageLength) chars")
                        }
                        .padding(16)
                        .background(AppColors.cardBackground)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.primaryText.opacity(0.1), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
                .padding(.bottom, 120)
            }
        }
        .alert("Clear All Ideas", isPresented: $showingClearAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear All", role: .destructive) {
                ideasViewModel.clearAllIdeas()
            }
        } message: {
            Text("Are you sure you want to delete all your ideas? This action cannot be undone.")
        }
    }
    
    private var totalCharacters: Int {
        ideasViewModel.ideas.reduce(0) { $0 + $1.text.count }
    }
    
    private var averageLength: Int {
        guard !ideasViewModel.ideas.isEmpty else { return 0 }
        return totalCharacters / ideasViewModel.ideas.count
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 4)
            
            content
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let isDestructive: Bool
    let action: () -> Void
    
    init(icon: String, title: String, isDestructive: Bool = false, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.isDestructive = isDestructive
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(isDestructive ? .red : AppColors.accentYellow)
                    .frame(width: 24)
                
                Text(title)
                    .font(.ubuntu(16))
                    .foregroundColor(isDestructive ? .red : AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.primaryText.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.ubuntu(14))
                .foregroundColor(AppColors.secondaryText)
            
            Spacer()
            
            Text(value)
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(AppColors.accentYellow)
        }
    }
}
