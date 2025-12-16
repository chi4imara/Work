import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingTerms = false
    @State private var showingPrivacy = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 50, weight: .medium))
                            .foregroundColor(AppColors.primaryYellow)
                        
                        Text("Settings")
                            .font(.ubuntu(24, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                    
                    VStack(spacing: 20) {
                        SettingsSection(title: "Legal") {
                            VStack(spacing: 0) {
                                SettingsRow(
                                    icon: "doc.text",
                                    title: "Terms and Conditions",
                                    action: {
                                        openURL("https://www.termsfeed.com/live/8251c289-aa54-463e-a17c-077621be55c4")
                                    }
                                )
                                
                                Divider()
                                    .background(AppColors.primaryText.opacity(0.1))
                                
                                SettingsRow(
                                    icon: "shield",
                                    title: "Privacy Policy",
                                    action: {
                                        openURL("https://www.termsfeed.com/live/5919b6e3-86b1-4a6c-aea2-b63117eafb74")
                                    }
                                )
                            }
                        }
                        
                        SettingsSection(title: "Support") {
                            VStack(spacing: 0) {
                                SettingsRow(
                                    icon: "envelope",
                                    title: "Contact Us",
                                    action: {
                                        openURL("https://www.termsfeed.com/live/5919b6e3-86b1-4a6c-aea2-b63117eafb74")
                                    }
                                )
                                
                                Divider()
                                    .background(AppColors.primaryText.opacity(0.1))
                                
                                SettingsRow(
                                    icon: "star",
                                    title: "Rate App",
                                    action: {
                                        requestReview()
                                    }
                                )
                            }
                        }
                        
                        VStack(spacing: 8) {
                            Text("ReadLoom")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryText)
                        }
                        .padding(.top, 30)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 100)
            }
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
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(AppColors.cardBackground)
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
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.primaryYellow)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
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
                BackgroundView()
                
                VStack(spacing: 20) {
                    Image(systemName: "safari")
                        .font(.system(size: 50, weight: .light))
                        .foregroundColor(AppColors.primaryYellow)
                    
                    Text("Opening in Safari...")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                    
                    Button("Open Link") {
                        if let url = URL(string: url) {
                            UIApplication.shared.open(url)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryBlue)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.primaryYellow)
                    )
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(AppColors.primaryText)
            )
        }
        .onAppear {
            if let url = URL(string: url) {
                UIApplication.shared.open(url)
            }
        }
    }
}

#Preview {
    SettingsView()
}
