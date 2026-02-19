import SwiftUI
import StoreKit

struct MainTabView: View {
    @StateObject private var workoutStore = WorkoutStore()
    
    var body: some View {
        TabView {
            WorkoutsView()
                .tabItem {
                    Image(systemName: "figure.strengthtraining.traditional")
                    Text("Workouts")
                }
                .tag(0)
            
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .tag(1)
            
            HistoryView()
                .environmentObject(workoutStore)
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("History")
                }
                .tag(2)
            
            ExercisesView()
                .environmentObject(workoutStore)
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                    Text("Exercises")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(4)
        }
        .environmentObject(workoutStore)
        .accentColor(ColorManager.accentOrange)
        .preferredColorScheme(.dark)
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(ColorManager.primaryBackground)
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(ColorManager.accentOrange)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(ColorManager.accentOrange),
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(ColorManager.mediumGray)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(ColorManager.mediumGray),
            .font: UIFont.systemFont(ofSize: 12, weight: .regular)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

struct HistoryView: View {
    @EnvironmentObject var workoutStore: WorkoutStore
    
    var body: some View {
        NavigationStack {
            ZStack {
                ColorManager.primaryGradient
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("History")
                            .font(FontManager.playfairDisplay(size: 32, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    
                    if workoutStore.workoutSessions.isEmpty {
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.system(size: 60))
                                .foregroundColor(ColorManager.mediumGray)
                            
                            Text("No workout history yet")
                                .font(FontManager.playfairDisplay(size: 20, weight: .medium))
                                .foregroundColor(ColorManager.secondaryText)
                            
                            Text("Complete your first workout to see it here")
                                .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                                .foregroundColor(ColorManager.tertiaryText)
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                        }
                        .padding()
                        
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 20) {
                                ForEach(Array(workoutStore.sessionsByMonth.keys.sorted(by: >)), id: \.self) { month in
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text(month)
                                            .font(FontManager.playfairDisplay(size: 20, weight: .bold))
                                            .foregroundColor(ColorManager.accentBlue)
                                            .padding(.horizontal, 20)
                                        
                                        ForEach(workoutStore.sessionsByMonth[month] ?? []) { session in
                                            NavigationLink(destination: WorkoutDetailView(workout: workoutStore.workouts.first { $0.id == session.workoutId }!)
                                                .environmentObject(workoutStore)) {
                                                    HistoryRowView(session: session)
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                            .padding(.bottom, 100)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct HistoryRowView: View {
    let session: WorkoutSession
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(session.workoutName)
                    .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                
                HStack(spacing: 8) {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 12))
                        .foregroundColor(ColorManager.accentBlue)
                    
                    Text("\(session.exerciseCount) exercises")
                        .font(FontManager.playfairDisplay(size: 14, weight: .regular))
                        .foregroundColor(ColorManager.secondaryText)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(session.dayMonth)
                    .font(FontManager.playfairDisplay(size: 15, weight: .semibold))
                    .foregroundColor(ColorManager.accentBlue)
            }
        }
        .padding(18)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorManager.accentBlue.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: ColorManager.primaryBackground.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

struct ExercisesView: View {
    @EnvironmentObject var workoutStore: WorkoutStore
    @State private var expandedExercises: Set<String> = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                ColorManager.primaryGradient
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Exercises")
                            .font(FontManager.playfairDisplay(size: 32, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    
                    if workoutStore.allExercises.isEmpty {
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: "list.bullet")
                                .font(.system(size: 60))
                                .foregroundColor(ColorManager.mediumGray)
                            
                            Text("No exercises yet")
                                .font(FontManager.playfairDisplay(size: 20, weight: .medium))
                                .foregroundColor(ColorManager.secondaryText)
                            
                            Text("Create your first workout to see exercises here")
                                .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                                .foregroundColor(ColorManager.tertiaryText)
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                        }
                        .padding()
                        
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(Array(workoutStore.allExercises.keys.sorted()), id: \.self) { exerciseName in
                                    ExerciseRowView(
                                        exerciseName: exerciseName,
                                        workoutCount: workoutStore.allExercises[exerciseName] ?? 0,
                                        workouts: workoutStore.workoutsContaining(exercise: exerciseName),
                                        isExpanded: expandedExercises.contains(exerciseName),
                                        workoutStore: workoutStore
                                    ) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            if expandedExercises.contains(exerciseName) {
                                                expandedExercises.remove(exerciseName)
                                            } else {
                                                expandedExercises.insert(exerciseName)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                            .padding(.bottom, 100)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct ExerciseRowView: View {
    let exerciseName: String
    let workoutCount: Int
    let workouts: [Workout]
    let isExpanded: Bool
    let workoutStore: WorkoutStore
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onTap) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [ColorManager.accentBlue.opacity(0.3), ColorManager.accentPurple.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "figure.strengthtraining.traditional")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(ColorManager.accentBlue)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(exerciseName)
                            .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(ColorManager.primaryText)
                            .multilineTextAlignment(.leading)
                        
                        Text("\(workoutCount) workout\(workoutCount == 1 ? "" : "s")")
                            .font(FontManager.playfairDisplay(size: 14, weight: .regular))
                            .foregroundColor(ColorManager.secondaryText)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(ColorManager.accentBlue)
                        .padding(8)
                        .background(ColorManager.accentBlue.opacity(0.1))
                        .clipShape(Circle())
                }
                .padding(16)
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    Divider()
                        .background(ColorManager.accentBlue.opacity(0.3))
                        .padding(.horizontal, 16)
                    
                    ForEach(workouts) { workout in
                        NavigationLink(destination: WorkoutDetailView(workout: workout)
                            .environmentObject(workoutStore)) {
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(ColorManager.accentOrange.opacity(0.2))
                                    .frame(width: 8, height: 8)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(workout.name)
                                        .font(FontManager.playfairDisplay(size: 15, weight: .medium))
                                        .foregroundColor(ColorManager.primaryText)
                                    
                                    if let exercise = workout.exercises.first(where: { $0.name == exerciseName }) {
                                        Text(exercise.reps)
                                            .font(FontManager.playfairDisplay(size: 13, weight: .regular))
                                            .foregroundColor(ColorManager.accentBlue)
                                    }
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(ColorManager.tertiaryText)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(ColorManager.cardBackground.opacity(0.3))
                            .cornerRadius(12)
                            .padding(.horizontal, 16)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.bottom, 12)
            }
        }
        .background(ColorManager.cardGradient)
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(
                    isExpanded ? ColorManager.accentBlue.opacity(0.4) : ColorManager.accentBlue.opacity(0.2),
                    lineWidth: isExpanded ? 1.5 : 1
                )
        )
        .shadow(color: ColorManager.primaryBackground.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

struct SettingsView: View {
    @State private var isAnimating = false
    
    var body: some View {
            ZStack {
                ColorManager.primaryGradient
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Settings")
                            .font(FontManager.playfairDisplay(size: 32, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            Spacer()
                                .frame(height: 30)
                            
                            VStack(spacing: 35) {
                                SettingsButton(
                                    title: "Privacy Policy",
                                    icon: "shield.checkered",
                                    gradient: LinearGradient(
                                        colors: [ColorManager.accentBlue, ColorManager.accentPurple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    isLarge: true,
                                    action: { openURL("https://www.privacypolicies.com/live/fbbb54b7-4f8b-4c04-9258-997ab32bbd5c") }
                                )
                                .padding(.horizontal, 25)
                                
                                HStack(spacing: 20) {
                                    SettingsButton(
                                        title: "Contact Us",
                                        icon: "envelope.fill",
                                        gradient: LinearGradient(
                                            colors: [ColorManager.accentOrange, ColorManager.accentTeal],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        isLarge: false,
                                        action: { openURL("https://www.privacypolicies.com/live/fbbb54b7-4f8b-4c04-9258-997ab32bbd5c") }
                                    )
                                    
                                    SettingsButton(
                                        title: "Rate App",
                                        icon: "star.fill",
                                        gradient: LinearGradient(
                                            colors: [ColorManager.accentTeal, ColorManager.accentBlue],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        isLarge: false,
                                        action: { requestReview() }
                                    )
                                }
                                .padding(.horizontal, 25)
                            }
                            
                            Spacer()
                                .frame(height: 50)
                        }
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

struct SettingsButton: View {
    let title: String
    let icon: String
    let gradient: LinearGradient
    let isLarge: Bool
    let action: () -> Void
    @State private var isPressed = false
    
    private var iconSize: CGFloat { isLarge ? 80 : 65 }
    private var iconFontSize: CGFloat { isLarge ? 36 : 30 }
    private var titleFontSize: CGFloat { isLarge ? 19 : 16 }
    private var buttonHeight: CGFloat { isLarge ? 180 : 150 }
    private var circleSize: CGFloat { isLarge ? 80 : 65 }
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
            action()
        }) {
            VStack(spacing: 18) {
                ZStack {
                    Circle()
                        .fill(ColorManager.primaryText.opacity(0.2))
                        .frame(width: circleSize, height: circleSize)
                    
                    Image(systemName: icon)
                        .font(.system(size: iconFontSize, weight: .semibold))
                        .foregroundColor(ColorManager.primaryText)
                }
                
                Text(title)
                    .font(FontManager.playfairDisplay(size: titleFontSize, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .frame(height: buttonHeight)
            .background(
                ZStack {
                    gradient
                    
                    RoundedRectangle(cornerRadius: 26)
                        .stroke(
                            LinearGradient(
                                colors: [ColorManager.primaryText.opacity(0.4), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                }
            )
            .cornerRadius(26)
            .overlay(
                RoundedRectangle(cornerRadius: 26)
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.1), Color.clear],
                            startPoint: .top,
                            endPoint: .center
                        )
                    )
            )
            .shadow(
                color: ColorManager.accentBlue.opacity(0.25),
                radius: isPressed ? 10 : 18,
                x: 0,
                y: isPressed ? 5 : 10
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MainTabView()
}
