import SwiftUI

struct ExportOptionsView: View {
    @Binding var isPresented: Bool
    let onExportPDF: () -> Void
    let onExportJSON: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 20)
            
            VStack(spacing: AppTheme.Spacing.lg) {
                VStack(spacing: AppTheme.Spacing.sm) {
                    Text("Export Data")
                        .font(AppTheme.Fonts.title2)
                        .foregroundColor(AppTheme.Colors.primaryText)
                    
                    Text("Choose format to save your mood data to Files")
                        .font(AppTheme.Fonts.callout)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: AppTheme.Spacing.md) {
                    ExportOptionButton(
                        title: "PDF Report",
                        subtitle: "Beautiful report with charts and analytics",
                        icon: "doc.text.fill",
                        color: .red,
                        action: {
                            onExportPDF()
                            isPresented = false
                        }
                    )
                    
                    ExportOptionButton(
                        title: "JSON Data",
                        subtitle: "Raw data for importing to other apps",
                        icon: "doc.plaintext.fill",
                        color: .orange,
                        action: {
                            onExportJSON()
                            isPresented = false
                        }
                    )
                }
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                        .font(AppTheme.Fonts.buttonFont)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                .fill(Color.white.opacity(0.1))
                        )
                }
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.bottom, AppTheme.Spacing.xl)
        }
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                .fill(AppTheme.Colors.backgroundBlue)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct ExportOptionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.md - 2) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(AppTheme.Fonts.headline)
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .fontWeight(.semibold)
                    
                    Text(subtitle)
                        .font(AppTheme.Fonts.tabBarFont)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .multilineTextAlignment(.leading)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(AppTheme.Colors.tertiaryText)
            }
            .padding(AppTheme.Spacing.md)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(Color.white.opacity(isPressed ? 0.15 : 0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        ExportOptionsView(
            isPresented: .constant(true),
            onExportPDF: {},
            onExportJSON: {}
        )
        .padding()
    }
}
