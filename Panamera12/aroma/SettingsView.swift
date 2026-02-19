import SwiftUI
import StoreKit

struct SettingsView: View {
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(.bauhausBold(28))
                        .foregroundColor(.appPrimaryBlue)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                ScrollView {
                    VStack(spacing: 0) {
                        headerView
                        
                        VStack(spacing: 20) {
                            HStack(spacing: 15) {
                                SettingsCardView(
                                    title: "Privacy Policy",
                                    icon: "shield.checkered",
                                    color: .appPrimaryBlue,
                                    size: .large
                                ) {
                                    openURL("https://www.freeprivacypolicy.com/live/ed6be39e-3611-4a08-b520-bf68917087e5")
                                }
                                
                                VStack(spacing: 15) {
                                    SettingsCardView(
                                        title: "Rate App",
                                        icon: "star.fill",
                                        color: .appPrimaryYellow,
                                        size: .small
                                    ) {
                                        requestAppReview()
                                    }
                                    
                                    SettingsCardView(
                                        title: "Contact",
                                        icon: "envelope.fill",
                                        color: .appAccentPink,
                                        size: .small
                                    ) {
                                        openURL("https://forms.gle/LkG1NFT5NnhiyXjt8")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(AppColors.splashGradient)
                    .frame(width: 80, height: 80)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 35, weight: .light))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 5) {
                Text("Fragrance Archive")
                    .font(.bauhausBold(20))
                    .foregroundColor(.appPrimaryBlue)
            }
        }
        .padding(.top, 20)
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

struct SettingsCardView: View {
    let title: String
    let icon: String
    let color: Color
    let size: CardSize
    let action: () -> Void
    
    enum CardSize {
        case small, large
        
        var height: CGFloat {
            switch self {
            case .small: return 80
            case .large: return 175
            }
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack {
                if size == .large {
                    Spacer()
                }
                
                VStack(spacing: size == .large ? 15 : 8) {
                    Image(systemName: icon)
                        .font(.system(size: size == .large ? 30 : 20, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(title)
                        .font(.bauhausMedium(16))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                
                if size == .large {
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: size.height)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [color, color.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
            )
        }
    }
}

struct WebView: View {
    let url: String
    let title: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Image(systemName: "globe")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(.appPrimaryBlue.opacity(0.3))
                    
                    Text("Opening in browser...")
                        .font(.bauhausLight(16))
                        .foregroundColor(.appTextGray)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.bauhausLight(16))
                    .foregroundColor(.appPrimaryBlue)
                }
            }
        }
        .onAppear {
            if let url = URL(string: url) {
                UIApplication.shared.open(url)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct ContactView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Image(systemName: "envelope.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.appPrimaryBlue)
                    
                    VStack(spacing: 15) {
                        Text("Contact Us")
                            .font(.bauhausBold(24))
                            .foregroundColor(.appPrimaryBlue)
                        
                        Text("support@fragrancearchive.com")
                            .font(.bauhausLight(16))
                            .foregroundColor(.appTextGray)
                    }
                    
                    Button("Open Email App") {
                        if let url = URL(string: "mailto:support@fragrancearchive.com") {
                            UIApplication.shared.open(url)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.bauhausMedium(16))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(AppColors.buttonGradient)
                    )
                }
            }
            .navigationTitle("Contact")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.bauhausLight(16))
                    .foregroundColor(.appPrimaryBlue)
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
