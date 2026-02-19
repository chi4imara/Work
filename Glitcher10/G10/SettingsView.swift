import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    @ObservedObject var viewModel: ShoppingViewModel
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 8) {
                        Text("Settings")
                            .font(FontManager.ubuntu(size: 28, weight: .bold))
                            .foregroundColor(ColorManager.white)
                        
                        Text("Manage your app preferences")
                            .font(FontManager.ubuntu(size: 16))
                            .foregroundColor(ColorManager.white.opacity(0.7))
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        SettingsButton(
                            title: "Privacy Policy",
                            subtitle: "How we handle your data",
                            icon: "shield.checkerboard",
                            color: ColorManager.lightBlue,
                            action: viewModel.openPrivacyPolicy
                        )
                        
                        SettingsButton(
                            title: "Contact",
                            subtitle: "Get in touch",
                            icon: "envelope",
                            color: ColorManager.orange,
                            action: viewModel.openContactEmail
                        )
                        
                        SettingsButton(
                            title: "Rate App",
                            subtitle: "Share feedback",
                            icon: "star",
                            color: ColorManager.success,
                            action: {
                                showingRateAlert = true
                            }
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 8) {
                        Text("Garage Shopping List")
                            .font(FontManager.ubuntu(size: 18, weight: .medium))
                            .foregroundColor(ColorManager.white)
                    }
                    .padding(.top, 30)
                }
                .padding(.bottom, 10)
            }
        }
        .alert("Rate Our App", isPresented: $showingRateAlert) {
            Button("Not Now", role: .cancel) { }
            Button("Rate App") {
                requestReview()
            }
        } message: {
            Text("Enjoying the app? Please take a moment to rate us on the App Store!")
        }
    }
}

struct SettingsButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(FontManager.ubuntu(size: 16, weight: .medium))
                        .foregroundColor(ColorManager.white)
                    
                    Text(subtitle)
                        .font(FontManager.ubuntu(size: 14))
                        .foregroundColor(ColorManager.white.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(ColorManager.white.opacity(0.5))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorManager.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
            )
            .shadow(color: ColorManager.darkBlue.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView(viewModel: ShoppingViewModel())
}
