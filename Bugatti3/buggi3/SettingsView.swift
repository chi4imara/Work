import SwiftUI
import StoreKit
import UniformTypeIdentifiers

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    @EnvironmentObject var viewModel: ExperimentViewModel
    @State private var showShareSheet = false
    @State private var exportURL: URL?
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical)
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("About")
                                .font(.ubuntu(20, weight: .medium))
                                .foregroundColor(Color.theme.primaryYellow)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Personal Experiments Tracker")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(Color.theme.primaryText)
                                
                                Text("This app helps you record personal experiments in a clear and simple format. Write down what you tried, what you changed, and what result you got.")
                                    .font(.ubuntu(16))
                                    .foregroundColor(Color.theme.secondaryText)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.theme.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.theme.cardBorder, lineWidth: 1)
                            )
                            .cornerRadius(12)
                        }
                        
                        VStack(spacing: 16) {
                            SettingsButton(
                                title: "Privacy Policy",
                                icon: "lock.shield",
                                color: Color.theme.accentPurple
                            ) {
                                openURL("https://doc-hosting.flycricket.io/storedly-homebound-list-privacy-policy/0d940b28-a761-45d3-830f-650f0d1cd4c9/privacy")
                            }
                            
                            SettingsButton(
                                title: "Contact Us",
                                icon: "envelope",
                                color: Color.theme.accentPink
                            ) {
                                openURL("https://forms.gle/BZLSrFHC2DhAeknFA")
                            }
                            
                            SettingsButton(
                                title: "Rate App",
                                icon: "star",
                                color: Color.theme.primaryYellow
                            ) {
                                requestReview()
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let url = exportURL {
                ShareSheet(activityItems: [url])
            }
        }
    }
    
    private func exportAndShareExperiments() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        var text = "Personal Experiments Export\n"
        text += "Exported: \(formatter.string(from: Date()))\n\n"
        for (index, exp) in viewModel.experiments.enumerated() {
            text += "--- Experiment \(index + 1) ---\n"
            text += "Tried: \(exp.tried)\n"
            text += "Changed: \(exp.changed)\n"
            text += "Result: \(exp.result)\n"
            text += "Updated: \(formatter.string(from: exp.updatedAt))\n\n"
        }
        guard let data = text.data(using: .utf8) else { return }
        let fileFormatter = DateFormatter()
        fileFormatter.dateFormat = "yyyy-MM-dd_HH-mm"
        let fileName = "experiments_\(fileFormatter.string(from: Date())).txt"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        try? data.write(to: tempURL)
        exportURL = tempURL
        showShareSheet = true
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 30)
                
                Text(title)
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Color.theme.secondaryText)
            }
            .padding()
            .background(Color.theme.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.theme.cardBorder, lineWidth: 1)
            )
            .cornerRadius(12)
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    SettingsView()
        .environmentObject(ExperimentViewModel())
}
