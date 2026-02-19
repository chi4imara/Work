import SwiftUI

struct ProcedureDetailView: View {
    @ObservedObject var viewModel: SkinCareViewModel
    let procedureId: UUID
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var procedure: Procedure? {
        viewModel.procedure(byId: procedureId)
    }
    
    @ViewBuilder
    private var editSheetContent: some View {
        if viewModel.procedure(byId: procedureId) != nil {
            EditProcedureView(viewModel: viewModel, procedureId: procedureId)
        } else {
            EmptyView()
        }
    }
    
    var body: some View {
        Group {
            if let procedure = procedure {
                detailContent(procedure: procedure)
            } else {
                procedureNotFoundView
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if procedure != nil {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        showingEditView = true
                    }
                    .foregroundColor(ColorManager.primaryBlue)
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            editSheetContent
        }
        .alert("Delete Procedure", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deleteProcedure(byId: procedureId)
                presentationMode.wrappedValue.dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this procedure? This action cannot be undone.")
        }
    }
    
    private func detailContent(procedure: Procedure) -> some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView(procedure: procedure)
                    detailsView(procedure: procedure)
                    historyView(procedure: procedure)
                    actionButtonsView(procedure: procedure)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
    }
    
    private var procedureNotFoundView: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "questionmark.circle")
                    .font(.system(size: 50))
                    .foregroundColor(ColorManager.secondaryText)
                Text("Procedure not found")
                    .font(.titleMedium)
                    .foregroundColor(ColorManager.primaryText)
                Button("Back") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(ColorManager.primaryBlue)
            }
        }
    }
    
    private func headerView(procedure: Procedure) -> some View {
        VStack(spacing: 12) {
            Text(procedure.name)
                .font(.titleLarge)
                .foregroundColor(ColorManager.primaryText)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 16) {
                Label(procedure.type.rawValue, systemImage: "tag")
                Label(procedure.frequency.rawValue, systemImage: "repeat")
            }
            .font(.bodyMedium)
            .foregroundColor(ColorManager.secondaryText)
        }
        .padding(.vertical, 20)
    }
    
    private func detailsView(procedure: Procedure) -> some View {
        VStack(spacing: 16) {
            HStack {
                Text("Details")
                    .font(.titleMedium)
                    .foregroundColor(ColorManager.primaryText)
                Spacer()
            }
            
            VStack(spacing: 12) {
                DetailRow(title: "Time of Day", value: procedure.timeOfDay.rawValue)
                
                if let duration = procedure.duration {
                    DetailRow(title: "Duration", value: "\(duration) minutes")
                }
                
                if let nextDate = procedure.nextScheduledDate {
                    DetailRow(title: "Next Scheduled", value: DateFormatter.detailFormatter.string(from: nextDate))
                }
                
                if !procedure.notes.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.bodyLarge)
                            .foregroundColor(ColorManager.primaryText)
                            .fontWeight(.medium)
                        
                        Text(procedure.notes)
                            .font(.bodyMedium)
                            .foregroundColor(ColorManager.secondaryText)
                            .padding(12)
                            .background(ColorManager.cardBackground.opacity(0.5))
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding(20)
        .background(ColorManager.cardBackground)
        .cornerRadius(16)
        .shadow(color: ColorManager.shadowColor, radius: 5, x: 0, y: 3)
    }
    
    private func historyView(procedure: Procedure) -> some View {
        VStack(spacing: 16) {
            HStack {
                Text("Completion History")
                    .font(.titleMedium)
                    .foregroundColor(ColorManager.primaryText)
                Spacer()
                Text("\(procedure.completedDates.count) times")
                    .font(.bodyMedium)
                    .foregroundColor(ColorManager.secondaryText)
            }
            
            if procedure.completedDates.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "clock.circle")
                        .font(.system(size: 30))
                        .foregroundColor(ColorManager.primaryBlue.opacity(0.6))
                    
                    Text("No completions yet")
                        .font(.bodyMedium)
                        .foregroundColor(ColorManager.secondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(procedure.completedDates.sorted(by: >).prefix(10), id: \.self) { date in
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(ColorManager.successGreen)
                            
                            Text(DateFormatter.historyFormatter.string(from: date))
                                .font(.bodyMedium)
                                .foregroundColor(ColorManager.darkText)
                            
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .padding(20)
        .background(ColorManager.cardBackground)
        .cornerRadius(16)
        .shadow(color: ColorManager.shadowColor, radius: 5, x: 0, y: 3)
    }
    
    private func actionButtonsView(procedure: Procedure) -> some View {
        VStack(spacing: 12) {
            Button(action: {
                viewModel.toggleProcedureCompletion(procedure)
            }) {
                Text(procedure.isCompleted ? "Mark as Incomplete" : "Mark as Complete")
                    .font(.titleSmall)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [ColorManager.primaryBlue, ColorManager.primaryYellow]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: ColorManager.shadowColor, radius: 5, x: 0, y: 3)
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                Text("Delete Procedure")
                    .font(.bodyLarge)
                    .foregroundColor(ColorManager.errorRed)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(ColorManager.cardBackground)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ColorManager.errorRed.opacity(0.3), lineWidth: 1)
                    )
            }
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.bodyLarge)
                .foregroundColor(ColorManager.primaryText)
                .fontWeight(.medium)
            
            Spacer()
            
            Text(value)
                .font(.bodyMedium)
                .foregroundColor(ColorManager.secondaryText)
        }
    }
}

struct EditProcedureView: View {
    @ObservedObject var viewModel: SkinCareViewModel
    let procedureId: UUID
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Group {
            if let procedure = viewModel.procedure(byId: procedureId) {
                AddProcedureView(
                    viewModel: viewModel,
                    initialName: procedure.name,
                    initialType: procedure.type,
                    initialFrequency: procedure.frequency,
                    initialTimeOfDay: procedure.timeOfDay,
                    initialDuration: procedure.duration.map { String($0) },
                    initialNotes: procedure.notes.isEmpty ? nil : procedure.notes,
                    isEditMode: true,
                    onSave: saveProcedure
                )
            } else {
                EmptyView()
            }
        }
    }
    
    private func saveProcedure(name: String, type: Procedure.ProcedureType, frequency: Procedure.ProcedureFrequency, timeOfDay: Procedure.TimeOfDay, duration: Int?, notes: String) {
        guard var updated = viewModel.procedure(byId: procedureId) else { return }
        updated.name = name
        updated.type = type
        updated.frequency = frequency
        updated.timeOfDay = timeOfDay
        updated.duration = duration
        updated.notes = notes
        viewModel.updateProcedure(updated)
        presentationMode.wrappedValue.dismiss()
    }
}

extension DateFormatter {
    static let detailFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter
    }()
    
    static let historyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' HH:mm"
        return formatter
    }()
}

#Preview {
    NavigationView {
        ProcedureDetailView(
            viewModel: SkinCareViewModel(),
            procedureId: UUID()
        )
    }
}
