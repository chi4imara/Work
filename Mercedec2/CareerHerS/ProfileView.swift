import SwiftUI
import StoreKit

struct ProfileView: View {
    @ObservedObject private var viewModel = ProfileViewModel.shared
    @State private var showPermissionDeniedAlert = false
    
    private var notificationsEnabledBinding: Binding<Bool> {
        Binding(
            get: { viewModel.user.notificationsEnabled },
            set: { newValue in
                if newValue {
                    NotificationManager.shared.requestPermissionIfNeeded { granted in
                        if granted {
                            viewModel.user.notificationsEnabled = true
                        } else {
                            showPermissionDeniedAlert = true
                        }
                    }
                } else {
                    viewModel.user.notificationsEnabled = false
                }
            }
        )
    }
    
    private var weeklyReportEnabledBinding: Binding<Bool> {
        Binding(
            get: { viewModel.user.weeklyReportEnabled },
            set: { newValue in
                if newValue {
                    NotificationManager.shared.requestPermissionIfNeeded { granted in
                        if granted {
                            viewModel.user.weeklyReportEnabled = true
                        } else {
                            showPermissionDeniedAlert = true
                        }
                    }
                } else {
                    viewModel.user.weeklyReportEnabled = false
                }
            }
        )
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Profile")
                        .font(.custom("PlayfairDisplay-Bold", size: 28))
                        .foregroundColor(Color.theme.primaryBlue)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.showSettings = true
                    }) {
                        Image(systemName: "gearshape.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(Color.theme.primaryBlue)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        VStack(spacing: 20) {
                            VStack(spacing: 16) {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(Color.theme.primaryBlue)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                                
                                VStack(spacing: 8) {
                                    TextField("Your Name", text: $viewModel.user.name)
                                        .font(.custom("PlayfairDisplay-SemiBold", size: 20))
                                        .foregroundColor(Color.theme.primaryBlue)
                                        .multilineTextAlignment(.center)
                                        .textFieldStyle(PlainTextFieldStyle())
                                    
                                    TextField("your.email@example.com", text: $viewModel.user.email)
                                        .font(.custom("PlayfairDisplay-Regular", size: 16))
                                        .foregroundColor(Color.theme.darkGray)
                                        .multilineTextAlignment(.center)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                }
                            }
                            .padding(24)
                            .background(Color.theme.cardGradient)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Career Goals")
                                    .font(.custom("PlayfairDisplay-SemiBold", size: 20))
                                    .foregroundColor(Color.theme.primaryBlue)
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.showGoalCreation = true
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(Color.theme.primaryYellow)
                                }
                            }
                            
                            VStack(spacing: 12) {
                                ProfileField(
                                    title: "Current Goal",
                                    text: $viewModel.user.currentGoal,
                                    placeholder: "Enter your current career goal"
                                )
                                
                                ProfileField(
                                    title: "Desired Position",
                                    text: $viewModel.user.desiredPosition,
                                    placeholder: "What position do you want to achieve?"
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.theme.cardGradient)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Learning Preferences")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 20))
                                .foregroundColor(Color.theme.primaryBlue)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Learning Pace")
                                    .font(.custom("PlayfairDisplay-Medium", size: 16))
                                    .foregroundColor(Color.theme.darkGray)
                                
                                HStack(spacing: 8) {
                                    ForEach(LearningPace.allCases, id: \.self) { pace in
                                        Button(action: {
                                            viewModel.user.learningPace = pace
                                        }) {
                                            Text(pace.rawValue)
                                                .font(.custom("PlayfairDisplay-Medium", size: 14))
                                                .foregroundColor(viewModel.user.learningPace == pace ? .white : Color.theme.primaryBlue)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(viewModel.user.learningPace == pace ? Color.theme.primaryBlue : Color.white)
                                                .cornerRadius(20)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color.theme.primaryBlue, lineWidth: 1)
                                                )
                                        }
                                    }
                                }
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.theme.cardGradient)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Notifications")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 20))
                                .foregroundColor(Color.theme.primaryBlue)
                            
                            VStack(spacing: 12) {
                                NotificationToggle(
                                    title: "Course Reminders",
                                    description: "Get notified about new courses",
                                    isOn: notificationsEnabledBinding
                                )
                                
                                NotificationToggle(
                                    title: "Weekly Progress Report",
                                    description: "Receive weekly progress updates",
                                    isOn: weeklyReportEnabledBinding
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.theme.cardGradient)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                        .padding(.horizontal, 20)
                        
                        Button(action: {
                            viewModel.saveProfile()
                        }) {
                            Text("Save Changes")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.theme.buttonGradient)
                                .cornerRadius(25)
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 120)
                }
            }
        }
        .sheet(isPresented: $viewModel.showGoalCreation) {
            GoalCreationView()
        }
        .sheet(isPresented: $viewModel.showSettings) {
            SettingsView(profileViewModel: viewModel)
        }
        .alert("Notifications Disabled", isPresented: $showPermissionDeniedAlert) {
            Button("OK", role: .cancel) { }
            Button("Open Settings") {
                NotificationManager.shared.openAppSettings()
            }
        } message: {
            Text("Please allow notifications in Settings to receive course reminders and progress reports.")
        }
        .onAppear {
            viewModel.syncNotificationSettingsWithSystem()
        }
    }
}

