import SwiftUI

struct WheelOfFortuneView: View {
    @EnvironmentObject var ideaStore: IdeaStore
    @StateObject private var wheelViewModel = WheelViewModel()
    @State private var showingResult = false
    @State private var showingHelp = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 30) {
                WheelHeaderView(
                    ideasCount: ideaStore.ideas.count,
                    onHelpTapped: { showingHelp = true }
                )
                
                if ideaStore.ideas.isEmpty {
                    WheelEmptyStateView()
                } else {
                    EnhancedWheelView(viewModel: wheelViewModel)
                    
                    WheelSpinButton(
                        isSpinning: wheelViewModel.isSpinning,
                        onSpin: { spinWheel() }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
        .onAppear {
            wheelViewModel.updateSections(with: ideaStore.ideas)
        }
        .onChange(of: ideaStore.ideas) { _ in
            wheelViewModel.updateSections(with: ideaStore.ideas)
        }
        .sheet(isPresented: $showingResult) {
            if let idea = wheelViewModel.selectedIdea {
                EnhancedWheelResultView(selectedIdea: idea)
                    .environmentObject(ideaStore)
            }
        }
        .sheet(isPresented: $showingHelp) {
            WheelHelpView()
        }
    }
    
    private func spinWheel() {
        guard !wheelViewModel.isSpinning else { return }
        
        wheelViewModel.spin { selectedIdea in
            showingResult = true
        }
    }
}

class WheelViewModel: ObservableObject {
    @Published var rotationAngle: Double = 0
    @Published var isSpinning = false
    @Published var selectedIdea: Idea?
    @Published var wheelSections: [WheelSection] = []
    @Published var pointerAngle: Double = 0
    @Published var spinVelocity: Double = 0
    
    private let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    func updateSections(with ideas: [Idea]) {
        guard !ideas.isEmpty else {
            wheelSections = []
            return
        }
        
        let anglePerSection = 360.0 / Double(ideas.count)
        wheelSections = ideas.enumerated().map { index, idea in
            let startAngle = Double(index) * anglePerSection
            let endAngle = startAngle + anglePerSection
            return WheelSection(
                idea: idea,
                startAngle: startAngle,
                endAngle: endAngle,
                color: AppColors.wheelColors[index % AppColors.wheelColors.count]
            )
        }
    }
    
    func spin(completion: @escaping (Idea) -> Void) {
        guard !isSpinning, !wheelSections.isEmpty else { return }
        
        isSpinning = true
        hapticFeedback.prepare()
        
        withAnimation(.easeInOut(duration: 0.1).repeatCount(3, autoreverses: true)) {
            pointerAngle = 8
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.pointerAngle = 0
            
            let fullRotations = Double.random(in: 8...12) * 360
            let finalAngle = Double.random(in: 0...360)
            let totalRotation = fullRotations + finalAngle
            
            withAnimation(.timingCurve(0.25, 0.1, 0.25, 1.0, duration: 5.0)) {
                self.rotationAngle += totalRotation
                self.spinVelocity = totalRotation / 5.0
            }
            
            self.addSpinHaptics()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.2) {
                let normalizedRotation = (self.rotationAngle.truncatingRemainder(dividingBy: 360) + 360).truncatingRemainder(dividingBy: 360)
                
                let sectionAngle = 360.0 / Double(self.wheelSections.count)
                
                let effectiveAngle = (360 - normalizedRotation).truncatingRemainder(dividingBy: 360)
                
                let sectionIndex = Int(effectiveAngle / sectionAngle) % self.wheelSections.count

                let safeIndex = sectionIndex % self.wheelSections.count
                self.selectedIdea = self.wheelSections[safeIndex].idea
                
                let successFeedback = UINotificationFeedbackGenerator()
                successFeedback.notificationOccurred(.success)
                
                completion(self.wheelSections[safeIndex].idea)
                
                self.isSpinning = false
                self.spinVelocity = 0
            }
        }
    }
    
    private func addSpinHaptics() {
        let hapticInterval = 0.1
        let totalDuration = 4.0
        
        for i in 0..<Int(totalDuration / hapticInterval) {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * hapticInterval) {
                if self.isSpinning {
                    self.hapticFeedback.impactOccurred()
                }
            }
        }
    }
}


