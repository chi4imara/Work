import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var viewModel: PrinciplesViewModel
    @State private var animateItems = false
    @State private var showingRateAlert = false
    @State private var showingSampleDataAlert = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridPattern()
                .opacity(0.15)
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 20) {
                        settingsSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                animateItems = true
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.playfairDisplay(32, weight: .bold))
                .foregroundColor(Color.appTextBlue)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var settingsSection: some View {
        VStack(spacing: 15) {
            SettingsRowView(
                icon: "lock.shield",
                title: "Privacy Policy",
                subtitle: "How we protect your data",
                color: Color.appTextBlue
            ) {
                openURL("https://doc-hosting.flycricket.io/myquiet-rule-privacy-policy/a384b2c4-6455-4e62-b903-ab62ab01914b/privacy")
            }
            .scaleEffect(animateItems ? 1.0 : 0.8)
            .opacity(animateItems ? 1.0 : 0.0)
            .animation(.easeOut(duration: 0.6).delay(0.1), value: animateItems)
            
            SettingsRowView(
                icon: "envelope",
                title: "Contact Us",
                subtitle: "Get in touch with support",
                color: Color.appAccentYellow
            ) {
                openURL("https://forms.gle/b6W7BXxD1v8HiDMw9")
            }
            .scaleEffect(animateItems ? 1.0 : 0.8)
            .opacity(animateItems ? 1.0 : 0.0)
            .animation(.easeOut(duration: 0.6).delay(0.2), value: animateItems)
            
            SettingsRowView(
                icon: "star",
                title: "Rate App",
                subtitle: "Share your experience",
                color: Color.appSoftPurple
            ) {
                requestReview()
            }
            .scaleEffect(animateItems ? 1.0 : 0.8)
            .opacity(animateItems ? 1.0 : 0.0)
            .animation(.easeOut(duration: 0.6).delay(0.3), value: animateItems)
        }
    }
    
    private var sampleDataSection: some View {
        VStack(spacing: 15) {
            Rectangle()
                .fill(Color.appLightGray)
                .frame(height: 1)
                .padding(.vertical, 10)
                .opacity(animateItems ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.6).delay(0.35), value: animateItems)
            
            SettingsRowView(
                icon: "doc.badge.plus",
                title: "Load sample data",
                subtitle: "Add sample principles for testing",
                color: Color.appSuccessGreen
            ) {
                viewModel.loadSampleData()
                showingSampleDataAlert = true
            }
            .scaleEffect(animateItems ? 1.0 : 0.8)
            .opacity(animateItems ? 1.0 : 0.0)
            .animation(.easeOut(duration: 0.6).delay(0.4), value: animateItems)
        }
        .alert("Sample data loaded", isPresented: $showingSampleDataAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("\(SampleData.principleTexts.count) sample principles have been added. Switch to Principles tab to see them.")
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 15) {
            Rectangle()
                .fill(Color.appLightGray)
                .frame(height: 1)
                .padding(.vertical, 10)
                .opacity(animateItems ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.6).delay(0.4), value: animateItems)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("App Version")
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(Color.appTextBlue)
                    
                    Text("1.0.0")
                        .font(.playfairDisplay(14, weight: .regular))
                        .foregroundColor(Color.appDarkGray)
                }
                
                Spacer()
                
                Image(systemName: "info.circle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color.appLightOrange)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(AppColors.cardGradient)
                    .shadow(color: Color.appTextBlue.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(animateItems ? 1.0 : 0.8)
            .opacity(animateItems ? 1.0 : 0.0)
            .animation(.easeOut(duration: 0.6).delay(0.5), value: animateItems)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("About")
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(Color.appTextBlue)
                
                Text("MyQuiet helps you capture and organize the personal principles that guide your life. Keep your core values and beliefs in one focused, distraction-free space.")
                    .font(.playfairDisplay(14, weight: .regular))
                    .foregroundColor(Color.appDarkGray)
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(AppColors.cardGradient)
                    .shadow(color: Color.appTextBlue.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(animateItems ? 1.0 : 0.8)
            .opacity(animateItems ? 1.0 : 0.0)
            .animation(.easeOut(duration: 0.6).delay(0.6), value: animateItems)
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
}

struct SettingsRowView: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 45, height: 45)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(Color.appTextBlue)
                        .multilineTextAlignment(.leading)
                    
                    Text(subtitle)
                        .font(.playfairDisplay(13, weight: .regular))
                        .foregroundColor(Color.appDarkGray)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.appDarkGray.opacity(0.6))
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(AppColors.cardGradient)
                    .shadow(color: Color.appTextBlue.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    SettingsView(viewModel: PrinciplesViewModel())
}
