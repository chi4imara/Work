import SwiftUI
import Charts

struct HobbyDetailView: View {
    @ObservedObject var viewModel: HobbyViewModel
    @Environment(\.dismiss) private var dismiss
    
    private var hobby: Hobby? {
        viewModel.hobbies.first { $0.id == viewModel.selectedHobby?.id }
    }
    
    @State private var showingAddSession = false
    @State private var showingDeleteAlert = false
    @State private var showingRenameAlert = false
    @State private var newHobbyName = ""
    @State private var selectedSession: HobbySession?
    
    var body: some View {
        Group {
            if let hobby = hobby {
                ZStack {
                    WebPatternBackground()
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            headerStatsView(hobby: hobby)
                            
                            if !hobby.sessions.isEmpty {
                                activityChartView(hobby: hobby)
                            }
                            
                            sessionsListView(hobby: hobby)
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            } else {
                VStack {
                    Text("Hobby not found")
                        .font(FontManager.title)
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Button("Go Back") {
                        dismiss()
                    }
                    .padding()
                    .background(ColorTheme.primaryBlue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .navigationTitle("Hobby Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("Back")
                            .font(FontManager.body)
                    }
                    .foregroundColor(ColorTheme.primaryBlue)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if let hobby = hobby {
                    Menu {
                        Button("Rename Hobby") {
                            newHobbyName = hobby.name
                            showingRenameAlert = true
                        }
                        
                        Button("Delete Hobby", role: .destructive) {
                            showingDeleteAlert = true
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(ColorTheme.primaryBlue)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddSession) {
            if let hobby = hobby {
                AddSessionView(hobby: hobby, viewModel: viewModel)
            }
        }
        .alert("Delete Hobby", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let hobby = hobby {
                    viewModel.deleteHobby(hobby)
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete this hobby? All sessions will be lost.")
        }
        .alert("Rename Hobby", isPresented: $showingRenameAlert) {
            TextField("Hobby name", text: $newHobbyName)
            Button("Cancel", role: .cancel) { }
            Button("Save") {
                if let hobby = hobby, !newHobbyName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    viewModel.updateHobbyName(hobby, newName: newHobbyName.trimmingCharacters(in: .whitespacesAndNewlines))
                }
            }
        } message: {
            Text("Enter a new name for your hobby")
        }
        .overlay(
            Group {
                if hobby != nil {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                showingAddSession = true
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 16, weight: .bold))
                                    Text("New Session")
                                        .font(FontManager.body)
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [ColorTheme.primaryBlue, ColorTheme.darkBlue]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(25)
                                .shadow(color: ColorTheme.primaryBlue.opacity(0.4), radius: 15, x: 0, y: 8)
                            }
                            .padding(.trailing, 20)
                            .padding(.bottom, 30)
                        }
                    }
                }
            }
        )
    }
    
    private func headerStatsView(hobby: Hobby) -> some View {
        VStack(spacing: 20) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(ColorTheme.primaryBlue.opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: hobby.icon)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(ColorTheme.primaryBlue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(hobby.name)
                        .font(FontManager.title)
                        .foregroundColor(ColorTheme.primaryText)
                        .fontWeight(.bold)
                    
                    Text("Last activity: \(hobby.lastActivityFormatted)")
                        .font(FontManager.body)
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                Spacer()
            }
            
            HStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(ColorTheme.lightBlue.opacity(0.3), lineWidth: 10)
                        .frame(width: 100, height: 100)
                    
                    Circle()
                        .trim(from: 0, to: hobby.progressPercentage)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [ColorTheme.primaryBlue, ColorTheme.darkBlue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 1.0), value: hobby.progressPercentage)
                    
                    Text("\(Int(hobby.progressPercentage * 100))%")
                        .font(FontManager.subheadline)
                        .foregroundColor(ColorTheme.primaryBlue)
                        .fontWeight(.bold)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    StatRow(icon: "star.fill", label: "Sessions", value: "\(hobby.totalSessions)", color: ColorTheme.primaryBlue)
                    StatRow(icon: "clock.fill", label: "Total Time", value: hobby.totalTimeFormatted, color: ColorTheme.accent)
                    StatRow(icon: "calendar.circle.fill", label: "Created", value: formatDate(hobby.createdAt), color: ColorTheme.success)
                }
                
                Spacer()
            }
        }
        .padding(20)
        .background(ColorTheme.cardGradient)
        .cornerRadius(20)
        .shadow(color: ColorTheme.lightBlue.opacity(0.2), radius: 12, x: 0, y: 6)
    }
    
    private func activityChartView(hobby: Hobby) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Activity Chart")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
                .fontWeight(.semibold)
            
            if #available(iOS 16.0, *) {
                Chart {
                    ForEach(getChartData(hobby: hobby), id: \.date) { dataPoint in
                        LineMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Duration", dataPoint.duration)
                        )
                        .foregroundStyle(ColorTheme.primaryBlue)
                        .interpolationMethod(.catmullRom)
                        
                        PointMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Duration", dataPoint.duration)
                        )
                        .foregroundStyle(ColorTheme.darkBlue)
                        .symbolSize(30)
                    }
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: 7)) { _ in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                    }
                }
                .chartYAxis {
                    AxisMarks { _ in
                        AxisGridLine()
                        AxisValueLabel()
                    }
                }
            } else {
                SimpleLineChart(data: getChartData(hobby: hobby))
                    .frame(height: 200)
            }
        }
        .padding(20)
        .background(ColorTheme.cardGradient)
        .cornerRadius(16)
        .shadow(color: ColorTheme.lightBlue.opacity(0.15), radius: 8, x: 0, y: 4)
    }
    
    private func sessionsListView(hobby: Hobby) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Sessions History")
                    .font(FontManager.headline)
                    .foregroundColor(ColorTheme.primaryText)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(hobby.sessions.count) total")
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            if hobby.sessions.isEmpty {
                emptySessionsView
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(hobby.sessions.sorted(by: { $0.date > $1.date })) { session in
                        SessionCard(session: session)
                            .onTapGesture {
                                selectedSession = session
                            }
                    }
                }
            }
        }
        .padding(20)
        .background(ColorTheme.cardGradient)
        .cornerRadius(16)
        .shadow(color: ColorTheme.lightBlue.opacity(0.15), radius: 8, x: 0, y: 4)
    }
    
    private var emptySessionsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock.badge.plus")
                .font(.system(size: 40, weight: .light))
                .foregroundColor(ColorTheme.lightBlue)
            
            Text("No sessions yet")
                .font(FontManager.subheadline)
                .foregroundColor(ColorTheme.primaryText)
                .fontWeight(.semibold)
            
            Text("Add your first session to start tracking your progress")
                .font(FontManager.body)
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 30)
    }
    
    private func getChartData(hobby: Hobby) -> [ChartDataPoint] {
        let calendar = Calendar.current
        let sortedSessions = hobby.sessions.sorted(by: { $0.date < $1.date })
        
        return sortedSessions.map { session in
            ChartDataPoint(date: session.date, duration: session.duration)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct StatRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
                .frame(width: 20)
            
            Text(label)
                .font(FontManager.body)
                .foregroundColor(ColorTheme.secondaryText)
            
            Spacer()
            
            Text(value)
                .font(FontManager.body)
                .foregroundColor(ColorTheme.primaryText)
                .fontWeight(.semibold)
        }
    }
}

