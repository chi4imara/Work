import SwiftUI

struct SettingsView: View {
    @ObservedObject var appViewModel: AppViewModel
    
    var body: some View {
        ZStack {
            ColorManager.primaryGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    Text("Settings")
                        .font(.playfairDisplay(size: 28, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                        .padding(.vertical, 10)
                    
                    VStack(spacing: 16) {
                        SettingsRow(
                            title: "Privacy Policy",
                            icon: "shield.fill",
                            iconColor: ColorManager.lightBlue
                        ) {
                            openURL("https://www.freeprivacypolicy.com/live/ea29b84a-4064-4bb2-adc3-05d19455a17a")
                        }
                        
                        SettingsRow(
                            title: "Contact Us",
                            icon: "envelope.fill",
                            iconColor: ColorManager.orange
                        ) {
                            openURL("https://forms.gle/dHkPvHCMAkpc6GQT7")
                        }
                        
                        SettingsRow(
                            title: "Rate the App",
                            icon: "star.fill",
                            iconColor: ColorManager.warning
                        ) {
                            appViewModel.requestAppReview()
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 120)
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(iconColor)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.playfairDisplay(size: 18, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(ColorManager.secondaryText)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorManager.secondaryBackground.opacity(0.8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                        .stroke(ColorManager.lightBlue.opacity(0.2), lineWidth: 1)
                    }
            )
        }
    }
}

#Preview {
    SettingsView(appViewModel: AppViewModel())
}
