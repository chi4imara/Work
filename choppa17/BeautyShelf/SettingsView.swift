import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var showingAbout = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        Text("Settings")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(AppColors.primaryYellow.opacity(0.2))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "sparkles")
                                    .font(.system(size: 36, weight: .medium))
                                    .foregroundColor(AppColors.primaryYellow)
                            }
                            
                            VStack(spacing: 4) {
                                Text("BeautyShelf")
                                    .font(.ubuntu(20, weight: .bold))
                                    .foregroundColor(AppColors.primaryText)
                            }
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                    
                    VStack(spacing: 24) {
                        SettingsSection(title: "App") {
                            VStack(spacing: 0) {
                                SettingsRow(
                                    title: "Rate App",
                                    icon: "star.fill",
                                    action: {
                                        requestReview()
                                    }
                                )
                                
                                Divider()
                                    .background(AppColors.primaryText.opacity(0.1))
                                    .padding(.leading, 60)
                                
                                SettingsRow(
                                    title: "Contact Us",
                                    icon: "envelope.fill",
                                    action: {
                                        openURL("https://www.termsfeed.com/live/12cfa0dd-f22f-4b26-bde9-d1c82c2bb31d")
                                    }
                                )
                            }
                        }
                        
                        SettingsSection(title: "Data") {
                            VStack(spacing: 0) {
                                SettingsRow(
                                    title: "Export Data",
                                    icon: "square.and.arrow.up.fill",
                                    action: {
                                        exportData()
                                    }
                                )
                            }
                        }
                        
                        SettingsSection(title: "Legal") {
                            VStack(spacing: 0) {
                                SettingsRow(
                                    title: "Privacy Policy",
                                    icon: "hand.raised.fill",
                                    action: {
                                        openURL("https://www.termsfeed.com/live/12cfa0dd-f22f-4b26-bde9-d1c82c2bb31d")
                                    }
                                )
                                
                                Divider()
                                    .background(AppColors.primaryText.opacity(0.1))
                                    .padding(.leading, 60)
                                
                                SettingsRow(
                                    title: "Terms of Use",
                                    icon: "doc.text.fill",
                                    action: {
                                        openURL("https://www.termsfeed.com/live/49c2d409-9b00-44d4-b7bd-631ceb8db575")
                                    }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func exportData() {
        guard let jsonString = appViewModel.exportData() else {
            return
        }
        
        let activityVC = UIActivityViewController(
            activityItems: [jsonString],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true)
        }
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
                .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                content
            }
            .background(AppColors.cardBackground.opacity(0.9))
            .cornerRadius(16)
        }
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    var isDestructive: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(isDestructive ? AppColors.warningRed.opacity(0.2) : AppColors.primaryYellow.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color.black)
                }
                
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(isDestructive ? AppColors.warningRed : AppColors.darkText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.darkText.opacity(0.5))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(AppColors.primaryYellow.opacity(0.2))
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: "sparkles")
                                    .font(.system(size: 48, weight: .medium))
                                    .foregroundColor(AppColors.primaryYellow)
                            }
                            
                            VStack(spacing: 8) {
                                Text("BeautyShelf")
                                    .font(.ubuntu(28, weight: .bold))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Text("Organize your beauty space")
                                    .font(.ubuntu(16, weight: .regular))
                                    .foregroundColor(AppColors.secondaryText)
                            }
                        }
                        .padding(.top, 20)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("About BeautyShelf")
                                .font(.ubuntu(20, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("BeautyShelf helps you organize your entire makeup collection with ease. Create virtual storage places, track expiration dates, and always know where your favorite products are located.")
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(AppColors.primaryText)
                                .lineSpacing(4)
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Features")
                                .font(.ubuntu(20, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            VStack(spacing: 12) {
                                FeatureRow(
                                    icon: "archivebox.fill",
                                    title: "Storage Organization",
                                    description: "Create and manage virtual storage places"
                                )
                                
                                FeatureRow(
                                    icon: "calendar.badge.clock",
                                    title: "Expiration Tracking",
                                    description: "Never let your products expire again"
                                )
                                
                                FeatureRow(
                                    icon: "magnifyingglass",
                                    title: "Smart Search",
                                    description: "Find products by name, brand, or category"
                                )
                                
                                FeatureRow(
                                    icon: "chart.bar.fill",
                                    title: "Product Analytics",
                                    description: "Track your beauty collection insights"
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 8) {
                            Text("Built with ❤️ for beauty enthusiasts")
                                .font(.ubuntu(14, weight: .regular))
                                .foregroundColor(AppColors.secondaryText)
                        }
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryYellow.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.primaryYellow)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(description)
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppViewModel())
}