struct SessionCard: View {
    let session: HobbySession
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(spacing: 2) {
                Text(formatDay(session.date))
                    .font(FontManager.small)
                    .foregroundColor(ColorTheme.secondaryText)
                
                Text(formatDayNumber(session.date))
                    .font(FontManager.subheadline)
                    .foregroundColor(ColorTheme.primaryText)
                    .fontWeight(.bold)
            }
            .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(session.durationFormatted)
                        .font(FontManager.subheadline)
                        .foregroundColor(ColorTheme.primaryText)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text(formatTime(session.date))
                        .font(FontManager.body)
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                if !session.comment.isEmpty {
                    Text(session.comment)
                        .font(FontManager.body)
                        .foregroundColor(ColorTheme.secondaryText)
                        .lineLimit(2)
                }
            }
        }
        .padding(12)
        .background(ColorTheme.background)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(ColorTheme.lightBlue.opacity(0.2), lineWidth: 1)
        )
    }
    
    private func formatDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).uppercased()
    }
    
    private func formatDayNumber(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ChartDataPoint {
    let date: Date
    let duration: Int
}

struct SimpleLineChart: View {
    let data: [ChartDataPoint]
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                guard !data.isEmpty else { return }
                
                let maxDuration = data.map(\.duration).max() ?? 1
                let width = geometry.size.width
                let height = geometry.size.height
                
                for (index, point) in data.enumerated() {
                    let x = CGFloat(index) / CGFloat(data.count - 1) * width
                    let y = height - (CGFloat(point.duration) / CGFloat(maxDuration) * height)
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(ColorTheme.primaryBlue, lineWidth: 2)
        }
    }
}
