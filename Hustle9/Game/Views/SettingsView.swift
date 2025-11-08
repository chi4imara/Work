import SwiftUI
import StoreKit


struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingRateAlert = false
    
    @ViewBuilder
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            SettingsSection(title: "Legal") {
                                SettingsRow(
                                    icon: "doc.text",
                                    title: "Terms & Conditions",
                                    action: {
                                        openURL("https://docs.google.com/document/d/1C59MWvVErW6N7RpENWuXgOUwHhG2Fw9I02tynfWyfJc/edit?usp=sharing")
                                    }
                                )
                                
                                Divider()
                                    .overlay(Color.white)
                                
                                SettingsRow(
                                    icon: "hand.raised",
                                    title: "Privacy Policy",
                                    action: {
                                        openURL("https://docs.google.com/document/d/1D1JH17dwcXDtH5STq62M9Cv5eExU70v_8k8RVjWWsHw/edit?usp=sharing")
                                    }
                                )
                            }
                            
                            SettingsSection(title: "Support") {
                                SettingsRow(
                                    icon: "envelope",
                                    title: "Contact Us",
                                    action: {
                                        openURL("https://forms.gle/qpmEnfvx3bALNDdX7")
                                    }
                                )
                                
                                Divider()
                                    .overlay(Color.white)
                                
                                SettingsRow(
                                    icon: "star",
                                    title: "Rate App",
                                    action: {
                                        requestReview()
                                    }
                                )
                            }
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .font(AppFonts.title1)
                        .foregroundColor(AppColors.primaryText)
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.accent)
                    }
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
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

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(AppFonts.title3)
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 4)
            
            VStack(spacing: 1) {
                content
            }
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
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.accent)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    ZStack {
        BackgroundView()
        SettingsView()
    }
}
