import SwiftUI

struct TodayView: View {
    @EnvironmentObject var viewModel: GroomingViewModel
    @State private var showAddProcedure = false
    @State private var showCelebration = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.getGreeting())
                                .font(FontManager.playfairDisplay(.bold, size: 28))
                                .foregroundColor(.primaryWhite)
                            
                            Text("What's in your routine today?")
                                .font(FontManager.playfairDisplay(.regular, size: 16))
                                .foregroundColor(.primaryWhite.opacity(0.8))
                        }
                        
                        Spacer()
                        
                        DailyProgressIndicator()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                SectionCard(
                    title: "Skincare",
                    icon: "face.smiling",
                    procedures: viewModel.procedures.filter { $0.category == .skincare },
                    onAddTap: { showAddProcedure = true },
                    onProcedureTap: { procedure in
                        withAnimation(.spring()) {
                            viewModel.toggleProcedureCompletion(procedure)
                            if procedure.isCompleted {
                                showCelebrationMessage()
                            }
                        }
                    }
                )
                
                HealthSection()
                
                SectionCard(
                    title: "Style",
                    icon: "tshirt",
                    procedures: viewModel.procedures.filter { $0.category == .style },
                    onAddTap: { showAddProcedure = true },
                    onProcedureTap: { procedure in
                        withAnimation(.spring()) {
                            viewModel.toggleProcedureCompletion(procedure)
                            if procedure.isCompleted {
                                showCelebrationMessage()
                            }
                        }
                    }
                )
                
                DailyChallengeCard()
            }
            .padding(.bottom, 120)
        }
        .environmentObject(viewModel)
        .sheet(isPresented: $showAddProcedure) {
            AddProcedureView()
        }
    }
    
    private func showCelebrationMessage() {
        showCelebration = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showCelebration = false
        }
    }
}

struct SectionCard: View {
    let title: String
    let icon: String
    let procedures: [Procedure]
    let onAddTap: () -> Void
    let onProcedureTap: (Procedure) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(spacing: 12) {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.primaryOrange)
                    
                    Text(title)
                        .font(FontManager.playfairDisplay(.semibold, size: 20))
                        .foregroundColor(.primaryWhite)
                }
                
                Spacer()
                
                Button(action: onAddTap) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.primaryOrange)
                }
            }
            
            if procedures.isEmpty {
                EmptyStateView(message: "Add your first procedure to get started")
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(procedures) { procedure in
                        ProcedureRow(
                            procedure: procedure,
                            onTap: { onProcedureTap(procedure) }
                        )
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardGradient)
        )
        .padding(.horizontal, 20)
    }
}

struct ProcedureRow: View {
    let procedure: Procedure
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(procedure.isCompleted ? Color.primaryOrange : Color.primaryWhite.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if procedure.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.primaryOrange)
                    }
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(procedure.name)
                        .font(FontManager.playfairDisplay(.medium, size: 16))
                        .foregroundColor(.primaryWhite)
                        .strikethrough(procedure.isCompleted)
                    
                    Text(procedure.frequency)
                        .font(FontManager.playfairDisplay(.regular, size: 12))
                        .foregroundColor(.primaryWhite.opacity(0.6))
                }
                
                Spacer()
                
                if procedure.isFavorite {
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.primaryOrange)
                }
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HealthSection: View {
    @EnvironmentObject var viewModel: GroomingViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(spacing: 12) {
                    Image(systemName: "heart")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.primaryOrange)
                    
                    Text("Health")
                        .font(FontManager.playfairDisplay(.semibold, size: 20))
                        .foregroundColor(.primaryWhite)
                }
                
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(viewModel.healthMetrics) { metric in
                    HealthMetricCard(metric: metric) { updatedMetric in
                        viewModel.updateHealthMetric(updatedMetric)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardGradient)
        )
        .padding(.horizontal, 20)
    }
}

struct HealthMetricCard: View {
    let metric: HealthMetric
    let onUpdate: (HealthMetric) -> Void
    @State private var inputValue: String = ""
    @State private var showInput = false
    
