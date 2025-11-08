import SwiftUI
import UserNotifications

struct NotificationSettingsView: View {
    @StateObject private var notificationManager = NotificationManager.shared
    @StateObject private var appColors = AppColors.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var showingPermissionAlert = false
    
    var body: some View {
        ZStack {
            appColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    notificationStatus
                    
                    dailyReminderSection
                    
                    timeSettingsSection
                    
                    frequencySection
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Permission Required", isPresented: $showingPermissionAlert) {
            Button("Settings") {
                openAppSettings()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please enable notifications in Settings to receive daily mood reminders.")
        }
    }
    
    private var notificationStatus: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: notificationManager.isAuthorized ? "bell.fill" : "bell.slash.fill")
                    .font(.system(size: 24))
                    .foregroundColor(notificationManager.isAuthorized ? appColors.accentGreen : appColors.textSecondary)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(notificationManager.isAuthorized ? "Notifications Enabled" : "Notifications Disabled")
                        .font(.builderSans(.semiBold, size: 18))
                        .foregroundColor(appColors.textPrimary)
                    
                    Text(notificationManager.isAuthorized ? "You'll receive daily reminders" : "Enable to get daily mood reminders")
                        .font(.builderSans(.regular, size: 14))
                        .foregroundColor(appColors.textSecondary)
                }
                
                Spacer()
            }
            
            if !notificationManager.isAuthorized {
                Button(action: requestNotificationPermission) {
                    Text("Enable Notifications")
                        .font(.builderSans(.semiBold, size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(appColors.buttonGradient)
                        .cornerRadius(24)
                }
            }
        }
        .padding(20)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(16)
        .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.1), radius: 10, x: 0, y: 5)
    }
    
    private var dailyReminderSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Daily Reminder")
                .font(.builderSans(.semiBold, size: 20))
                .foregroundColor(appColors.textPrimary)
            
            VStack(spacing: 12) {
                ToggleRow(
                    title: "Enable Daily Reminder",
                    subtitle: "Get reminded to log your mood",
                    isOn: $notificationManager.dailyReminderEnabled
                )
                
                if notificationManager.dailyReminderEnabled {
                    Divider()
                        .padding(.leading, 50)
                    
                    ToggleRow(
                        title: "Weekend Reminders",
                        subtitle: "Include weekends in reminders",
                        isOn: $notificationManager.weekendReminders
                    )
                }
            }
        }
        .padding(20)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(16)
        .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.1), radius: 10, x: 0, y: 5)
    }
    
    private var timeSettingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Reminder Time")
                .font(.builderSans(.semiBold, size: 20))
                .foregroundColor(appColors.textPrimary)
            
            VStack(spacing: 12) {
                TimePickerRow(
                    title: "Morning Reminder",
                    time: $notificationManager.morningTime,
                    isEnabled: notificationManager.dailyReminderEnabled
                )
                
                Divider()
                    .padding(.leading, 50)
                
                TimePickerRow(
                    title: "Evening Reminder",
                    time: $notificationManager.eveningTime,
                    isEnabled: notificationManager.dailyReminderEnabled
                )
            }
        }
        .padding(20)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(16)
        .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.1), radius: 10, x: 0, y: 5)
    }
    
    private var frequencySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Reminder Frequency")
                .font(.builderSans(.semiBold, size: 20))
                .foregroundColor(appColors.textPrimary)
            
            VStack(spacing: 12) {
                ForEach(NotificationManager.Frequency.allCases, id: \.self) { frequency in
                    FrequencyRow(
                        frequency: frequency,
                        isSelected: notificationManager.selectedFrequency == frequency
                    ) {
                        notificationManager.selectedFrequency = frequency
                    }
                }
            }
        }
        .padding(20)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(16)
        .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.1), radius: 10, x: 0, y: 5)
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    notificationManager.updateAuthorizationStatus()
                } else {
                    showingPermissionAlert = true
                }
            }
        }
    }
    
    private func openAppSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}

struct ToggleRow: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    @StateObject private var appColors = AppColors.shared
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.builderSans(.medium, size: 16))
                    .foregroundColor(appColors.textPrimary)
                
                Text(subtitle)
                    .font(.builderSans(.regular, size: 14))
                    .foregroundColor(appColors.textSecondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: appColors.primaryOrange))
        }
    }
}

struct TimePickerRow: View {
    let title: String
    @Binding var time: Date
    let isEnabled: Bool
    @StateObject private var appColors = AppColors.shared
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.builderSans(.medium, size: 16))
                    .foregroundColor(appColors.textPrimary)
                
                Text(time.formatted(date: .omitted, time: .shortened))
                    .font(.builderSans(.regular, size: 14))
                    .foregroundColor(appColors.textSecondary)
            }
            
            Spacer()
            
            DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .preferredColorScheme(appColors.selectedScheme == .dark ? .dark : .light)
                .disabled(!isEnabled)
        }
    }
}

struct FrequencyRow: View {
    let frequency: NotificationManager.Frequency
    let isSelected: Bool
    let action: () -> Void
    @StateObject private var appColors = AppColors.shared
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(frequency.displayName)
                        .font(.builderSans(.medium, size: 16))
                        .foregroundColor(appColors.textPrimary)
                    
                    Text(frequency.description)
                        .font(.builderSans(.regular, size: 14))
                        .foregroundColor(appColors.textSecondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(appColors.primaryOrange)
                }
            }
            .padding(16)
            .background(isSelected ? appColors.primaryOrange.opacity(0.1) : Color.clear)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? appColors.primaryOrange : Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

#Preview {
    NotificationSettingsView()
}
