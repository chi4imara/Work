import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var viewModel: InteriorIdeasViewModel
    @State private var showingRateApp = false
    @State private var animateCards = false
    @State private var selectedCard: Int? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        VStack(spacing: 20) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Settings")
                                        .font(AppFonts.largeTitle())
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Text("Manage your app preferences")
                                        .font(AppFonts.subheadline())
                                        .foregroundColor(AppColors.secondaryText)
                                }
                                
                                Spacer()
                                
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [AppColors.primaryOrange.opacity(0.3), AppColors.primaryOrange.opacity(0.1)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 70, height: 70)
                                        .overlay(
                                            Circle()
                                                .stroke(AppColors.primaryOrange.opacity(0.5), lineWidth: 2)
                                        )
                                    
                                    Image(systemName: "gearshape.fill")
                                        .font(.system(size: 28, weight: .semibold))
                                        .foregroundColor(AppColors.primaryOrange)
                                        .rotationEffect(.degrees(animateCards ? 360 : 0))
                                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: false), value: animateCards)
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
                            
                            Divider()
                                .overlay {
                                    Color.white
                                }
                        }
                        .padding(.bottom, 30)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 20) {
                            
                            ModernSettingsCard(
                                title: "Terms of Use",
                                subtitle: "Rules and conditions",
                                icon: "doc.text.fill",
                                gradient: LinearGradient(
                                    colors: [AppColors.primaryOrange, AppColors.primaryOrange.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                action: { 
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        selectedCard = selectedCard == 0 ? nil : 0
                                    }
                                    openURL("https://docs.google.com/document/d/1gx4QpVUI5tT5hSJFPBiQoWTzZa4e_4K5pLCEKmSbGA4/edit?usp=sharing")
                                },
                                isSelected: selectedCard == 0
                            )
                            .scaleEffect(animateCards ? 1.0 : 0.8)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateCards)
                            
                            ModernSettingsCard(
                                title: "Privacy Policy",
                                subtitle: "Data protection",
                                icon: "lock.shield.fill",
                                gradient: LinearGradient(
                                    colors: [AppColors.accentPurple, AppColors.accentPurple.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                action: { 
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        selectedCard = selectedCard == 1 ? nil : 1
                                    }
                                    openURL("https://docs.google.com/document/d/1LpP01oQjaaZ_J2e7CzmAte5p8xBOy3wBW-D9sO4iao0/edit?usp=sharing")
                                },
                                isSelected: selectedCard == 1
                            )
                            .scaleEffect(animateCards ? 1.0 : 0.8)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateCards)
                            
                            ModernSettingsCard(
                                title: "Contact Us",
                                subtitle: "Support & help",
                                icon: "envelope.fill",
                                gradient: LinearGradient(
                                    colors: [AppColors.accentGreen, AppColors.accentGreen.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                action: { 
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        selectedCard = selectedCard == 2 ? nil : 2
                                    }
                                    openURL("https://forms.gle/u2MvwRtFpNDdiJbx9")
                                },
                                isSelected: selectedCard == 2
                            )
                            .scaleEffect(animateCards ? 1.0 : 0.8)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateCards)
                            
                            ModernSettingsCard(
                                title: "Rate App",
                                subtitle: "Your feedback matters",
                                icon: "star.fill",
                                gradient: LinearGradient(
                                    colors: [AppColors.accentPink, AppColors.accentPink.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                action: { 
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        selectedCard = selectedCard == 3 ? nil : 3
                                    }
                                    requestReview() 
                                },
                                isSelected: selectedCard == 3
                            )
                            .scaleEffect(animateCards ? 1.0 : 0.8)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateCards)
                        }
                        .padding(.horizontal, 24)
                        
                        FloatingParticlesView()
                            .frame(height: 80)
                            .opacity(0.4)
                        
                        Spacer(minLength: 50)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                withAnimation {
                    animateCards = true
                }
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct ModernSettingsCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let gradient: LinearGradient
    let action: () -> Void
    let isSelected: Bool
    
    @State private var isPressed = false
    @State private var isHovered = false
    @State private var iconRotation: Double = 0
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
                iconRotation += 360
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                action()
            }
        }) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(gradient)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                        )
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(.white.opacity(0.2))
                                    .frame(width: 50, height: 50)
                                
                                Image(systemName: icon)
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.white)
                                    .rotationEffect(.degrees(iconRotation))
                                    .animation(.easeInOut(duration: 0.6), value: iconRotation)
                            }
                            
                            Spacer()
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 4) {
                            Circle()
                                .fill(.white.opacity(0.3))
                                .frame(width: 8, height: 8)
                            Circle()
                                .fill(.white.opacity(0.2))
                                .frame(width: 6, height: 6)
                            Circle()
                                .fill(.white.opacity(0.1))
                                .frame(width: 4, height: 4)
                        }
                    }
                    .padding(20)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(AppFonts.headline())
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(subtitle)
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 20)
            }
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(
                                isSelected ? AppColors.primaryOrange : AppColors.cardBorder,
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
            .shadow(
                color: isSelected ? AppColors.primaryOrange.opacity(0.4) : .black.opacity(0.15),
                radius: isSelected ? 15 : 8,
                x: 0,
                y: isSelected ? 8 : 4
            )
        }
        .scaleEffect(isPressed ? 0.96 : (isHovered ? 1.03 : 1.0))
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isPressed)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}