    var body: some View {
        Button(action: { showInput = true }) {
            VStack(spacing: 8) {
                Text(metric.name)
                    .font(FontManager.playfairDisplay(.medium, size: 14))
                    .foregroundColor(.primaryWhite)
                
                if metric.value.isEmpty {
                    Text("Tap to add")
                        .font(FontManager.playfairDisplay(.regular, size: 12))
                        .foregroundColor(.primaryWhite.opacity(0.6))
                } else {
                    Text("\(metric.value) \(metric.unit)")
                        .font(FontManager.playfairDisplay(.semibold, size: 16))
                        .foregroundColor(.primaryOrange)
                }
            }
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.primaryWhite.opacity(0.1))
            )
        }
        .buttonStyle(PlainButtonStyle())
        .alert("Enter \(metric.name)", isPresented: $showInput) {
            TextField(metric.unit, text: $inputValue)
                .keyboardType(.decimalPad)
            
            Button("Save") {
                var updatedMetric = metric
                updatedMetric.value = inputValue
                updatedMetric.date = Date()
                onUpdate(updatedMetric)
                inputValue = ""
            }
            
            Button("Cancel", role: .cancel) {
                inputValue = ""
            }
        }
        .onAppear {
            inputValue = metric.value
        }
    }
}

struct DailyChallengeCard: View {
    @EnvironmentObject var viewModel: GroomingViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(spacing: 12) {
                    Image(systemName: "target")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.primaryOrange)
                    
                    Text("Daily Challenge")
                        .font(FontManager.playfairDisplay(.semibold, size: 20))
                        .foregroundColor(.primaryWhite)
                }
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text(viewModel.currentChallenge.title)
                    .font(FontManager.playfairDisplay(.semibold, size: 18))
                    .foregroundColor(.primaryWhite)
                
                Text(viewModel.currentChallenge.description)
                    .font(FontManager.playfairDisplay(.regular, size: 14))
                    .foregroundColor(.primaryWhite.opacity(0.8))
                
                Button(action: {
                    withAnimation(.spring()) {
                        viewModel.completeChallenge()
                    }
                }) {
                    Text(viewModel.currentChallenge.isCompleted ? "Completed!" : "I did it!")
                        .font(FontManager.playfairDisplay(.semibold, size: 16))
                        .foregroundColor(.primaryWhite)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(viewModel.currentChallenge.isCompleted ? Color.successGreen : Color.primaryOrange)
                        )
                }
                .disabled(viewModel.currentChallenge.isCompleted)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardGradient)
        )
        .padding(.horizontal, 20)
    }
}

struct DailyProgressIndicator: View {
    @EnvironmentObject var viewModel: GroomingViewModel
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.primaryWhite.opacity(0.3), lineWidth: 4)
                .frame(width: 60, height: 60)
            
            Circle()
                .trim(from: 0, to: progressValue)
                .stroke(Color.primaryOrange, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 60, height: 60)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1), value: progressValue)
            
            Text("\(Int(progressValue * 100))%")
                .font(FontManager.playfairDisplay(.semibold, size: 12))
                .foregroundColor(.primaryWhite)
        }
    }
    
    private var progressValue: Double {
        viewModel.getTodayProgress()?.progressPercentage ?? 0.0
    }
}

struct EmptyStateView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "plus.circle")
                .font(.system(size: 40))
                .foregroundColor(.primaryWhite.opacity(0.3))
            
            Text(message)
                .font(FontManager.playfairDisplay(.regular, size: 14))
                .foregroundColor(.primaryWhite.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct CelebrationOverlay: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        if isShowing {
            ZStack {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.successGreen)
                        .scaleEffect(isShowing ? 1.0 : 0.5)
                        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isShowing)
                    
                    Text("Excellent work!")
                        .font(FontManager.playfairDisplay(.semibold, size: 20))
                        .foregroundColor(.primaryWhite)
                        .opacity(isShowing ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.3).delay(0.2), value: isShowing)
                }
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.cardGradient)
                )
            }
            .transition(.opacity)
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
            .environmentObject(GroomingViewModel())
            .background(Color.backgroundGradient)
    }
}
