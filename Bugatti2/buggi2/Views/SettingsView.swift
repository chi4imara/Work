import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject var inventoryViewModel: InventoryViewModel
    @State private var showingRateAlert = false
    @State private var showingSampleDataAlert = false
    
    var body: some View {
        ZStack {
            GridBackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(.playfairDisplay(28, weight: .bold))
                        .foregroundColor(AppColors.primaryTextWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 16) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(
                                            LinearGradient(
                                                colors: [AppColors.primaryBlue, AppColors.accentGreen],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 60, height: 60)
                                    
                                    Image(systemName: "archivebox.fill")
                                        .font(.system(size: 28, weight: .medium))
                                        .foregroundColor(AppColors.backgroundWhite)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Inventory Tracker")
                                        .font(.playfairDisplay(20, weight: .bold))
                                        .foregroundColor(AppColors.primaryTextWhite)
                                    
                                    Text("Keep track of your belongings")
                                        .font(.playfairDisplay(14, weight: .medium))
                                        .foregroundColor(AppColors.secondaryTextWhite)
                                        .lineLimit(2)
                                }
                                
                                Spacer()
                            }
                            
                            Text("This app helps you create a clear personal inventory of your belongings. Add items you own, note where they are stored, and record ownership details.")
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(AppColors.secondaryTextWhite)
                                .lineSpacing(2)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppColors.cardBackground)
                                .shadow(color: AppColors.shadowColor, radius: 6, x: 0, y: 3)
                        )
                        
                        VStack(spacing: 16) {
                            SettingsRowView(
                                icon: "star.fill",
                                title: "Rate App",
                                subtitle: "Help us improve",
                                iconColor: AppColors.primaryYellow,
                                action: {
                                    requestAppReview()
                                }
                            )
                            
                            SettingsRowView(
                                icon: "shield.fill",
                                title: "Privacy Policy",
                                subtitle: "Data protection information",
                                iconColor: AppColors.accentGreen,
                                action: {
                                    openURL("https://doc-hosting.flycricket.io/is-itemaspaceone-privacy-policy/63d009f5-dd2e-460c-9f55-c2eaa2bdaa7b/privacy")
                                }
                            )
                            
                            SettingsRowView(
                                icon: "envelope.fill",
                                title: "Contact Us",
                                subtitle: "Get support or send feedback",
                                iconColor: AppColors.softOrange,
                                action: {
                                    openURL("https://forms.gle/dNewMn2fF6fZqkWk6")
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .alert("Sample Data Loaded", isPresented: $showingSampleDataAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Inventory has been filled with sample items for testing.")
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsRowView: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.playfairDisplay(16, weight: .semibold))
                        .foregroundColor(AppColors.primaryTextWhite)
                    
                    Text(subtitle)
                        .font(.playfairDisplay(14, weight: .medium))
                        .foregroundColor(AppColors.secondaryTextWhite)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.primaryTextWhite.opacity(0.8))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
                    .shadow(color: AppColors.shadowColor, radius: 2, x: 0, y: 1)
            )
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(InventoryViewModel())
}