struct FloatingParticlesView: View {
    @State private var particles: [Particle] = []
    @State private var animateParticles = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles, id: \.id) { particle in
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        particle.color.opacity(0.4),
                                        particle.color.opacity(0.2),
                                        particle.color.opacity(0.0)
                                    ],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: particle.size
                                )
                            )
                            .frame(width: particle.size * 2, height: particle.size * 2)
                            .blur(radius: 0.5)
                        
                        Circle()
                            .fill(particle.color.opacity(0.1))
                            .frame(width: particle.size * 4, height: particle.size * 4)
                            .blur(radius: 2)
                    }
                    .position(particle.position)
                    .animation(
                        Animation.easeInOut(duration: particle.duration)
                            .repeatForever(autoreverses: true),
                        value: particle.position
                    )
                }
            }
        }
        .onAppear {
            createParticles()
            withAnimation(.easeInOut(duration: 2.0)) {
                animateParticles = true
            }
        }
    }
    
    private func createParticles() {
        let colors = [
            AppColors.primaryOrange,
            AppColors.accentPurple,
            AppColors.accentGreen,
            AppColors.accentPink,
            AppColors.primaryBlue
        ]
        
        particles = (0..<12).map { _ in
            Particle(
                id: UUID(),
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                size: CGFloat.random(in: 2...6),
                duration: Double.random(in: 6...12),
                color: colors.randomElement() ?? AppColors.primaryOrange
            )
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            for i in particles.indices {
                withAnimation(
                    Animation.easeInOut(duration: particles[i].duration)
                        .repeatForever(autoreverses: true)
                ) {
                    particles[i].position = CGPoint(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                }
            }
        }
    }
}

struct Particle {
    let id: UUID
    var position: CGPoint
    let size: CGFloat
    let duration: Double
    let color: Color
}

struct StatisticsChartView: View {
    @ObservedObject var viewModel: InteriorIdeasViewModel
    @State private var animateChart = false
    @State private var selectedSegment: Int? = nil
    
    private let chartColors = [
        AppColors.primaryOrange,
        AppColors.accentPurple,
        AppColors.accentGreen,
        AppColors.accentPink,
        AppColors.primaryBlue
    ]
    
    private var chartData: [(category: String, count: Int, color: Color)] {
        let categoryData = viewModel.ideasByCategory
        return InteriorIdea.Category.allCases.enumerated().map { index, category in
            let count = categoryData[category] ?? 0
            let color = chartColors[index % chartColors.count]
            return (category.rawValue, count, color)
        }.filter { $0.count > 0 }
    }
    
