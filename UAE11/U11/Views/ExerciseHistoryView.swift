import SwiftUI

struct ExerciseHistoryView: View {
    let exercise: Exercise
    @EnvironmentObject var viewModel: ExerciseViewModel
    @State private var showingAddResult = false
    @State private var showingEditExercise = false
    @State private var showingDeleteAlert = false
    @Environment(\.dismiss) private var dismiss
    
    private var currentExercise: Exercise? {
        viewModel.exercises.first { $0.id == exercise.id }
    }
    
    private var sortedResults: [WorkoutResult] {
        currentExercise?.results.sorted { $0.date > $1.date } ?? []
    }
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColors.lightBlue)
                    }
                    
                    Spacer()
                    
                    Text(currentExercise?.name ?? exercise.name)
                        .font(.playfairDisplay(size: 20, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Button("Add Result") {
                            showingAddResult = true
                        }
                        .font(.playfairDisplay(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.lightBlue)
                        
                        Menu {
                            Button(action: {
                                showingEditExercise = true
                            }) {
                                Label("Edit Exercise", systemImage: "pencil")
                            }
                            
                            Button(role: .destructive, action: {
                                showingDeleteAlert = true
                            }) {
                                Label("Delete Exercise", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppColors.lightBlue)
                                .padding(8)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 20)
                
                if sortedResults.isEmpty {
                    EmptyHistoryView(showingAddResult: $showingAddResult)
                } else {
                    if let currentExercise = currentExercise {
                        HistoryListView(
                            exercise: currentExercise,
                            results: sortedResults,
                            showingAddResult: $showingAddResult
                        )
                        .environmentObject(viewModel)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingAddResult) {
            if let currentExercise = currentExercise {
                NewResultView(exercise: currentExercise)
                    .environmentObject(viewModel)
            }
        }
        .sheet(isPresented: $showingEditExercise) {
            if let currentExercise = currentExercise {
                EditExerciseView(exercise: currentExercise)
                    .environmentObject(viewModel)
            }
        }
        .alert("Delete Exercise", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let currentExercise = currentExercise {
                    viewModel.deleteExercise(currentExercise)
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete this exercise? All workout results will be lost.")
        }
    }
}

struct EmptyHistoryView: View {
    @Binding var showingAddResult: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "chart.bar.doc.horizontal")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.lightBlue.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("No results yet")
                    .font(.playfairDisplay(size: 24, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add your first workout result")
                    .font(.playfairDisplay(size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                showingAddResult = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("Add Result")
                }
                .font(.playfairDisplay(size: 18, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.lightBlue)
                )
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct HistoryListView: View {
    let exercise: Exercise
    let results: [WorkoutResult]
    @Binding var showingAddResult: Bool
    @EnvironmentObject var viewModel: ExerciseViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                showingAddResult = true
            }) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Add Result")
                        .font(.playfairDisplay(size: 16, weight: .semibold))
                }
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.lightBlue)
                )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(results) { result in
                        ResultRowView(
                            exercise: exercise,
                            result: result
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }
        }
    }
}

struct ResultRowView: View {
    let exercise: Exercise
    let result: WorkoutResult
    @EnvironmentObject var viewModel: ExerciseViewModel
    @State private var showingDeleteAlert = false
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(result.formattedWeight)
                    .font(.playfairDisplay(size: 18, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(result.formattedReps)
                    .font(.playfairDisplay(size: 14, weight: .medium))
                    .foregroundColor(AppColors.lightBlue)
            }
            
            Spacer()
            
            Text(result.formattedDate)
                .font(.playfairDisplay(size: 14, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.dangerButton.opacity(0.7))
                    .padding(8)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
        )
        .alert("Delete Result", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteResult(result, from: exercise)
            }
        } message: {
            Text("Are you sure you want to delete this workout result?")
        }
    }
}

#Preview {
    let sampleExercise = Exercise(name: "Bench Press")
    ExerciseHistoryView(exercise: sampleExercise)
        .environmentObject(ExerciseViewModel())
}
