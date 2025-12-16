import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsViewModel: SettingsViewModel
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    VStack(spacing: 20) {
                        Spacer(minLength: 60)
                        
                        Text("Settings")
                            .font(.ubuntu(36, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                            .scaleEffect(scale)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: scale)
                        
                        Text("Customize your peaceful experience")
                            .font(.ubuntu(18, weight: .light))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    
                    ZStack {
                        ForEach(0..<4) { index in
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            AppColors.elementPurple.opacity(0.3),
                                            AppColors.warmOrange.opacity(0.3),
                                            AppColors.softGreen.opacity(0.3)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                                .frame(width: 200 + CGFloat(index * 50), height: 200 + CGFloat(index * 50))
                                .rotationEffect(.degrees(rotationAngle + Double(index * 45)))
                                .animation(
                                    .linear(duration: 20 + Double(index * 5))
                                    .repeatForever(autoreverses: false),
                                    value: rotationAngle
                                )
                        }
                        
                        VStack(spacing: 50) {
                            HStack(spacing: 60) {
                                SettingsButton(
                                    item: settingsViewModel.settingsItems[0],
                                    onTap: { settingsViewModel.handleAction($0) }
                                )
                                .rotationEffect(.degrees(-15))
                                
                                SettingsButton(
                                    item: settingsViewModel.settingsItems[1],
                                    onTap: { settingsViewModel.handleAction($0) }
                                )
                                .rotationEffect(.degrees(15))
                            }
                            
                            HStack(spacing: 60) {
                                SettingsButton(
                                    item: settingsViewModel.settingsItems[2],
                                    onTap: { settingsViewModel.handleAction($0) }
                                )
                                .rotationEffect(.degrees(15))
                                
                                SettingsButton(
                                    item: settingsViewModel.settingsItems[3],
                                    onTap: { settingsViewModel.handleAction($0) }
                                )
                                .rotationEffect(.degrees(-15))
                            }
                        }
                        .scaleEffect(pulseScale)
                        .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: pulseScale)
                    }
                    .frame(height: 500)
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 30) {
                        HStack(spacing: 20) {
                            ForEach(0..<5) { index in
                                Circle()
                                    .fill(AppColors.textYellow.opacity(0.4))
                                    .frame(width: 8, height: 8)
                                    .offset(y: sin(Double(index) * 0.5 + rotationAngle * 0.1) * 10)
                                    .animation(
                                        .easeInOut(duration: 2)
                                        .repeatForever(autoreverses: true)
                                        .delay(Double(index) * 0.2),
                                        value: rotationAngle
                                    )
                            }
                        }
                        
                        Text("Every setting is a step towards inner peace")
                            .font(.ubuntuItalic(16, weight: .light))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding(.top, 40)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .onAppear {
            withAnimation {
                scale = 1.0
                rotationAngle = 360
                pulseScale = 1.05
            }
        }
    }
}

struct SettingsButton: View {
    let item: SettingsItem
    let onTap: (SettingsAction) -> Void
    @State private var isPressed = false
    @State private var glowIntensity: Double = 0.3
    
    var body: some View {
        Button(action: {
            onTap(item.action)
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        RadialGradient(
                            colors: [
                                AppColors.elementPurple.opacity(glowIntensity),
                                AppColors.warmOrange.opacity(glowIntensity * 0.5),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 10,
                            endRadius: 60
                        )
                    )
                    .frame(width: 140, height: 120)
                    .blur(radius: 8)
                
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        AppColors.elementPurple.opacity(0.8),
                                        AppColors.warmOrange.opacity(0.6)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: iconForAction(item.action))
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    Text(item.title)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .frame(width: 100)
                }
                .frame(width: 120, height: 100)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            AppColors.elementPurple.opacity(0.6),
                                            AppColors.warmOrange.opacity(0.4)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .shadow(
                            color: AppColors.elementPurple.opacity(0.4),
                            radius: isPressed ? 4 : 12,
                            x: 0,
                            y: isPressed ? 2 : 6
                        )
                )
                .scaleEffect(isPressed ? 0.9 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isPressed)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                glowIntensity = 0.8
            }
        }
    }
    
    private func iconForAction(_ action: SettingsAction) -> String {
        switch action {
        case .termsAndConditions:
            return "doc.text"
        case .privacyPolicy:
            return "lock.shield"
        case .contactEmail:
            return "envelope"
        case .rateApp:
            return "star"
        }
    }
}

#Preview {
    SettingsView(settingsViewModel: SettingsViewModel())
}