    private var totalIdeas: Int {
        chartData.reduce(0) { $0 + $1.count }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if totalIdeas > 0 {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(AppColors.cardBorder, lineWidth: 1)
                        )
                    
                    VStack(spacing: 20) {
                        HStack {
                            Text("Ideas Distribution")
                                .font(AppFonts.headline())
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                            
                            Text("\(totalIdeas) total")
                                .font(AppFonts.caption())
                                .foregroundColor(AppColors.secondaryText)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(AppColors.primaryOrange.opacity(0.2))
                                )
                        }
                        
                        GeometryReader { geometry in
                            ZStack {
                                Circle()
                                    .stroke(AppColors.cardBorder, lineWidth: 2)
                                    .frame(width: min(geometry.size.width, geometry.size.height) - 20)
                                
                                ForEach(Array(chartData.enumerated()), id: \.offset) { index, data in
                                    PieChartSegment(
                                        data: data,
                                        total: totalIdeas,
                                        startAngle: startAngle(for: index),
                                        endAngle: endAngle(for: index),
                                        isSelected: selectedSegment == index,
                                        animate: animateChart
                                    )
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                            selectedSegment = selectedSegment == index ? nil : index
                                        }
                                    }
                                }
                                
                                VStack(spacing: 4) {
                                    Text("\(totalIdeas)")
                                        .font(AppFonts.title1(size: 24))
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Text("ideas")
                                        .font(AppFonts.caption())
                                        .foregroundColor(AppColors.secondaryText)
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .frame(height: 200)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(Array(chartData.enumerated()), id: \.offset) { index, data in
                                LegendItem(
                                    category: data.category,
                                    count: data.count,
                                    color: data.color,
                                    percentage: Double(data.count) / Double(totalIdeas) * 100,
                                    isSelected: selectedSegment == index
                                )
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        selectedSegment = selectedSegment == index ? nil : index
                                    }
                                }
                            }
                        }
                    }
                    .padding(20)
                }
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "chart.pie")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text("No data to display")
                        .font(AppFonts.subheadline())
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text("Add interior ideas to see statistics")
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.tertiaryText)
                        .multilineTextAlignment(.center)
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(AppColors.cardBorder, lineWidth: 1)
                        )
                )
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).delay(0.5)) {
                animateChart = true
            }
        }
    }
    
    private func startAngle(for index: Int) -> Angle {
        let previousCount = chartData.prefix(index).reduce(0) { $0 + $1.count }
        let startPercentage = Double(previousCount) / Double(totalIdeas)
        return .degrees(startPercentage * 360 - 90)
    }
    
    private func endAngle(for index: Int) -> Angle {
        let currentCount = chartData[index].count
        let endPercentage = Double(chartData.prefix(index + 1).reduce(0) { $0 + $1.count }) / Double(totalIdeas)
        return .degrees(endPercentage * 360 - 90)
    }
}

struct PieChartSegment: View {
    let data: (category: String, count: Int, color: Color)
    let total: Int
    let startAngle: Angle
    let endAngle: Angle
    let isSelected: Bool
    let animate: Bool
    
    @State private var animationProgress: Double = 0
    
    var body: some View {
        Path { path in
            let center = CGPoint(x: 100, y: 100)
            let radius: CGFloat = 80
            
            path.move(to: center)
            path.addArc(
                center: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: Angle(degrees: startAngle.degrees + (endAngle.degrees - startAngle.degrees) * animationProgress),
                clockwise: false
            )
            path.closeSubpath()
        }
        .fill(
            RadialGradient(
                colors: [
                    data.color,
                    data.color.opacity(0.8)
                ],
                center: .center,
                startRadius: 0,
                endRadius: 80
            )
        )
        .overlay(
            Path { path in
                let center = CGPoint(x: 100, y: 100)
                let radius: CGFloat = 80
                
                path.move(to: center)
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: Angle(degrees: startAngle.degrees + (endAngle.degrees - startAngle.degrees) * animationProgress),
                    clockwise: false
                )
                path.closeSubpath()
            }
            .stroke(.white.opacity(0.3), lineWidth: 2)
        )
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        .onAppear {
            if animate {
                withAnimation(.easeInOut(duration: 1.0).delay(0.2)) {
                    animationProgress = 1.0
                }
            } else {
                animationProgress = 1.0
            }
        }
    }
}

struct LegendItem: View {
    let category: String
    let count: Int
    let color: Color
    let percentage: Double
    let isSelected: Bool
    
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: 16, height: 16)
                    .overlay(
                        Circle()
                            .stroke(.white, lineWidth: 2)
                    )
                
                if isSelected {
                    Circle()
                        .stroke(color, lineWidth: 3)
                        .frame(width: 24, height: 24)
                        .opacity(0.6)
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(category)
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Text("\(count)")
                        .font(AppFonts.caption2())
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text("(\(String(format: "%.0f", percentage))%)")
                        .font(AppFonts.caption2())
                        .foregroundColor(AppColors.tertiaryText)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? color.opacity(0.2) : Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? color : Color.clear, lineWidth: 1)
                )
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
        }
    }
}

#Preview {
    SettingsView(viewModel: InteriorIdeasViewModel())
}
