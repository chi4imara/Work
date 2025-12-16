import SwiftUI

struct SettingsScreen: View {
    @StateObject private var settingsViewModel = SettingsViewModel()
    @StateObject private var notificationManager = NotificationManager.shared
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    @State private var showingTimePicker = false
    @State private var showingExportSheet = false
    
    var body: some View {
        ZStack {
            ColorManager.shared.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerSection
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        notificationsSection
                        
                        legalSection
                        
                        contactSection
                        
                        appSection
                        
                        dataSection
                        
                        decorativeSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            Text("Settings")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(ColorManager.shared.primaryBlue)
            
            Spacer()
        }
    }
    
    private var legalSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Legal")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorManager.shared.primaryBlue)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "doc.text.fill",
                    title: "Terms of Use",
                    iconColor: ColorManager.shared.primaryPurple
                ) {
                    settingsViewModel.openURL("https://www.termsfeed.com/live/05e87d87-cd05-48cf-9894-a9cd1ff00c43")
                }
                
                Divider()
                    .background(ColorManager.shared.lightGray)
                    .padding(.leading, 50)
                
                SettingsRow(
                    icon: "lock.shield.fill",
                    title: "Privacy Policy",
                    iconColor: ColorManager.shared.primaryBlue
                ) {
                    settingsViewModel.openURL("https://www.termsfeed.com/live/92424c1a-a422-4155-8c92-338f7f05cf59")
                }
            }
            .background(ColorManager.shared.cardGradient)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
    
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Contact")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorManager.shared.primaryBlue)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "envelope.fill",
                    title: "Contact Email",
                    iconColor: ColorManager.shared.primaryYellow
                ) {
                    settingsViewModel.openURL("https://www.termsfeed.com/live/92424c1a-a422-4155-8c92-338f7f05cf59")
                }
            }
            .background(ColorManager.shared.cardGradient)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
    
    private var notificationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notifications")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorManager.shared.primaryBlue)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                Toggle(isOn: $notificationManager.isEnabled) {
                    HStack {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 20))
                            .foregroundColor(ColorManager.shared.primaryPurple)
                            .frame(width: 30)
                        
                        Text("Daily Reminder")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(ColorManager.shared.darkGray)
                    }
                    .padding(.vertical, 14)
                }
                .toggleStyle(SwitchToggleStyle(tint: ColorManager.shared.primaryPurple))
                .padding(.horizontal, 16)
                
                if notificationManager.isEnabled {
                    Divider()
                        .background(ColorManager.shared.lightGray)
                        .padding(.leading, 50)
                    
                    Button(action: {
                        showingTimePicker = true
                    }) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 20))
                                .foregroundColor(ColorManager.shared.primaryBlue)
                                .frame(width: 30)
                            
                            Text("Reminder Time")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorManager.shared.darkGray)
                            
                            Spacer()
                            
                            Text(NotificationManager.shared.reminderTime, style: .time)
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(ColorManager.shared.primaryBlue)
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(ColorManager.shared.lightGray)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                    }
                }
            }
            .background(ColorManager.shared.cardGradient)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
        .sheet(isPresented: $showingTimePicker) {
            TimePickerSheet(selectedTime: $notificationManager.reminderTime)
        }
    }
    
    private var dataSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Data")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorManager.shared.primaryBlue)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "square.and.arrow.up.fill",
                    title: "Export Data",
                    iconColor: ColorManager.shared.softGreen
                ) {
                    exportData()
                }
            }
            .background(ColorManager.shared.cardGradient)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
        .sheet(isPresented: $showingExportSheet) {
            ShareSheet(activityItems: [generateExportText()])
        }
    }
    
    private var appSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("App")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorManager.shared.primaryBlue)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "star.fill",
                    title: "Rate App",
                    iconColor: ColorManager.shared.accentPink
                ) {
                    settingsViewModel.requestAppReview()
                }
            }
            .background(ColorManager.shared.cardGradient)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
    
    private var decorativeSection: some View {
        VStack(spacing: 30) {
            HStack(spacing: 20) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    ColorManager.shared.primaryPurple.opacity(0.3),
                                    ColorManager.shared.primaryBlue.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 24))
                        .foregroundColor(ColorManager.shared.softGreen)
                }
                
                VStack(spacing: 12) {
                    Circle()
                        .fill(ColorManager.shared.primaryYellow.opacity(0.6))
                        .frame(width: 16, height: 16)
                    
                    Circle()
                        .fill(ColorManager.shared.accentPink.opacity(0.6))
                        .frame(width: 12, height: 12)
                }
                
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    ColorManager.shared.primaryYellow.opacity(0.3),
                                    ColorManager.shared.accentPink.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 20))
                        .foregroundColor(ColorManager.shared.accentPink)
                }
                
                Spacer()
            }
            .padding(.vertical, 20)
            
            HStack(spacing: 30) {
                Spacer()
                
                HStack(spacing: 20) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 18))
                        .foregroundColor(ColorManager.shared.primaryPurple.opacity(0.6))
                    
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                        .foregroundColor(ColorManager.shared.primaryBlue.opacity(0.5))
                    
                    Image(systemName: "circle.fill")
                        .font(.system(size: 10))
                        .foregroundColor(ColorManager.shared.softGreen.opacity(0.5))
                    
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                        .foregroundColor(ColorManager.shared.primaryYellow.opacity(0.5))
                    
                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 18))
                        .foregroundColor(ColorManager.shared.primaryBlue.opacity(0.6))
                }
                
                Spacer()
            }
            
            HStack(spacing: 40) {
                Spacer()
                
                Circle()
                    .fill(ColorManager.shared.primaryPurple.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Circle()
                    .fill(ColorManager.shared.primaryBlue.opacity(0.15))
                    .frame(width: 30, height: 30)
                
                Circle()
                    .fill(ColorManager.shared.softGreen.opacity(0.2))
                    .frame(width: 35, height: 35)
                
                Circle()
                    .fill(ColorManager.shared.primaryYellow.opacity(0.15))
                    .frame(width: 25, height: 25)
                
                Spacer()
            }
            .padding(.top, 10)
        }
        .padding(.vertical, 30)
    }
    
    private func exportData() {
        showingExportSheet = true
    }
    
    private func generateExportText() -> String {
        var exportText = "Calmline - Mindfulness Journal Export\n"
        exportText += "Generated: \(DateFormatter.exportFormatter.string(from: Date()))\n\n"
        
        exportText += "=== STATISTICS ===\n"
        let stats = dataManager.getStatistics()
        exportText += "Total mindful days: \(stats.totalDays)\n"
        exportText += "Current streak: \(stats.currentStreak) days\n"
        exportText += "This week: \(stats.thisWeekCount) days\n"
        exportText += "This month: \(stats.thisMonthCount) days\n\n"
        
        exportText += "=== HABIT STATISTICS ===\n"
        for (habit, count) in stats.habitStats.sorted(by: { $0.value > $1.value }) {
            exportText += "\(habit): \(count) days\n"
        }
        exportText += "\n"
        
        exportText += "=== DAY ENTRIES ===\n"
        let sortedEntries = dataManager.dayEntries.sorted { $0.date > $1.date }
        for entry in sortedEntries {
            let dateStr = DateFormatter.exportDateFormatter.string(from: entry.date)
            exportText += "\n\(dateStr)\n"
            if !entry.checkedHabits.isEmpty {
                for habit in entry.checkedHabits.sorted() {
                    exportText += "  ✓ \(habit)\n"
                }
            }
            if !entry.note.isEmpty {
                exportText += "  Note: \(entry.note)\n"
            }
        }
        
        return exportText
    }
}

struct TimePickerSheet: View {
    @Binding var selectedTime: Date
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.shared.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Text("Select reminder time")
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(ColorManager.shared.primaryBlue)
                        .padding(.top, 20)
                    
                    DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Reminder Time")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(ColorManager.shared.primaryPurple)
            )
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

extension DateFormatter {
    static let exportFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
    
    static let exportDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter
    }()
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(iconColor)
                    .frame(width: 30)
                
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorManager.shared.darkGray)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorManager.shared.lightGray)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }
}

#Preview {
    SettingsScreen()
}
