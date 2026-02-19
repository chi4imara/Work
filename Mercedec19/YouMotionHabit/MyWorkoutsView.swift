import SwiftUI

struct MyWorkoutsView: View {
    @EnvironmentObject var workoutsVM: WorkoutsViewModel
    @EnvironmentObject var progressVM: ProgressViewModel
    @State private var sortBy: SortOption = .date
    @State private var showAddWorkout = false
    
    enum SortOption: String, CaseIterable {
        case date = "Date"
        case type = "Type"
        case goal = "Goal"
    }
    
    var sortedWorkouts: [ScheduledWorkout] {
        switch sortBy {
        case .date:
            return workoutsVM.scheduledWorkouts.sorted { $0.scheduledDate > $1.scheduledDate }
        case .type:
            return workoutsVM.scheduledWorkouts.sorted { $0.workout.type.rawValue < $1.workout.type.rawValue }
        case .goal:
            return workoutsVM.scheduledWorkouts.sorted { $0.workout.goal.rawValue < $1.workout.goal.rawValue }
        }
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()

            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("My Workouts")
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(ColorTheme.textPrimary)
                            
                            Text("Track your scheduled and completed sessions")
                                .font(.ubuntu(14, weight: .regular))
                                .foregroundColor(ColorTheme.textSecondary)
                        }
                        
                        Spacer()
                        
                        Button(action: { showAddWorkout.toggle() }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(ColorTheme.primaryYellow)
                                .padding(10)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                        }
                    }
                    
                    HStack {
                        Text("Sort by:")
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(ColorTheme.textSecondary)
                        
                        Menu {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Button(option.rawValue) {
                                    sortBy = option
                                }
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Text(sortBy.rawValue)
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(ColorTheme.primaryYellow)
                                
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(ColorTheme.primaryYellow)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(ColorTheme.cardBackground)
                            .cornerRadius(8)
                        }
                        
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if sortedWorkouts.isEmpty {
                            EmptyMyWorkoutsView {
                                showAddWorkout = true
                            }
                        } else {
                            ForEach(sortedWorkouts) { scheduledWorkout in
                                MyWorkoutCard(scheduledWorkout: scheduledWorkout) { action in
                                    handleWorkoutAction(action, for: scheduledWorkout)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .sheet(isPresented: $showAddWorkout) {
            AddWorkoutView()
                .environmentObject(workoutsVM)
        }
    }
    
    private func handleWorkoutAction(_ action: WorkoutAction, for scheduledWorkout: ScheduledWorkout) {
        switch action {
        case .complete:
            workoutsVM.completeWorkout(scheduledWorkout)
            progressVM.recordWorkout()
        case .cancel:
            workoutsVM.cancelWorkout(scheduledWorkout)
        case .addNote(let note):
            workoutsVM.addNote(to: scheduledWorkout, note: note)
        }
    }
}

enum WorkoutAction {
    case complete
    case cancel
    case addNote(String)
}

struct MyWorkoutCard: View {
    let scheduledWorkout: ScheduledWorkout
    let onAction: (WorkoutAction) -> Void
    
    @State private var showNoteSheet = false
    @State private var noteText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(scheduledWorkout.workout.name)
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(ColorTheme.textPrimary)
                    
                    HStack(spacing: 12) {
                        Label(scheduledWorkout.workout.type.rawValue, systemImage: "tag")
                        Label("\(scheduledWorkout.workout.duration) min", systemImage: "clock")
                        Label(scheduledWorkout.scheduledDate.formatted(date: .abbreviated, time: .shortened), systemImage: "calendar")
                    }
                    .font(.ubuntu(11, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                }
                
                Spacer()
                
                StatusBadge(status: scheduledWorkout.status)
            }
            
            if scheduledWorkout.status == .completed {
                ProgressBar(progress: 1.0)
            } else if scheduledWorkout.status == .planned && scheduledWorkout.scheduledDate < Date() {
                ProgressBar(progress: 0.0, color: ColorTheme.warningOrange)
            }
            
            if let notes = scheduledWorkout.notes, !notes.isEmpty {
                Text("Note: \(notes)")
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                    .padding(8)
                    .background(ColorTheme.cardBackground)
                    .cornerRadius(8)
            }
            
            HStack(spacing: 12) {
                if scheduledWorkout.status == .planned {
                    Button {
                        onAction(.complete)
                    } label: {
                        Text("Complete")
                            .font(.ubuntu(12, weight: .bold))
                            .foregroundColor(ColorTheme.primaryWhite)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(ColorTheme.successGreen)
                            .cornerRadius(15)
                    }
                    
                    Button {
                        onAction(.cancel)
                    } label: {
                        Text("Cancel")
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(ColorTheme.textSecondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(ColorTheme.cardBackground)
                            .cornerRadius(15)
                    }
                }
                
                Button {
                    noteText = scheduledWorkout.notes ?? ""
                    showNoteSheet = true
                } label: {
                    Text("Add Note")
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(ColorTheme.primaryYellow)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(ColorTheme.cardBackground)
                        .cornerRadius(15)
                }
                
                Spacer()
            }
        }
        .padding(16)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.cardBorder, lineWidth: 1)
        )
        .sheet(isPresented: $showNoteSheet) {
            NoteSheet(noteText: $noteText) { note in
                onAction(.addNote(note))
            }
        }
    }
}

struct StatusBadge: View {
    let status: WorkoutStatus
    
    var statusColor: Color {
        switch status {
        case .planned:
            return ColorTheme.primaryYellow
        case .completed:
            return ColorTheme.successGreen
        case .missed:
            return ColorTheme.errorRed
        }
    }
    
    var body: some View {
        Text(status.rawValue)
            .font(.ubuntu(10, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor)
            .cornerRadius(8)
    }
}

struct ProgressBar: View {
    let progress: CGFloat
    let color: Color
    
    init(progress: CGFloat, color: Color = ColorTheme.successGreen) {
        self.progress = progress
        self.color = color
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(ColorTheme.cardBackground)
                    .frame(height: 4)
                    .cornerRadius(2)
                
                Rectangle()
                    .fill(color)
                    .frame(width: geometry.size.width * progress, height: 4)
                    .cornerRadius(2)
            }
        }
        .frame(height: 4)
    }
}

struct EmptyMyWorkoutsView: View {
    let onStartFirstWorkout: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "list.bullet.clipboard")
                .font(.system(size: 50, weight: .light))
                .foregroundColor(ColorTheme.textSecondary)
            
            VStack(spacing: 8) {
                Text("You haven't started any workouts yet")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                
                Text("Schedule your first workout and begin your fitness journey")
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                onStartFirstWorkout()
            } label: {
                Text("Start First Workout")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(ColorTheme.primaryYellow)
                    .cornerRadius(25)
            }
        }
        .padding(40)
    }
}

struct NoteSheet: View {
    @Binding var noteText: String
    let onSave: (String) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $noteText)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorTheme.textPrimary)
                    .scrollContentBackground(.hidden)
                    .padding()
                    .background(ColorTheme.cardBackground)
                    .cornerRadius(12)
                    .padding()
                
                Spacer()
            }
            .background(AnimatedBackground())
            .navigationTitle("Add Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(noteText)
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.primaryYellow)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
