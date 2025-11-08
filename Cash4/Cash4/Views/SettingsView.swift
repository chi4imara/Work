import SwiftUI
import StoreKit
import UniformTypeIdentifiers

struct SettingsView: View {
    @ObservedObject var viewModel: CollectionViewModel
    @State private var showingClearDataAlert = false
    @State private var showingExportOptions = false
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Text("Settings")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    VStack(spacing: 20) {
                        SettingsSection(title: "Data Management") {
                            VStack(spacing: 12) {
                                SettingsRow(
                                    icon: "trash.circle",
                                    title: "Clear All Data",
                                    subtitle: "Remove all collection items and data",
                                    color: .red
                                ) {
                                    showingClearDataAlert = true
                                }
                                
                                SettingsRow(
                                    icon: "square.and.arrow.up",
                                    title: "Export Data",
                                    subtitle: "Export your collection data",
                                    color: .accentGreen
                                ) {
                                    showingExportOptions = true
                                }
                            }
                        }
                        
                        SettingsSection(title: "App Information") {
                            VStack(spacing: 12) {
                                SettingsRow(
                                    icon: "star.circle",
                                    title: "Rate App",
                                    subtitle: "Rate us on the App Store",
                                    color: .accentOrange
                                ) {
                                    requestReview()
                                }
                                
                                SettingsRow(
                                    icon: "envelope.circle",
                                    title: "Contact Us",
                                    subtitle: "Send us feedback or questions",
                                    color: .lightBlue
                                ) {
                                    openURL("https://google.com")
                                }
                            }
                        }
                        
                        SettingsSection(title: "Legal") {
                            VStack(spacing: 12) {
                                SettingsRow(
                                    icon: "document.circle",
                                    title: "Terms of Use",
                                    subtitle: "Read our terms and conditions",
                                    color: .accentPurple
                                ) {
                                    openURL("https://google.com")
                                }
                                
                                SettingsRow(
                                    icon: "lock.circle",
                                    title: "Privacy Policy",
                                    subtitle: "Learn about data protection",
                                    color: .accentPurple
                                ) {
                                    openURL("https://google.com")
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .alert("Clear All Data", isPresented: $showingClearDataAlert) {
            Button("Clear", role: .destructive) {
                viewModel.clearAllData()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will permanently delete all your collection items, wishlist, transactions, and sets. This action cannot be undone.")
        }
        .actionSheet(isPresented: $showingExportOptions) {
            ActionSheet(
                title: Text("Export Format"),
                message: Text("Choose the format for your data export"),
                buttons: [
                    .default(Text("JSON (Complete Data)")) {
                        exportData(format: .json)
                    },
                    .default(Text("CSV (Items Only)")) {
                        exportData(format: .csv)
                    },
                    .cancel()
                ]
            )
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func exportData(format: ExportFormat) {
        let exportData = ExportData(
            items: viewModel.items,
            wishlistItems: viewModel.wishlistItems,
            transactions: viewModel.transactions,
            sets: viewModel.sets,
            categories: viewModel.categories,
            conditions: viewModel.conditions,
            exportDate: Date()
        )
        
        do {
            let fileName: String
            let fileData: Data
            let mimeType: String
            
            switch format {
            case .json:
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                encoder.outputFormatting = .prettyPrinted
                fileData = try encoder.encode(exportData)
                fileName = "CollectionDiary_Export_\(DateFormatter.fileName.string(from: Date())).json"
                mimeType = "application/json"
                
            case .csv:
                let csvString = exportData.itemsCSV
                fileData = csvString.data(using: .utf8) ?? Data()
                fileName = "CollectionDiary_Items_\(DateFormatter.fileName.string(from: Date())).csv"
                mimeType = "text/csv"
            }
            
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            try fileData.write(to: tempURL)
            
            let activityVC = UIActivityViewController(
                activityItems: [tempURL],
                applicationActivities: nil
            )
            
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = UIApplication.shared.windows.first?.rootViewController?.view
                popover.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController?.present(activityVC, animated: true)
            }
        } catch {
            print("Export error: \(error)")
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
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            content
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
        )
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 32, height: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.callout)
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

enum ExportFormat {
    case json
    case csv
}

struct ExportData: Codable {
    let items: [CollectionItem]
    let wishlistItems: [WishlistItem]
    let transactions: [Transaction]
    let sets: [CollectionSet]
    let categories: [String]
    let conditions: [String]
    let exportDate: Date
    let appVersion: String = "1.0.0"
    let exportFormat: String = "Collection Diary Export"
    
    var summary: String {
        return """
        Collection Diary Export
        
        Total Items: \(items.count)
        Wishlist Items: \(wishlistItems.count)
        Transactions: \(transactions.count)
        Sets: \(sets.count)
        Categories: \(categories.count)
        Export Date: \(DateFormatter.export.string(from: exportDate))
        """
    }
    
    var itemsCSV: String {
        let headers = "Name,Category,Series,Number,Year,Manufacturer,Country,Condition,Quantity,Purchase Price,Current Value,Storage Location,Notes,Date Added\n"
        let rows = items.map { item in
            let name = item.name.replacingOccurrences(of: ",", with: ";")
            let category = item.category.replacingOccurrences(of: ",", with: ";")
            let series = item.series.replacingOccurrences(of: ",", with: ";")
            let notes = item.notes.replacingOccurrences(of: ",", with: ";")
            let purchasePrice = item.purchasePrice.map { String($0) } ?? ""
            let currentValue = item.currentValue.map { String($0) } ?? ""
            let year = item.year.map { String($0) } ?? ""
            
            return "\(name),\(category),\(series),\(item.number),\(year),\(item.manufacturer),\(item.country),\(item.condition),\(item.quantity),\(purchasePrice),\(currentValue),\(item.storageLocation),\(notes),\(DateFormatter.csv.string(from: item.dateAdded))"
        }.joined(separator: "\n")
        
        return headers + rows
    }
}

extension DateFormatter {
    static let export: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter
    }()
    
    static let fileName: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm"
        return formatter
    }()
    
    static let csv: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

#Preview {
    SettingsView(viewModel: CollectionViewModel())
}
