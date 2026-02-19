import SwiftUI

struct CarePlanView: View {
    @ObservedObject var viewModel: SkinCareViewModel
    @State private var showingAddProcedure = false
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    headerView
                    
                    if viewModel.procedures.isEmpty {
                        emptyStateView
                    } else {
                        todaySection
                        
                        weeklySection
                        
                        progressSection
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 150)
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    addButton
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
        .sheet(isPresented: $showingAddProcedure) {
            AddProcedureView(viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Care Plan")
                .font(.titleLarge)
                .foregroundColor(ColorManager.primaryText)
            
            Text(DateFormatter.dayFormatter.string(from: Date()))
                .font(.bodyMedium)
                .foregroundColor(ColorManager.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.circle")
                .font(.system(size: 60))
                .foregroundColor(ColorManager.primaryBlue.opacity(0.6))
            
            Text("Add your first procedure to start planning your skincare routine")
                .font(.bodyLarge)
                .foregroundColor(ColorManager.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.vertical, 60)
    }
    
    private var todaySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Today")
                    .font(.titleMedium)
                    .foregroundColor(ColorManager.primaryText)
                Spacer()
            }
            
            LazyVStack(spacing: 12) {
                ForEach(viewModel.getDailyProcedures()) { procedure in
                    ProcedureCard(
                        procedure: procedure,
                        procedureId: procedure.id,
                        viewModel: viewModel,
                        onToggle: {
                            viewModel.toggleProcedureCompletion(procedure)
                        }
                    )
                }
            }
        }
        .padding(.horizontal, 4)
    }
    
    private var weeklySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Weekly Procedures")
                    .font(.titleMedium)
                    .foregroundColor(ColorManager.primaryText)
                Spacer()
            }
            
            LazyVStack(spacing: 12) {
                ForEach(viewModel.getWeeklyProcedures()) { procedure in
                    WeeklyProcedureCard(
                        procedure: procedure,
                        procedureId: procedure.id,
                        viewModel: viewModel,
                        onToggle: {
                            viewModel.toggleProcedureCompletion(procedure)
                        }
                    )
                }
            }
        }
        .padding(.horizontal, 4)
    }
    
    private var progressSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Today's Progress")
                    .font(.titleMedium)
                    .foregroundColor(ColorManager.primaryText)
                Spacer()
            }
            
            ProgressCard(percentage: viewModel.getTodayCompletionPercentage())
        }
        .padding(.horizontal, 4)
    }
    
    private var addButton: some View {
        Button(action: {
            showingAddProcedure = true
        }) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [ColorManager.primaryBlue, ColorManager.primaryYellow]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Circle())
                .shadow(color: ColorManager.shadowColor, radius: 10, x: 0, y: 5)
        }
    }
}

struct ProcedureCard: View {
    let procedure: Procedure
    let procedureId: UUID
    @ObservedObject var viewModel: SkinCareViewModel
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: onToggle) {
                Image(systemName: procedure.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(procedure.isCompleted ? ColorManager.successGreen : ColorManager.primaryBlue)
            }
            
            NavigationLink(destination: ProcedureDetailView(viewModel: viewModel, procedureId: procedureId)) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(procedure.name)
                        .font(.bodyLarge)
                        .foregroundColor(ColorManager.darkText)
                        .strikethrough(procedure.isCompleted)
                    
                    HStack {
                        Text(procedure.timeOfDay.rawValue)
                            .font(.bodySmall)
                            .foregroundColor(ColorManager.secondaryText)
                        
                        if let duration = procedure.duration {
                            Text("• \(duration) min")
                                .font(.bodySmall)
                                .foregroundColor(ColorManager.secondaryText)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer(minLength: 0)
        }
        .padding(16)
        .background(ColorManager.cardBackground)
        .cornerRadius(12)
        .shadow(color: ColorManager.shadowColor, radius: 5, x: 0, y: 2)
    }
}

struct WeeklyProcedureCard: View {
    let procedure: Procedure
    let procedureId: UUID
    @ObservedObject var viewModel: SkinCareViewModel
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            NavigationLink(destination: ProcedureDetailView(viewModel: viewModel, procedureId: procedureId)) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(procedure.name)
                        .font(.bodyLarge)
                        .foregroundColor(ColorManager.darkText)
                    
                    if let nextDate = procedure.nextScheduledDate {
                        Text("Next: \(DateFormatter.shortFormatter.string(from: nextDate))")
                            .font(.bodySmall)
                            .foregroundColor(ColorManager.secondaryText)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer(minLength: 0)
            
            Button(action: onToggle) {
                Text("Mark Done")
                    .font(.bodySmall)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(ColorManager.primaryBlue)
                    .cornerRadius(20)
            }
        }
        .padding(16)
        .background(ColorManager.cardBackground)
        .cornerRadius(12)
        .shadow(color: ColorManager.shadowColor, radius: 5, x: 0, y: 2)
    }
}

struct ProgressCard: View {
    let percentage: Double
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("\(Int(percentage))% Complete")
                    .font(.titleSmall)
                    .foregroundColor(ColorManager.darkText)
                Spacer()
            }
            
            ProgressView(value: min(max(percentage, 0), 100), total: 100)
                .progressViewStyle(LinearProgressViewStyle(tint: ColorManager.primaryBlue))
                .scaleEffect(x: 1, y: 2, anchor: .center)
        }
        .padding(20)
        .background(ColorManager.cardBackground)
        .cornerRadius(12)
        .shadow(color: ColorManager.shadowColor, radius: 5, x: 0, y: 2)
    }
}

extension DateFormatter {
    static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter
    }()
    
    static let shortFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
}

#Preview {
    CarePlanView(viewModel: SkinCareViewModel())
}
