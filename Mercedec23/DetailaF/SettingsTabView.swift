import SwiftUI

struct SettingsTabView: View {
    @EnvironmentObject private var accessoryViewModel: AccessoryViewModel
    @EnvironmentObject private var collectionViewModel: CollectionViewModel
    @EnvironmentObject private var progressViewModel: ProgressViewModel
    @StateObject private var settingsVM = SettingsViewModel()
    @State private var showingSampleDataAlert = false
    @State private var sampleDataAlertMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 28) {
                        appHeaderCard
                        supportSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .alert("Sample Data", isPresented: $showingSampleDataAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(sampleDataAlertMessage)
            }
        }
    }
    
    private var appHeaderCard: some View {
        VStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.cardGradient)
                    .frame(height: 1)
                    .opacity(0)
                
                Circle()
                    .fill(AppColors.buttonGradient)
                    .frame(width: 88, height: 88)
                    .shadow(color: AppColors.primaryYellow.opacity(0.35), radius: 12, x: 0, y: 6)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundColor(AppColors.backgroundWhite)
            }
            
            VStack(spacing: 6) {
                Text("AccessorizeHer")
                    .font(.playfairDisplay(26, weight: .bold))
                    .foregroundColor(AppColors.textBlue)
            }
            
            Text("Discover the perfect accessories for any outfit, try virtual looks, and save your favorites.")
                .font(.playfairDisplay(14, weight: .medium))
                .foregroundColor(AppColors.darkGray)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 16)
        }
        .padding(.vertical, 28)
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardGradient)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 8)
    }
    
    private var supportSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionLabel("Support")
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                SettingsActionCard(
                    icon: "star.fill",
                    title: "Rate App",
                    color: AppColors.primaryYellow
                ) {
                    settingsVM.rateApp()
                }
                
                SettingsActionCard(
                    icon: "envelope.fill",
                    title: "Contact Us",
                    color: AppColors.accentPink
                ) {
                    settingsVM.contactSupport()
                }
                
                SettingsActionCard(
                    icon: "shield.fill",
                    title: "Privacy Policy",
                    color: AppColors.textBlue
                ) {
                    settingsVM.openPrivacyPolicy()
                }
                
                SettingsActionCard(
                    icon: "square.and.arrow.up.fill",
                    title: "Share App",
                    color: AppColors.accentGreen
                ) {
                    ShareHelper.shareApp()
                }
            }
        }
    }
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionLabel("About")
            
            HStack(spacing: 0) {
                aboutItem(title: "1.0.0", subtitle: "Version")
                Divider()
                    .frame(height: 36)
                    .background(AppColors.lightGray)
                aboutItem(title: "2026", subtitle: "Year")
                Divider()
                    .frame(height: 36)
                    .background(AppColors.lightGray)
                aboutItem(title: "iOS 16+", subtitle: "Platform")
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
    }
    
    private var testingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionLabel("Testing")
            
            Button(action: loadSampleData) {
                HStack(spacing: 14) {
                    Image(systemName: "square.and.arrow.down.fill")
                        .font(.system(size: 22))
                        .foregroundColor(AppColors.primaryYellow)
                        .frame(width: 44, height: 44)
                        .background(AppColors.primaryYellow.opacity(0.15))
                        .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Load Sample Data")
                            .font(.playfairDisplay(17, weight: .semibold))
                            .foregroundColor(AppColors.textBlue)
                        
                        Text("Add sample accessories, collections and try-on history for testing")
                            .font(.playfairDisplay(13, weight: .medium))
                            .foregroundColor(AppColors.darkGray)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.darkGray.opacity(0.6))
                }
                .padding(18)
                .background(AppColors.cardGradient)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.primaryYellow.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.playfairDisplay(15, weight: .semibold))
            .foregroundColor(AppColors.textBlue)
            .padding(.leading, 4)
    }
    
    private func aboutItem(title: String, subtitle: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.playfairDisplay(16, weight: .bold))
                .foregroundColor(AppColors.textBlue)
            Text(subtitle)
                .font(.playfairDisplay(12, weight: .medium))
                .foregroundColor(AppColors.darkGray)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func loadSampleData() {
        let data = SampleData.generate()
        accessoryViewModel.loadSampleData(data.accessories)
        collectionViewModel.loadSampleData(data.collections)
        progressViewModel.loadSampleData(data.sessions)
        sampleDataAlertMessage = "Sample data has been loaded. You now have \(data.accessories.count) accessories, \(data.collections.count) collections and \(data.sessions.count) try-on sessions."
        showingSampleDataAlert = true
    }
}

struct SettingsActionCard: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(0.15))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.playfairDisplay(14, weight: .semibold))
                    .foregroundColor(AppColors.textBlue)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .padding(.horizontal, 12)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
    }
}

#Preview {
    SettingsTabView()
        .environmentObject(AccessoryViewModel())
        .environmentObject(CollectionViewModel())
        .environmentObject(ProgressViewModel())
}
