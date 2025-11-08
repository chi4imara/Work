import SwiftUI
import StoreKit

extension Notification.Name {
    static let dataCleared = Notification.Name("dataCleared")
}

struct SettingsView: View {
    @Environment(\.requestReview) private var requestReview
    @ObservedObject private var medicationViewModel = MedicationViewModel.shared
    @ObservedObject private var referenceViewModel = ReferenceViewModel.shared
    @State private var showingClearDataAlert = false
    @State private var showingDataClearedAlert = false
    @State private var selectedTab = 0
    @State private var animateCards = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                        Text("Settings")
                            .font(AppFonts.largeTitle().bold())
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    heroSection
                    
                    tabSelector
                    
                    Group {
                        switch selectedTab {
                        case 0:
                            quickActionsContent
                        case 1:
                            legalContent
                        case 2:
                            supportContent
                        case 3:
                            dataContent
                        default:
                            quickActionsContent
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: selectedTab)
                }
                .padding(.bottom, 100)
            }
        }
        .alert("Clear All Data", isPresented: $showingClearDataAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear All Data", role: .destructive) {
                clearAllData()
            }
        } message: {
            Text("This will permanently delete all your medications, doses, and references. This action cannot be undone.")
        }
        .alert("Data Cleared", isPresented: $showingDataClearedAlert) {
            Button("OK") { }
        } message: {
            Text("All your data has been successfully cleared.")
        }
        .onAppear {
            medicationViewModel.loadData()
            referenceViewModel.loadReferences()
            
            withAnimation(.easeInOut(duration: 0.8).delay(0.2)) {
                animateCards = true
            }
        }
    }
    
    private var heroSection: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [AppColors.accentBlue.opacity(0.3), Color.clear],
                            center: .center,
                            startRadius: 20,
                            endRadius: 60
                        )
                    )
                    .frame(width: 120, height: 120)
                    .blur(radius: 20)
                
                Circle()
                    .fill(AppColors.cardBackground)
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "pills.fill")
                            .font(.system(size: 35))
                            .foregroundColor(AppColors.accentBlue)
                    )
                    .shadow(color: AppColors.accentBlue.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .scaleEffect(animateCards ? 1.0 : 0.8)
            .opacity(animateCards ? 1.0 : 0.0)
            
            VStack(spacing: 8) {
                Text("Daily Med Care Tracker")
                    .font(AppFonts.largeTitle())
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Your personal medication companion")
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            .opacity(animateCards ? 1.0 : 0.0)
            .offset(y: animateCards ? 0 : 20)
        }
        .padding(.bottom, 40)
        .padding(.top, 10)
        .padding(.horizontal, 20)
    }
    
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(0..<4) { index in
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: tabIcons[index])
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(selectedTab == index ? AppColors.primaryText : AppColors.secondaryText)
                        
                        Text(tabTitles[index])
                            .font(AppFonts.caption())
                            .fontWeight(selectedTab == index ? .semibold : .regular)
                            .foregroundColor(selectedTab == index ? AppColors.primaryText : AppColors.secondaryText)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedTab == index ? Color.yellow.opacity(0.3) : Color.clear)
                            .shadow(color: selectedTab == index ? .black.opacity(0.1) : .clear, radius: 5, x: 0, y: 2)
                    )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    private var quickActionsContent: some View {
        VStack(spacing: 20) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 15) {
                ForEach(Array(quickActionItems.enumerated()), id: \.offset) { index, item in
                    QuickActionCard(
                        item: item,
                        delay: Double(index) * 0.1
                    )
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var legalContent: some View {
        VStack(spacing: 15) {
            ForEach(legalItems, id: \.title) { item in
                ModernSettingsRow(item: item)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var supportContent: some View {
        VStack(spacing: 15) {
            ForEach(supportItems, id: \.title) { item in
                ModernSettingsRow(item: item)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var dataContent: some View {
        VStack(spacing: 15) {
            ForEach(dataItems, id: \.title) { item in
                ModernSettingsRow(item: item)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private let tabIcons = ["bolt.fill", "doc.text.fill", "questionmark.circle.fill", "gear"]
    private let tabTitles = ["Quick", "Legal", "Support", "Data"]
    
    private var quickActionItems: [SettingsItem] {
        [
            SettingsItem(icon: "star.fill", title: "Rate App", subtitle: "Help us improve", color: AppColors.warningYellow, action: { requestReview() }),
            SettingsItem(icon: "envelope.fill", title: "Contact", subtitle: "Get in touch", color: AppColors.accentBlue, action: { openURL("https://www.termsfeed.com/live/fc15b3b8-ae07-433b-aff8-064898aa78e6") })
        ]
    }
    
    private var legalItems: [SettingsItem] {
        [
            SettingsItem(icon: "doc.text.fill", title: "Terms and Conditions", subtitle: "Read our terms", color: AppColors.accentBlue, action: { openURL("https://www.termsfeed.com/live/6cc0ca17-9e48-4a25-8f22-d060908b3f79") }),
            SettingsItem(icon: "hand.raised.fill", title: "Privacy Policy", subtitle: "Your privacy matters", color: AppColors.primaryPurple, action: { openURL("https://www.termsfeed.com/live/fc15b3b8-ae07-433b-aff8-064898aa78e6") })
        ]
    }
    
    private var supportItems: [SettingsItem] {
        [
            SettingsItem(icon: "envelope.fill", title: "Contact Us", subtitle: "Send feedback", color: AppColors.accentBlue, action: { openURL("https://www.termsfeed.com/live/fc15b3b8-ae07-433b-aff8-064898aa78e6") }),
            SettingsItem(icon: "star.fill", title: "Rate App", subtitle: "Rate on App Store", color: AppColors.warningYellow, action: { requestReview() }),
        ]
    }
    
    private var dataItems: [SettingsItem] {
        [
            SettingsItem(icon: "trash.fill", title: "Clear All Data", subtitle: "Delete everything", color: AppColors.errorRed, action: { showingClearDataAlert = true })
        ]
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func clearAllData() {
        DataManager.shared.clearAllData()
        
        medicationViewModel.medications = []
        medicationViewModel.doses = []
        referenceViewModel.references = []
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
        
        NotificationCenter.default.post(name: .dataCleared, object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showingDataClearedAlert = true
        }
        
        print("✅ All data cleared successfully!")
    }
}


struct AnimatedBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(0..<8, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: CGFloat.random(in: 20...60))
                    .offset(
                        x: animate ? CGFloat.random(in: -200...200) : CGFloat.random(in: -100...100),
                        y: animate ? CGFloat.random(in: -400...400) : CGFloat.random(in: -200...200)
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 3...6))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.5),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct QuickActionCard: View {
    let item: SettingsItem
    let delay: Double
    
    @State private var animate = false
    
    var body: some View {
        Button(action: item.action) {
            VStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [item.color.opacity(0.2), item.color.opacity(0.05)],
                                center: .center,
                                startRadius: 10,
                                endRadius: 30
                            )
                        )
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: item.icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(item.color)
                }
                
                VStack(spacing: 4) {
                    Text(item.title)
                        .font(AppFonts.callout())
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.cardText)
                    
                    Text(item.subtitle)
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.cardSecondaryText)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 25)
            .concaveCard(color: AppColors.cardBackground)
        }
        .scaleEffect(animate ? 1.0 : 0.8)
        .opacity(animate ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(delay)) {
                animate = true
            }
        }
    }
}

struct ModernSettingsRow: View {
    let item: SettingsItem
    @State private var animate = false
    
    var body: some View {
        Button(action: item.action) {
            HStack(spacing: 15) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(item.color.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: item.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(item.color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(AppFonts.callout())
                        .fontWeight(.medium)
                        .foregroundColor(AppColors.cardText)
                    
                    Text(item.subtitle)
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.cardSecondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.cardSecondaryText)
            }
            .padding(20)
            .concaveCard(color: AppColors.cardBackground)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(animate ? 1.0 : 0.95)
        .opacity(animate ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.1)) {
                animate = true
            }
        }
    }
}

struct FloatingActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    @State private var animate = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(title)
                    .font(AppFonts.callout())
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 15)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
            )
        }
        .scaleEffect(animate ? 1.0 : 0.9)
        .opacity(animate ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.5)) {
                animate = true
            }
        }
    }
}

struct SettingsItem {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
}

#Preview {
    SettingsView()
}
