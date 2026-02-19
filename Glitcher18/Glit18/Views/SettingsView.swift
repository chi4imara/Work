import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(.playfairDisplay(size: 28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(AppColors.accentGradient)
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "sparkles")
                                    .font(.system(size: 32, weight: .medium))
                                    .foregroundColor(AppColors.deepPurple)
                            }
                            
                            VStack(spacing: 8) {
                                Text("Accessory Organizer")
                                    .font(.playfairDisplay(size: 24, weight: .bold))
                                    .foregroundColor(AppColors.primaryText)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .glassCard()
                        
                        VStack(spacing: 0) {
                            SettingsRow(
                                icon: "shield.fill",
                                title: "Privacy Policy",
                                showChevron: true
                            ) {
                                openURL("https://www.freeprivacypolicy.com/live/3669733b-25f8-4fe2-bc3f-bf4a3cf0805c")
                            }
                            
                            Divider()
                                .background(AppColors.cardBorder)
                            
                            SettingsRow(
                                icon: "envelope.fill",
                                title: "Contact Us",
                                showChevron: true
                            ) {
                                openURL("https://forms.gle/nQVx7UWC67utNKoC7")
                            }
                            
                            Divider()
                                .background(AppColors.cardBorder)
                            
                            SettingsRow(
                                icon: "star.fill",
                                title: "Rate the App",
                                showChevron: true
                            ) {
                                showingRateAlert = true
                            }
                        }
                        .glassCard()
                        
                        VStack(spacing: 16) {
                            Text("Keep your accessories organized and create perfect outfit combinations.")
                                .font(.playfairDisplay(size: 16, weight: .regular))
                                .foregroundColor(AppColors.secondaryText)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .glassCard()
                    }
                    .padding()
                }
            }
        }
        .alert("Rate Our App", isPresented: $showingRateAlert) {
            Button("Rate Now") {
                requestReview()
            }
            Button("Maybe Later", role: .cancel) { }
        } message: {
            Text("If you enjoy using our app, please take a moment to rate it. Your feedback helps us improve!")
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let showChevron: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.accentYellow.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.accentYellow)
                }
                
                Text(title)
                    .font(.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    SettingsView()
}
