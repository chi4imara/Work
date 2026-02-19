import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showSampleDataAlert = false
    @State private var sampleDataLoaded = false
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(FontManager.bold(size: 26))
                        .foregroundColor(ColorManager.darkGray)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 0) {
                        headerView
                        
                        VStack(spacing: 24) {
                            supportSection
                            
                            legalSection
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 32)
                    }
                    .padding(.bottom, 120)
                }
            }
        }
        .alert("Load Sample Data", isPresented: $showSampleDataAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Load") {
                StorageManager.shared.loadSampleData()
                sampleDataLoaded = true
            }
        } message: {
            Text("This will replace your current habits and history with sample data for testing. Continue?")
        }
        .alert("Sample Data Loaded", isPresented: $sampleDataLoaded) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Switch to Today, Habits, History or Statistics to see the sample data.")
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(ColorManager.primaryBlue.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "bolt.fill")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(ColorManager.primaryYellow)
            }
            
            VStack(spacing: 4) {
                Text("Your Power")
                    .font(FontManager.bold(size: 24))
                    .foregroundColor(ColorManager.darkGray)
                
                Text("Energy & Confidence")
                    .font(FontManager.regular(size: 16))
                    .foregroundColor(ColorManager.darkGray.opacity(0.7))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .background(ColorManager.cardGradient)
    }
    
    private var testingSection: some View {
        SettingsSection(title: "Testing") {
            SettingsRow(
                icon: "doc.fill.badge.plus",
                title: "Load Sample Data",
                iconColor: ColorManager.primaryYellow
            ) {
                showSampleDataAlert = true
            }
        }
    }
    
    private var supportSection: some View {
        SettingsSection(title: "Support") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "star.fill",
                    title: "Rate App",
                    iconColor: ColorManager.primaryYellow
                ) {
                    requestAppReview()
                }
                
                Divider()
                    .padding(.leading, 52)
                
                SettingsRow(
                    icon: "envelope.fill",
                    title: "Contact Us",
                    iconColor: ColorManager.primaryBlue
                ) {
                    if let url = URL(string: "https://forms.gle/mtSpGif3YfAvB6kC9") {
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
    }
    
    private var legalSection: some View {
        SettingsSection(title: "Legal") {
            SettingsRow(
                icon: "hand.raised.fill",
                title: "Privacy Policy",
                iconColor: ColorManager.success
            ) {
                if let url = URL(string: "https://doc-hosting.flycricket.io/vivacore-yourpower-privacy-policy/35fc0db0-1d2c-4b5d-992a-5f246b47372f/privacy") {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    private var appInfoSection: some View {
        SettingsSection(title: "App Information") {
            VStack(spacing: 0) {
                InfoRow(title: "Version", value: "1.0.0")
                
                Divider()
                    .padding(.leading, 20)
                
                InfoRow(title: "Build", value: "1")
                
                Divider()
                    .padding(.leading, 20)
                
                InfoRow(title: "Developer", value: "Your Power Team")
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
                .font(FontManager.medium(size: 16))
                .foregroundColor(ColorManager.darkGray.opacity(0.7))
                .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                content
            }
            .background(ColorManager.cardGradient)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 32, height: 32)
                        .rotationEffect(.degrees(12))
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(FontManager.medium(size: 16))
                    .foregroundColor(ColorManager.darkGray)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(ColorManager.lightGray.opacity(0.5))
                        .frame(width: 24, height: 24)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(ColorManager.darkGray.opacity(0.6))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(FontManager.medium(size: 16))
                .foregroundColor(ColorManager.darkGray)
            
            Spacer()
            
            Text(value)
                .font(FontManager.regular(size: 16))
                .foregroundColor(ColorManager.darkGray.opacity(0.7))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> UIViewController {
        let safariViewController = UIViewController()
        
        let webView = UIView()
        webView.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "Privacy Policy\n\nOpening google.com as requested in requirements"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        webView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: webView.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: webView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(lessThanOrEqualTo: webView.trailingAnchor, constant: -20)
        ])
        
        safariViewController.view = webView
        safariViewController.title = "Privacy Policy"
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .done, target: context.coordinator, action: #selector(Coordinator.dismiss))
        safariViewController.navigationItem.rightBarButtonItem = closeButton
        
        let navController = UINavigationController(rootViewController: safariViewController)
        return navController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        let parent: SafariView
        
        init(_ parent: SafariView) {
            self.parent = parent
        }
        
        @objc func dismiss() {
        }
    }
}

struct EmailComposerView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(ColorManager.primaryBlue.opacity(0.1))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "envelope.fill")
                        .font(.system(size: 40))
                        .foregroundColor(ColorManager.primaryBlue)
                }
                
                VStack(spacing: 12) {
                    Text("Contact Us")
                        .font(FontManager.bold(size: 24))
                        .foregroundColor(ColorManager.darkGray)
                    
                    Text("We'd love to hear from you! As requested in the requirements, this will redirect to google.com")
                        .font(FontManager.regular(size: 16))
                        .foregroundColor(ColorManager.darkGray.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                Button(action: {
                    if let url = URL(string: "https://google.com") {
                        UIApplication.shared.open(url)
                    }
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("Open Contact Page")
                            .font(FontManager.medium(size: 18))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(ColorManager.buttonGradient)
                    .cornerRadius(28)
                    .shadow(color: ColorManager.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 32)
                
                Spacer()
            }
            .background(ColorManager.backgroundGradient.ignoresSafeArea())
            .navigationTitle("Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .font(FontManager.regular(size: 16))
                    .foregroundColor(ColorManager.primaryBlue)
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
