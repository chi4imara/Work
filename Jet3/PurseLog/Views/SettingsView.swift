import SwiftUI
import StoreKit
import Foundation

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    @StateObject private var bagViewModel = BagViewModel()
    @StateObject private var notesViewModel = NotesViewModel()
    @State private var showingExportSheet = false
    @State private var exportText = ""
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(spacing: 0) {
                    headerView
                    
                    VStack(spacing: 16) {
                        settingsSection
                        appInfoSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .sheet(isPresented: $showingExportSheet) {
            ExportDataView(exportText: $exportText)
        }
    }
    
    private func exportData() {
        struct ExportData: Codable {
            let bags: [Bag]
            let notes: [Note]
            let exportDate: String
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .medium
        
        let export = ExportData(
            bags: bagViewModel.bags,
            notes: notesViewModel.notes,
            exportDate: dateFormatter.string(from: Date())
        )
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        
        if let jsonData = try? encoder.encode(export),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            exportText = jsonString
            showingExportSheet = true
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            Text("Settings")
                .font(FontManager.ubuntu(.bold, size: 28))
                .foregroundColor(AppColors.primaryText)
            
            Text("Manage your app preferences")
                .font(FontManager.ubuntu(.regular, size: 16))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var settingsSection: some View {
        VStack(spacing: 12) {
            SettingsRow(
                icon: "square.and.arrow.up.fill",
                title: "Export Data",
                iconColor: AppColors.primaryBlue
            ) {
                exportData()
            }
            
            SettingsRow(
                icon: "star.fill",
                title: "Rate App",
                iconColor: AppColors.primaryYellow
            ) {
                requestReview()
            }
            
            SettingsRow(
                icon: "shield.fill",
                title: "Privacy Policy",
                iconColor: AppColors.primaryPurple
            ) {
                openURL("https://www.freeprivacypolicy.com/live/29449b81-7b46-419b-bce6-835d140bed05")
            }
            
            SettingsRow(
                icon: "doc.text.fill",
                title: "Terms of Use",
                iconColor: AppColors.primaryBlue
            ) {
                openURL("https://www.freeprivacypolicy.com/live/5f250a8b-9b21-47cf-ae57-10ec495e8157")
            }
            
            SettingsRow(
                icon: "envelope.fill",
                title: "Contact Us",
                iconColor: AppColors.success
            ) {
                openURL("https://forms.gle/VsFyF4GcihcsEMD86")
            }
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                Image(systemName: "handbag.fill")
                    .font(.system(size: 50))
                    .foregroundColor(AppColors.primaryYellow)
                
                Text("PurseLog")
                    .font(FontManager.ubuntu(.bold, size: 24))
                    .foregroundColor(AppColors.darkText)
                
                Text("Organize your bag collection with style")
                    .font(FontManager.ubuntu(.regular, size: 14))
                    .foregroundColor(AppColors.darkText)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
            }
            .padding(.vertical, 32)
            .frame(maxWidth: .infinity)
            .cardStyle()
            
            Text("© 2024 PurseLog. All rights reserved.")
                .font(FontManager.ubuntu(.regular, size: 12))
                .foregroundColor(AppColors.secondaryText)
                .padding(.top, 8)
        }
        .padding(.top, 20)
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
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
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(FontManager.ubuntu(.medium, size: 16))
                    .foregroundColor(AppColors.darkText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.darkText.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .cardStyle()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