struct WheelHeaderView: View {
    let ideasCount: Int
    let onHelpTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Wheel of Fortune")
                        .font(.nunito(.bold, size: 28))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Let fate choose your next idea")
                        .font(.nunito(.medium, size: 14))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Button(action: onHelpTapped) {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(AppColors.elementBackground)
                                .overlay(
                                    Circle()
                                        .stroke(AppColors.elementBorder, lineWidth: 1)
                                )
                        )
                }
                .buttonStyle(ScaleButtonStyle())
            }
            
            if ideasCount > 0 {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.yellow)
                    
                    Text("\(ideasCount) ideas ready to spin")
                        .font(.nunito(.semiBold, size: 16))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.yellow)
                        .opacity(0.8)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardGradient)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.elementBorder, lineWidth: 1)
                        )
                )
            }
        }
    }
}
    

struct WheelEmptyStateView: View {
    @State private var animateIcon = false
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.elementBackground.opacity(0.3))
                    .frame(width: 200, height: 200)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.3), .clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                
                Image(systemName: "lightbulb")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(AppColors.primaryText.opacity(0.6))
                    .scaleEffect(animateIcon ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateIcon)
            }
            
            VStack(spacing: 12) {
                Text("No Ideas to Spin")
                    .font(.nunito(.bold, size: 24))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add some ideas first to use the wheel of fortune")
                    .font(.nunito(.regular, size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
        .onAppear {
            animateIcon = true
        }
    }
}

struct EnhancedWheelView: View {
    @ObservedObject var viewModel: WheelViewModel
    @State private var glowIntensity: Double = 0.5
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [.gold, .gold.opacity(0.3), .gold],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 8
                )
                .frame(width: 280, height: 280)
                .shadow(color: .gold.opacity(glowIntensity), radius: 15, x: 0, y: 0)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: glowIntensity)
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            AppColors.elementBackground.opacity(0.9),
                            AppColors.elementBackground.opacity(0.6)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 120
                    )
                )
                .frame(width: 240, height: 240)
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.8), .clear, .white.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                )
                .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
            
            GeometryReader { geo in
                ForEach(Array(viewModel.wheelSections.enumerated()), id: \.offset) { index, section in
                    EnhancedWheelSectionView(
                        geo: geo,
                        section: section,
                        index: index,
                        totalSections: viewModel.wheelSections.count,
                        isSpinning: viewModel.isSpinning
                    )
                }
            }
            .rotationEffect(.degrees(viewModel.rotationAngle))

            
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.gold, .orange, .red.opacity(0.8)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 35
                        )
                    )
                    .frame(width: 70, height: 70)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [.white, .white.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 4
                            )
                    )
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                
                Circle()
                    .fill(Color.white.opacity(0.4))
                    .frame(width: 25, height: 25)
                
                ForEach(0..<12, id: \.self) { i in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.9), .white.opacity(0.3)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 2, height: 30)
                        .offset(y: -15)
                        .rotationEffect(.degrees(Double(i) * 30))
                }
            }
            
            EnhancedPointerView(angle: viewModel.pointerAngle)
                .frame(width: 50, height: 70)
                .rotationEffect(.degrees(270))
                .offset(x: 120)
        }
        .onAppear {
            glowIntensity = 0.8
        }
    }
}

struct WheelSpinButton: View {
    let isSpinning: Bool
    let onSpin: () -> Void
    
    @State private var buttonScale: CGFloat = 1.0
    @State private var glowOpacity: Double = 0.3
    
