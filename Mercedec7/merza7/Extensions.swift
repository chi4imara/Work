import SwiftUI
import Foundation

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay) ?? self
    }
    
    func isInSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    func daysBetween(_ date: Date) -> Int {
        Calendar.current.dateComponents([.day], from: self.startOfDay, to: date.startOfDay).day ?? 0
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let impactFeedback = UIImpactFeedbackGenerator(style: style)
        impactFeedback.impactOccurred()
    }
    
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(type)
    }
    
    func selection() {
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let foregroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppFonts.button())
            .foregroundColor(foregroundColor)
            .padding(.vertical, AppSpacing.md)
            .padding(.horizontal, AppSpacing.lg)
            .background(backgroundColor)
            .cornerRadius(AppRadius.lg)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppFonts.button())
            .foregroundColor(AppColors.textPrimary)
            .padding(.vertical, AppSpacing.md)
            .padding(.horizontal, AppSpacing.lg)
            .background(Color.white.opacity(0.8))
            .cornerRadius(AppRadius.lg)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .stroke(AppColors.primaryBlue.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct CardModifier: ViewModifier {
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    
    init(
        backgroundColor: Color = Color.white.opacity(0.9),
        cornerRadius: CGFloat = AppRadius.lg,
        shadowRadius: CGFloat = 4
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
    }
    
    func body(content: Content) -> some View {
        content
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: AppShadows.light, radius: shadowRadius, x: 0, y: 2)
    }
}

extension View {
    func cardStyle(
        backgroundColor: Color = Color.white.opacity(0.9),
        cornerRadius: CGFloat = AppRadius.lg,
        shadowRadius: CGFloat = 4
    ) -> some View {
        modifier(CardModifier(
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            shadowRadius: shadowRadius
        ))
    }
}

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(AppColors.primaryBlue, lineWidth: 4)
                .frame(width: 40, height: 40)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    Animation.linear(duration: 1)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
            
            Text("Loading...")
                .font(AppFonts.body())
                .foregroundColor(AppColors.textSecondary)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let description: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(
        icon: String,
        title: String,
        description: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.description = description
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(AppColors.textSecondary)
            
            Text(title)
                .font(AppFonts.title3())
                .foregroundColor(AppColors.textPrimary)
                .multilineTextAlignment(.center)
            
            Text(description)
                .font(AppFonts.body())
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            
            if let actionTitle = actionTitle, let action = action {
                Button(actionTitle, action: action)
                    .buttonStyle(PrimaryButtonStyle(
                        backgroundColor: AppColors.accentYellow,
                        foregroundColor: AppColors.textLight
                    ))
            }
        }
        .padding(AppSpacing.xl)
    }
}
