import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var appState: AppState
    @State private var showingLoadSampleDataAlert = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Text("Settings")
                            .font(.appTitle)
                            .foregroundColor(.appWhite)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    VStack(spacing: 0) {
                        SettingsRow(
                            icon: "shield.fill",
                            iconColor: .appLightBlue,
                            title: "Privacy Policy",
                            subtitle: "Data protection policy"
                        ) {
                            if let url = URL(string: "https://doc-hosting.flycricket.io/powrion-forcero-privacy-policy/7565df51-83ce-4f23-ab90-0a052b1cc8d6/privacy") {
                                UIApplication.shared.open(url)
                            }
                        }
                        
                        Divider()
                            .background(Color.appWhite.opacity(0.15))
                            .padding(.leading, 56)
                        
                        SettingsRow(
                            icon: "star.fill",
                            iconColor: .appOrange,
                            title: "Rate App",
                            subtitle: "Leave a review"
                        ) {
                            requestAppReview()
                        }
                        
                        Divider()
                            .background(Color.appWhite.opacity(0.15))
                            .padding(.leading, 56)
                        
                        SettingsRow(
                            icon: "envelope.fill",
                            iconColor: .appGreen,
                            title: "Contact Us",
                            subtitle: "Send feedback"
                        ) {
                            if let url = URL(string: "https://forms.gle/AidM3P8x4b2WAyTp9") {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                    .background(AppColors.cardGradient)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.appWhite.opacity(0.12), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 12) {
                        Image(systemName: "fork.knife")
                            .font(.system(size: 32))
                            .foregroundColor(.appOrange.opacity(0.8))
                        
                        Text("Breakfast in 10 Minutes")
                            .font(.appTitle3)
                            .foregroundColor(.appWhite)
                        
                        Text("Start your day right with quick and delicious breakfast recipes")
                            .font(.appFootnote)
                            .foregroundColor(.appWhite.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .padding(.vertical, 28)
                    .frame(maxWidth: .infinity)
                    .background(Color.appWhite.opacity(0.04))
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 120)
            }
        }
        .alert("Load Sample Data", isPresented: $showingLoadSampleDataAlert) {
            Button("Load") {
                appState.loadSampleData()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will replace your current recipes and data with sample content for testing.")
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.appHeadline)
                        .foregroundColor(.appWhite)
                    
                    Text(subtitle)
                        .font(.appCaption)
                        .foregroundColor(.appWhite.opacity(0.6))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.appWhite.opacity(0.4))
            }
            .padding(16)
        }
    }
}

struct WebView: View {
    let url: String
    let title: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Image(systemName: "globe")
                        .font(.system(size: 60))
                        .foregroundColor(.appWhite.opacity(0.3))
                    
                    VStack(spacing: 12) {
                        Text("Opening Web Page")
                            .font(.appTitle3)
                            .foregroundColor(.appWhite)
                        
                        Text("This will redirect you to \(url)")
                            .font(.appBody)
                            .foregroundColor(.appWhite.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    
                    Button("Open in Browser") {
                        if let webURL = URL(string: url) {
                            UIApplication.shared.open(webURL)
                        }
                        dismiss()
                    }
                    .font(.appHeadline)
                    .foregroundColor(.appWhite)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.appOrange)
                    .cornerRadius(25)
                    .padding(.horizontal, 40)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.appOrange)
                }
            }
            .toolbarBackground(Color.appDarkBlue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

#Preview {
    SettingsView(appState: AppState())
}
