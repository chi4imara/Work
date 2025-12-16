import SwiftUI

struct ExportDataView: View {
    @Binding var exportText: String
    @Environment(\.dismiss) private var dismiss
    @State private var showingShareSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 20) {
                    VStack(spacing: 12) {
                        Image(systemName: "square.and.arrow.up.fill")
                            .font(.system(size: 50))
                            .foregroundColor(AppColors.primaryBlue)
                        
                        Text("Export Data")
                            .font(FontManager.ubuntu(.bold, size: 24))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Your collection data in JSON format")
                            .font(FontManager.ubuntu(.regular, size: 14))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    .padding(.top, 20)
                    
                    ScrollView {
                        Text(exportText)
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(AppColors.darkText)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(AppColors.cardBackground)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 12) {
                        Button(action: {
                            shareData()
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share Data")
                            }
                            .font(FontManager.ubuntu(.medium, size: 18))
                            .foregroundColor(AppColors.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(AppColors.buttonPrimary)
                            .cornerRadius(28)
                        }
                        
                        Button("Copy to Clipboard") {
                            UIPasteboard.general.string = exportText
                        }
                        .buttonStyle(SecondaryButtonStyle())
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Export Data")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
            }
            .preferredColorScheme(.dark)
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: [exportText])
        }
    }
    
    private func shareData() {
        showingShareSheet = true
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