struct ProfileField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("PlayfairDisplay-Medium", size: 14))
                .foregroundColor(Color.theme.darkGray)
            
            TextField(placeholder, text: $text)
                .font(.custom("PlayfairDisplay-Regular", size: 16))
                .foregroundColor(Color.theme.primaryBlue)
                .padding(12)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.theme.lightGray, lineWidth: 1)
                )
        }
    }
}

struct NotificationToggle: View {
    let title: String
    let description: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("PlayfairDisplay-Medium", size: 16))
                    .foregroundColor(Color.theme.primaryBlue)
                
                Text(description)
                    .font(.custom("PlayfairDisplay-Regular", size: 12))
                    .foregroundColor(Color.theme.darkGray)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: Color.theme.primaryYellow))
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(8)
    }
}

struct GoalCreationView: View {
    @StateObject private var viewModel = GoalCreationViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 16) {
                            ProfileField(
                                title: "Goal Title",
                                text: $viewModel.title,
                                placeholder: "Enter your goal"
                            )
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Skill")
                                    .font(.custom("PlayfairDisplay-Medium", size: 14))
                                    .foregroundColor(Color.theme.darkGray)
                                
                                Menu {
                                    ForEach(viewModel.availableSkills, id: \.self) { skill in
                                        Button(skill) {
                                            viewModel.selectedSkill = skill
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(viewModel.selectedSkill.isEmpty ? "Select a skill" : viewModel.selectedSkill)
                                            .font(.custom("PlayfairDisplay-Regular", size: 16))
                                            .foregroundColor(viewModel.selectedSkill.isEmpty ? Color.theme.darkGray.opacity(0.6) : Color.theme.primaryBlue)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color.theme.darkGray)
                                    }
                                    .padding(12)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.theme.lightGray, lineWidth: 1)
                                    )
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Deadline")
                                    .font(.custom("PlayfairDisplay-Medium", size: 14))
                                    .foregroundColor(Color.theme.darkGray)
                                
                                DatePicker("", selection: $viewModel.deadline, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .padding(12)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.theme.lightGray, lineWidth: 1)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Priority")
                                    .font(.custom("PlayfairDisplay-Medium", size: 14))
                                    .foregroundColor(Color.theme.darkGray)
                                
                                HStack(spacing: 8) {
                                    ForEach(Priority.allCases, id: \.self) { priority in
                                        Button(action: {
                                            viewModel.priority = priority
                                        }) {
                                            Text(priority.rawValue)
                                                .font(.custom("PlayfairDisplay-Medium", size: 14))
                                                .foregroundColor(viewModel.priority == priority ? .white : Color.theme.primaryBlue)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(viewModel.priority == priority ? priorityColor(priority) : Color.white)
                                                .cornerRadius(20)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(priorityColor(priority), lineWidth: 1)
                                                )
                                        }
                                    }
                                }
                            }
                        }
                        .padding(20)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationTitle("Add Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.custom("PlayfairDisplay-Medium", size: 16))
                    .foregroundColor(Color.theme.accentOrange)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if viewModel.isFormValid {
                            let _ = viewModel.createGoal()
                            dismiss()
                        }
                    }
                    .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                    .foregroundColor(viewModel.isFormValid ? Color.theme.primaryBlue : Color.theme.darkGray.opacity(0.5))
                    .disabled(!viewModel.isFormValid)
                }
            }
        }
    }
    
    private func priorityColor(_ priority: Priority) -> Color {
        switch priority {
        case .low:
            return Color.theme.softGreen
        case .medium:
            return Color.theme.primaryYellow
        case .high:
            return Color.theme.accentOrange
        }
    }
}

struct SettingsView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 16) {
                            SettingsRow(
                                title: "Privacy Policy",
                                icon: "shield.checkerboard",
                                action: {
                                    openURL("https://www.termsfeed.com/live/7f713871-a640-4b92-99d4-8eccc158c67c")
                                }
                            )
                            
                            SettingsRow(
                                title: "Contact Us",
                                icon: "envelope.circle",
                                action: {
                                    openURL("https://www.termsfeed.com/live/7f713871-a640-4b92-99d4-8eccc158c67c")
                                }
                            )
                            
                            SettingsRow(
                                title: "Rate App",
                                icon: "star.circle",
                                action: {
                                    profileViewModel.requestAppReview()
                                }
                            )
                        }
                        .padding(20)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                    .foregroundColor(Color.theme.primaryBlue)
                }
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(Color.theme.primaryBlue)
                    .frame(width: 40, height: 40)
                    .background(Color.theme.lightBlue.opacity(0.2))
                    .clipShape(Circle())
                
                Text(title)
                    .font(.custom("PlayfairDisplay-Medium", size: 16))
                    .foregroundColor(Color.theme.primaryBlue)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(Color.theme.darkGray.opacity(0.6))
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}

#Preview {
    ProfileView()
}
