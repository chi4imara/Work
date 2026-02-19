import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: ExerciseViewModel
    @State private var showingAddExercise = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                AppColors.primaryGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        Text("Exercise Weights")
                            .font(.playfairDisplay(size: 28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                            .padding(.top, 20)
                        
                        SearchBar(text: $viewModel.searchText)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    
                    if viewModel.filteredExercises.isEmpty {
                        EmptyStateView(showingAddExercise: $showingAddExercise)
                        
                        Spacer()
                    } else {
                        ExerciseListView(
                            exercises: viewModel.filteredExercises,
                            showingAddExercise: $showingAddExercise
                        )
                    }

                }
            }
        }
        .sheet(isPresented: $showingAddExercise) {
            NewExerciseView()
                .environmentObject(viewModel)
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.secondaryText)
            
            TextField("Search exercises...", text: $text)
                .font(.playfairDisplay(size: 16))
                .foregroundColor(AppColors.primaryText)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
        )
    }
}

struct EmptyStateView: View {
    @Binding var showingAddExercise: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "dumbbell")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.lightBlue.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("Add your first exercise")
                    .font(.playfairDisplay(size: 24, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Start tracking your strength progress")
                    .font(.playfairDisplay(size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                showingAddExercise = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("Add Exercise")
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

struct ExerciseListView: View {
    let exercises: [Exercise]
    @Binding var showingAddExercise: Bool
    @EnvironmentObject var viewModel: ExerciseViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                showingAddExercise = true
            }) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Add Exercise")
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
                    ForEach(exercises) { exercise in
                        NavigationLink(destination: ExerciseHistoryView(exercise: exercise)
                            .environmentObject(viewModel)) {
                            ExerciseRowView(exercise: exercise)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                viewModel.deleteExercise(exercise)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }
        }
    }
}

struct ExerciseRowView: View {
    let exercise: Exercise
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(exercise.name)
                    .font(.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                if let lastResult = exercise.lastResult {
                    HStack(spacing: 8) {
                        Text(lastResult.displayText)
                            .font(.playfairDisplay(size: 14, weight: .medium))
                            .foregroundColor(AppColors.lightBlue)
                        
                        Text("•")
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text(lastResult.formattedDate)
                            .font(.playfairDisplay(size: 14))
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
        )
    }
}

#Preview {
    HomeView()
        .environmentObject(ExerciseViewModel())
}
