import SwiftUI
import StoreKit

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.requestReview) var requestReview
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var showingClearDataAlert = false
    @State private var showingLoadDataAlert = false
    
    var body: some View {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        headerSection
                        
                        settingsList
                        
                        appInfoSection
                    }
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.vertical, AppSpacing.sm)
                }
            }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                HStack(spacing: AppSpacing.sm) {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(AppColors.accentYellow)
                    
                    Text("Settings")
                        .font(AppFonts.title1())
                        .foregroundColor(AppColors.textPrimary)
                }
                
                Text("Customize your experience")
                    .font(AppFonts.body())
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
        }
        .padding(.bottom, AppSpacing.sm)
    }
    
    private var settingsList: some View {
        VStack(spacing: AppSpacing.md) {
            SettingsCard(
                icon: "star.fill",
                title: "Rate App",
                subtitle: "Share your feedback",
                color: AppColors.accentYellow,
                action: {
                    requestReview()
                }
            )
            
            SettingsCard(
                icon: "envelope.fill",
                title: "Contact Us",
                subtitle: "Get in touch with us",
                color: AppColors.primaryBlue,
                action: {
                    viewModel.contactUs()
                }
            )
            
            SettingsCard(
                icon: "shield.fill",
                title: "Privacy Policy",
                subtitle: "How we protect your data",
                color: AppColors.lightGreen,
                action: {
                    viewModel.openPrivacyPolicy()
                }
            )
        }
        .alert("Load Sample Data", isPresented: $showingLoadDataAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Load", role: .destructive) {
                appViewModel.loadSampleData()
            }
        } message: {
            Text("This will replace all current data with sample data for testing.")
        }
        .alert("Clear All Data", isPresented: $showingClearDataAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                appViewModel.clearAllData()
            }
        } message: {
            Text("This will permanently delete all your habits, tasks, and progress. This action cannot be undone.")
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: AppSpacing.lg) {
            VStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppColors.primaryBlue.opacity(0.3), AppColors.accentYellow.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "app.badge")
                        .font(.system(size: 35))
                        .foregroundColor(AppColors.primaryBlue)
                }
                
                VStack(spacing: AppSpacing.xs) {
                    Text("SelfCareCoach")
                        .font(AppFonts.title2())
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("Build healthy habits effortlessly")
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .italic()
                        .padding(.top, AppSpacing.xs)
                }
            }
            .padding(AppSpacing.xl)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: AppRadius.xl)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.95),
                                Color.white.opacity(0.85)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: AppShadows.medium, radius: 10, x: 0, y: 5)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.xl)
                    .stroke(
                        LinearGradient(
                            colors: [AppColors.primaryBlue.opacity(0.3), AppColors.accentYellow.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            
            HStack(spacing: AppSpacing.sm) {
                Text("Made with")
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.textSecondary)
                
                HeartPulseIcon()
                
                Text("for your wellness journey")
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(.top, AppSpacing.sm)
        }
    }
}

struct SettingsCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [color.opacity(0.2), color.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(title)
                        .font(AppFonts.headline())
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(subtitle)
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .fill(Color.white.opacity(0.9))
                    .shadow(color: AppShadows.light, radius: 4, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .stroke(
                        LinearGradient(
                            colors: [color.opacity(0.3), Color.clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 1
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
    }
}

struct HexagonButton: View {
    let icon: String
    let title: String
    let color: Color
    var size: CGFloat = 100
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                action()
            }
        }) {
            VStack(spacing: AppSpacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: size * 0.24))
                    .foregroundColor(.white)
                
                Text(title)
                    .font(AppFonts.bodyMedium())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(width: size, height: size)
            .background(
                HexagonShape()
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .rotation3DEffect(
                .degrees(isPressed ? 5 : 0),
                axis: (x: 1, y: 1, z: 0)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CircleSettingsButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var rotation: Double = 0
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
                rotation += 360
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                action()
            }
        }) {
            VStack(spacing: AppSpacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(rotation))
                
                Text(title)
                    .font(AppFonts.caption())
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .frame(width: 80, height: 80)
            .background(
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [color, color.opacity(0.7)],
                            center: .topLeading,
                            startRadius: 10,
                            endRadius: 50
                        )
                    )
                    .shadow(color: color.opacity(0.4), radius: 6, x: 0, y: 3)
            )
            .scaleEffect(isPressed ? 0.9 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DiamondButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                action()
            }
        }) {
            VStack(spacing: AppSpacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(.white)
                
                Text(title)
                    .font(AppFonts.caption())
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .frame(width: 90, height: 90)
            .background(
                DiamondShape()
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: color.opacity(0.4), radius: 6, x: 0, y: 3)
            )
            .rotationEffect(.degrees(45))
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RoundedSquareButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                action()
            }
        }) {
            VStack(spacing: AppSpacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                
                Text(title)
                    .font(AppFonts.bodyMedium())
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .frame(width: 110, height: 110)
            .background(
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .rotationEffect(.degrees(isPressed ? 5 : 0))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StarButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var rotation: Double = 0
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
                rotation += 180
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                action()
            }
        }) {
            VStack(spacing: AppSpacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                
                Text(title)
                    .font(AppFonts.caption())
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .frame(width: 85, height: 85)
            .background(
                StarShape()
                    .fill(
                        RadialGradient(
                            colors: [color, color.opacity(0.7)],
                            center: .center,
                            startRadius: 5,
                            endRadius: 50
                        )
                    )
                    .shadow(color: color.opacity(0.4), radius: 6, x: 0, y: 3)
            )
            .rotationEffect(.degrees(rotation))
            .scaleEffect(isPressed ? 0.95 : 1.0)
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
            let angle = Double(i) * Double.pi / 3
            let point = CGPoint(
                x: center.x + radius * CGFloat(cos(angle)),
                y: center.y + radius * CGFloat(sin(angle))
            )
            
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

struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let size = min(rect.width, rect.height) / 2
        
        path.move(to: CGPoint(x: center.x, y: center.y - size))
        path.addLine(to: CGPoint(x: center.x + size, y: center.y))
        path.addLine(to: CGPoint(x: center.x, y: center.y + size))
        path.addLine(to: CGPoint(x: center.x - size, y: center.y))
        path.closeSubpath()
        
        return path
    }
}

struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.4
        let points = 5
        
        for i in 0..<points * 2 {
            let angle = Double(i) * Double.pi / Double(points) - Double.pi / 2
            let radius = i % 2 == 0 ? outerRadius : innerRadius
            let point = CGPoint(
                x: center.x + radius * CGFloat(cos(angle)),
                y: center.y + radius * CGFloat(sin(angle))
            )
            
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

struct FloatingSettingsButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    @State private var isAnimating = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(color)
                        .shadow(color: color.opacity(0.4), radius: 6, x: 0, y: 3)
                )
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
        }
        .onAppear {
            withAnimation(
                Animation.easeInOut(duration: 2)
                    .repeatForever(autoreverses: true)
            ) {
                isAnimating = true
            }
        }
    }
}

struct HeartPulseIcon: View {
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Image(systemName: "heart.fill")
            .font(.caption)
            .foregroundColor(AppColors.softPink)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 1.0)
                        .repeatForever(autoreverses: true)
                ) {
                    scale = 1.2
                }
            }
    }
}

#Preview {
    SettingsView()
}