    var body: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedback.impactOccurred()
            onSpin()
        }) {
            HStack(spacing: 12) {
                if isSpinning {
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 3)
                            .frame(width: 24, height: 24)
                        
                        Circle()
                            .trim(from: 0, to: 0.7)
                            .stroke(Color.white, lineWidth: 3)
                            .frame(width: 24, height: 24)
                            .rotationEffect(.degrees(isSpinning ? 360 : 0))
                            .animation(.linear(duration: 1.0).repeatForever(autoreverses: false), value: isSpinning)
                    }
                } else {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 22, weight: .bold))
                        .rotationEffect(.degrees(buttonScale == 1.0 ? 0 : 10))
                }
                
                Text(isSpinning ? "Spinning..." : "Spin the Wheel")
                    .font(.nunito(.bold, size: 18))
                    .animation(.none, value: isSpinning)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: isSpinning ? 
                                    [AppColors.secondaryText, AppColors.secondaryText.opacity(0.8)] :
                                    [AppColors.primaryBlue, AppColors.accentBlue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    if !isSpinning {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.4), .clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    }
                }
            )
            .shadow(
                color: isSpinning ? .clear : AppColors.primaryBlue.opacity(glowOpacity),
                radius: 15,
                x: 0,
                y: 8
            )
            .scaleEffect(buttonScale)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isSpinning)
        .padding(.top, 25)
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                glowOpacity = 0.6
            }
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                buttonScale = pressing ? 0.95 : 1.0
            }
        }, perform: {})
    }
}

struct EnhancedWheelResultView: View {
    @EnvironmentObject var ideaStore: IdeaStore
    @Environment(\.presentationMode) var presentationMode
    
    let selectedIdea: Idea
    @State private var showingCelebration = false
    @State private var confettiAnimation = false
    @State private var cardScale: CGFloat = 0.8
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                if confettiAnimation {
                    ConfettiView()
                }
                
                VStack(spacing: 30) {
                    enhancedCelebrationView
                    
                    enhancedResultCard
                    
                    enhancedActionButtons
                }
                .padding(.horizontal, 20)
                .scaleEffect(cardScale)
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            showingCelebration = true
            confettiAnimation = true
            
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0.3).delay(0.2)) {
                cardScale = 1.0
            }
            
            let hapticFeedback = UINotificationFeedbackGenerator()
            hapticFeedback.notificationOccurred(.success)
        }
    }
    
    private var enhancedCelebrationView: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.yellow.opacity(0.2))
                    .frame(width: 140, height: 140)
                    .scaleEffect(showingCelebration ? 1.4 : 1.0)
                    .opacity(showingCelebration ? 0.3 : 0.8)
                    .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: showingCelebration)
                
                Circle()
                    .fill(Color.yellow.opacity(0.4))
                    .frame(width: 120, height: 120)
                    .scaleEffect(showingCelebration ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: showingCelebration)
                
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.yellow, .orange.opacity(0.8)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 50
                        )
                    )
                    .frame(width: 100, height: 100)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.6), lineWidth: 3)
                    )
                
                ForEach(0..<8, id: \.self) { i in
                    Image(systemName: "star.fill")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .offset(y: -40)
                        .rotationEffect(.degrees(Double(i) * 45))
                        .rotationEffect(.degrees(showingCelebration ? 360 : 0))
                        .animation(.linear(duration: 3.0).repeatForever(autoreverses: false), value: showingCelebration)
                }
                
                Image(systemName: "star.fill")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
                    .scaleEffect(showingCelebration ? 1.1 : 0.9)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: showingCelebration)
            }
            
            VStack(spacing: 8) {
                Text("🎉 Congratulations! 🎉")
                    .font(.nunito(.bold, size: 28))
                    .foregroundColor(AppColors.primaryText)
                
                Text("The wheel has chosen your next project")
                    .font(.nunito(.medium, size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
        }
    }
    
    private var enhancedResultCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(selectedIdea.title)
                        .font(.nunito(.bold, size: 24))
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(2)
                    
                    HStack(spacing: 8) {
                        Image(systemName: selectedIdea.category.iconName)
                            .font(.system(size: 14, weight: .medium))
                        
                        Text(selectedIdea.category.displayName)
                            .font(.nunito(.semiBold, size: 14))
                    }
                    .foregroundColor(AppColors.categoryColor(for: selectedIdea.category))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColors.categoryColor(for: selectedIdea.category).opacity(0.2))
                    )
                }
                
                Spacer()
                
                if selectedIdea.isFavorite {
                    Image(systemName: "star.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.yellow)
                }
            }
            
            if !selectedIdea.description.isEmpty {
                Text(selectedIdea.description)
                    .font(.nunito(.regular, size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .lineSpacing(4)
            }
            
            if !selectedIdea.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(selectedIdea.tags, id: \.id) { tag in
                            Text(tag.name)
                                .font(.nunito(.medium, size: 12))
                                .foregroundColor(AppColors.primaryText)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color(hex: tag.color).opacity(0.3))
                                )
                        }
                    }
                    .padding(.horizontal, 1)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.elementBorder, lineWidth: 1)
                )
        )
    }
    
    private var enhancedActionButtons: some View {
        VStack(spacing: 12) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Back to Wheel")
                        .font(.nunito(.semiBold, size: 16))
                }
                .foregroundColor(AppColors.primaryBlue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.white)
                .cornerRadius(12)
            }
            
            Button(action: {
                ideaStore.toggleFavorite(selectedIdea)
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: selectedIdea.isFavorite ? "star.slash" : "star.fill")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text(selectedIdea.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                        .font(.nunito(.semiBold, size: 16))
                }
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(AppColors.buttonGradient)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.elementBorder, lineWidth: 1)
                )
            }
        }
    }
}

