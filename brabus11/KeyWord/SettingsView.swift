import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            FloatingBubblesView()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 25) {
                        appSettingsSection
                        
                        actionsSection
                        
                        appInfoSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .alert("Delete All Words", isPresented: $viewModel.showingDeleteAllAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete All", role: .destructive) {
                viewModel.deleteAllWords()
            }
        } message: {
            Text("Are you sure you want to delete all words? This action cannot be undone.")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.playfairDisplay(32, weight: .bold))
                .foregroundColor(ColorManager.textBlue)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var appSettingsSection: some View {
        VStack(spacing: 0) {
            HStack {
                Text("App Settings")
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(ColorManager.textBlue)
                
                Spacer()
            }
            .padding(.bottom, 15)
            
            VStack(spacing: 0) {
                settingsRow(
                    title: "Open with Dictionary screen",
                    subtitle: "Start the app on the Dictionary tab",
                    isToggle: true,
                    toggleValue: $viewModel.settings.openWithDictionaryScreen
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.8))
                    .shadow(color: ColorManager.primaryBlue.opacity(0.05), radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private var actionsSection: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Actions")
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(ColorManager.textBlue)
                
                Spacer()
            }
            .padding(.bottom, 15)
            
            VStack(spacing: 0) {
                actionRow(
                    title: "Rate App",
                    subtitle: "Help us improve the app",
                    icon: "star.fill",
                    iconColor: ColorManager.primaryYellow,
                    action: {
                        viewModel.requestAppReview()
                    }
                )
                
                Divider()
                    .padding(.horizontal, 20)
                
                actionRow(
                    title: "Delete All Words",
                    subtitle: "Remove all saved entries",
                    icon: "trash.fill",
                    iconColor: ColorManager.accentOrange,
                    action: {
                        viewModel.confirmDeleteAll()
                    }
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.8))
                    .shadow(color: ColorManager.primaryBlue.opacity(0.05), radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 0) {
            HStack {
                Text("App Info")
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(ColorManager.textBlue)
                
                Spacer()
            }
            .padding(.bottom, 15)
            
            VStack(spacing: 0) {
                infoRow(
                    title: "Privacy Policy",
                    subtitle: "How we protect your data",
                    icon: "lock.shield.fill",
                    iconColor: ColorManager.accentPurple,
                    action: {
                        viewModel.openURL("https://doc-hosting.flycricket.io/innerphrases-privacy-policy/9220674f-e2c2-4790-92cd-c811defb9b62/privacy")
                    }
                )
                
                Divider()
                    .padding(.horizontal, 20)
                
                infoRow(
                    title: "Contact Us",
                    subtitle: "Get in touch with support",
                    icon: "envelope.fill",
                    iconColor: ColorManager.accentGreen,
                    action: {
                        viewModel.openURL("https://forms.gle/E9UEQbvpYehMdG6V7")
                    }
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.8))
                    .shadow(color: ColorManager.primaryBlue.opacity(0.05), radius: 8, x: 0, y: 4)
            )
        }
    }
    
    @ViewBuilder
    private func settingsRow(
        title: String,
        subtitle: String,
        isToggle: Bool = false,
        toggleValue: Binding<Bool>? = nil
    ) -> some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(ColorManager.textBlue)
                
                Text(subtitle)
                    .font(.playfairDisplay(13, weight: .regular))
                    .foregroundColor(ColorManager.darkGray.opacity(0.7))
            }
            
            Spacer()
            
            if isToggle, let toggleValue = toggleValue {
                Toggle("", isOn: toggleValue)
                    .tint(ColorManager.primaryBlue)
                    .onChange(of: toggleValue.wrappedValue) { _ in
                        viewModel.updateSettings()
                    }
            }
        }
        .padding(20)
    }
    
    @ViewBuilder
    private func actionRow(
        title: String,
        subtitle: String,
        icon: String,
        iconColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.playfairDisplay(16, weight: .semibold))
                        .foregroundColor(ColorManager.textBlue)
                    
                    Text(subtitle)
                        .font(.playfairDisplay(13, weight: .regular))
                        .foregroundColor(ColorManager.darkGray.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorManager.darkGray.opacity(0.5))
            }
            .padding(20)
        }
    }
    
    @ViewBuilder
    private func infoRow(
        title: String,
        subtitle: String,
        icon: String,
        iconColor: Color,
        action: (() -> Void)?
    ) -> some View {
        Group {
            if let action = action {
                Button(action: action) {
                    infoRowContent(title: title, subtitle: subtitle, icon: icon, iconColor: iconColor, hasAction: true)
                }
            } else {
                infoRowContent(title: title, subtitle: subtitle, icon: icon, iconColor: iconColor, hasAction: false)
            }
        }
    }
    
    @ViewBuilder
    private func infoRowContent(
        title: String,
        subtitle: String,
        icon: String,
        iconColor: Color,
        hasAction: Bool
    ) -> some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(ColorManager.textBlue)
                
                Text(subtitle)
                    .font(.playfairDisplay(13, weight: .regular))
                    .foregroundColor(ColorManager.darkGray.opacity(0.7))
            }
            
            Spacer()
            
            if hasAction {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorManager.darkGray.opacity(0.5))
            }
        }
        .padding(20)
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel())
}
