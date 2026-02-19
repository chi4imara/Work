import SwiftUI

enum HistorySheetItem: Identifiable {
    case workoutDetails(workoutId: UUID)
    
    var id: String {
        switch self {
        case .workoutDetails(let workoutId):
            return "workoutDetails-\(workoutId.uuidString)"
        }
    }
}

struct HistoryView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var sheetItem: HistorySheetItem?
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Text("History")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                if !viewModel.history.isEmpty {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(groupedHistoryKeys, id: \.self) { monthYear in
                                HistorySection(
                                    monthYear: monthYear,
                                    entries: viewModel.groupedHistory()[monthYear] ?? []
                                ) { entry in
                                    if let workout = findWorkoutForEntry(entry) {
                                        sheetItem = .workoutDetails(workoutId: workout.id)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120)
                    }
                } else {
                    emptyState
                    
                    Spacer()
                }
            }
        }
        .sheet(item: $sheetItem) { item in
            switch item {
            case .workoutDetails(let workoutId):
                DayDetailsView(viewModel: viewModel, workoutId: workoutId)
            }
        }
    }
    
    private var groupedHistoryKeys: [String] {
        return Array(viewModel.groupedHistory().keys).sorted { first, second in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            let firstDate = formatter.date(from: first) ?? Date.distantPast
            let secondDate = formatter.date(from: second) ?? Date.distantPast
            return firstDate > secondDate
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "clock")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(ColorManager.lightBlue)
                
                Text("No history yet")
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Your workout history will appear here as you add and complete workouts")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private func findWorkoutForEntry(_ entry: HistoryEntry) -> Workout? {
        return viewModel.workouts.first { $0.day == entry.day && $0.type == entry.workoutType }
    }
}

struct HistorySection: View {
    let monthYear: String
    let entries: [HistoryEntry]
    let onEntryTap: (HistoryEntry) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(monthYear)
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
                .padding(.horizontal, 4)
            
            VStack(spacing: 8) {
                ForEach(entries.sorted { $0.date > $1.date }, id: \.id) { entry in
                    HistoryEntryRow(entry: entry) {
                        onEntryTap(entry)
                    }
                }
            }
        }
    }
}

struct HistoryEntryRow: View {
    let entry: HistoryEntry
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                VStack {
                    Image(systemName: actionIcon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(actionColor)
                        .frame(width: 30, height: 30)
                        .background(
                            Circle()
                                .fill(actionColor.opacity(0.2))
                        )
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(entry.day.rawValue)
                            .font(.ubuntu(16, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Text("•")
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(ColorManager.secondaryText)
                        
                        Text(entry.workoutType.displayName)
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(ColorManager.lightBlue)
                        
                        Spacer()
                    }
                    
                    Text(entry.actionType.rawValue.capitalized)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(ColorManager.secondaryText)
                    
                    if !entry.note.isEmpty {
                        Text(entry.note)
                            .font(.ubuntu(12, weight: .regular))
                            .foregroundColor(ColorManager.secondaryText)
                            .lineLimit(2)
                    }
                    
                    Text(formatDate(entry.date))
                        .font(.ubuntu(10, weight: .regular))
                        .foregroundColor(ColorManager.secondaryText.opacity(0.8))
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(ColorManager.secondaryText)
            }
            .padding(16)
            .background(ColorManager.cardGradient)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var actionIcon: String {
        switch entry.actionType {
        case .added:
            return "plus.circle"
        case .modified:
            return "pencil.circle"
        case .completed:
            return "checkmark.circle"
        }
    }
    
    private var actionColor: Color {
        switch entry.actionType {
        case .added:
            return ColorManager.lightBlue
        case .modified:
            return ColorManager.orange
        case .completed:
            return ColorManager.green
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    HistoryView(viewModel: WorkoutViewModel())
}
