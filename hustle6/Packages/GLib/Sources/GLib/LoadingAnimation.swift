import SwiftUI

struct AppFonts {
    private static let poppinsLight = "Poppins-Light"
    private static let poppinsRegular = "Poppins-Regular"
    private static let poppinsMedium = "Poppins-Medium"
    private static let poppinsSemiBold = "Poppins-SemiBold"
    private static let poppinsBold = "Poppins-Bold"
    
    static func light(_ size: CGFloat) -> Font {
        return Font.custom(poppinsLight, size: size)
    }
    
    static func regular(_ size: CGFloat) -> Font {
        return Font.custom(poppinsRegular, size: size)
    }
    
    static func medium(_ size: CGFloat) -> Font {
        return Font.custom(poppinsMedium, size: size)
    }
    
    static func semiBold(_ size: CGFloat) -> Font {
        return Font.custom(poppinsSemiBold, size: size)
    }
    
    static func bold(_ size: CGFloat) -> Font {
        return Font.custom(poppinsBold, size: size)
    }
    
    static let largeTitle = bold(34)
    static let title1 = bold(28)
    static let title2 = semiBold(22)
    static let title3 = semiBold(20)
    static let headline = semiBold(17)
    static let body = regular(17)
    static let callout = regular(16)
    static let subheadline = regular(15)
    static let footnote = regular(13)
    static let caption1 = regular(12)
    static let caption2 = regular(11)
    
    static let ideaTitle = bold(24)
    static let ideaCategory = medium(16)
    static let ideaDescription = regular(15)
    static let buttonTitle = semiBold(16)
    static let tabBarTitle = medium(12)
    static let navigationTitle = semiBold(18)
}

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func registerFonts() {
        let fontNames = [
            "Poppins-Light",
            "Poppins-Regular",
            "Poppins-Medium",
            "Poppins-SemiBold",
            "Poppins-Bold"
        ]
        
        for fontName in fontNames {
            guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") else {
                print("❌ Could not find font file: \(fontName).ttf")
                continue
            }
            
            var error: Unmanaged<CFError>?
            if !CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error) {
                if let error = error?.takeRetainedValue() {
                    print("❌ Failed to register font \(fontName): \(error)")
                }
            } else {
                print("✅ Successfully registered font: \(fontName)")
            }
        }
    }
    
    static func poppinsRegular(size: CGFloat) -> Font {
        return AppFonts.regular(size)
    }
    
    static func poppinsMedium(size: CGFloat) -> Font {
        return AppFonts.medium(size)
    }
    
    static func poppinsSemiBold(size: CGFloat) -> Font {
        return AppFonts.semiBold(size)
    }
    
    static func poppinsBold(size: CGFloat) -> Font {
        return AppFonts.bold(size)
    }
    
    static func poppinsLight(size: CGFloat) -> Font {
        return AppFonts.light(size)
    }
    
    static let title = AppFonts.title1
    static let headline = AppFonts.headline
    static let subheadline = AppFonts.subheadline
    static let body = AppFonts.body
    static let caption = AppFonts.caption1
    static let small = AppFonts.caption2
}

struct AppColors {
    static let primary = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let secondary = Color(red: 0.4, green: 0.8, blue: 1.0)
    static let accent = Color(red: 0.1, green: 0.4, blue: 0.8)
    
    static let background = Color.white
    static let cardBackground = Color(red: 0.98, green: 0.99, blue: 1.0)
    static let surfaceBackground = Color(red: 0.95, green: 0.97, blue: 1.0)
    
    static let primaryText = Color(red: 0.1, green: 0.1, blue: 0.2)
    static let secondaryText = Color(red: 0.4, green: 0.5, blue: 0.6)
    static let lightText = Color(red: 0.6, green: 0.7, blue: 0.8)
    static let onPrimary = Color.white
    
    static let buttonPrimary = primary
    static let buttonSecondary = secondary
    static let buttonDisabled = Color(red: 0.8, green: 0.85, blue: 0.9)
    
    static let success = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warning = Color(red: 1.0, green: 0.7, blue: 0.2)
    static let error = Color(red: 1.0, green: 0.3, blue: 0.3)
    
