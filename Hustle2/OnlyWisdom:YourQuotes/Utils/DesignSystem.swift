import SwiftUI

struct DesignSystem {
    
    struct Colors {
        static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
        static let lightBlue = Color(red: 0.7, green: 0.85, blue: 1.0)
        static let darkBlue = Color(red: 0.1, green: 0.3, blue: 0.6)
        
        static let backgroundPrimary = Color.white
        static let backgroundSecondary = Color(red: 0.98, green: 0.99, blue: 1.0)
        static let backgroundTertiary = Color(red: 0.95, green: 0.97, blue: 1.0)
        
        static let textPrimary = Color(red: 0.1, green: 0.1, blue: 0.1)
        static let textSecondary = Color(red: 0.4, green: 0.4, blue: 0.4)
        static let textLight = lightBlue
        static let textDark = darkBlue
        
        static let accent = primaryBlue
        static let success = Color(red: 0.2, green: 0.8, blue: 0.4)
        static let warning = Color(red: 1.0, green: 0.6, blue: 0.2)
        static let error = Color(red: 1.0, green: 0.3, blue: 0.3)
        
        static let cardBackground = Color.white
        static let cardShadow = Color.black.opacity(0.1)
        static let divider = Color(red: 0.9, green: 0.9, blue: 0.9)
        
        static let tabBarBackground = Color.white.opacity(0.95)
        static let tabBarSelected = primaryBlue
        static let tabBarUnselected = Color.gray
    }
    
    struct Gradients {
        static let backgroundGradient = LinearGradient(
            colors: [
                Colors.backgroundPrimary,
                Colors.backgroundSecondary,
                Colors.backgroundTertiary
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let blueWebGradient = LinearGradient(
            colors: [
                Colors.lightBlue.opacity(0.3),
                Colors.primaryBlue.opacity(0.1),
                Colors.darkBlue.opacity(0.2)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let cardGradient = LinearGradient(
            colors: [
                Colors.cardBackground,
                Colors.backgroundSecondary
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        
        static let buttonGradient = LinearGradient(
            colors: [
                Colors.primaryBlue,
                Colors.darkBlue
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    struct CornerRadius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let round: CGFloat = 50
    }
    
    struct Shadow {
        static let light = Color.black.opacity(0.05)
        static let medium = Color.black.opacity(0.1)
        static let heavy = Color.black.opacity(0.2)
        
        static let cardShadow: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) = (
            color: light,
            radius: 8,
            x: 0,
            y: 2
        )
        
        static let buttonShadow: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) = (
            color: medium,
            radius: 4,
            x: 0,
            y: 2
        )
    }
    
    struct Animation {
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let standard = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.5)
        static let spring = SwiftUI.Animation.spring(response: 0.5, dampingFraction: 0.8)
    }
}

extension View {
    func cardStyle() -> some View {
        self
            .background(DesignSystem.Gradients.cardGradient)
            .cornerRadius(DesignSystem.CornerRadius.md)
            .shadow(
                color: DesignSystem.Shadow.cardShadow.color,
                radius: DesignSystem.Shadow.cardShadow.radius,
                x: DesignSystem.Shadow.cardShadow.x,
                y: DesignSystem.Shadow.cardShadow.y
            )
    }
    
    func primaryButtonStyle() -> some View {
        self
            .foregroundColor(.white)
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.md)
            .background(DesignSystem.Gradients.buttonGradient)
            .cornerRadius(DesignSystem.CornerRadius.md)
            .shadow(
                color: DesignSystem.Shadow.buttonShadow.color,
                radius: DesignSystem.Shadow.buttonShadow.radius,
                x: DesignSystem.Shadow.buttonShadow.x,
                y: DesignSystem.Shadow.buttonShadow.y
            )
    }
    
    func secondaryButtonStyle() -> some View {
        self
            .foregroundColor(DesignSystem.Colors.primaryBlue)
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.md)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                    .stroke(DesignSystem.Colors.primaryBlue, lineWidth: 1)
            )
    }
    
    func backgroundGradient() -> some View {
        self
            .background(
                ZStack {
                    DesignSystem.Gradients.backgroundGradient
                        .ignoresSafeArea()
                    
                    BlueWebPattern()
                        .opacity(0.3)
                        .ignoresSafeArea()
                }
            )
    }
}

struct BlueWebPattern: View {
    var body: some View {
        Canvas { context, size in
            let path = Path { path in
                let centerX = size.width / 2
                let centerY = size.height / 2
                let radius = min(size.width, size.height) / 3
                
                for i in 0..<8 {
                    let angle = Double(i) * .pi / 4
                    let endX = centerX + cos(angle) * radius
                    let endY = centerY + sin(angle) * radius
                    
                    path.move(to: CGPoint(x: centerX, y: centerY))
                    path.addLine(to: CGPoint(x: endX, y: endY))
                }
                
                for i in 1...3 {
                    let circleRadius = radius * Double(i) / 3
                    path.addEllipse(in: CGRect(
                        x: centerX - circleRadius,
                        y: centerY - circleRadius,
                        width: circleRadius * 2,
                        height: circleRadius * 2
                    ))
                }
            }
            
            context.stroke(
                path,
                with: .color(DesignSystem.Colors.lightBlue),
                lineWidth: 1
            )
        }
    }
}
