import SwiftUI

struct TodayView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var showingAddTask = false
    @State private var showingCelebration = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(viewModel.greeting)
                                    .font(.playfairDisplay(.bold, size: 28))
                                    .foregroundColor(.primaryBlue)
                                
                                Text("What's new in your journey today?")
                                    .font(.playfairDisplay(.regular, size: 16))
                                    .foregroundColor(.textSecondary)
                            }
                            
                            Spacer()
                            
                            CircularProgressView(progress: viewModel.dailyProgress, size: 60)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Today's Tasks")
                                .font(.playfairDisplay(.semibold, size: 22))
                                .foregroundColor(.primaryBlue)
                            
                            Spacer()
                            
                            Button(action: {
                                showingAddTask = true
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.primaryYellow)
                            }
                        }
                        
                        if viewModel.dailyTasks.isEmpty {
                            EmptyStateView(
                                title: "No tasks yet",
                                subtitle: "Start with one task - it's already an adventure!",
                                systemImage: "checkmark.circle"
                            )
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.dailyTasks) { task in
                                    TaskCardView(task: task) {
                                        withAnimation(.spring()) {
                                            viewModel.markTaskAsCompleted(task)
                                            if viewModel.dailyProgress == 1.0 {
                                                showingCelebration = true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .cardStyle()
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("My Places")
                            .font(.playfairDisplay(.semibold, size: 22))
                            .foregroundColor(.primaryBlue)
                        
                        if viewModel.places.isEmpty {
                            EmptyStateView(
                                title: "No places added",
                                subtitle: "Add your first location and start exploring!",
                                systemImage: "location.circle"
                            )
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.places.prefix(3)) { place in
                                    PlaceCardView(place: place) {
                                        withAnimation(.spring()) {
                                            viewModel.markPlaceAsCompleted(place)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .cardStyle()
                    .padding(.horizontal, 20)
                    
                    if let challenge = viewModel.currentChallenge {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Today's Mini Challenge")
                                .font(.playfairDisplay(.semibold, size: 22))
                                .foregroundColor(.primaryBlue)
                            
                            ChallengeCardView(challenge: challenge) {
                                withAnimation(.spring()) {
                                    viewModel.completeDailyChallenge()
                                    showingCelebration = true
                                }
                            }
                        }
                        .cardStyle()
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView(viewModel: viewModel)
        }
        .overlay(
            CelebrationView(isShowing: $showingCelebration)
        )
    }
}

struct TaskCardView: View {
    let task: DailyTask
    let onComplete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: onComplete) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(task.isCompleted ? .successGreen : .primaryBlue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.playfairDisplay(.medium, size: 16))
                    .foregroundColor(.primaryBlue)
                    .strikethrough(task.isCompleted)
                
                HStack {
                    Image(systemName: task.category.icon)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text(task.category.rawValue)
                        .font(.playfairDisplay(.regular, size: 14))
                        .foregroundColor(.textSecondary)
                }
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(task.isCompleted ? Color.successGreen.opacity(0.1) : Color.white.opacity(0.8))
        )
    }
}

struct PlaceCardView: View {
    let place: Place
    let onComplete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: onComplete) {
                Image(systemName: place.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(place.isCompleted ? .successGreen : .primaryBlue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(place.name)
                    .font(.playfairDisplay(.medium, size: 16))
                    .foregroundColor(.primaryBlue)
                    .strikethrough(place.isCompleted)
                
                HStack {
                    Image(systemName: place.category.icon)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text(place.category.rawValue)
                        .font(.playfairDisplay(.regular, size: 14))
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                    
                    Text(place.status.rawValue)
                        .font(.playfairDisplay(.regular, size: 12))
                        .foregroundColor(.primaryYellow)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.primaryYellow.opacity(0.2))
                        )
                }
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(place.isCompleted ? Color.successGreen.opacity(0.1) : Color.white.opacity(0.8))
        )
    }
}

struct ChallengeCardView: View {
    let challenge: MiniChallenge
    let onComplete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(challenge.title)
                .font(.playfairDisplay(.semibold, size: 18))
                .foregroundColor(.primaryBlue)
            
            Text(challenge.description)
                .font(.playfairDisplay(.regular, size: 14))
                .foregroundColor(.textSecondary)
            
            Button("I did it!") {
                onComplete()
            }
            .primaryButtonStyle()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.primaryYellow.opacity(0.1), Color.primaryBlue.opacity(0.1)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
    }
}

struct EmptyStateView: View {
    let title: String
    let subtitle: String
    let systemImage: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: 48))
                .foregroundColor(.primaryBlue.opacity(0.6))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.playfairDisplay(.semibold, size: 18))
                    .foregroundColor(.primaryBlue)
                
                Text(subtitle)
                    .font(.playfairDisplay(.regular, size: 14))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(32)
    }
}

struct CelebrationView: View {
    @Binding var isShowing: Bool
    @State private var animationScale: CGFloat = 0.1
    @State private var animationOpacity: Double = 0
    
    var body: some View {
        if isShowing {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismissCelebration()
                    }
                
                VStack(spacing: 24) {
                    Text("🎉")
                        .font(.system(size: 80))
                        .scaleEffect(animationScale)
                    
                    VStack(spacing: 12) {
                        Text("Awesome!")
                            .font(.playfairDisplay(.bold, size: 28))
                            .foregroundColor(.primaryBlue)
                        
                        Text("You're opening new horizons!")
                            .font(.playfairDisplay(.regular, size: 16))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button("Continue") {
                        dismissCelebration()
                    }
                    .primaryButtonStyle()
                }
                .padding(32)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white)
                        .shadow(radius: 20)
                )
                .padding(.horizontal, 40)
                .scaleEffect(animationScale)
                .opacity(animationOpacity)
            }
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    animationScale = 1.0
                    animationOpacity = 1.0
                }
            }
        }
    }
    
    private func dismissCelebration() {
        withAnimation(.easeInOut(duration: 0.3)) {
            animationScale = 0.1
            animationOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isShowing = false
        }
    }
}

#Preview {
    TodayView(viewModel: AppViewModel())
}
