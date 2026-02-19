import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var practiceViewModel: PracticeViewModel
    @Environment(\.requestReview) var requestReview
    @State private var showingSampleDataLoaded = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(.appTitle)
                        .foregroundColor(AppColors.primaryNavy)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 0) {
                        headerSection
                        
                        VStack(spacing: 25) {
                            supportSection
                            
                            legalSection
                        }
                        .padding(.top, 30)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [AppColors.primaryOrange, AppColors.lightBlue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            .shadow(color: AppColors.primaryOrange.opacity(0.3), radius: 15, x: 0, y: 8)
            
            VStack(spacing: 8) {
                Text("Evening Rest")
                    .font(.appTitle)
                    .foregroundColor(AppColors.primaryNavy)
                
                Text("Your personal relaxation companion")
                    .font(.bodyText)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.top, 20)
        .padding(.horizontal, 40)
    }
    
    private var supportSection: some View {
        SettingsSection(title: "Support & Feedback") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "envelope.fill",
                    title: "Contact Us",
                    iconColor: AppColors.lightBlue,
                    action: {
                        openURL("https://www.termsfeed.com/live/7158da20-8240-4f17-8af8-6c5542b4086b")
                    }
                )
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsRow(
                    icon: "star.fill",
                    title: "Rate App",
                    iconColor: AppColors.primaryOrange,
                    action: {
                        requestReview()
                    }
                )
            }
        }
    }
    
    private var legalSection: some View {
        SettingsSection(title: "Legal") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "doc.text.fill",
                    title: "Privacy Policy",
                    iconColor: AppColors.softGreen,
                    action: {
                        openURL("https://www.termsfeed.com/live/7158da20-8240-4f17-8af8-6c5542b4086b")
                    }
                )
            }
        }
    }
    
    private var testingSection: some View {
        SettingsSection(title: "Testing") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "square.and.arrow.down.fill",
                    title: "Load Sample Data",
                    iconColor: AppColors.primaryOrange,
                    action: {
                        practiceViewModel.loadSampleData()
                        showingSampleDataLoaded = true
                    }
                )
            }
        }
        .alert("Sample Data Loaded", isPresented: $showingSampleDataLoaded) {
            Button("OK") { }
        } message: {
            Text("Sample practices and history for the last 14 days have been loaded. Check Today, History, and Statistics.")
        }
    }
    
    private var appInfoSection: some View {
        SettingsSection(title: "App Information") {
            VStack(spacing: 0) {
                SettingsInfoRow(
                    icon: "info.circle.fill",
                    title: "Version",
                    value: "1.0.0",
                    iconColor: AppColors.primaryNavy
                )
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsInfoRow(
                    icon: "calendar.circle.fill",
                    title: "Release Date",
                    value: "February 2026",
                    iconColor: AppColors.mediumGray
                )
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
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
                .font(.cardTitle)
                .foregroundColor(AppColors.primaryNavy)
                .padding(.horizontal, 20)
            
            content
                .background(AppColors.cardGradient)
                .cornerRadius(16)
                .shadow(color: AppColors.primaryNavy.opacity(0.1), radius: 8, x: 0, y: 4)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(iconColor)
                    .frame(width: 30, height: 30)
                    .background(iconColor.opacity(0.1))
                    .clipShape(Circle())
                
                Text(title)
                    .font(.bodyText)
                    .foregroundColor(AppColors.primaryNavy)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.mediumGray)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

struct SettingsInfoRow: View {
    let icon: String
    let title: String
    let value: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(iconColor)
                .frame(width: 30, height: 30)
                .background(iconColor.opacity(0.1))
                .clipShape(Circle())
            
            Text(title)
                .font(.bodyText)
                .foregroundColor(AppColors.primaryNavy)
            
            Spacer()
            
            Text(value)
                .font(.caption)
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

struct CreativeSettingsLayout: View {
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 15) {
                    SettingsCardButton(
                        icon: "envelope.fill",
                        title: "Contact",
                        color: AppColors.lightBlue,
                        action: {}
                    )
                    
                    SettingsCardButton(
                        icon: "doc.text.fill",
                        title: "Privacy",
                        color: AppColors.softGreen,
                        action: {}
                    )
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 15) {
                    SettingsCardButton(
                        icon: "star.fill",
                        title: "Rate App",
                        color: AppColors.primaryOrange,
                        action: {}
                    )
                    
                    SettingsCardButton(
                        icon: "info.circle.fill",
                        title: "About",
                        color: AppColors.primaryNavy,
                        action: {}
                    )
                }
            }
            
            ZStack {
                Circle()
                    .stroke(AppColors.mediumGray.opacity(0.2), lineWidth: 2)
                    .frame(width: 200, height: 200)
                
                ForEach(0..<4) { index in
                    let angle = Double(index) * 90 * .pi / 180
                    let x = cos(angle) * 80
                    let y = sin(angle) * 80
                    
                    CircularSettingsButton(
                        icon: ["envelope.fill", "star.fill", "doc.text.fill", "info.circle.fill"][index],
                        color: [AppColors.lightBlue, AppColors.primaryOrange, AppColors.softGreen, AppColors.primaryNavy][index],
                        action: {}
                    )
                    .offset(x: x, y: y)
                }
            }
        }
        .padding(20)
    }
}

struct SettingsCardButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(color)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(AppColors.primaryNavy)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CircularSettingsButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(color)
                .clipShape(Circle())
                .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(practiceViewModel: PracticeViewModel())
    }
}
