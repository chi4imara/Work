import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(.custom("PlayfairDisplay-Bold", size: 32))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 30) {
                        VStack(spacing: 16) {
                            Image(systemName: "sparkles.rectangle.stack.fill")
                                .font(.system(size: 60))
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("Beauty Care")
                                .font(.custom("PlayfairDisplay-Bold", size: 24))
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("Your personal beauty salon")
                                .font(.custom("PlayfairDisplay-Regular", size: 16))
                                .foregroundColor(AppColors.secondaryText)
                        }
                        .padding(.top, 20)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            
                            SettingsCardView(
                                title: "Terms of Use",
                                icon: "doc.text.fill",
                                color: AppColors.primaryText,
                                isLarge: true
                            ) {
                                openURL("https://www.privacypolicies.com/live/5b79d54b-f972-44f9-ac41-f4a1fd10b0f6")
                            }
                            
                            SettingsCardView(
                                title: "Privacy Policy",
                                icon: "lock.shield.fill",
                                color: AppColors.accentYellow,
                                isLarge: false
                            ) {
                                openURL("https://www.privacypolicies.com/live/d60ae8b8-24df-4637-a1f9-aec505f87940")
                            }
                            
                            SettingsCardView(
                                title: "Contact Us",
                                icon: "envelope.fill",
                                color: AppColors.successGreen,
                                isLarge: false
                            ) {
                                openURL("https://www.privacypolicies.com/live/d60ae8b8-24df-4637-a1f9-aec505f87940")
                            }
                            
                            SettingsCardView(
                                title: "Rate the App",
                                icon: "star.fill",
                                color: AppColors.warningRed,
                                isLarge: true
                            ) {
                                requestReview()
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
}

struct SettingsCardView: View {
    let title: String
    let icon: String
    let color: Color
    let isLarge: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .shadow(color: AppColors.shadowColor, radius: 6, x: 0, y: 3)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color.opacity(0.3), lineWidth: 2)
            )
        }
    }
}

struct CircularSettingsButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(color)
                .clipShape(Circle())
                .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}
