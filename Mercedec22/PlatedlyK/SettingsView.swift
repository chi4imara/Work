import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var recipeViewModel: RecipeViewModel
    @ObservedObject var mealPlanViewModel: MealPlanViewModel
    @ObservedObject var userViewModel: UserViewModel
    @State private var showingPrivacyPolicy = false
    @State private var showingRateAlert = false
    @State private var showingSampleDataLoaded = false
    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridPattern()
                .opacity(0.2)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                    
                    supportSection
                    
                    legalSection
                    
                    appVersionView
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 180)
            }
        }
        .sheet(isPresented: $showingPrivacyPolicy) {
            PrivacyPolicyView()
        }
        .alert("Sample Data Loaded", isPresented: $showingSampleDataLoaded) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Recipes, meal plans, and profile have been loaded for testing.")
        }
        .alert("Rate CookHer", isPresented: $showingRateAlert) {
            Button("Rate Now") {
                requestReview()
            }
            Button("Later", role: .cancel) {}
        } message: {
            Text("If you enjoy using CookHer, please take a moment to rate us on the App Store. Your feedback helps us improve!")
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Settings")
                    .font(AppFonts.title(28))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Customize your experience")
                    .font(AppFonts.subtitle(16))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.primaryYellow)
                    .frame(width: 60, height: 60)
                
                Image(systemName: "fork.knife")
                    .font(.system(size: 24))
                    .foregroundColor(.black)
            }
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 0) {
            settingsRow(
                icon: "info.circle",
                title: "About CookHer",
                subtitle: "Learn more about the app",
                iconColor: AppColors.primaryYellow
            ) {
            }
            
            Divider()
                .padding(.leading, 60)
                .background(AppColors.cardBorder)
            
            settingsRow(
                icon: "questionmark.circle",
                title: "Help & FAQ",
                subtitle: "Get answers to common questions",
                iconColor: AppColors.secondaryGreen
            ) {
            }
            
            Divider()
                .padding(.leading, 60)
                .background(AppColors.cardBorder)
            
            settingsRow(
                icon: "bubble.left.and.bubble.right",
                title: "Feedback",
                subtitle: "Share your thoughts with us",
                iconColor: AppColors.secondaryOrange
            ) {
            }
        }
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var testingSection: some View {
        VStack(spacing: 0) {
            Button(action: loadSampleData) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(AppColors.secondaryGreen.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "square.and.arrow.down.fill")
                            .font(.system(size: 18))
                            .foregroundColor(AppColors.secondaryGreen)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Load Sample Data")
                            .font(AppFonts.body(16))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("Add test recipes, meal plans, and profile")
                            .font(AppFonts.caption(14))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.textSecondary)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private func loadSampleData() {
        recipeViewModel.loadSampleData()
        mealPlanViewModel.loadSampleData(recipes: recipeViewModel.recipes)
        userViewModel.loadSampleData()
        showingSampleDataLoaded = true
    }
    
    private var supportSection: some View {
        VStack(spacing: 0) {
            settingsRow(
                icon: "star.fill",
                title: "Rate App",
                subtitle: "Rate us on the App Store",
                iconColor: AppColors.primaryYellow
            ) {
                showingRateAlert = true
            }
            
            Divider()
                .padding(.leading, 60)
                .background(AppColors.cardBorder)
            
            settingsRow(
                icon: "envelope",
                title: "Contact Us",
                subtitle: "Get in touch with our team",
                iconColor: AppColors.secondaryPurple
            ) {
                if let url = URL(string: "https://www.privacypolicies.com/live/8fa7597a-fe90-4a34-abe7-170bb5bc651b") {
                    UIApplication.shared.open(url)
                }
            }
            
            Divider()
                .padding(.leading, 60)
                .background(AppColors.cardBorder)
            
            settingsRow(
                icon: "square.and.arrow.up",
                title: "Share App",
                subtitle: "Tell your friends about CookHer",
                iconColor: Color.green
            ) {
                shareApp()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var legalSection: some View {
        VStack(spacing: 0) {
            settingsRow(
                icon: "doc.text",
                title: "Privacy Policy",
                subtitle: "How we handle your data",
                iconColor: AppColors.secondaryPink
            ) {
                if let url = URL(string: "https://www.privacypolicies.com/live/8fa7597a-fe90-4a34-abe7-170bb5bc651b") {
                    UIApplication.shared.open(url)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var appVersionView: some View {
        VStack(spacing: 12) {
            Text("CookHer")
                .font(AppFonts.subtitle(18))
                .foregroundColor(AppColors.textPrimary)
            
            Text("Made with ❤️ for healthy cooking")
                .font(AppFonts.caption(12))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private func settingsRow(
        icon: String,
        title: String,
        subtitle: String,
        iconColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(AppFonts.body(16))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(subtitle)
                        .font(AppFonts.caption(14))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
    
    private func shareApp() {
        let activityVC = UIActivityViewController(
            activityItems: ["Check out CookHer - the best app for healthy cooking! https://apps.apple.com"],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
}

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Privacy Policy")
                            .font(AppFonts.title(24))
                            .foregroundColor(AppColors.textPrimary)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            privacySection(
                                title: "Data Collection",
                                content: "We collect minimal data necessary to provide you with personalized recipe recommendations and meal planning features. This includes your dietary preferences, allergies, and meal history."
                            )
                            
                            privacySection(
                                title: "Data Usage",
                                content: "Your data is used solely to improve your experience within the app. We analyze your preferences to suggest relevant recipes and track your nutrition goals."
                            )
                            
                            privacySection(
                                title: "Data Security",
                                content: "We implement industry-standard security measures to protect your personal information. Your data is encrypted and stored securely."
                            )
                            
                            privacySection(
                                title: "Data Sharing",
                                content: "We do not sell, trade, or share your personal information with third parties without your explicit consent, except as required by law."
                            )
                            
                            privacySection(
                                title: "Your Rights",
                                content: "You have the right to access, modify, or delete your personal data at any time through the app settings or by contacting us."
                            )
                        }
                        
                        Text("Last updated: February 2, 2026")
                            .font(AppFonts.caption(12))
                            .foregroundColor(AppColors.textSecondary)
                            .padding(.top, 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .foregroundColor(AppColors.primaryYellow)
            }
        }
    }
    
    private func privacySection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppFonts.subtitle(16))
                .foregroundColor(AppColors.textPrimary)
            
            Text(content)
                .font(AppFonts.body(14))
                .foregroundColor(AppColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
}

#Preview {
    SettingsView(
        recipeViewModel: RecipeViewModel(),
        mealPlanViewModel: MealPlanViewModel(),
        userViewModel: UserViewModel()
    )
}