struct WheelSection {
    let idea: Idea
    let startAngle: Double
    let endAngle: Double
    let color: Color
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct PointerView: View {
    var body: some View {
        ZStack {
            Triangle()
                .fill(
                    LinearGradient(
                        colors: [.red, .orange],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    Triangle()
                        .stroke(Color.white, lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
            
            Circle()
                .fill(Color.white)
                .frame(width: 8, height: 8)
                .offset(y: 15)
                .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
        }
    }
}

struct EnhancedWheelSectionView: View {
    let geo: GeometryProxy
    let section: WheelSection
    let index: Int
    let totalSections: Int
    let isSpinning: Bool
    
    @State private var sectionGlow: Double = 0.0
    
    var body: some View {
        ZStack {
            Path { path in
                let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
                let radius: CGFloat = 120
                
                path.move(to: center)
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: .degrees(section.startAngle),
                    endAngle: .degrees(section.endAngle),
                    clockwise: false
                )
                path.closeSubpath()
            }
            .fill(
                RadialGradient(
                    colors: [
                        section.color.opacity(0.9),
                        section.color.opacity(0.7),
                        section.color.opacity(0.5)
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: 120
                )
            )
            .overlay(
                Path { path in
                    let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
                    let radius: CGFloat = 120
                    
                    path.move(to: center)
                    path.addArc(
                        center: center,
                        radius: radius,
                        startAngle: .degrees(section.startAngle),
                        endAngle: .degrees(section.endAngle),
                        clockwise: false
                    )
                    path.closeSubpath()
                }
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.6), .white.opacity(0.2), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
            )
            
            Path { path in
                let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
                let outerRadius: CGFloat = 120
                let innerRadius: CGFloat = 100
                
                let startRadians = section.startAngle * .pi / 180
                
                let startOuter = CGPoint(
                    x: center.x + outerRadius * cos(startRadians),
                    y: center.y + outerRadius * sin(startRadians)
                )
                let startInner = CGPoint(
                    x: center.x + innerRadius * cos(startRadians),
                    y: center.y + innerRadius * sin(startRadians)
                )
                
                path.move(to: startInner)
                path.addLine(to: startOuter)
            }
            .stroke(
                LinearGradient(
                    colors: [.white.opacity(0.8), .white.opacity(0.3)],
                    startPoint: .center,
                    endPoint: .leading
                ),
                lineWidth: 1.5
            )
            
            let midAngle = (section.startAngle + section.endAngle) / 2
            let textRadius: CGFloat = 85
            
            Text(section.idea.title)
                .font(.nunito(.bold, size: min(10, 100 / Double(totalSections))))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: max(40, 160 / Double(totalSections)))
                .rotationEffect(.degrees(midAngle + 90))
                .offset(
                    x: textRadius * cos(midAngle * .pi / 180),
                    y: textRadius * sin(midAngle * .pi / 180)
                )
                .shadow(color: .black.opacity(0.7), radius: 3, x: 1, y: 1)
                .shadow(color: section.color.opacity(0.5), radius: sectionGlow, x: 0, y: 0)
        }
        .onAppear {
            if !isSpinning {
                withAnimation(.easeInOut(duration: Double.random(in: 1.5...3.0)).repeatForever(autoreverses: true).delay(Double(index) * 0.2)) {
                    sectionGlow = 2.0
                }
            }
        }
    }
}

struct EnhancedPointerView: View {
    let angle: Double
    @State private var shadowIntensity: Double = 0.3
    
    var body: some View {
        ZStack {
            Triangle()
                .fill(Color.black.opacity(shadowIntensity))
                .frame(width: 45, height: 65)
                .offset(x: 2, y: 2)
            
            Triangle()
                .fill(
                    LinearGradient(
                        colors: [.red, .orange, .yellow.opacity(0.8)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    Triangle()
                        .stroke(
                            LinearGradient(
                                colors: [.white, .white.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                )
                .shadow(color: .red.opacity(0.4), radius: 8, x: 0, y: 0)
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.white, .gray.opacity(0.8)],
                        center: .center,
                        startRadius: 0,
                        endRadius: 6
                    )
                )
                .frame(width: 12, height: 12)
                .offset(y: 20)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
        }
        .rotationEffect(.degrees(angle))
        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: angle)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                shadowIntensity = 0.6
            }
        }
    }
}


struct ConfettiView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<50, id: \.self) { i in
                ConfettiPiece(index: i)
                    .opacity(animate ? 0 : 1)
                    .animation(.easeOut(duration: Double.random(in: 2...4)).delay(Double.random(in: 0...1)), value: animate)
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct ConfettiPiece: View {
    let index: Int
    @State private var position = CGPoint(x: CGFloat.random(in: 0...400), y: -50)
    @State private var rotation: Double = 0
    
    var body: some View {
        Rectangle()
            .fill(AppColors.wheelColors.randomElement() ?? .blue)
            .frame(width: 8, height: 8)
            .rotationEffect(.degrees(rotation))
            .position(position)
            .onAppear {
                withAnimation(.easeOut(duration: Double.random(in: 2...4))) {
                    position.y = 900
                    position.x += CGFloat.random(in: -100...100)
                    rotation = Double.random(in: 0...720)
                }
            }
    }
}

struct WheelHelpView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
            ZStack {
                AnimatedBackground()
                
                VStack {
                    
                    HStack {
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Done")
                                .font(.nunito(.bold, size: 18))
                                .foregroundColor(AppColors.primaryText)
                        }
                        .opacity(0)
                        .disabled(true)
                        
                        Spacer()
                        
                        Text("Help")
                            .font(.nunito(.bold, size: 18))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Done")
                                .font(.nunito(.bold, size: 18))
                                .foregroundColor(AppColors.primaryText)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom, 8)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("🎯 How to Use the Wheel of Fortune")
                                    .font(.nunito(.bold, size: 24))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Text("Let fate choose your next idea to implement!")
                                    .font(.nunito(.medium, size: 16))
                                    .foregroundColor(AppColors.secondaryText)
                                    .lineSpacing(2)
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                HelpStepView(
                                    icon: "lightbulb.fill",
                                    title: "Add Ideas",
                                    description: "Create some ideas in the 'Ideas' section so they appear on the wheel"
                                )
                                
                                HelpStepView(
                                    icon: "arrow.triangle.2.circlepath",
                                    title: "Spin the Wheel",
                                    description: "Tap the 'Spin the Wheel' button and watch it rotate"
                                )
                                
                                HelpStepView(
                                    icon: "star.fill",
                                    title: "Get Result",
                                    description: "The wheel will stop on a random idea - that's your next project!"
                                )
                                
                                HelpStepView(
                                    icon: "heart.fill",
                                    title: "Add to Favorites",
                                    description: "Liked the selected idea? Add it to favorites for quick access"
                                )
                            }
                        }
                        .padding(20)
                    }
                }
            }
    }
}

struct HelpStepView: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.yellow)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(AppColors.elementBackground)
                        .overlay(
                            Circle()
                                .stroke(AppColors.elementBorder, lineWidth: 1)
                        )
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.nunito(.bold, size: 18))
                    .foregroundColor(AppColors.primaryText)
                
                Text(description)
                    .font(.nunito(.regular, size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .lineSpacing(2)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.elementBorder, lineWidth: 1)
                )
        )
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

extension Color {
    static let gold = Color(hex: "#FFD700")
    static let darkGold = Color(hex: "#B8860B")
}

