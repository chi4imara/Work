import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: ExperimentViewModel
    @State private var selectedDate = Date()
    @State private var selectedExperimentId: UUID?
    
    private var experimentsForSelectedDate: [Experiment] {
        viewModel.experiments.filter { experiment in
            Calendar.current.isDate(experiment.createdAt, inSameDayAs: selectedDate) ||
            Calendar.current.isDate(experiment.updatedAt, inSameDayAs: selectedDate)
        }
    }
    
    private var datesWithExperiments: Set<DateComponents> {
        var components = Set<DateComponents>()
        let calendar = Calendar.current
        for experiment in viewModel.experiments {
            components.insert(calendar.dateComponents([.year, .month, .day], from: experiment.createdAt))
            components.insert(calendar.dateComponents([.year, .month, .day], from: experiment.updatedAt))
        }
        return components
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                HStack {
                    Text("Calendar")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical)
                
                if viewModel.experiments.isEmpty {
                    VStack(spacing: 30) {
                        Spacer()
                        Image(systemName: "calendar")
                            .font(.system(size: 60))
                            .foregroundColor(Color.theme.primaryYellow)
                        Text("No experiments yet.")
                            .font(.ubuntu(20, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                        Text("Add experiments to see them on the calendar.")
                            .font(.ubuntu(16))
                            .foregroundColor(Color.theme.secondaryText)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            DatePicker(
                                "Select date",
                                selection: $selectedDate,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.graphical)
                            .accentColor(Color.theme.primaryYellow)
                            .padding()
                            .background(Color.theme.cardBackground)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.theme.cardBorder, lineWidth: 1)
                            )
                            
                            if experimentsForSelectedDate.isEmpty {
                                Text("No experiments on this date.")
                                    .font(.ubuntu(16))
                                    .foregroundColor(Color.theme.secondaryText)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 40)
                            } else {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Experiments on \(formattedDate(selectedDate))")
                                        .font(.ubuntu(18, weight: .medium))
                                        .foregroundColor(Color.theme.primaryYellow)
                                    
                                    ForEach(experimentsForSelectedDate) { experiment in
                                        Button(action: {
                                            selectedExperimentId = experiment.id
                                        }) {
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text(experiment.tried)
                                                    .font(.ubuntu(16, weight: .medium))
                                                    .foregroundColor(Color.theme.primaryText)
                                                    .lineLimit(2)
                                                Text(experiment.result)
                                                    .font(.ubuntu(14))
                                                    .foregroundColor(Color.theme.secondaryText)
                                                    .lineLimit(1)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding()
                                            .background(Color.theme.cardBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.theme.cardBorder, lineWidth: 1)
                                            )
                                            .cornerRadius(12)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .sheet(item: Binding(
            get: {
                selectedExperimentId.flatMap { id in
                    viewModel.experiment(byId: id).map { ExperimentWrapper(experiment: $0) }
                }
            },
            set: { _ in selectedExperimentId = nil }
        )) { wrapper in
            ExperimentDetailView(experimentId: wrapper.experiment.id)
                .environmentObject(viewModel)
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

private struct ExperimentWrapper: Identifiable {
    let experiment: Experiment
    var id: UUID { experiment.id }
}

#Preview {
    CalendarView(viewModel: ExperimentViewModel())
}
