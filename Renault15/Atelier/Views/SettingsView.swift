import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject var viewModel: HairstyleViewModel
    @State private var showSampleDataAlert = false
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(AppFonts.title)
                        .foregroundColor(AppColors.primaryWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 0) {
                        headerSection
                        
                        VStack(spacing: 24) {
                            privacySection
                            
                            supportSection
                            
                            appSection
                        }
                        .padding(.horizontal, AppDimensions.screenPadding)
                        .padding(.top, 30)
                    }
                    .padding(.bottom, 30)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.primaryYellow)
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "scissors")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.darkBlue)
                )
            
            VStack(spacing: 4) {
                Text("My Hairstyle")
                    .font(AppFonts.title)
                    .foregroundColor(AppColors.primaryWhite)
            }
        }
        .padding(.top, 20)
    }
    
    private var testingSection: some View {
        SettingsSection(title: "Testing") {
            SettingsRow(
                icon: "doc.badge.plus",
                title: "Load Sample Data",
                subtitle: "Add sample hairstyles and looks for testing"
            ) {
                viewModel.loadSampleData()
                showSampleDataAlert = true
            }
        }
        .alert("Sample Data Loaded", isPresented: $showSampleDataAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Sample hairstyles, looks, and categories have been loaded and saved. They will persist after you close and reopen the app.")
        }
    }
    
    private var privacySection: some View {
        SettingsSection(title: "Privacy") {
            SettingsRow(
                icon: "shield.lefthalf.filled",
                title: "Privacy Policy",
                subtitle: "Learn how we protect your data"
            ) {
                if let url = URL(string: "https://doc-hosting.flycricket.io/silkatelier-privacy-policy/58f69be5-3a76-4046-87fb-06f7c930895a/privacy") {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    private var supportSection: some View {
        SettingsSection(title: "Support") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "envelope.fill",
                    title: "Contact Us",
                    subtitle: "Get help and send feedback"
                ) {
                    if let url = URL(string: "https://forms.gle/QRTGzDZ433cqWN9X8") {
                        UIApplication.shared.open(url)
                    }
                }
                
                Divider()
                    .background(AppColors.primaryWhite.opacity(0.2))
                    .padding(.horizontal, 16)
                
                SettingsRow(
                    icon: "star.fill",
                    title: "Rate the App",
                    subtitle: "Share your experience with others"
                ) {
                    requestAppReview()
                }
            }
        }
    }
    
    private var appSection: some View {
        SettingsSection(title: "About") {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.primaryYellow)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("About This App")
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.primaryWhite)
                        
                        Text("Create and manage your hairstyle collection with ease. Try new looks, save favorites, and track your hair journey.")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.primaryWhite.opacity(0.7))
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
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
                .font(AppFonts.subtitle)
                .foregroundColor(AppColors.primaryWhite)
                .padding(.horizontal, AppDimensions.screenPadding)
            
            VStack(spacing: 0) {
                content
            }
            .background(AppColors.primaryWhite.opacity(0.1))
            .cornerRadius(AppDimensions.cornerRadius)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.primaryYellow)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.primaryWhite)
                        .multilineTextAlignment(.leading)
                    
                    Text(subtitle)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.primaryWhite.opacity(0.7))
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.primaryWhite.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        
        DispatchQueue.main.async {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

#Preview {
    SettingsView()
        .environmentObject(HairstyleViewModel())
}
