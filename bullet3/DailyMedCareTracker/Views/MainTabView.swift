import SwiftUI

struct MainTabView: View {
    @ObservedObject private var medicationViewModel = MedicationViewModel.shared
    @State private var animateCards = false
    @State private var selectedCard: Int? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                FloatingParticlesView()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        HStack {
                            Text("Daily Med Care")
                                .font(AppFonts.largeTitle().bold())
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                        }
                        .padding(.top)
                        
                        heroSection
                        
                        navigationCards
                        
                        quickStatsSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 50)
                }
            }
        }
        .onAppear {
            medicationViewModel.loadData()
            
            withAnimation(.easeInOut(duration: 0.8).delay(0.2)) {
                animateCards = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            medicationViewModel.loadData()
        }
        .onReceive(NotificationCenter.default.publisher(for: .dataCleared)) { _ in
            medicationViewModel.loadData()
        }
    }
    
    private var todayDosesCount: Int {
        let today = Date()
        return medicationViewModel.getDosesForDay(today).count
    }
    
    private var todayTakenDoses: Int {
        let today = Date()
        let todayDoses = medicationViewModel.getDosesForDay(today)
        return todayDoses.filter { $0.status == .taken }.count
    }
    
    private var thisWeekDosesCount: Int {
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek) ?? today
        
        return medicationViewModel.doses.filter { dose in
            dose.date >= startOfWeek && dose.date <= endOfWeek
        }.count
    }
    
    private var heroSection: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [AppColors.accentBlue.opacity(0.4), Color.clear],
                            center: .center,
                            startRadius: 20,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                    .blur(radius: 30)
                
                Circle()
                    .fill(AppColors.cardBackground)
                    .frame(width: 100, height: 100)
                    .overlay(
                        Image(systemName: "pills.fill")
                            .font(.system(size: 45))
                            .foregroundColor(AppColors.accentBlue)
                    )
                    .shadow(color: AppColors.accentBlue.opacity(0.3), radius: 15, x: 0, y: 8)
            }
            .scaleEffect(animateCards ? 1.0 : 0.8)
            .opacity(animateCards ? 1.0 : 0.0)
            
            VStack(spacing: 12) {
                Text("Welcome to Your")
                    .font(AppFonts.title2())
                    .foregroundColor(AppColors.primaryText)
                
                Text("Medication Tracker")
                    .font(AppFonts.largeTitle())
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Stay organized, stay healthy")
                    .font(AppFonts.callout())
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            .opacity(animateCards ? 1.0 : 0.0)
            .offset(y: animateCards ? 0 : 30)
        }
        .padding(.bottom, 40)
        .padding(.top, 10)
    }
    
    private var navigationCards: some View {
        VStack(spacing: 20) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 20) {
                NavigationCard(
                    icon: "calendar.circle.fill",
                    title: "Calendar",
                    subtitle: "Track your medications",
                    color: AppColors.accentBlue,
                    destination: CalendarView(),
                    delay: 0.1,
                    animate: animateCards
                )
                
                NavigationCard(
                    icon: "chart.bar.fill",
                    title: "Analytics",
                    subtitle: "View your progress",
                    color: AppColors.successGreen,
                    destination: AnalyticsView(),
                    delay: 0.2,
                    animate: animateCards
                )
                
                NavigationCard(
                    icon: "book.fill",
                    title: "Reference",
                    subtitle: "Medicine library",
                    color: AppColors.primaryPurple,
                    destination: ReferenceView(),
                    delay: 0.3,
                    animate: animateCards
                )
                
                NavigationCard(
                    icon: "gearshape.fill",
                    title: "Settings",
                    subtitle: "App preferences",
                    color: AppColors.warningYellow,
                    destination: SettingsView(),
                    delay: 0.4,
                    animate: animateCards
                )
            }
        }
    }
    
    private var quickStatsSection: some View {
        VStack(spacing: 15) {
            Text("Quick Overview")
                .font(AppFonts.title3())
                .fontWeight(.semibold)
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 15) {
                StatCard(
                    icon: "pills.fill",
                    title: "Medications",
                    value: "\(medicationViewModel.medications.count)",
                    color: AppColors.accentBlue
                )
                
                StatCard(
                    icon: "checkmark.circle.fill",
                    title: "Today's Doses",
                    value: "\(todayTakenDoses)/\(todayDosesCount)",
                    color: AppColors.successGreen
                )
                
                StatCard(
                    icon: "calendar.badge.clock",
                    title: "This Week",
                    value: "\(thisWeekDosesCount)",
                    color: AppColors.primaryPurple
                )
            }
        }
        .opacity(animateCards ? 1.0 : 0.0)
        .offset(y: animateCards ? 0 : 20)
    }
}

struct NavigationCard<Destination: View>: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let destination: Destination
    let delay: Double
    let animate: Bool
    
    @State private var isPressed = false
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [color.opacity(0.2), color.opacity(0.05)],
                                center: .center,
                                startRadius: 10,
                                endRadius: 40
                            )
                        )
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: icon)
                        .font(.system(size: 35, weight: .medium))
                        .foregroundColor(color)
                }
                
                VStack(spacing: 8) {
                    Text(title)
                        .font(AppFonts.title3())
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.cardText)
                    
                    Text(subtitle)
                        .font(AppFonts.caption2())
                        .foregroundColor(AppColors.cardSecondaryText)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical, 30)
            .padding(.horizontal, 20)
            .concaveCard(color: AppColors.cardBackground)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .scaleEffect(animate ? 1.0 : 0.8)
        .opacity(animate ? 1.0 : 0.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(delay)) {
            }
        }
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 4) {
                Text(value)
                    .font(AppFonts.title2())
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.cardText)
                
                Text(title)
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.cardSecondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .concaveCard(color: AppColors.cardBackground)
    }
}

struct FloatingParticlesView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<12, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: CGFloat.random(in: 15...40))
                    .offset(
                        x: animate ? CGFloat.random(in: -300...300) : CGFloat.random(in: -150...150),
                        y: animate ? CGFloat.random(in: -600...600) : CGFloat.random(in: -300...300)
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 4...8))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.3),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    MainTabView()
}
