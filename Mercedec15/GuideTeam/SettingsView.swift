import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.requestReview) private var requestReview
    @EnvironmentObject var spaListVM: SPAListViewModel
    @EnvironmentObject var bookingsVM: BookingsViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    @EnvironmentObject var progressVM: ProgressViewModel
    @State private var showingSampleDataLoaded = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        appSection
                        
                        legalSection
                        
                        supportSection
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.primaryPurple)
                }
            }
            .preferredColorScheme(.dark)
            .alert("Sample Data Loaded", isPresented: $showingSampleDataLoaded) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Salons, bookings, and profile have been filled with sample data for testing.")
            }
        }
    }
    
    private var sampleDataSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Testing")
                .font(.playfairBold(size: 20))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 2) {
                SettingsItem(
                    title: "Load Sample Data",
                    subtitle: "Fill app with sample salons, bookings and profile",
                    icon: "square.and.arrow.down.fill",
                    iconColor: ColorTheme.accentGreen,
                    action: loadSampleData
                )
            }
            .padding(16)
            .background(ColorTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private func loadSampleData() {
        spaListVM.loadSampleData()
        spaListVM.applyFilters()
        bookingsVM.loadSampleData()
        profileVM.loadSampleData()
        progressVM.recalculate(bookings: bookingsVM.bookings, visitGoal: profileVM.profile.visitGoal)
        showingSampleDataLoaded = true
    }
    
    private var appSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("App")
                .font(.playfairBold(size: 20))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 2) {
                SettingsItem(
                    title: "Rate App",
                    subtitle: "Help us improve SpaBuddy",
                    icon: "star.fill",
                    iconColor: ColorTheme.accentOrange,
                    action: {
                        requestReview()
                    }
                )
                
                Divider()
                    .background(ColorTheme.cardBorder)
                
                ShareAppRow(
                    title: "Share App",
                    subtitle: "Tell your friends about SpaBuddy",
                    icon: "square.and.arrow.up",
                    iconColor: ColorTheme.primaryBlue
                )
            }
            .padding(16)
            .background(ColorTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private var legalSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Legal")
                .font(.playfairBold(size: 20))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 2) {
                SettingsItem(
                    title: "Privacy Policy",
                    subtitle: "How we protect your data",
                    icon: "lock.shield",
                    iconColor: ColorTheme.accentGreen,
                    action: {
                        openURL("https://doc-hosting.flycricket.io/thermaguide-privacy-policy/a7ff0f5e-0586-4398-9079-964402d813db/privacy")
                    }
                )
            }
            .padding(16)
            .background(ColorTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private var supportSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Support")
                .font(.playfairBold(size: 20))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 2) {
                SettingsItem(
                    title: "Contact Us",
                    subtitle: "Help Us!",
                    icon: "envelope",
                    iconColor: ColorTheme.accentPink,
                    action: {
                        openURL("https://forms.gle/VcbpjajXXNTwJM8f9")
                    }
                )
            }
            .padding(16)
            .background(ColorTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func openEmail() {
        if let url = URL(string: "mailto:support@spabuddy.com") {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsItem: View {
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(iconColor)
                    .frame(width: 28, height: 28)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.playfairSemiBold(size: 16))
                        .foregroundColor(ColorTheme.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(subtitle)
                        .font(.playfairRegular(size: 14))
                        .foregroundColor(ColorTheme.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                if title != "App Version" {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(ColorTheme.secondaryText)
                }
            }
            .padding(.vertical, 8)
        }
    }
}

struct ShareAppRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    
    private let shareText = "Check out SpaBuddy - the best app for finding SPA salons!"
    
    var body: some View {
        ShareLink(
            item: shareText,
            subject: Text("SpaBuddy"),
            message: Text(shareText)
        ) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(iconColor)
                    .frame(width: 28, height: 28)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.playfairSemiBold(size: 16))
                        .foregroundColor(ColorTheme.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(subtitle)
                        .font(.playfairRegular(size: 14))
                        .foregroundColor(ColorTheme.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(ColorTheme.secondaryText)
            }
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SPAListViewModel())
        .environmentObject(BookingsViewModel())
        .environmentObject(ProfileViewModel())
        .environmentObject(ProgressViewModel())
}