    static let bubbleBlue1 = Color(red: 0.6, green: 0.85, blue: 1.0).opacity(0.3)
    static let bubbleBlue2 = Color(red: 0.4, green: 0.75, blue: 1.0).opacity(0.4)
    static let bubbleBlue3 = Color(red: 0.5, green: 0.8, blue: 1.0).opacity(0.2)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color.white,
            Color(red: 0.96, green: 0.98, blue: 1.0),
            Color(red: 0.94, green: 0.96, blue: 1.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color(red: 0.98, green: 0.99, blue: 1.0),
            Color(red: 0.96, green: 0.98, blue: 1.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let primaryGradient = LinearGradient(
        colors: [primary, secondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accentGradient = LinearGradient(
        colors: [accent, primary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Color {
    static let appPrimary = AppColors.primary
    static let appSecondary = AppColors.secondary
    static let appAccent = AppColors.accent
    static let appBackground = AppColors.background
    static let appCardBackground = AppColors.cardBackground
    static let appSurfaceBackground = AppColors.surfaceBackground
    static let appPrimaryText = AppColors.primaryText
    static let appSecondaryText = AppColors.secondaryText
    static let appLightText = AppColors.lightText
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func hapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> some View {
        self.onTapGesture {
            let impactFeedback = UIImpactFeedbackGenerator(style: style)
            impactFeedback.impactOccurred()
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

extension String {
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func truncated(to length: Int) -> String {
        if self.count <= length {
            return self
        } else {
            return String(self.prefix(length)) + "..."
        }
    }
    
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    func formatted(style: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        return formatter.string(from: self)
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

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

extension Array where Element: Identifiable {
    func removeDuplicates() -> [Element] {
        var seen = Set<Element.ID>()
        return filter { seen.insert($0.id).inserted }
    }
}

extension UserDefaults {
    func setObject<T: Codable>(_ object: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(object) {
            set(data, forKey: key)
        }
    }
    
    func getObject<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        guard let data = data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: data)
    }
}

struct HapticManager {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let impactFeedback = UIImpactFeedbackGenerator(style: style)
        impactFeedback.impactOccurred()
    }
    
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(type)
    }
    
    static func selection() {
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()
    }
}

struct AnimationPresets {
    static let spring = Animation.spring(response: 0.5, dampingFraction: 0.8)
    static let easeInOut = Animation.easeInOut(duration: 0.3)
    static let bouncy = Animation.interpolatingSpring(stiffness: 300, damping: 15)
    static let gentle = Animation.easeInOut(duration: 0.6)
}

struct DeviceInfo {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let isSmallDevice = screenWidth < 375
    static let isMediumDevice = screenWidth >= 375 && screenWidth < 414
    static let isLargeDevice = screenWidth >= 414
    
    static var safeAreaInsets: UIEdgeInsets {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return .zero
        }
        return window.safeAreaInsets
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct CardModifier: ViewModifier {
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    
    init(cornerRadius: CGFloat = 16, shadowRadius: CGFloat = 6) {
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(AppColors.cardGradient)
                    .shadow(color: AppColors.primary.opacity(0.1), radius: shadowRadius, x: 0, y: 3)
            )
    }
}

extension View {
    func cardStyle(cornerRadius: CGFloat = 16, shadowRadius: CGFloat = 6) -> some View {
        modifier(CardModifier(cornerRadius: cornerRadius, shadowRadius: shadowRadius))
    }
}

struct AnimatedBackground: View {
    @State private var bubbles: [Bubble] = []
    @State private var animationTimer: Timer?
    
    let bubbleCount = 15
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ForEach(bubbles) { bubble in
                    Circle()
                        .fill(bubble.color)
                        .frame(width: bubble.size, height: bubble.size)
                        .position(x: bubble.x, y: bubble.y)
                        .blur(radius: bubble.blur)
                        .animation(
                            Animation.easeInOut(duration: bubble.duration)
                                .repeatForever(autoreverses: true),
                            value: bubble.y
                        )
                }
            }
        }
        .onAppear {
            setupBubbles()
            startAnimation()
        }
        .onDisappear {
            stopAnimation()
        }
    }
    
    private func setupBubbles() {
        bubbles = (0..<bubbleCount).map { _ in
            Bubble(
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: CGFloat.random(in: 0...UIScreen.main.bounds.height),
                size: CGFloat.random(in: 20...80),
                color: [AppColors.bubbleBlue1, AppColors.bubbleBlue2, AppColors.bubbleBlue3].randomElement()!,
                duration: Double.random(in: 3...8),
                blur: CGFloat.random(in: 1...3)
            )
        }
    }
    
    private func startAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            animateBubbles()
        }
    }
    
    private func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
    private func animateBubbles() {
        for i in bubbles.indices {
            if Bool.random() {
                bubbles[i].x += CGFloat.random(in: -2...2)
                bubbles[i].y += CGFloat.random(in: -2...2)
                
                bubbles[i].x = max(0, min(UIScreen.main.bounds.width, bubbles[i].x))
                bubbles[i].y = max(0, min(UIScreen.main.bounds.height, bubbles[i].y))
            }
        }
    }
}

struct Bubble: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    let size: CGFloat
    let color: Color
    let duration: Double
    let blur: CGFloat
}

struct PulsatingBubble: View {
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.3
    
    let color: Color
    let size: CGFloat
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: Double.random(in: 2...4))
                        .repeatForever(autoreverses: true)
                ) {
                    scale = 1.2
                    opacity = 0.1
                }
            }
    }
}

