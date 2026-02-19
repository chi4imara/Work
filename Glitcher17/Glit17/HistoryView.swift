import SwiftUI

struct HistoryView: View {
    @ObservedObject var appState: AppState
    
    var body: some View {
            ZStack {
                ColorManager.mainGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("History")
                            .font(FontManager.ubuntu(28, weight: .bold))
                            .foregroundColor(ColorManager.textWhite)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            if appState.history.isEmpty {
                                EmptyStateView(
                                    message: "You haven't completed any procedures yet.",
                                    icon: "clock.badge.exclamationmark"
                                )
                                .padding(.top, 100)
                            } else {
                                ForEach(appState.history) { historyEntry in
                                    HistoryEntryCardView(
                                        historyEntry: historyEntry,
                                        appState: appState
                                    )
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                            }
                        }
                        .padding(.bottom, 120)
                    }
                }
            }
    }
}

struct HistoryEntryCardView: View {
    let historyEntry: HistoryEntry
    @ObservedObject var appState: AppState
    @State private var showingDetails = false
    
    private var procedure: Procedure? {
        appState.procedures.first { $0.id == historyEntry.procedureId }
    }
    
    private var procedureName: String {
        procedure?.name ?? historyEntry.procedureName
    }
    
    private var categoryName: String {
        procedure?.category.name ?? historyEntry.categoryName
    }
    
    var body: some View {
        Button(action: {
            showingDetails = true
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(procedureName)
                            .font(FontManager.ubuntu(18, weight: .bold))
                            .foregroundColor(ColorManager.textWhite)
                            .multilineTextAlignment(.leading)
                        
                        HStack(spacing: 16) {
                            Label(categoryName, systemImage: "tag")
                                .font(FontManager.ubuntu(14, weight: .medium))
                                .foregroundColor(ColorManager.textSecondary)
                            
                            Label(formatDate(historyEntry.completionDate), systemImage: "calendar")
                                .font(FontManager.ubuntu(14, weight: .medium))
                                .foregroundColor(ColorManager.textSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(ColorManager.successGreen)
                }
                
                HStack {
                    Text("Tap to view details")
                        .font(FontManager.ubuntu(12, weight: .medium))
                        .foregroundColor(ColorManager.accentYellow)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(ColorManager.accentYellow)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorManager.cardGradient)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetails) {
            ProcedureDetailsView(procedureId: historyEntry.procedureId, appState: appState)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }
}

#Preview {
    let appState = AppState()
    
    let sampleHistory = [
        HistoryEntry(
            procedureId: UUID(),
            procedureName: "Face Mask",
            categoryName: "Skin",
            completionDate: Date()
        ),
        HistoryEntry(
            procedureId: UUID(),
            procedureName: "Hair Treatment",
            categoryName: "Hair",
            completionDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        ),
        HistoryEntry(
            procedureId: UUID(),
            procedureName: "Nail Care",
            categoryName: "Nails",
            completionDate: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date()
        )
    ]
    
    appState.history = sampleHistory
    
    return HistoryView(appState: appState)
}
