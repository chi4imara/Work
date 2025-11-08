import SwiftUI

struct ExportProgressView: View {
    @Binding var isPresented: Bool
    let exportType: ExportType
    @State private var progress: Double = 0
    @State private var isCompleted = false
    @State private var errorMessage: String?
    
    enum ExportType {
        case pdf
        case json
        
        var title: String {
            switch self {
            case .pdf: return "Creating PDF Report"
            case .json: return "Exporting JSON Data"
            }
        }
        
        var icon: String {
            switch self {
            case .pdf: return "doc.text.fill"
            case .json: return "doc.plaintext.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .pdf: return .red
            case .json: return .blue
            }
        }
    }
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            ZStack {
                Circle()
                    .fill(exportType.color.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.green)
                } else if errorMessage != nil {
                    Image(systemName: "xmark")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.red)
                } else {
                    Image(systemName: exportType.icon)
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(exportType.color)
                }
            }
            
            VStack(spacing: AppTheme.Spacing.md) {
                Text(exportType.title)
                    .font(AppTheme.Fonts.title2)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .fontWeight(.semibold)
                
                if let error = errorMessage {
                    Text(error)
                        .font(AppTheme.Fonts.callout)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                } else if isCompleted {
                    Text("Export completed successfully!")
                        .font(AppTheme.Fonts.callout)
                        .foregroundColor(.green)
                        .multilineTextAlignment(.center)
                } else {
                    Text("Please wait...")
                        .font(AppTheme.Fonts.callout)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }
            
            if !isCompleted && errorMessage == nil {
                VStack(spacing: AppTheme.Spacing.sm) {
                    ProgressView(value: min(max(progress, 0), 1))
                        .progressViewStyle(LinearProgressViewStyle(tint: exportType.color))
                        .frame(height: 8)
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                    
                    Text("\(Int(min(max(progress, 0), 1) * 100))%")
                        .font(AppTheme.Fonts.caption1)
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                }
            }
            
            if isCompleted || errorMessage != nil {
                Button(action: {
                    isPresented = false
                }) {
                    Text(errorMessage != nil ? "Close" : "Done")
                        .font(AppTheme.Fonts.buttonFont)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                .fill(errorMessage != nil ? .red : .green)
                        )
                }
            }
        }
        .padding(AppTheme.Spacing.xl)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                .fill(AppTheme.Colors.backgroundBlue)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .onAppear {
            startExport()
        }
    }
    
    private func startExport() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            withAnimation(.easeInOut(duration: 0.1)) {
                progress = min(progress + 0.05, 1.0)
                
                if progress >= 1.0 {
                    timer.invalidate()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isCompleted = true
                        }
                    }
                }
            }
        }
    }
    
    func setError(_ message: String) {
        errorMessage = message
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        ExportProgressView(
            isPresented: .constant(true),
            exportType: .pdf
        )
        .padding()
    }
}
