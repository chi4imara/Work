import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    @State private var showingSampleDataAlert = false
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: 20) {
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(ColorTheme.accentColor)
                        
                        VStack(spacing: 8) {
                            Text("Body & Care")
                                .font(.playfair(24, weight: .bold))
                                .foregroundColor(ColorTheme.textColor)
                            
                            Text("Your gentle companion for body wellness")
                                .font(.playfair(16))
                                .foregroundColor(ColorTheme.secondaryColor)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.vertical, 40)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 20) {
                        SettingsCard(
                            icon: "lock.shield",
                            title: "Privacy",
                            subtitle: "Policy"
                        ) {
                            openURL("https://www.freeprivacypolicy.com/live/cbf406c5-23b3-4778-a1cb-6a1219bf070d")
                        }
                        
                        SettingsCard(
                            icon: "envelope.circle",
                            title: "Contact",
                            subtitle: "Support"
                        ) {
                            openURL("https://forms.gle/nmpXbgEypj3fZfL87")
                        }
                        
                        SettingsCard(
                            icon: "star.circle",
                            title: "Rate",
                            subtitle: "App"
                        ) {
                            requestReview()
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .alert("Sample Data Loaded", isPresented: $showingSampleDataAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Sample practices and history have been loaded for testing.")
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestReview() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
    private func loadSampleData() {
        DataManager.shared.loadSampleData()
        showingSampleDataAlert = true
    }
}

struct SettingsCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(ColorTheme.accentColor.opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(ColorTheme.accentColor)
                }
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.playfair(16, weight: .medium))
                        .foregroundColor(ColorTheme.textColor)
                    
                    Text(subtitle)
                        .font(.playfair(14))
                        .foregroundColor(ColorTheme.secondaryColor)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .background(ColorTheme.cardGradient)
            .cornerRadius(20)
            .shadow(color: ColorTheme.shadowColor, radius: 8, x: 0, y: 4)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

struct FloatingGridLayout: View {
    let items: [SettingsItem]
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                SettingsCard(
                    icon: items[0].icon,
                    title: items[0].title,
                    subtitle: items[0].subtitle,
                    action: items[0].action
                )
                
                SettingsCard(
                    icon: items[1].icon,
                    title: items[1].title,
                    subtitle: items[1].subtitle,
                    action: items[1].action
                )
            }
            
            HStack(spacing: 20) {
                Spacer()
                    .frame(width: 40)
                
                SettingsCard(
                    icon: items[2].icon,
                    title: items[2].title,
                    subtitle: items[2].subtitle,
                    action: items[2].action
                )
                
                SettingsCard(
                    icon: items[3].icon,
                    title: items[3].title,
                    subtitle: items[3].subtitle,
                    action: items[3].action
                )
                
                Spacer()
                    .frame(width: 40)
            }
        }
    }
}

struct SettingsItem {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
}

#Preview {
    SettingsView()
}
