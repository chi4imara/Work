import SwiftUI

struct ScheduleView: View {
    @ObservedObject var viewModel: ProcedureViewModel
    @State private var selectedDay: WeekDay?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Schedule")
                        .font(.bellGothic(size: 28, weight: .bold))
                        .foregroundColor(AppColors.primaryBlue)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.procedures.isEmpty {
                    VStack(spacing: 30) {
                        Spacer()
                        
                        Image(systemName: "calendar")
                            .font(.system(size: 80))
                            .foregroundColor(AppColors.primaryBlue.opacity(0.3))
                        
                        VStack(spacing: 15) {
                            Text("No procedures yet.")
                                .font(.bellGothic(size: 22, weight: .bold))
                                .foregroundColor(AppColors.primaryBlue)
                            
                            Text("Create procedures first, then add them to your schedule.")
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
                            ForEach(WeekDay.allCases, id: \.rawValue) { day in
                                DayScheduleView(
                                    day: day,
                                    viewModel: viewModel,
                                    onAddProcedure: {
                                        selectedDay = day
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                    }
                }
            }
        }
        .sheet(item: $selectedDay) { day in
            ProcedureSelectionView(
                day: day,
                viewModel: viewModel,
                selectedDay: $selectedDay
            )
        }
    }
    
    private var isScheduleEmpty: Bool {
        WeekDay.allCases.allSatisfy { day in
            viewModel.proceduresForDay(day).isEmpty
        }
    }
}

struct DayScheduleView: View {
    let day: WeekDay
    @ObservedObject var viewModel: ProcedureViewModel
    let onAddProcedure: () -> Void
    
    private var procedures: [Procedure] {
        viewModel.proceduresForDay(day)
    }
    
    private var isToday: Bool {
        day == WeekDay.today
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Text(day.name)
                        .font(.bellGothic(size: 18, weight: .bold))
                        .foregroundColor(isToday ? AppColors.primaryYellow : AppColors.primaryBlue)
                    
                    if isToday {
                        Circle()
                            .fill(AppColors.primaryYellow)
                            .frame(width: 8, height: 8)
                    }
                }
                
                Spacer()
                
                Button(action: onAddProcedure) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 28, height: 28)
                        .background(AppColors.primaryYellow)
                        .clipShape(Circle())
                }
            }
            
            if procedures.isEmpty {
                Text("No procedures scheduled")
                    .font(.bellGothic(size: 14))
                    .foregroundColor(AppColors.darkGray.opacity(0.7))
                    .italic()
                    .padding(.leading, 4)
            } else {
                VStack(spacing: 8) {
                    ForEach(procedures) { procedure in
                        NavigationLink(destination: ProcedureDetailView(procedureId: procedure.id, viewModel: viewModel)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(procedure.name)
                                        .font(.bellGothic(size: 16, weight: .bold))
                                        .foregroundColor(AppColors.primaryBlue)
                                        .lineLimit(1)
                                    
                                    if !procedure.steps.isEmpty {
                                        Text("\(procedure.steps.count) steps")
                                            .font(.bellGothic(size: 12))
                                            .foregroundColor(AppColors.darkGray.opacity(0.7))
                                    }
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppColors.primaryBlue.opacity(0.5))
                            }
                            .padding(12)
                            .background(AppColors.cardGradient)
                            .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.7))
                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

struct ProcedureSelectionView: View {
    let day: WeekDay
    @ObservedObject var viewModel: ProcedureViewModel
    @Binding var selectedDay: WeekDay?
    @State private var selectedProcedures: Set<UUID> = []
    
    var availableProcedures: [Procedure] {
        let scheduledIds = Set(viewModel.proceduresForDay(day).map { $0.id })
        return viewModel.procedures.filter { !scheduledIds.contains($0.id) }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack {
                    if viewModel.procedures.isEmpty {
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: "list.clipboard")
                                .font(.system(size: 60))
                                .foregroundColor(AppColors.primaryBlue.opacity(0.3))
                            
                            Text("No procedures available.")
                                .font(.bellGothic(size: 18, weight: .bold))
                                .foregroundColor(AppColors.primaryBlue)
                            
                            Text("Create procedures first in the Procedures tab.")
                                .font(.bellGothic(size: 16))
                                .foregroundColor(AppColors.darkGray)
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 40)
                    } else if availableProcedures.isEmpty {
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: "checkmark.circle")
                                .font(.system(size: 60))
                                .foregroundColor(AppColors.primaryBlue.opacity(0.3))
                            
                            Text("All procedures are already scheduled for \(day.name.lowercased()).")
                                .font(.bellGothic(size: 16))
                                .foregroundColor(AppColors.darkGray)
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 40)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(availableProcedures) { procedure in
                                    Button(action: {
                                        if selectedProcedures.contains(procedure.id) {
                                            selectedProcedures.remove(procedure.id)
                                        } else {
                                            selectedProcedures.insert(procedure.id)
                                        }
                                    }) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(procedure.name)
                                                    .font(.bellGothic(size: 16, weight: .bold))
                                                    .foregroundColor(AppColors.primaryBlue)
                                                    .lineLimit(2)
                                                
                                                if !procedure.description.isEmpty {
                                                    Text(procedure.description)
                                                        .font(.bellGothic(size: 14))
                                                        .foregroundColor(AppColors.darkGray)
                                                        .lineLimit(1)
                                                }
                                                
                                                if !procedure.steps.isEmpty {
                                                    Text("\(procedure.steps.count) steps")
                                                        .font(.bellGothic(size: 12))
                                                        .foregroundColor(AppColors.darkGray.opacity(0.7))
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: selectedProcedures.contains(procedure.id) ? "checkmark.circle.fill" : "circle")
                                                .font(.system(size: 20))
                                                .foregroundColor(selectedProcedures.contains(procedure.id) ? AppColors.primaryYellow : AppColors.lightGray)
                                        }
                                        .padding(16)
                                        .background(AppColors.cardGradient)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(
                                                    selectedProcedures.contains(procedure.id) ? AppColors.primaryYellow : Color.clear,
                                                    lineWidth: 2
                                                )
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                }
            }
            .navigationTitle("Add to \(day.name)")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        selectedDay = nil
                    }
                    .font(.bellGothic(size: 16))
                    .foregroundColor(AppColors.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addSelectedProcedures()
                    }
                    .font(.bellGothic(size: 16, weight: .bold))
                    .foregroundColor(selectedProcedures.isEmpty ? AppColors.lightGray : AppColors.primaryYellow)
                    .disabled(selectedProcedures.isEmpty)
                }
            }
        }
    }
    
    private func addSelectedProcedures() {
        for procedureId in selectedProcedures {
            viewModel.addProcedureToSchedule(procedureId, day: day)
        }
        selectedDay = nil
    }
}

#Preview {
    ScheduleView(viewModel: ProcedureViewModel())
}
