import SwiftUI

struct HabitsView: View {
    @StateObject private var viewModel = HabitsViewModel()
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerSection
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.top, AppSpacing.sm)
                
                if viewModel.habits.isEmpty {
                    emptyStateView
                } else {
                    habitsList
                }
            }
        }
        .onAppear {
            viewModel.habits = appViewModel.habits
        }
        .onChange(of: appViewModel.habits, perform: { newHabits in
            if viewModel.habits != newHabits {
                viewModel.habits = newHabits
            }
        })
        .sheet(isPresented: $viewModel.showingAddHabit) {
            AddHabitView { habit in
                viewModel.addHabit(habit)
                appViewModel.addHabit(habit)
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("My Habits")
                    .font(AppFonts.title1())
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Track your daily progress")
                    .font(AppFonts.body())
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Button(action: { viewModel.showingAddHabit = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(AppColors.accentYellow)
            }
        }
    }
    
    private var habitsList: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.md) {
                ForEach(viewModel.habits) { habit in
                    HabitCard(habit: habit) {
                        viewModel.updateHabitProgress(habit.id)
                        if let index = appViewModel.habits.firstIndex(where: { $0.id == habit.id }) {
                            appViewModel.habits[index].completedDays += 1
                            appViewModel.habits[index].streak += 1
                            appViewModel.habits[index].lastCompletedDate = Date()
                            appViewModel.checkAndUnlockAchievements()
                        }
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.lg)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()
            
            Image(systemName: "heart.circle")
                .font(.system(size: 80))
                .foregroundColor(AppColors.textSecondary)
            
            Text("You haven't added a habit yet")
                .font(AppFonts.title2())
                .foregroundColor(AppColors.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Start building healthy habits by adding your first one")
                .font(AppFonts.body())
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            
            Button {
                viewModel.showingAddHabit = true
            } label: {
                Text("Add Habit")
                    .font(AppFonts.button())
                    .foregroundColor(AppColors.textLight)
                    .padding(.horizontal, AppSpacing.xl)
                    .padding(.vertical, AppSpacing.md)
                    .background(AppColors.accentYellow)
                    .cornerRadius(AppRadius.lg)
                    .shadow(color: AppShadows.medium, radius: 4, x: 0, y: 2)
            }
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.lg)
    }
}

struct HabitCard: View {
    let habit: Habit
    let onUpdate: () -> Void
    @State private var showingProgress = false
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            HStack {
                HStack(spacing: AppSpacing.sm) {
                    Image(systemName: habit.type.icon)
                        .font(.title2)
                        .foregroundColor(habit.type.color)
                    
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text(habit.name)
                            .font(AppFonts.headline())
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text(habit.frequency.rawValue)
                            .font(AppFonts.caption())
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: AppSpacing.xs) {
                    HStack(spacing: AppSpacing.xs) {
                        Image(systemName: "flame.fill")
                            .font(.caption)
                            .foregroundColor(AppColors.accentYellow)
                        
                        Text("\(habit.streak)")
                            .font(AppFonts.bodyMedium())
                            .foregroundColor(AppColors.textPrimary)
                    }
                    
                    Text("day streak")
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                HStack {
                    Text("Progress")
                        .font(AppFonts.body())
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Text("\(habit.completedDays)/\(habit.targetDays) days")
                        .font(AppFonts.bodyMedium())
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("(\(habit.progressPercentage)%)")
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.textSecondary)
                }
                
                SwiftUI.ProgressView(value: habit.progress)
                    .progressViewStyle(CustomProgressViewStyle(color: habit.type.color))
                    .scaleEffect(y: 2.0)
            }
            
            HStack(spacing: AppSpacing.md) {
                Button {
                    withAnimation(.spring()) {
                        onUpdate()
                    }
                } label: {
                    Text("Mark Complete")
                        .font(AppFonts.button())
                        .foregroundColor(AppColors.textLight)
                        .padding(.vertical, AppSpacing.sm)
                        .frame(maxWidth: .infinity)
                        .background(habit.type.color)
                        .cornerRadius(AppRadius.md)
                }
                
                Button(action: { showingProgress.toggle() }) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.title3)
                        .foregroundColor(AppColors.textPrimary)
                }
                .padding(AppSpacing.sm)
                .background(Color.white.opacity(0.8))
                .cornerRadius(AppRadius.md)
            }
        }
        .padding(AppSpacing.md)
        .background(Color.white.opacity(0.9))
        .cornerRadius(AppRadius.lg)
        .shadow(color: AppShadows.light, radius: 4, x: 0, y: 2)
        .sheet(isPresented: $showingProgress) {
            HabitProgressView(habit: habit)
        }
    }
}

