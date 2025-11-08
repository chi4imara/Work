import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Settings")
                            .font(.appLargeTitle)
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            SettingsSection(title: "App") {
                                SettingsRow(
                                    title: "Rate App",
                                    icon: "star.fill",
                                    action: {
                                        requestReview()
                                    }
                                )
                            }
                            
                            SettingsSection(title: "Legal") {
                                SettingsRow(
                                    title: "Terms of Use",
                                    icon: "doc.text",
                                    action: {
                                        openURL("https://docs.google.com/document/d/1OwJHqqiIxv-G-DJebW_zSgcRuZ3cWu2q7L3L-o1AqbU/edit?usp=sharing")
                                    }
                                )
                                
                                Divider()
                                    .overlay {
                                        Color.white
                                    }
                                    .frame(maxWidth: .infinity)
                                
                                SettingsRow(
                                    title: "Privacy Policy",
                                    icon: "hand.raised.fill",
                                    action: {
                                        openURL("https://docs.google.com/document/d/1Ns0L0bLF-SMPZxa21wzgEjGQreMmw5qlm92JHJQf0Pc/edit?usp=sharing")
                                    }
                                )
                            }
                            
                            SettingsSection(title: "Contact") {
                                SettingsRow(
                                    title: "Contact Us",
                                    icon: "envelope.fill",
                                    action: {
                                        openURL("https://forms.gle/NA6w5qm4g4WekHZe7")
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
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
                .font(.appHeadline)
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 4)
            
            VStack(spacing: 1) {
                content
            }
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(AppColors.yellow)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.appBody)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(16)
        }
    }
}

#Preview {
    SettingsView()
}
