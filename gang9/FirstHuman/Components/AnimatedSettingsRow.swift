import SwiftUI

struct AnimatedSettingsRow: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var isHovered = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(isHovered ? 0.2 : 0.15))
                        .frame(width: 40, height: 40)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(color)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                }
                
                Text(title)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                    .rotationEffect(.degrees(isPressed ? 90 : 0))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(color.opacity(isHovered ? 0.3 : 0.2), lineWidth: 1)
                    }
                    .shadow(
                        color: color.opacity(0.1),
                        radius: isPressed ? 2 : 4,
                        x: 0,
                        y: isPressed ? 1 : 2
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
    }
}

#Preview {
    VStack(spacing: 8) {
        AnimatedSettingsRow(
            title: "Terms of Use",
            icon: "doc.text",
            color: AppColors.primaryBlue,
            action: {}
        )
        
        AnimatedSettingsRow(
            title: "Privacy Policy",
            icon: "lock.shield",
            color: AppColors.accentGreen,
            action: {}
        )
    }
    .padding()
    .background(AnimatedBackground())
}
