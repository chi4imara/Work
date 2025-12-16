import SwiftUI
import StoreKit

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @StateObject private var recipeManager = RecipeManager()
    @State private var showCategoryManagement = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            Image(systemName: "fork.knife.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(AppColors.primaryYellow)
                            
                            Text("Recipe Daily")
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppColors.cardBackground)
                        .cornerRadius(12)
                        .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
                        
                        VStack(spacing: 0) {
                            SettingsRow(
                                icon: "doc.text",
                                title: "Terms and Conditions",
                                action: viewModel.openTermsAndConditions
                            )
                            
                            Divider()
                                .padding(.leading, 60)
                            
                            SettingsRow(
                                icon: "hand.raised",
                                title: "Privacy Policy",
                                action: viewModel.openPrivacyPolicy
                            )
                            
                            Divider()
                                .padding(.leading, 60)
                            
                            SettingsRow(
                                icon: "envelope",
                                title: "Contact Us",
                                action: viewModel.contactSupport
                            )
                            
                            Divider()
                                .padding(.leading, 60)
                            
                            SettingsRow(
                                icon: "star",
                                title: "Rate App",
                                action: viewModel.rateApp
                            )
                        }
                        .cardStyle()
                        
                        VStack(spacing: 16) {
                            HStack(spacing: 20) {
                                SettingsCircleButton(
                                    icon: "doc.fill",
                                    color: AppColors.primaryBlue,
                                    action: viewModel.openTermsAndConditions
                                )
                                
                                SettingsCircleButton(
                                    icon: "hand.raised.fill",
                                    color: AppColors.accentRed,
                                    action: viewModel.openPrivacyPolicy
                                )
                                
                                SettingsCircleButton(
                                    icon: "envelope.fill",
                                    color: AppColors.accentGreen,
                                    action: viewModel.contactSupport
                                )
                                
                                SettingsCircleButton(
                                    icon: "star.fill",
                                    color: AppColors.primaryYellow,
                                    action: viewModel.rateApp
                                )
                            }
                            .padding(.vertical, 20)
                            
                            Text("Recipe Daily")
                                .font(.ubuntu(16, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppColors.cardBackground)
                        .cornerRadius(12)
                        .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
                        
                        Spacer(minLength: 30)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
        }
        .alert("Rate Our App", isPresented: $viewModel.showRateApp) {
            Button("Rate Now") {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            }
            Button("Later", role: .cancel) { }
        } message: {
            Text("Would you like to rate our app in the App Store?")
        }
        .sheet(isPresented: $showCategoryManagement) {
            CategoryManagementView()
                .environmentObject(recipeManager)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.primaryBlue)
                    .frame(width: 28, height: 28)
                
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
        }
    }
}

struct SettingsCircleButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(color)
                .clipShape(Circle())
                .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    SettingsView()
}
