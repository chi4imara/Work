import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var viewModel: EventsViewModel
    @State private var showingClearAlert = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(.custom("PlayfairDisplay-Bold", size: 32))
                        .foregroundColor(ColorTheme.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            SettingsCard {
                                Button(action: rateApp) {
                                    HStack {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(ColorTheme.accentYellow)
                                            .font(.system(size: 20))
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Rate App")
                                                .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                                                .foregroundColor(ColorTheme.textPrimary)
                                            
                                            Text("Help us improve the app")
                                                .font(.custom("PlayfairDisplay-Regular", size: 14))
                                                .foregroundColor(ColorTheme.textSecondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(ColorTheme.textSecondary)
                                            .font(.system(size: 14, weight: .medium))
                                    }
                                }
                            }
                            
                            SettingsCard {
                                Button(action: openPrivacyPolicy) {
                                    HStack {
                                        Image(systemName: "lock.shield.fill")
                                            .foregroundColor(ColorTheme.primaryBlue)
                                            .font(.system(size: 20))
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Privacy Policy")
                                                .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                                                .foregroundColor(ColorTheme.textPrimary)
                                            
                                            Text("View our privacy policy")
                                                .font(.custom("PlayfairDisplay-Regular", size: 14))
                                                .foregroundColor(ColorTheme.textSecondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(ColorTheme.textSecondary)
                                            .font(.system(size: 14, weight: .medium))
                                    }
                                }
                            }
                            
                            SettingsCard {
                                Button(action: openContactEmail) {
                                    HStack {
                                        Image(systemName: "envelope.fill")
                                            .foregroundColor(ColorTheme.successGreen)
                                            .font(.system(size: 20))
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Contact Us")
                                                .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                                                .foregroundColor(ColorTheme.textPrimary)
                                            
                                            Text("Send us your feedback")
                                                .font(.custom("PlayfairDisplay-Regular", size: 14))
                                                .foregroundColor(ColorTheme.textSecondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(ColorTheme.textSecondary)
                                            .font(.system(size: 14, weight: .medium))
                                    }
                                }
                            }
                        }
                        
                        VStack(spacing: 16) {
                            HStack {
                                Text("Danger Zone")
                                    .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                                    .foregroundColor(ColorTheme.deleteRed)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            
                            SettingsCard {
                                Button(action: { showingClearAlert = true }) {
                                    HStack {
                                        Image(systemName: "trash.fill")
                                            .foregroundColor(ColorTheme.deleteRed)
                                            .font(.system(size: 20))
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Clear All Events")
                                                .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                                                .foregroundColor(ColorTheme.deleteRed)
                                            
                                            Text("Delete all recorded events")
                                                .font(.custom("PlayfairDisplay-Regular", size: 14))
                                                .foregroundColor(ColorTheme.textSecondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(ColorTheme.textSecondary)
                                            .font(.system(size: 14, weight: .medium))
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    .padding(.bottom, 120)
                }
            }
        }
        .alert("Clear All Events", isPresented: $showingClearAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear All", role: .destructive) {
                viewModel.clearAllEvents()
            }
        } message: {
            Text("Are you sure you want to delete all events? This action cannot be undone.")
        }
    }
    
    private func rateApp() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func openPrivacyPolicy() {
        if let url = URL(string: "https://doc-hosting.flycricket.io/daymarks-plain-today-privacy-policy/923054ac-9bbd-4cb6-a3ce-8f21e18059ad/privacy") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openContactEmail() {
        if let url = URL(string: "https://forms.gle/gMhaUfhsnAqMUGLKA") {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(ColorTheme.cardBackground)
            .cornerRadius(12)
            .shadow(color: ColorTheme.shadowColor, radius: 4, x: 0, y: 2)
    }
}
