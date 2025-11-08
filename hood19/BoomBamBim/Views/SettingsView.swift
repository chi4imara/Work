import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) private var requestReview
    @State private var selectedButton: String? = nil
    @State private var showAnimation = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    AppColors.background,
                    AppColors.cardBackground,
                    AppColors.lightBlue.opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            AnimatedSettingsBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    SettingsHeader()
                        .opacity(showAnimation ? 1 : 0)
                        .animation(.easeOut(duration: 0.8).delay(0.1), value: showAnimation)
                    
                    VStack(spacing: 24) {
                        QuickActionsSection(selectedButton: $selectedButton)
                            .opacity(showAnimation ? 1 : 0)
                            .offset(y: showAnimation ? 0 : 30)
                            .animation(.easeOut(duration: 0.8).delay(0.3), value: showAnimation)
                        
                        LegalSupportSection(selectedButton: $selectedButton)
                            .opacity(showAnimation ? 1 : 0)
                            .offset(y: showAnimation ? 0 : 30)
                            .animation(.easeOut(duration: 0.8).delay(0.5), value: showAnimation)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .onAppear {
            showAnimation = true
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsHeader: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Settings")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.primaryText)
            
            ZStack {
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [AppColors.primaryBlue.opacity(0.3), AppColors.accent.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
                    .frame(width: 100, height: 100)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.primaryBlue, AppColors.darkBlue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                
                Image(systemName: "house.fill")
                    .font(.system(size: 36, weight: .medium))
                    .foregroundColor(.white)
                    .scaleEffect(isAnimating ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
            }
            
            VStack(spacing: 8) {
                Text("Home Projects")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Plan with Clarity")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                
                RoundedRectangle(cornerRadius: 2)
                    .fill(
                        LinearGradient(
                            colors: [AppColors.primaryBlue, AppColors.accent],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 60, height: 4)
                    .padding(.top, 8)
            }
        }
        .padding(.vertical, 40)
        .padding(.top, -15)
        .onAppear {
            isAnimating = true
        }
    }
}

struct QuickActionsSection: View {
    @Binding var selectedButton: String?
    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Quick Actions", icon: "bolt.fill")
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ModernButton(
                    title: "Rate App",
                    subtitle: "Share your feedback",
                    icon: "star.fill",
                    color: AppColors.inProgressYellow,
                    isSelected: selectedButton == "rate"
                ) {
                    selectedButton = "rate"
                    requestReview()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        selectedButton = nil
                    }
                }
                
                ModernButton(
                    title: "Contact Us",
                    subtitle: "Support & feedback",
                    icon: "envelope.fill",
                    color: AppColors.teal,
                    isSelected: selectedButton == "contact"
                ) {
                    selectedButton = "contact"
                    openURL("https://forms.gle/xJKGdGimEZausSEY8")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        selectedButton = nil
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct LegalSupportSection: View {
    @Binding var selectedButton: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Legal Information", icon: "doc.text.fill")
            
            VStack(spacing: 12) {
                LegalButton(
                    title: "Terms of Use",
                    icon: "doc.text",
                    isSelected: selectedButton == "terms"
                ) {
                    selectedButton = "terms"
                    openURL("https://docs.google.com/document/d/1n8zE21wDHoMElFtqF2AsMtp8X4O08X2niabq3RrC3RU/edit?usp=sharing")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        selectedButton = nil
                    }
                }
                
                Divider()
                    .frame(maxWidth: .infinity)
                
                LegalButton(
                    title: "Privacy Policy",
                    icon: "lock.shield",
                    isSelected: selectedButton == "privacy"
                ) {
                    selectedButton = "privacy"
                    openURL("https://docs.google.com/document/d/1T0rc7qLeBElJo1ez8kQfZkJq5Lk48xsSag8XCN-zVYY/edit?usp=sharing")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        selectedButton = nil
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(AppColors.primaryBlue)
            
            Text(title)
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
    }
}

struct ModernButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
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
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [color, color.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                        .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(AppFonts.cardTitle)
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? color.opacity(0.1) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? color : Color.clear, lineWidth: 2)
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
    }
}

struct LegalButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
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
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.lightBlue.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryBlue)
                }
                
                Text(title)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.lightText)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColors.primaryBlue.opacity(0.1) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? AppColors.primaryBlue : Color.clear, lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
    }
}