struct FloatingBubbles: View {
    @State private var bubblePositions: [CGPoint] = []
    @State private var animationOffset: CGFloat = 0
    
    let bubbleCount = 8
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<bubbleCount, id: \.self) { index in
                    let bubble = getBubbleData(for: index, in: geometry.size)
                    
                    PulsatingBubble(
                        color: bubble.color,
                        size: bubble.size
                    )
                    .position(
                        x: bubble.position.x + sin(animationOffset + Double(index)) * 20,
                        y: bubble.position.y + cos(animationOffset + Double(index) * 0.5) * 15
                    )
                }
            }
        }
        .onAppear {
            withAnimation(
                Animation.linear(duration: 20)
                    .repeatForever(autoreverses: false)
            ) {
                animationOffset = .pi * 4
            }
        }
    }
    
    private func getBubbleData(for index: Int, in size: CGSize) -> (position: CGPoint, color: Color, size: CGFloat) {
        let colors = [AppColors.bubbleBlue1, AppColors.bubbleBlue2, AppColors.bubbleBlue3]
        let bubbleSize = CGFloat.random(in: 30...60)
        
        let position = CGPoint(
            x: CGFloat.random(in: bubbleSize...(size.width - bubbleSize)),
            y: CGFloat.random(in: bubbleSize...(size.height - bubbleSize))
        )
        
        return (
            position: position,
            color: colors[index % colors.count],
            size: bubbleSize
        )
    }
}

public struct LoadingAnimation: View {
    @State private var isLoading = true
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var circleScale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    
    public var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.primary.opacity(0.3), AppColors.secondary.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .opacity(0.7)
                    
                    Circle()
                        .trim(from: 0.0, to: 0.7)
                        .stroke(
                            AppColors.primaryGradient,
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(AppColors.accentGradient)
                        .frame(width: 40, height: 40)
                        .scaleEffect(circleScale)
                    
                    Circle()
                        .fill(AppColors.onPrimary)
                        .frame(width: 8, height: 8)
                        .opacity(opacity)
                }
                
                Text("Loading...")
                    .font(AppFonts.medium(18))
                    .foregroundColor(AppColors.primaryText)
                    .opacity(opacity)
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeOut(duration: 0.5)) {
                    isLoading = false
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeIn(duration: 0.8)) {
            opacity = 1.0
        }
        
        withAnimation(
            Animation.linear(duration: 2.0)
                .repeatForever(autoreverses: false)
        ) {
            rotationAngle = 360
        }
        
        withAnimation(
            Animation.easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
        ) {
            pulseScale = 1.3
        }
        
        withAnimation(
            Animation.easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true)
        ) {
            circleScale = 1.0
        }
    }
}
struct CustomLoader: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(AppColors.primary.opacity(0.3), lineWidth: 3)
                .frame(width: 60, height: 60)
            
            Circle()
                .trim(from: 0.0, to: 0.6)
                .stroke(
                    AngularGradient(
                        colors: [AppColors.primary, AppColors.secondary, AppColors.accent],
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .frame(width: 60, height: 60)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    Animation.linear(duration: 1.5)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
            
            Circle()
                .fill(AppColors.primary)
                .frame(width: 20, height: 20)
                .scaleEffect(isAnimating ? 1.2 : 0.8)
                .animation(
                    Animation.easeInOut(duration: 1.0)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct PulsingDots: View {
    @State private var animationPhase = 0.0
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(AppColors.primary)
                    .frame(width: 12, height: 12)
                    .scaleEffect(
                        1.0 + 0.5 * sin(animationPhase + Double(index) * 0.6)
                    )
                    .opacity(
                        0.5 + 0.5 * sin(animationPhase + Double(index) * 0.6)
                    )
            }
        }
        .onAppear {
            withAnimation(
                Animation.linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
            ) {
                animationPhase = .pi * 4
            }
        }
    }
}
