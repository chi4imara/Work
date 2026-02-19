import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingLoadSampleAlert = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 28) {
                    HeaderView()
                    
                    UserStatsView()
                        .padding(.horizontal, 20)
                    
                    SettingsSectionView(
                        requestAppReview: requestAppReview
                    )
                }
                .padding(.top, 20)
                .padding(.bottom, 120)
            }
        }
        .alert("Load Sample Data", isPresented: $showingLoadSampleAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Load") {
                appState.loadSampleDataForTesting()
            }
        } message: {
            Text("This will replace all your current wardrobe items, outfits, challenges and progress with sample data for testing.")
        }
    }
    
    @ViewBuilder
    private func HeaderView() -> some View {
        HStack(spacing: 16) {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [AppColors.yellow, AppColors.pink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 64, height: 64)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 28))
                        .foregroundColor(AppColors.accentText)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Settings")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(appState.currentUser)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func UserStatsView() -> some View {
        VStack(spacing: 16) {
            HStack {
                Text("Your Style Journey")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                Spacer()
            }
            
            HStack(spacing: 12) {
                StatCard(
                    value: "\(appState.wardrobeItems.count)",
                    label: "Items",
                    color: AppColors.yellow
                )
                
                StatCard(
                    value: "\(appState.outfits.count)",
                    label: "Outfits",
                    color: AppColors.pink
                )
                
                StatCard(
                    value: "\(appState.dailyProgress.count)",
                    label: "Days Active",
                    color: AppColors.purple
                )
            }
        }
        .padding(20)
        .cardStyle()
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func openContact() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsSectionView: View {
    let requestAppReview: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Support & Info")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            
            VStack(spacing: 12) {
                SettingsRow(
                    icon: "lock.shield.fill",
                    title: "Privacy Policy",
                    subtitle: "Data protection policy",
                    color: AppColors.purple
                ) {
                    if let url = URL(string: "https://www.privacypolicies.com/live/0e83a9af-814f-4eb0-bbd3-6abaad36fde3") {
                        UIApplication.shared.open(url)
                    }
                }
                
                SettingsRow(
                    icon: "star.fill",
                    title: "Rate App",
                    subtitle: "Leave a review",
                    color: AppColors.yellow
                ) {
                    requestAppReview()
                }
                
                SettingsRow(
                    icon: "envelope.fill",
                    title: "Contact Us",
                    subtitle: "Contact email",
                    color: AppColors.green
                ) {
                    if let url = URL(string: "https://www.privacypolicies.com/live/0e83a9af-814f-4eb0-bbd3-6abaad36fde3") {
                        UIApplication.shared.open(url)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct TestingSectionView: View {
    @Binding var showingLoadSampleAlert: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Testing")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            
            SettingsRow(
                icon: "square.and.arrow.down.fill",
                title: "Load Sample Data",
                subtitle: "Replace data with test content",
                color: AppColors.orange
            ) {
                showingLoadSampleAlert = true
            }
            .padding(.horizontal, 20)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(0.25))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(subtitle)
                        .font(.ubuntu(13))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
            .cornerRadius(16)
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct StatCard: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.ubuntu(22, weight: .bold))
                .foregroundColor(color)
            
            Text(label)
                .font(.ubuntu(11))
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(color.opacity(0.15))
        .cornerRadius(14)
    }
}

struct WebView: UIViewControllerRepresentable {
    let url: String
    
    func makeUIViewController(context: Context) -> UIViewController {
        let webViewController = UIViewController()
        
        let alert = UIAlertController(
            title: "Privacy Policy",
            message: "This would open our privacy policy page at \(url)",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        DispatchQueue.main.async {
            webViewController.present(alert, animated: true)
        }
        
        return webViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
}