struct AnimatedSettingsBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<6, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                AppColors.primaryBlue.opacity(0.1),
                                AppColors.accent.opacity(0.05),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 10,
                            endRadius: 60
                        )
                    )
                    .frame(width: CGFloat.random(in: 30...80))
                    .position(
                        x: animate ? CGFloat.random(in: 50...350) : CGFloat.random(in: 50...350),
                        y: animate ? CGFloat.random(in: 100...700) : CGFloat.random(in: 100...700)
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 4...8))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.8),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct HexagonButton: View {
    let title: String
    let icon: String
    let color: Color
    let size: CGFloat
    let action: () -> Void
    
    @State private var isPressed = false
    
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
            ZStack {
                HexagonShape()
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        HexagonShape()
                            .stroke(color.opacity(0.3), lineWidth: 2)
                    )
                    .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
                
                VStack(spacing: 8) {
                    Image(systemName: icon)
                        .font(.system(size: size * 0.25, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(title)
                        .font(AppFonts.caption1)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                }
                .padding(size * 0.15)
            }
            .frame(width: size, height: size)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        var path = Path()
        
        for i in 0..<6 {
            let angle = Double(i) * .pi / 3
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            let point = CGPoint(x: x, y: y)
            
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        
        path.closeSubpath()
        return path
    }
}

struct AppInfoSection: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryBlue)
                    
                    Text("App Information")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                
                VStack(spacing: 8) {
                    HStack {
                        Text("Version")
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.secondaryText)
                        
                        Spacer()
                        
                        Text("1.0.0")
                            .font(AppFonts.bodyMedium)
                            .foregroundColor(AppColors.primaryText)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.lightBlue.opacity(0.3))
                            )
                    }
                    
                    HStack {
                        Text("Build")
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.secondaryText)
                        
                        Spacer()
                        
                        Text("2024.1")
                            .font(AppFonts.bodyMedium)
                            .foregroundColor(AppColors.primaryText)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.lightBlue.opacity(0.3))
                            )
                    }
                }
            }
            
            HStack(spacing: 4) {
                Text("Made with")
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.lightText)
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.red)
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnimating)
                
                Text("for home improvement enthusiasts")
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.lightText)
            }
            .multilineTextAlignment(.center)
            
            HStack(spacing: 8) {
                ForEach(0..<7, id: \.self) { index in
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    AppColors.primaryBlue.opacity(0.6),
                                    AppColors.accent.opacity(0.4)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 8, height: 8)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .animation(
                            .easeInOut(duration: 0.8)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.1),
                            value: isAnimating
                        )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.bottom, 40)
        .onAppear {
            isAnimating = true
        }
    }
}

struct DiamondSettingsLayout: View {
    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width / 4, 100)
            
            ZStack {
                DiamondButton(
                    title: "Rate App",
                    icon: "star.fill",
                    color: AppColors.inProgressYellow,
                    size: size * 1.2
                ) {
                    requestReview()
                }
                
                DiamondButton(
                    title: "Privacy Policy",
                    icon: "lock.shield",
                    color: AppColors.primaryBlue,
                    size: size
                ) {
                }
                .offset(y: -size * 1.5)
                
                DiamondButton(
                    title: "Terms of Use",
                    icon: "doc.text",
                    color: AppColors.accent,
                    size: size
                ) {
                }
                .offset(x: -size * 1.5)
                
                DiamondButton(
                    title: "Contact Us",
                    icon: "envelope",
                    color: AppColors.teal,
                    size: size
                ) {
                }
                .offset(x: size * 1.5)
                
                DiamondButton(
                    title: "License",
                    icon: "checkmark.seal",
                    color: AppColors.completedGreen,
                    size: size
                ) {
                }
                .offset(y: size * 1.5)
            }
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}

struct DiamondButton: View {
    let title: String
    let icon: String
    let color: Color
    let size: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color)
                    .rotationEffect(.degrees(45))
                    .shadow(color: color.opacity(0.3), radius: 6, x: 0, y: 3)
                
                VStack(spacing: 6) {
                    Image(systemName: icon)
                        .font(.system(size: size * 0.3, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(title)
                        .font(AppFonts.caption2)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .frame(width: size, height: size)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}

