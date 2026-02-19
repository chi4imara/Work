import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    @StateObject private var dataManager = DataManager.shared
    @State private var showSampleDataAlert = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(.appTextPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        SettingsRow(
                            icon: "shield.fill",
                            title: "Privacy Policy",
                            action: {
                                if let url = URL(string: "https://doc-hosting.flycricket.io/presently-kind-sparks-privacy-policy/0e03a93e-7705-416c-a1e1-afb2f9322169/privacy") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        )
                        
                        SettingsRow(
                            icon: "envelope.fill",
                            title: "Contact Us",
                            action: {
                                if let url = URL(string: "https://forms.gle/oRHshq1DTnr6B9iB9") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        )
                        
                        SettingsRow(
                            icon: "star.fill",
                            title: "Rate App",
                            action: {
                                requestReview()
                            }
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    .padding(.bottom, 120)
                }
            }
        }
        .alert("Sample data loaded", isPresented: $showSampleDataAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Sample people and gift ideas have been loaded. You can now test the app.")
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
                    .font(.system(size: 20))
                    .foregroundColor(.appAccent)
                    .frame(width: 24)
                
                Text(title)
                    .font(.ubuntu(16))
                    .foregroundColor(.appTextPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.appTextSecondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.appCard)
            )
        }
    }
}

struct SettingsInfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.appAccent)
                .frame(width: 24)
            
            Text(title)
                .font(.ubuntu(16))
                .foregroundColor(.appTextPrimary)
            
            Spacer()
            
            Text(value)
                .font(.ubuntu(14))
                .foregroundColor(.appTextSecondary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appCard)
        )
    }
}

#Preview {
    SettingsView()
}
