import SwiftUI
import PhotosUI

private let reminderTimeFormatter: DateFormatter = {
    let f = DateFormatter()
    f.timeStyle = .short
    return f
}()

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var tempReminderTime = Date()
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    headerSection
                    
                    profileCard
                    
                    goalsSection
                    
                    settingsSection
                    
                    if viewModel.isEditing {
                        saveButton
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
            }
        }
        .onAppear {
            viewModel.user = appViewModel.user
            if let avatar = viewModel.user.avatar, avatar.hasPrefix("data:image"),
               let data = Data(base64Encoded: avatar.components(separatedBy: ",").last ?? ""),
               let image = UIImage(data: data) {
                selectedImage = image
            }
        }
        .onChange(of: appViewModel.user, perform: { newValue in
            if viewModel.user != newValue {
                viewModel.user = newValue
            }
        })
        .sheet(isPresented: $viewModel.showingTimePicker) {
            ReminderTimePickerView(
                time: $tempReminderTime,
                title: viewModel.editingReminderSlot == .morning ? "Morning Reminder" : "Evening Reminder",
                onSave: {
                    if viewModel.editingReminderSlot == .morning {
                        viewModel.user.morningTime = tempReminderTime
                    } else {
                        viewModel.user.eveningTime = tempReminderTime
                    }
                    viewModel.showingTimePicker = false
                },
                onCancel: {
                    viewModel.showingTimePicker = false
                }
            )
        }
        .photosPicker(
            isPresented: $viewModel.showingImagePicker,
            selection: $selectedPhoto,
            matching: .images
        )
        .task(id: selectedPhoto) {
            guard let item = selectedPhoto else { return }
            
            do {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        selectedImage = image
                        if let imageData = image.jpegData(compressionQuality: 0.7) {
                            let base64String = imageData.base64EncodedString()
                            viewModel.user.avatar = "data:image/jpeg;base64,\(base64String)"
                            viewModel.saveProfile()
                            appViewModel.user = viewModel.user
                        }
                    }
                }
            } catch {
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            Text("Profile")
                .font(AppFonts.title1())
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Button(viewModel.isEditing ? "Cancel" : "Edit") {
                withAnimation(.easeInOut) {
                    if viewModel.isEditing {
                        viewModel.user = appViewModel.user
                    }
                    viewModel.isEditing.toggle()
                }
            }
            .font(AppFonts.button())
            .foregroundColor(AppColors.accentYellow)
        }
    }
    
    private var profileCard: some View {
        VStack(spacing: AppSpacing.lg) {
            Button(action: { viewModel.showingImagePicker = true }) {
                ZStack {
                    Circle()
                        .fill(AppColors.primaryBlue.opacity(0.2))
                        .frame(width: 100, height: 100)
                    
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else if let avatar = viewModel.user.avatar, avatar.hasPrefix("data:image") {
                        if let data = Data(base64Encoded: avatar.components(separatedBy: ",").last ?? ""),
                           let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(AppColors.primaryBlue)
                        }
                    } else if let avatar = viewModel.user.avatar, let url = URL(string: avatar) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(AppColors.primaryBlue)
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(AppColors.primaryBlue)
                    }
                    
                    if viewModel.isEditing {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Image(systemName: "camera.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(AppColors.accentYellow)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                        }
                        .frame(width: 100, height: 100)
                    }
                }
            }
            .disabled(!viewModel.isEditing)
            
            VStack(spacing: AppSpacing.md) {
                if viewModel.isEditing {
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Name")
                            .font(AppFonts.bodyMedium())
                            .foregroundColor(AppColors.textPrimary)
                        
                        TextField("Enter your name", text: $viewModel.user.name)
                            .font(AppFonts.body())
                            .padding(AppSpacing.md)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(AppRadius.md)
                    }
                    
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Email")
                            .font(AppFonts.bodyMedium())
                            .foregroundColor(AppColors.textPrimary)
                        
                        TextField("Enter your email", text: $viewModel.user.email)
                            .font(AppFonts.body())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding(AppSpacing.md)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(AppRadius.md)
                    }
                } else {
                    VStack(spacing: AppSpacing.sm) {
                        Text(viewModel.user.name.isEmpty ? "Add your name" : viewModel.user.name)
                            .font(AppFonts.title2())
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text(viewModel.user.email.isEmpty ? "Add your email" : viewModel.user.email)
                            .font(AppFonts.body())
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
        }
        .padding(AppSpacing.lg)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.9))
        .cornerRadius(AppRadius.lg)
        .shadow(color: AppShadows.light, radius: 4, x: 0, y: 2)
    }
    
    private var goalsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Health Goals")
                .font(AppFonts.headline())
                .foregroundColor(AppColors.textPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: AppSpacing.md) {
                ForEach(HabitType.allCases) { type in
                    Button(action: {
                        if viewModel.isEditing {
                            var goalTypes = viewModel.user.goalTypes
                            if goalTypes.contains(type) {
                                goalTypes.removeAll { $0 == type }
                            } else {
                                goalTypes.append(type)
                            }
                            viewModel.user.goalTypes = goalTypes
                        }
                    }) {
                        HStack {
                            Image(systemName: type.icon)
                                .font(.title3)
                                .foregroundColor(type.color)
                            
                            Text(type.rawValue)
                                .font(AppFonts.body())
                                .foregroundColor(AppColors.textPrimary)
                            
                            Spacer()
                            
                            if viewModel.user.goalTypes.contains(type) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title3)
                                    .foregroundColor(AppColors.lightGreen)
                            }
                        }
                        .padding(AppSpacing.md)
                        .background(
                            viewModel.user.goalTypes.contains(type) ?
                            type.color.opacity(0.2) :
                                Color.white.opacity(0.8)
                        )
                        .cornerRadius(AppRadius.md)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppRadius.md)
                                .stroke(
                                    viewModel.user.goalTypes.contains(type) ? type.color : Color.clear,
                                    lineWidth: 2
                                )
                        )
                    }
                    .disabled(!viewModel.isEditing)
                }
            }
        }
    }
    
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Notification Settings")
                .font(AppFonts.headline())
                .foregroundColor(AppColors.textPrimary)
            
            VStack(spacing: AppSpacing.md) {
                HStack {
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text("Daily Reminders")
                            .font(AppFonts.bodyMedium())
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("Get notified about your daily tasks")
                            .font(AppFonts.caption())
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $viewModel.user.notificationsEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: AppColors.accentYellow))
                        .disabled(!viewModel.isEditing)
                }
                
                if viewModel.user.notificationsEnabled {
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Reminder Times")
                            .font(AppFonts.bodyMedium())
                            .foregroundColor(AppColors.textPrimary)
                        
                        HStack {
                            Text("Morning: \(reminderTimeFormatter.string(from: viewModel.user.morningTime))")
                                .font(AppFonts.body())
                                .foregroundColor(AppColors.textSecondary)
                            
                            Spacer()
                            
                            if viewModel.isEditing {
                                Button("Change") {
                                    viewModel.editingReminderSlot = .morning
                                    tempReminderTime = viewModel.user.morningTime
                                    viewModel.showingTimePicker = true
                                }
                                .font(AppFonts.caption())
                                .foregroundColor(AppColors.accentYellow)
                            }
                        }
                        
                        HStack {
                            Text("Evening: \(reminderTimeFormatter.string(from: viewModel.user.eveningTime))")
                                .font(AppFonts.body())
                                .foregroundColor(AppColors.textSecondary)
                            
                            Spacer()
                            
                            if viewModel.isEditing {
                                Button("Change") {
                                    viewModel.editingReminderSlot = .evening
                                    tempReminderTime = viewModel.user.eveningTime
                                    viewModel.showingTimePicker = true
                                }
                                .font(AppFonts.caption())
                                .foregroundColor(AppColors.accentYellow)
                            }
                        }
                    }
                    .padding(AppSpacing.md)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(AppRadius.md)
                }
            }
            .padding(AppSpacing.md)
            .background(Color.white.opacity(0.8))
            .cornerRadius(AppRadius.md)
        }
    }
    
    private var saveButton: some View {
        Button {
            withAnimation(.easeInOut) {
                viewModel.saveProfile()
                appViewModel.user = viewModel.user
            }
        } label: {
            Text("Save Changes")
                .font(AppFonts.button())
                .foregroundColor(AppColors.textLight)
                .padding(.vertical, AppSpacing.md)
                .frame(maxWidth: .infinity)
                .background(AppColors.accentYellow)
                .cornerRadius(AppRadius.lg)
                .shadow(color: AppShadows.medium, radius: 4, x: 0, y: 2)

        }
    }
}

struct ReminderTimePickerView: View {
    @Binding var time: Date
    let title: String
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: AppSpacing.lg) {
                    Text("Choose reminder time")
                        .font(AppFonts.body())
                        .foregroundColor(AppColors.textSecondary)
                    
                    DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .padding(.horizontal)
                }
                .padding(AppSpacing.lg)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onCancel()
                    }
                    .foregroundColor(AppColors.textPrimary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave()
                    }
                    .font(AppFonts.button())
                    .foregroundColor(AppColors.accentYellow)
                }
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppViewModel())
}
