import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var eventStore: EventStore
    @State private var showingSampleDataAlert = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                        Text("Settings")
                            .font(AppFonts.title(32))
                            .foregroundColor(AppColors.primaryWhite)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    VStack(spacing: 20) {
                        SettingsRowView(
                            title: "Privacy Policy",
                            icon: "shield.lefthalf.filled",
                            action: {
                                openURL("https://doc-hosting.flycricket.io/clearmilestones-privacy-policy/c343eb2c-0a68-441e-986c-55a1954b43a8/privacy")
                            }
                        )
                        
                        SettingsRowView(
                            title: "Contact Us",
                            icon: "envelope.fill",
                            action: {
                                openURL("https://forms.gle/R3mv1N1wqkWS9b439")
                            }
                        )
                        
                        SettingsRowView(
                            title: "Rate App",
                            icon: "star.fill",
                            action: {
                                requestReview()
                            }
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .alert("Sample data loaded", isPresented: $showingSampleDataAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Sample events have been loaded. You can view them in Events, Calendar, Search, and Statistics.")
        }
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func getAppVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}

struct SettingsRowView: View {
    let title: String
    let icon: String
    let subtitle: String?
    let action: (() -> Void)?
    @State private var isPressed = false
    
    init(title: String, icon: String, subtitle: String? = nil, action: (() -> Void)?) {
        self.title = title
        self.icon = icon
        self.subtitle = subtitle
        self.action = action
    }
    
    var body: some View {
        Group {
            if let action = action {
                Button(action: action) {
                    rowContent
                }
                .buttonStyle(PlainButtonStyle())
                .onLongPressGesture(minimumDuration: 0) { pressing in
                    isPressed = pressing
                } perform: {
                    action()
                }
            } else {
                rowContent
            }
        }
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
    
    private var rowContent: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryYellow.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.primaryYellow)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppFonts.headline(16))
                    .foregroundColor(AppColors.primaryWhite)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(AppFonts.caption(14))
                        .foregroundColor(AppColors.primaryWhite.opacity(0.7))
                }
            }
            
            Spacer()
            
            if action != nil {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.primaryWhite.opacity(0.5))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                        .stroke(AppColors.primaryWhite.opacity(0.1), lineWidth: 1)
                )
        )
    }
}