struct CustomProgressViewStyle: ProgressViewStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 4)
                    .cornerRadius(2)
                
                Rectangle()
                    .fill(color)
                    .frame(width: geometry.size.width * CGFloat(configuration.fractionCompleted ?? 0), height: 4)
                    .cornerRadius(2)
            }
        }
        .frame(height: 4)
    }
}

struct AddHabitView: View {
    @Environment(\.presentationMode) var presentationMode
    let onAdd: (Habit) -> Void
    
    @State private var name = ""
    @State private var selectedType: HabitType = .sleep
    @State private var selectedFrequency: Frequency = .daily
    @State private var targetDays = 7
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: AppSpacing.lg) {
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Habit Name")
                                .font(AppFonts.headline())
                                .foregroundColor(AppColors.textPrimary)
                            
                            TextField("Enter habit name", text: $name)
                                .font(AppFonts.body())
                                .padding(AppSpacing.md)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(AppRadius.md)
                        }
                        
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Type")
                                .font(AppFonts.headline())
                                .foregroundColor(AppColors.textPrimary)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: AppSpacing.sm) {
                                ForEach(HabitType.allCases) { type in
                                    Button(action: { selectedType = type }) {
                                        HStack {
                                            Image(systemName: type.icon)
                                                .foregroundColor(type.color)
                                            Text(type.rawValue)
                                                .font(AppFonts.body())
                                                .foregroundColor(AppColors.textPrimary)
                                        }
                                        .padding(AppSpacing.md)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            selectedType == type ?
                                            type.color.opacity(0.3) :
                                            Color.white.opacity(0.8)
                                        )
                                        .cornerRadius(AppRadius.md)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: AppRadius.md)
                                                .stroke(
                                                    selectedType == type ? type.color : Color.clear,
                                                    lineWidth: 2
                                                )
                                        )
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Frequency")
                                .font(AppFonts.headline())
                                .foregroundColor(AppColors.textPrimary)
                            
                            Picker("Frequency", selection: $selectedFrequency) {
                                ForEach(Frequency.allCases) { frequency in
                                    Text(frequency.rawValue).tag(frequency)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Target Days: \(targetDays)")
                                .font(AppFonts.headline())
                                .foregroundColor(AppColors.textPrimary)
                            
                            Slider(value: Binding(
                                get: { Double(targetDays) },
                                set: { targetDays = Int($0) }
                            ), in: 1...90, step: 1)
                            .accentColor(selectedType.color)
                        }
                    }
                    .padding(AppSpacing.md)
                }
            }
            .navigationTitle("Add Habit")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    let habit = Habit(name: name, type: selectedType, frequency: selectedFrequency, targetDays: targetDays)
                    onAdd(habit)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(name.isEmpty)
            )
        }
    }
}

struct HabitProgressView: View {
    let habit: Habit
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: AppSpacing.lg) {
                    ZStack {
                        Circle()
                            .stroke(habit.type.color.opacity(0.3), lineWidth: 12)
                            .frame(width: 150, height: 150)
                        
                        Circle()
                            .trim(from: 0, to: habit.progress)
                            .stroke(habit.type.color, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                            .frame(width: 150, height: 150)
                            .rotationEffect(.degrees(-90))
                        
                        VStack {
                            Text("\(habit.progressPercentage)%")
                                .font(AppFonts.title1())
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text("Complete")
                                .font(AppFonts.body())
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                    
                    VStack(spacing: AppSpacing.md) {
                        HStack {
                            StatCard(title: "Completed", value: "\(habit.completedDays)", color: habit.type.color)
                            StatCard(title: "Target", value: "\(habit.targetDays)", color: AppColors.textSecondary)
                        }
                        
                        HStack {
                            StatCard(title: "Streak", value: "\(habit.streak)", color: AppColors.accentYellow)
                            StatCard(title: "Remaining", value: "\(max(0, habit.targetDays - habit.completedDays))", color: AppColors.textSecondary)
                        }
                    }
                    
                    Spacer()
                }
                .padding(AppSpacing.lg)
            }
            .navigationTitle(habit.name)
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            Text(value)
                .font(AppFonts.title2())
                .foregroundColor(color)
            
            Text(title)
                .font(AppFonts.caption())
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(AppSpacing.md)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.8))
        .cornerRadius(AppRadius.md)
    }
}

#Preview {
    HabitsView()
        .environmentObject(AppViewModel())
}
