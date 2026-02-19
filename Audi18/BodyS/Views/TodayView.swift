import SwiftUI

struct TodayView: View {
    @ObservedObject var viewModel: ProcedureViewModel
    
    private var todaysProcedures: [Procedure] {
        viewModel.todaysProcedures()
    }
    
    private var todayName: String {
        WeekDay.today.name
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Today")
                            .font(.bellGothic(size: 28, weight: .bold))
                            .foregroundColor(AppColors.primaryBlue)
                        
                        Text(todayName)
                            .font(.bellGothic(size: 16))
                            .foregroundColor(AppColors.darkGray)
                    }
                    
                    Spacer()
                    
                    Circle()
                        .fill(AppColors.primaryYellow)
                        .frame(width: 12, height: 12)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if todaysProcedures.isEmpty {
                    VStack(spacing: 30) {
                        Spacer()
                        
                        Image(systemName: "sun.max")
                            .font(.system(size: 80))
                            .foregroundColor(AppColors.primaryBlue.opacity(0.3))
                        
                        VStack(spacing: 15) {
                            Text("No procedures for today.")
                                .font(.bellGothic(size: 22, weight: .bold))
                                .foregroundColor(AppColors.primaryBlue)
                            
                            Text("Enjoy your free day or add procedures to your schedule.")
                                .font(.bellGothic(size: 16))
                                .foregroundColor(AppColors.darkGray)
                                .multilineTextAlignment(.center)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(todaysProcedures) { procedure in
                                TodayProcedureView(
                                    procedure: procedure,
                                    viewModel: viewModel
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                    }
                }
            }
        }
    }
}

struct TodayProcedureView: View {
    let procedure: Procedure
    @ObservedObject var viewModel: ProcedureViewModel
    @State private var isExpanded = true
    
    private var completedStepsCount: Int {
        procedure.steps.enumerated().filter { index, _ in
            viewModel.isStepCompleted(procedureId: procedure.id, stepIndex: index)
        }.count
    }
    
    private var progressPercentage: Double {
        guard !procedure.steps.isEmpty else { return 0 }
        return Double(completedStepsCount) / Double(procedure.steps.count)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        NavigationLink(destination: ProcedureDetailView(procedureId: procedure.id, viewModel: viewModel)) {
                            Text(procedure.name)
                                .font(.bellGothic(size: 18, weight: .bold))
                                .foregroundColor(AppColors.primaryBlue)
                                .lineLimit(2)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        if !procedure.steps.isEmpty {
                            HStack(spacing: 8) {
                                Text("\(completedStepsCount)/\(procedure.steps.count) completed")
                                    .font(.bellGothic(size: 14))
                                    .foregroundColor(AppColors.darkGray)
                                
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .fill(AppColors.lightGray)
                                            .frame(height: 4)
                                            .cornerRadius(2)
                                        
                                        Rectangle()
                                            .fill(AppColors.primaryYellow)
                                            .frame(width: geometry.size.width * progressPercentage, height: 4)
                                            .cornerRadius(2)
                                            .animation(.easeInOut(duration: 0.3), value: progressPercentage)
                                    }
                                }
                                .frame(height: 4)
                                .frame(maxWidth: 100)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    if !procedure.steps.isEmpty {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(AppColors.primaryBlue)
                            .animation(.easeInOut(duration: 0.3), value: isExpanded)
                    }
                }
                .padding(16)
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded && !procedure.steps.isEmpty {
                VStack(spacing: 0) {
                    ForEach(Array(procedure.steps.enumerated()), id: \.offset) { index, step in
                        ChecklistStepView(
                            step: step,
                            stepIndex: index,
                            isCompleted: viewModel.isStepCompleted(procedureId: procedure.id, stepIndex: index),
                            onToggle: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    viewModel.toggleStepCompletion(procedureId: procedure.id, stepIndex: index)
                                }
                            }
                        )
                        
                        if index < procedure.steps.count - 1 {
                            Divider()
                                .padding(.leading, 50)
                        }
                    }
                }
                .background(AppColors.lightGray.opacity(0.3))
            }
        }
        .background(AppColors.cardGradient)
        .cornerRadius(12)
        .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct ChecklistStepView: View {
    let step: String
    let stepIndex: Int
    let isCompleted: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(isCompleted ? AppColors.primaryYellow : AppColors.lightGray, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isCompleted {
                        Circle()
                            .fill(AppColors.primaryYellow)
                            .frame(width: 24, height: 24)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: isCompleted)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(step)
                        .font(.bellGothic(size: 16))
                        .foregroundColor(isCompleted ? AppColors.darkGray.opacity(0.6) : AppColors.darkGray)
                        .strikethrough(isCompleted)
                        .lineSpacing(2)
                        .multilineTextAlignment(.leading)
                        .animation(.easeInOut(duration: 0.2), value: isCompleted)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    TodayView(viewModel: ProcedureViewModel())
}
