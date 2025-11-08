import SwiftUI

struct WheelOfFortuneView: View {
    @ObservedObject var viewModel: AppViewModel
    @Environment(\.dismiss) var dismiss
    @State private var isSpinning = false
    @State private var rotationAngle: Double = 0
    @State private var showResult = false
    @State private var showTaskEditor = false
    @State private var animateResult = false
    
    var body: some View {
        NavigationView {
            ZStack {
                StaticBackground()
                
                if viewModel.tasks.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        mainContentView
                    }
                    .padding(.bottom, 40)
                }
                
                VStack {
                    Spacer()
                    
                    Button(action: spinWheel) {
                        HStack {
                            if isSpinning {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: ColorTheme.textLight))
                                    .scaleEffect(0.8)
                                Text("Spinning...")
                            } else {
                                Image(systemName: "arrow.clockwise.circle.fill")
                                Text("Spin Wheel")
                            }
                        }
                        .font(.theme.headline)
                        .foregroundColor(ColorTheme.textLight)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            isSpinning ?
                            AnyShapeStyle(ColorTheme.lightBlue.opacity(0.7)) :
                                AnyShapeStyle(ColorTheme.buttonGradient)
                        )
                        .cornerRadius(28)
                        .shadow(color: ColorTheme.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .disabled(isSpinning)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 10)
                }
                
                if showResult, let currentTask = viewModel.currentTask {
                    resultOverlay(task: currentTask)
                }
            }
            .navigationTitle("Wheel of Fortune")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showTaskEditor = true
                    }) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(ColorTheme.primaryBlue)
                    }
                }
            }
            .sheet(isPresented: $showTaskEditor) {
                TaskEditorView(viewModel: viewModel)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Image(systemName: "circle.grid.cross")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.lightBlue)
            
            VStack(spacing: 12) {
                Text("No Tasks Available")
                    .font(.theme.title2)
                    .foregroundColor(ColorTheme.textPrimary)
                
                Text("Add at least one task to start spinning the wheel")
                    .font(.theme.body)
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                showTaskEditor = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Task")
                }
                .font(.theme.headline)
                .foregroundColor(ColorTheme.textLight)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(ColorTheme.buttonGradient)
                .cornerRadius(25)
            }
            .padding(.horizontal, 40)
        }
    }
    
    private var mainContentView: some View {
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .fill(ColorTheme.backgroundWhite)
                        .frame(width: 280, height: 280)
                        .shadow(color: ColorTheme.primaryBlue.opacity(0.2), radius: 15, x: 0, y: 5)
                    
                    GeometryReader { geo in
                        ForEach(0..<viewModel.tasks.count, id: \.self) { index in
                            WheelSegment(
                                geo: geo,
                                taskNumber: index + 1,
                                index: index,
                                totalSegments: viewModel.tasks.count,
                                colors: segmentColors
                            )
                        }
                        .rotationEffect(.degrees(rotationAngle))
                    }
                    
                    Circle()
                        .fill(ColorTheme.blueGradient)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "sparkles")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(ColorTheme.textLight)
                        )
                    
                    VStack {
                        Triangle()
                            .fill(ColorTheme.darkBlue)
                            .frame(width: 20, height: 30)
                            .rotationEffect(.degrees(180))
                        
                        Spacer()
                    }
                }
                .frame(width: 300, height: 300)
                
                VStack(spacing: 12) {
                    Text("Tasks Legend")
                        .font(.theme.headline)
                        .foregroundColor(ColorTheme.textPrimary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), spacing: 8) {
                        ForEach(0..<viewModel.tasks.count, id: \.self) { index in
                            HStack {
                                Circle()
                                    .fill(segmentColors[index % segmentColors.count])
                                    .frame(width: 16, height: 16)
                                
                                Text("\(index + 1)")
                                    .font(.theme.caption1)
                                    .foregroundColor(ColorTheme.textPrimary)
                                    .frame(width: 20, alignment: .center)
                                
                                Text(viewModel.tasks[index].text)
                                    .font(.theme.caption2)
                                    .foregroundColor(ColorTheme.textSecondary)
                                    .lineLimit(1)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(ColorTheme.backgroundWhite)
                                    .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.top, 20)
    }
    
    private func resultOverlay(task: PartyTask) -> some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissResult()
                }
            
            VStack(spacing: 30) {
                VStack(spacing: 20) {
                    Image(systemName: "party.popper")
                        .font(.system(size: 50, weight: .medium))
                        .foregroundColor(ColorTheme.primaryBlue)
                        .scaleEffect(animateResult ? 1.2 : 0.8)
                        .opacity(animateResult ? 1.0 : 0.0)
                    
                    Text("Your Task")
                        .font(.theme.title3)
                        .foregroundColor(ColorTheme.textSecondary)
                        .opacity(animateResult ? 1.0 : 0.0)
                    
                    VStack(spacing: 8) {
                        Text("Task #\(getTaskNumber(task))")
                            .font(.theme.headline)
                            .foregroundColor(ColorTheme.primaryBlue)
                            .opacity(animateResult ? 1.0 : 0.0)
                        
                        Text(task.text)
                            .font(.theme.title2)
                            .foregroundColor(ColorTheme.textPrimary)
                            .multilineTextAlignment(.center)
                            .opacity(animateResult ? 1.0 : 0.0)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 40)
                .padding(.horizontal, 30)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(ColorTheme.backgroundWhite)
                        .shadow(color: ColorTheme.primaryBlue.opacity(0.2), radius: 20, x: 0, y: 10)
                )
                .scaleEffect(animateResult ? 1.0 : 0.8)
                
                HStack(spacing: 15) {
                    Button(action: {
                        let success = viewModel.addToFavorites(text: task.text, type: .task)
                        showResult = false
                    }) {
                        HStack {
                            Image(systemName: "heart.fill")
                            Text("Save")
                        }
                        .font(.theme.callout)
                        .foregroundColor(ColorTheme.textLight)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(ColorTheme.accentPink)
                        .cornerRadius(22)
                    }
                    
                    Button(action: {
                        dismissResult()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            spinWheel()
                        }
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Spin Again")
                        }
                        .font(.theme.callout)
                        .foregroundColor(ColorTheme.textLight)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(ColorTheme.buttonGradient)
                        .cornerRadius(22)
                    }
                }
                .padding(.horizontal, 30)
                .opacity(animateResult ? 1.0 : 0.0)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                animateResult = true
            }
        }
    }
    
    private var segmentColors: [Color] {
        [
            ColorTheme.primaryBlue,
            ColorTheme.accentPink,
            ColorTheme.accentGreen,
            ColorTheme.accentOrange,
            ColorTheme.accentPurple,
            ColorTheme.lightBlue,
            ColorTheme.darkBlue,
            ColorTheme.textSecondary
        ]
    }
    
    private func spinWheel() {
        guard !isSpinning && !viewModel.tasks.isEmpty else { return }
        
        isSpinning = true
        
        let fullRotations = Double.random(in: 3...6) * 360
        let randomAngle = Double.random(in: 0...360)
        let totalRotation = fullRotations + randomAngle
        
        withAnimation(.easeOut(duration: 3.0)) {
            rotationAngle += totalRotation
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            isSpinning = false
            
            let normalizedRotation = self.rotationAngle.truncatingRemainder(dividingBy: 360)
            let wheelAngle = normalizedRotation < 0 ? normalizedRotation + 360 : normalizedRotation
            
            let segmentAngle = 360.0 / Double(self.viewModel.tasks.count)
            let pointerAngle = (360 - wheelAngle).truncatingRemainder(dividingBy: 360)
            let segmentIndex = Int(pointerAngle / segmentAngle)
            let clampedIndex = min(segmentIndex, self.viewModel.tasks.count - 1)
            
            self.viewModel.currentTask = self.viewModel.tasks[clampedIndex]
            self.viewModel.statistics.wheelSpins += 1
            self.viewModel.saveStatistics()
            
            self.showResult = true
        }
    }
    
    private func dismissResult() {
        withAnimation(.easeInOut(duration: 0.3)) {
            animateResult = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showResult = false
        }
    }
    
    private func getTaskNumber(_ task: PartyTask) -> Int {
        if let index = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
            return index + 1
        }
        return 1
    }
}

struct WheelSegment: View {
    let geo: GeometryProxy
    let taskNumber: Int
    let index: Int
    let totalSegments: Int
    let colors: [Color]
    
    private var segmentAngle: Double {
        360.0 / Double(totalSegments)
    }
    
    private var startAngle: Double {
        Double(index) * segmentAngle - 90
    }
    
    var body: some View {
        ZStack {
            Path { path in
                let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
                let radius: CGFloat = 140
                
                path.move(to: center)
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: .degrees(startAngle),
                    endAngle: .degrees(startAngle + segmentAngle),
                    clockwise: false
                )
                path.closeSubpath()
            }
            .fill(colors[index % colors.count])
            
            Text("\(taskNumber)")
                .font(.theme.title2)
                .fontWeight(.bold)
                .foregroundColor(ColorTheme.textLight)
                .rotationEffect(.degrees(startAngle + segmentAngle / 2 + 90))
                .offset(
                    x: cos((startAngle + segmentAngle / 2) * .pi / 180) * 90,
                    y: sin((startAngle + segmentAngle / 2) * .pi / 180) * 90
                )
        }
    }
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

#Preview {
    WheelOfFortuneView(viewModel: AppViewModel())
}
