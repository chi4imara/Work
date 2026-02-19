import SwiftUI
import StoreKit

enum DayDetailsSheetItem: Identifiable {
    case editWorkout(workoutId: UUID)
    
    var id: String {
        switch self {
        case .editWorkout(let workoutId):
            return "editWorkout-\(workoutId.uuidString)"
        }
    }
}

struct DayDetailsView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @Environment(\.dismiss) private var dismiss
    
    let workoutId: UUID
    
    @State private var sheetItem: DayDetailsSheetItem?
    @State private var showingDeleteAlert = false
    
    private var workout: Workout? {
        viewModel.workout(id: workoutId)
    }
    
    var body: some View {
        if let workout = workout {
            workoutDetailsView(workout: workout)
        } else {
            Text("Workout not found")
                .foregroundColor(ColorManager.primaryText)
        }
    }
    
    private func workoutDetailsView(workout: Workout) -> some View {
        NavigationView {
            ZStack {
                ColorManager.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        VStack(spacing: 15) {
                            Text(workout.day.fullName)
                                .font(.ubuntu(28, weight: .bold))
                                .foregroundColor(ColorManager.primaryText)
                            
                            Text(workout.type.displayName)
                                .font(.ubuntu(20, weight: .medium))
                                .foregroundColor(ColorManager.lightBlue)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(ColorManager.cardGradient)
                                .cornerRadius(20)
                        }
                        .padding(.top, 20)
                        
                        if !workout.note.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Note")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                Text(workout.note)
                                    .font(.ubuntu(14, weight: .regular))
                                    .foregroundColor(ColorManager.secondaryText)
                                    .padding(16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(ColorManager.cardGradient)
                                    .cornerRadius(12)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Last Modified")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                            
                            Text(formatDate(workout.lastModified))
                                .font(.ubuntu(14, weight: .regular))
                                .foregroundColor(ColorManager.secondaryText)
                                .padding(16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(ColorManager.cardGradient)
                                .cornerRadius(12)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Status")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                            
                            HStack {
                                Image(systemName: workout.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .font(.system(size: 20))
                                    .foregroundColor(workout.isCompleted ? ColorManager.green : ColorManager.secondaryText)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(workout.isCompleted ? "Completed" : "Not completed")
                                        .font(.ubuntu(14, weight: .medium))
                                        .foregroundColor(ColorManager.primaryText)
                                    
                                    if let completedDate = workout.completedDate {
                                        Text("Completed on \(formatDate(completedDate))")
                                            .font(.ubuntu(12, weight: .regular))
                                            .foregroundColor(ColorManager.secondaryText)
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding(16)
                            .background(ColorManager.cardGradient)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer()
                        
                        VStack(spacing: 15) {
                            if !workout.isCompleted {
                                Button(action: markCompleted) {
                                    Text("Mark Completed")
                                        .font(.ubuntu(16, weight: .bold))
                                        .foregroundColor(ColorManager.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(ColorManager.green)
                                        .cornerRadius(25)
                                }
                            }
                            
                            HStack(spacing: 15) {
                                Button(action: {
                                    sheetItem = .editWorkout(workoutId: workoutId)
                                }) {
                                    Text("Edit")
                                        .font(.ubuntu(16, weight: .bold))
                                        .foregroundColor(ColorManager.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(
                                            LinearGradient(
                                                colors: [ColorManager.lightBlue, ColorManager.orange],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .cornerRadius(25)
                                }
                                
                                Button(action: {
                                    showingDeleteAlert = true
                                }) {
                                    Text("Delete")
                                        .font(.ubuntu(16, weight: .bold))
                                        .foregroundColor(ColorManager.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(ColorManager.red)
                                        .cornerRadius(25)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("Workout Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorManager.lightBlue)
                }
            }
            .preferredColorScheme(.dark)
        }
        .sheet(item: $sheetItem) { item in
            switch item {
            case .editWorkout(let workoutId):
                if let workout = viewModel.workout(id: workoutId) {
                    AddWorkoutView(viewModel: viewModel, editingWorkout: workout)
                }
            }
        }
        .alert("Delete Workout", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteWorkout()
            }
        } message: {
            Text("Are you sure you want to delete this workout? This action cannot be undone.")
        }
    }
    
    private func markCompleted() {
        guard let workout = workout else { return }
        viewModel.markWorkoutCompleted(workout)
    }
    
    private func deleteWorkout() {
        guard let workout = workout else { return }
        viewModel.deleteWorkout(workout)
        dismiss()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    let viewModel = WorkoutViewModel()
    let workout = Workout(day: .monday, type: .strength, note: "Upper body workout with focus on chest and shoulders")
    viewModel.addWorkout(workout)
    return DayDetailsView(
        viewModel: viewModel,
        workoutId: workout.id
    )
}
