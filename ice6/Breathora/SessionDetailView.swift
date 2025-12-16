import SwiftUI

struct SessionDetailView: View {
    let session: SessionRecord
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        headerCardView
                        
                        sessionStatsView
                        
                        programDetailsView
                        
                        timelineView
                        
                        actionButtonsView
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Session Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.mediumText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingDeleteAlert = true }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .alert("Delete Session", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                SessionManager.shared.deleteSession(session)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this session record?")
        }
    }
    
    private var headerCardView: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                
                VStack(spacing: 8) {
                    Image(systemName: session.completedCycles == session.totalCycles ? "checkmark.circle.fill" : "clock.fill")
                        .font(.system(size: 40))
                        .foregroundColor(session.completedCycles == session.totalCycles ? .green : AppColors.yellowAccent)
                    
                    Text(session.completedCycles == session.totalCycles ? "Completed" : "Partial")
                        .font(.playfairDisplay(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.darkText)
                }
                
                Spacer()
            }
            
            Text(session.programName)
                .font(.playfairDisplay(size: 24, weight: .bold))
                .foregroundColor(AppColors.darkText)
                .multilineTextAlignment(.center)
            
            Text(session.formattedDate)
                .font(.playfairDisplay(size: 16, weight: .medium))
                .foregroundColor(AppColors.mediumText)
        }
        .padding(24)
        .background(AppColors.cardGradient)
        .cornerRadius(20)
        .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private var sessionStatsView: some View {
        VStack(spacing: 16) {
            Text("Session Statistics")
                .font(.playfairDisplay(size: 20, weight: .semibold))
                .foregroundColor(AppColors.darkText)
            
            HStack(spacing: 20) {
                StatCardView(
                    icon: "repeat",
                    title: "Cycles",
                    value: "\(session.completedCycles)/\(session.totalCycles)",
                    color: AppColors.primaryPurple
                )
                
                StatCardView(
                    icon: "timer",
                    title: "Duration",
                    value: session.formattedDuration,
                    color: AppColors.blueText
                )
            }
            
            HStack(spacing: 20) {
                StatCardView(
                    icon: "percent",
                    title: "Completion",
                    value: "\(Int((Double(session.completedCycles) / Double(session.totalCycles)) * 100))%",
                    color: session.completedCycles == session.totalCycles ? .green : AppColors.yellowAccent
                )
                
                StatCardView(
                    icon: "clock",
                    title: "Avg Cycle",
                    value: averageCycleTime,
                    color: AppColors.mediumText
                )
            }
        }
    }
    
    private var programDetailsView: some View {
        VStack(spacing: 16) {
            Text("Program Details")
                .font(.playfairDisplay(size: 20, weight: .semibold))
                .foregroundColor(AppColors.darkText)
            
            VStack(spacing: 12) {
                DetailRowView(
                    icon: "lungs",
                    title: "Breathing Pattern",
                    value: session.programPhases
                )
                
                DetailRowView(
                    icon: "repeat.circle",
                    title: "Target Cycles",
                    value: "\(session.totalCycles) cycles"
                )
                
                DetailRowView(
                    icon: "checkmark.circle",
                    title: "Completed Cycles",
                    value: "\(session.completedCycles) cycles"
                )
            }
            .padding(16)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
        }
    }
    
    private var timelineView: some View {
        VStack(spacing: 16) {
            Text("Session Timeline")
                .font(.playfairDisplay(size: 20, weight: .semibold))
                .foregroundColor(AppColors.darkText)
            
            VStack(spacing: 12) {
                TimelineItemView(
                    icon: "play.circle",
                    title: "Started",
                    time: formatDetailedTime(session.startTime),
                    color: .green
                )
                
                TimelineItemView(
                    icon: "stop.circle",
                    title: "Ended",
                    time: formatDetailedTime(session.endTime),
                    color: .red
                )
            }
            .padding(16)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
        }
    }
    
    private var actionButtonsView: some View {
        VStack(spacing: 16) {
            Button(action: {
                dismiss()
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "repeat")
                    Text("Repeat This Program")
                }
                .font(.playfairDisplay(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(AppColors.purpleGradient)
                .cornerRadius(28)
            }
            
            Button(action: { showingDeleteAlert = true }) {
                HStack(spacing: 12) {
                    Image(systemName: "trash")
                    Text("Delete Session")
                }
                .font(.playfairDisplay(size: 18, weight: .semibold))
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(AppColors.cardGradient)
                .cornerRadius(28)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.red, lineWidth: 2)
                )
            }
        }
    }
    
    private var averageCycleTime: String {
        guard session.completedCycles > 0 else { return "0s" }
        let avgSeconds = Int(session.duration) / session.completedCycles
        let minutes = avgSeconds / 60
        let seconds = avgSeconds % 60
        
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    }
    
    private func formatDetailedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm:ss a"
        return formatter.string(from: date)
    }
}

struct StatCardView: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(.playfairDisplay(size: 18, weight: .bold))
                .foregroundColor(AppColors.darkText)
            
            Text(title)
                .font(.playfairDisplay(size: 12, weight: .medium))
                .foregroundColor(AppColors.mediumText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(AppColors.cardGradient)
        .cornerRadius(12)
    }
}

struct DetailRowView: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppColors.primaryPurple)
                .frame(width: 24)
            
            Text(title)
                .font(.playfairDisplay(size: 16, weight: .medium))
                .foregroundColor(AppColors.mediumText)
            
            Spacer()
            
            Text(value)
                .font(.playfairDisplay(size: 16, weight: .semibold))
                .foregroundColor(AppColors.darkText)
        }
    }
}

struct TimelineItemView: View {
    let icon: String
    let title: String
    let time: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.darkText)
                
                Text(time)
                    .font(.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(AppColors.mediumText)
            }
            
            Spacer()
        }
    }
}

#Preview {
    SessionDetailView(
        session: SessionRecord(
            programName: "Deep Relaxation",
            programPhases: "Inhale 4s — Pause 7s — Exhale 8s",
            startTime: Date().addingTimeInterval(-1200),
            endTime: Date(),
            completedCycles: 8,
            totalCycles: 10
        )
    )
}
