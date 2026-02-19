import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) private var requestReview
    @EnvironmentObject var viewModel: WardrobeViewModel
    @State private var showingSampleDataAlert = false
    
    var body: some View {
        ZStack {
            AppColors.gradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 12) {
                            Image(systemName: "tshirt.fill")
                                .font(.system(size: 44))
                                .foregroundColor(AppColors.primary)
                            Text("Style Daily")
                                .font(.ubuntu(20, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 28)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppColors.cardBackground)
                                .shadow(color: AppColors.shadow, radius: 8, x: 0, y: 4)
                        )
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 0) {
                            SettingsRow(
                                icon: "shield.checkerboard",
                                iconColor: Color.green,
                                title: "Data Protection Policy"
                            ) {
                                openURL("https://www.termsfeed.com/live/e016ded1-9f47-4bad-b569-ff3b2b5cf373")
                            }
                            
                            Divider()
                                .padding(.leading, 56)
                            
                            SettingsRow(
                                icon: "envelope.fill",
                                iconColor: AppColors.accent,
                                title: "Contact Us"
                            ) {
                                openURL("https://www.termsfeed.com/live/e016ded1-9f47-4bad-b569-ff3b2b5cf373")
                            }
                            
                            Divider()
                                .padding(.leading, 56)
                            
                            SettingsRow(
                                icon: "star.fill",
                                iconColor: Color.orange,
                                title: "Rate App"
                            ) {
                                requestReview()
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppColors.cardBackground)
                                .shadow(color: AppColors.shadow, radius: 8, x: 0, y: 4)
                        )
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 120)
                }
            }
        }
        .alert("Sample Data Loaded", isPresented: $showingSampleDataAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Wardrobe items and outfits have been loaded for testing.")
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
    let iconColor: Color
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(iconColor)
                    .frame(width: 28, height: 28, alignment: .center)
                
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(WardrobeViewModel())
}
