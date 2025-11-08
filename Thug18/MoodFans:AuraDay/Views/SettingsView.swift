import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var animateContent = false
    @State private var showRateApp = false
    @State private var selectedButton: Int? = nil
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var floatingOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: AppTheme.Spacing.xxl) {
                    animatedHeaderView
                    
                    centralHubView
                    
                    floatingButtonsView
                    
                    bottomInfoView
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
                .padding(.vertical, AppTheme.Spacing.xl)
                .padding(.bottom, 80)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private var animatedHeaderView: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            HStack {
                Text("Settings")
                    .font(AppTheme.Fonts.largeTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : -30)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.accentYellow.opacity(0.2))
                        .frame(width: 50, height: 50)
                        .scaleEffect(pulseScale)
                    
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(AppTheme.Colors.accentYellow)
                        .rotationEffect(.degrees(rotationAngle))
                }
                .opacity(animateContent ? 1.0 : 0.0)
                .scaleEffect(animateContent ? 1.0 : 0.5)
            }
            
            Text("Customize your experience")
                .font(AppTheme.Fonts.subheadline)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
        }
        .padding(.top, -16)
    }
    
    private var centralHubView: some View {
        ZStack {
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            AppTheme.Colors.accentYellow.opacity(0.3),
                            AppTheme.Colors.primaryBlue.opacity(0.3),
                            AppTheme.Colors.accentYellow.opacity(0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                )
                .frame(width: 280, height: 280)
                .rotationEffect(.degrees(rotationAngle))
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            AppTheme.Colors.accentYellow.opacity(0.1),
                            AppTheme.Colors.primaryBlue.opacity(0.05)
                        ],
                        center: .center,
                        startRadius: 50,
                        endRadius: 140
                    )
                )
                .frame(width: 200, height: 200)
                .scaleEffect(pulseScale)
            
            VStack(spacing: AppTheme.Spacing.sm) {
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.cardBackground)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Circle()
                                .stroke(AppTheme.Colors.accentYellow.opacity(0.5), lineWidth: 2)
                        )
                    
                    Image(systemName: "paintpalette.fill")
                        .font(.system(size: 35, weight: .light))
                        .foregroundColor(AppTheme.Colors.accentYellow)
                        .rotationEffect(.degrees(rotationAngle * 0.5))
                }
                
                Text("MoodFans")
                    .font(AppTheme.Fonts.title3)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Text("AuraDay")
                    .font(AppTheme.Fonts.callout)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .scaleEffect(animateContent ? 1.0 : 0.8)
            
            ForEach(0..<6, id: \.self) { index in
                let angle = Double(index) * 60 - 90
                let radius: CGFloat = 120
                let x = cos(angle * .pi / 180) * radius
                let y = sin(angle * .pi / 180) * radius
                
                FloatingActionButton(
                    icon: floatingButtonIcons[index],
                    color: floatingButtonColors[index],
                    action: floatingButtonActions[index]
                )
                .offset(
                    x: animateContent ? x + floatingOffset : 0,
                    y: animateContent ? y + sin(floatingOffset * 0.01 + Double(index)) * 5 : 0
                )
                .opacity(animateContent ? 1.0 : 0.0)
                .scaleEffect(animateContent ? 1.0 : 0.3)
                .animation(
                    .easeOut(duration: 0.8)
                    .delay(max(0, 0.5 + Double(index) * 0.1)),
                    value: animateContent
                )
            }
        }
        .frame(height: 350)
    }
    
    private var floatingButtonsView: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Text("Quick Actions")
                .font(AppTheme.Fonts.title3)
                .foregroundColor(AppTheme.Colors.primaryText)
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppTheme.Spacing.lg) {
                ForEach(0..<4, id: \.self) { index in
                    InteractiveSettingsCard(
                        title: quickActionTitles[index],
                        icon: quickActionIcons[index],
                        color: quickActionColors[index],
                        action: quickActionActions[index]
                    )
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(
                        x: animateContent ? 0 : (index % 2 == 0 ? -100 : 100),
                        y: animateContent ? 0 : 50
                    )
                    .animation(
                        .easeOut(duration: 0.8)
                        .delay(max(0, 1.0 + Double(index) * 0.1)),
                        value: animateContent
                    )
                }
            }
        }
    }
    
    private var bottomInfoView: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            HStack(spacing: AppTheme.Spacing.md) {
                ForEach(0..<5, id: \.self) { index in
                    Circle()
                        .fill(AppTheme.Colors.accentYellow.opacity(0.6))
                        .frame(width: 8, height: 8)
                        .scaleEffect(pulseScale)
                        .animation(
                            .easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                            value: pulseScale
                        )
                }
            }
            .opacity(animateContent ? 1.0 : 0.0)
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
            animateContent = true
        }
        
        withAnimation(.linear(duration: 20.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            pulseScale = 1.1
        }
        
        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
            floatingOffset = 10
        }
    }
    
    private var floatingButtonIcons: [String] {
        ["star.fill", "hand.raised.fill", "doc.text.fill", "envelope.fill", "heart.fill", "info.circle.fill"]
    }
    
    private var floatingButtonColors: [Color] {
        [AppTheme.Colors.accentYellow, AppTheme.Colors.success, AppTheme.Colors.warning, AppTheme.Colors.primaryBlue, AppTheme.Colors.error, AppTheme.Colors.secondaryText]
    }
    
    private var floatingButtonActions: [() -> Void] {
        [
            { requestAppReview() },
            { openURL("https://google.com") },
            { openURL("https://google.com") },
            { openURL("https://google.com") },
            { HapticFeedback.success() },
            { HapticFeedback.light() }
        ]
    }
    
    private var quickActionTitles: [String] {
        ["Rate App", "Privacy Policy", "Terms of Use", "Contact Us"]
    }
    
    private var quickActionIcons: [String] {
        ["star.fill", "hand.raised.fill", "doc.text.fill", "envelope.fill"]
    }
    
    private var quickActionColors: [Color] {
        [AppTheme.Colors.accentYellow, AppTheme.Colors.success, AppTheme.Colors.warning, AppTheme.Colors.primaryBlue]
    }
    
    private var quickActionActions: [() -> Void] {
        [
            { requestAppReview() },
            { openURL("https://docs.google.com/document/d/1LENLQDjQXrhnMNr0o22K1RhazmhGqEeAaDa7iYwLvD8/edit?usp=sharing") },
            { openURL("https://docs.google.com/document/d/1mb-IH_aomBRwzVFSidBFi1DpB-wPQ0GdijWCLxX_Izw/edit?usp=sharing") },
            { openURL("https://forms.gle/ktsTLbamr8rFDdmm6") }
        ]
    }
    
    private func openURL(_ urlString: String) {
        HapticFeedback.light()
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestAppReview() {
        HapticFeedback.success()
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct FloatingActionButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var isHovered = false
    
    var body: some View {
        Button(action: {
            HapticFeedback.light()
            action()
        }) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .blur(radius: 8)
                    .opacity(isHovered ? 1.0 : 0.0)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.9 : (isHovered ? 1.1 : 1.0))
        .disabled(true)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isHovered = false
                }
            }
        }
    }
}

struct InteractiveSettingsCard: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Button(action: {
            HapticFeedback.medium()
            action()
        }) {
            VStack(spacing: AppTheme.Spacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                        .fill(
                            LinearGradient(
                                colors: [
                                    color.opacity(0.2),
                                    color.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                                .stroke(color.opacity(0.4), lineWidth: 2)
                        )
                        .frame(height: 100)
                    
                    Image(systemName: icon)
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(title ==  "Contact Us" ? .white : color)
                        .rotationEffect(.degrees(rotationAngle))
                        .scaleEffect(scale)
                }
                
                Text(title)
                    .font(AppTheme.Fonts.callout)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .multilineTextAlignment(.center)
            }
            .padding(AppTheme.Spacing.md)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
                if pressing {
                    rotationAngle = 360
                    scale = 1.2
                } else {
                    rotationAngle = 0
                    scale = 1.0
                }
            }
        }, perform: {})
        .rotation3DEffect(
            .degrees(isPressed ? 5 : 0),
            axis: (x: 1, y: 1, z: 0)
        )
        .animation(.easeInOut(duration: 0.3), value: rotationAngle)
        .animation(.easeInOut(duration: 0.2), value: scale)
    }
}

#Preview {
    SettingsView()
}
