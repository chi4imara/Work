import SwiftUI

struct CreateHabitView: View {
    @ObservedObject var habitStore: HabitStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentStep = 0
    @State private var habitName = ""
    @State private var selectedCategory: HabitCategory = .other
    @State private var habitComment = ""
    @State private var startDate = Date()
    
    private let totalSteps = 4
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    progressIndicatorView
                    
                    stepContentView
                        .frame(maxHeight: .infinity)
                    
                    navigationButtonsView
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button("Cancel") {
                dismiss()
            }
            .font(.ubuntu(16, weight: .medium))
            .foregroundColor(AppColors.textWhite)
            
            Spacer()
            
            Text("New Habit")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.textWhite)
            
            Spacer()
            
            Button("Cancel") {
                dismiss()
            }
            .font(.ubuntu(16, weight: .medium))
            .foregroundColor(.clear)
            .disabled(true)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    private var progressIndicatorView: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                ForEach(0..<totalSteps, id: \.self) { step in
                    Circle()
                        .fill(step <= currentStep ? AppColors.accentYellow : AppColors.textWhite.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(step == currentStep ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: currentStep)
                }
            }
            
            Text("Step \(currentStep + 1) of \(totalSteps)")
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(AppColors.textWhite.opacity(0.7))
        }
        .padding(.top, 20)
        .padding(.bottom, 30)
    }
    
    private var stepContentView: some View {
        Group {
            switch currentStep {
            case 0:
                nameStepView
            case 1:
                categoryStepView
            case 2:
                commentStepView
            case 3:
                dateStepView
            default:
                EmptyView()
            }
        }
        .padding(.horizontal, 20)
        .animation(.easeInOut(duration: 0.3), value: currentStep)
    }
    
    private var nameStepView: some View {
        VStack(spacing: 30) {
            VStack(spacing: 15) {
                Text("What habit do you want to break?")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.textWhite)
                    .multilineTextAlignment(.center)
                
                Text("Enter the name of the habit you want to stop")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.textWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            TextField("e.g., Social Media", text: $habitName)
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.textWhite)
                .padding(20)
                .background(AppColors.cardGradient)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(AppColors.textWhite.opacity(0.2), lineWidth: 1)
                )
            
            Spacer()
        }
    }
    
    private var categoryStepView: some View {
        VStack(spacing: 30) {
            VStack(spacing: 15) {
                Text("Choose a category")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.textWhite)
                    .multilineTextAlignment(.center)
                
                Text("This helps organize your habits")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.textWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                ForEach(HabitCategory.allCases) { category in
                    categoryCardView(category: category)
                }
            }
            
            Spacer()
        }
    }
    
    private func categoryCardView(category: HabitCategory) -> some View {
        Button(action: {
            selectedCategory = category
        }) {
            VStack(spacing: 15) {
                Image(systemName: category.icon)
                    .font(.system(size: 30, weight: .medium))
                    .foregroundColor(selectedCategory == category ? AppColors.primaryPurple : category.color)
                
                Text(category.rawValue)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.textWhite)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(
                selectedCategory == category ? 
                AnyShapeStyle(AppColors.accentYellow) : AnyShapeStyle(AppColors.cardGradient)
            )
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        selectedCategory == category ? 
                        AppColors.accentYellow : AppColors.textWhite.opacity(0.2), 
                        lineWidth: selectedCategory == category ? 2 : 1
                    )
            )
        }
        .scaleEffect(selectedCategory == category ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: selectedCategory)
    }
    
    private var commentStepView: some View {
        VStack(spacing: 30) {
            VStack(spacing: 15) {
                Text("Add a comment")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.textWhite)
                    .multilineTextAlignment(.center)
                
                Text("Optional: Why do you want to break this habit?")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.textWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            TextField("e.g., I want more time for reading", text: $habitComment, axis: .vertical)
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(AppColors.textWhite)
                .padding(20)
                .background(AppColors.cardGradient)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(AppColors.textWhite.opacity(0.2), lineWidth: 1)
                )
                .frame(minHeight: 100)
            
            Spacer()
        }
    }
    
    private var dateStepView: some View {
        VStack(spacing: 15) {
            VStack(spacing: 15) {
                Text("When do you start?")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.textWhite)
                    .multilineTextAlignment(.center)
                
                Text("Choose your start date")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.textWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                .colorInvert()
                .datePickerStyle(GraphicalDatePickerStyle())
                .frame(height: 330)
                .background(AppColors.cardGradient)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(AppColors.textWhite.opacity(0.2), lineWidth: 1)
                )
            
            Spacer()
        }
    }
    
    private var navigationButtonsView: some View {
        HStack(spacing: 15) {
            if currentStep > 0 {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentStep -= 1
                    }
                }) {
                    Text("Back")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.textWhite)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(AppColors.cardGradient)
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(AppColors.textWhite.opacity(0.2), lineWidth: 1)
                        )
                }
            }
            
            Button(action: {
                if currentStep < totalSteps - 1 {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentStep += 1
                    }
                } else {
                    saveHabit()
                }
            }) {
                Text(currentStep == totalSteps - 1 ? "Save Habit" : "Next")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryPurple)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(canProceed ? AppColors.accentYellow : AppColors.neutralGray)
                    .cornerRadius(25)
            }
            .disabled(!canProceed)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 50)
    }
    
    private var canProceed: Bool {
        switch currentStep {
        case 0:
            return !habitName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 1:
            return true
        case 2:
            return true
        case 3:
            return true 
        default:
            return false
        }
    }
    
    private func saveHabit() {
        let habit = Habit(
            name: habitName.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            comment: habitComment.trimmingCharacters(in: .whitespacesAndNewlines),
            startDate: startDate
        )
        
        habitStore.addHabit(habit)
        dismiss()
    }
}

#Preview {
    CreateHabitView(habitStore: HabitStore())
}
