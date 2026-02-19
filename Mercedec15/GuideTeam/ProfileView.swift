import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @EnvironmentObject var progressVM: ProgressViewModel
    @State private var showingSettings = false
    @State private var showingEditProfile = false
    @State private var showingAvatarPicker = false
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    profileHeaderView
                    
                    quickStatsView
                    
                    favoriteServicesView
                    
                    favoriteSalonView
                    
                    settingsSection
                }
                .padding(20)
            }
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(profile: $viewModel.profile) {
                viewModel.saveProfile()
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingAvatarPicker) {
            ImagePicker(image: Binding(
                get: { nil },
                set: { newImage in
                    if let image = newImage, let filename = ImageStorage.saveAvatarImage(image) {
                        viewModel.setAvatar(filename: filename)
                    }
                }
            ))
        }
    }
    
    private var profileHeaderView: some View {
        VStack(spacing: 16) {
            Button(action: { showingAvatarPicker = true }) {
                ZStack {
                    LoadedImageView(filename: viewModel.profile.avatarURL) {
                        Circle()
                            .fill(ColorTheme.primaryPurple.opacity(0.3))
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(ColorTheme.secondaryText)
                            )
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "camera.fill")
                                .font(.caption)
                                .foregroundColor(ColorTheme.primaryWhite)
                                .padding(6)
                                .background(ColorTheme.primaryPurple)
                                .clipShape(Circle())
                                .offset(x: 4, y: 4)
                        }
                        .frame(width: 100, height: 100)
                    }
                }
                .frame(width: 100, height: 100)
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(spacing: 8) {
                Text(viewModel.profile.name.isEmpty ? "Your Name" : viewModel.profile.name)
                    .font(.playfairBold(size: 24))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text(viewModel.profile.email.isEmpty ? "your.email@example.com" : viewModel.profile.email)
                    .font(.playfairRegular(size: 16))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            Button(action: { showingEditProfile = true }) {
                Text("Edit Profile")
                    .font(.playfairSemiBold(size: 16))
                    .foregroundColor(ColorTheme.buttonText)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(ColorTheme.buttonPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(ColorTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var quickStatsView: some View {
        HStack(spacing: 16) {
            StatItem(title: "Total Visits", value: "\(progressVM.statistics.totalVisits)", icon: "calendar.badge.checkmark")
            StatItem(title: "This Month", value: "\(progressVM.statistics.currentMonthVisits)", icon: "calendar")
            StatItem(title: "Avg Spent", value: progressVM.statistics.formattedAverageSpending, icon: "dollarsign.circle")
        }
    }
    
    private var favoriteServicesView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Favorite Services")
                .font(.playfairBold(size: 20))
                .foregroundColor(ColorTheme.primaryText)
            
            if viewModel.profile.favoriteServices.isEmpty {
                Text("No favorite services selected")
                    .font(.playfairRegular(size: 16))
                    .foregroundColor(ColorTheme.secondaryText)
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(ColorTheme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    ForEach(viewModel.profile.favoriteServices, id: \.self) { service in
                        ServiceBadge(service: service)
                    }
                }
            }
        }
    }
    
    private var favoriteSalonView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Favorite Salon")
                .font(.playfairBold(size: 20))
                .foregroundColor(ColorTheme.primaryText)
            
            HStack {
                Rectangle()
                    .fill(ColorTheme.primaryPurple.opacity(0.3))
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        Image(systemName: "photo")
                            .font(.title2)
                            .foregroundColor(ColorTheme.secondaryText)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.profile.favoriteSalon ?? "No favorite salon")
                        .font(.playfairSemiBold(size: 18))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    if viewModel.profile.favoriteSalon != nil {
                        HStack(spacing: 2) {
                            ForEach(0..<5) { _ in
                                Image(systemName: "star.fill")
                                    .font(.caption)
                                    .foregroundColor(ColorTheme.accentOrange)
                            }
                        }
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(ColorTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.playfairBold(size: 20))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 12) {
                SettingsRow(
                    title: "Notifications",
                    subtitle: "Push notifications for bookings",
                    icon: "bell.fill",
                    action: nil,
                    showToggle: true,
                    toggleBinding: Binding(
                        get: { viewModel.profile.notificationsEnabled },
                        set: { viewModel.updateNotificationSettings($0) }
                    ),
                    showChevron: false
                )
                
                SettingsRow(
                    title: "Monthly Goal",
                    subtitle: "\(viewModel.profile.visitGoal) visits per month",
                    icon: "target",
                    action: nil,
                    showToggle: false,
                    toggleBinding: nil,
                    showChevron: false
                )
                
                SettingsRow(
                    title: "App Settings",
                    subtitle: "Privacy, terms, and more",
                    icon: "gear",
                    action: { showingSettings = true },
                    showToggle: false,
                    toggleBinding: nil,
                    showChevron: true
                )
            }
        }
    }
}

struct StatItem: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(ColorTheme.primaryWhite)
            
            Text(value)
                .font(.playfairBold(size: 20))
                .foregroundColor(ColorTheme.primaryText)
            
            Text(title)
                .font(.playfairRegular(size: 12))
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(ColorTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ServiceBadge: View {
    let service: ServiceCategory
    
    var body: some View {
        HStack {
            Image(systemName: service.icon)
                .foregroundColor(ColorTheme.primaryPurple)
            
            Text(service.rawValue)
                .font(.playfairRegular(size: 14))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
        }
        .padding(12)
        .background(ColorTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ColorTheme.cardBorder, lineWidth: 1)
        )
    }
}

struct SettingsRow: View {
    let title: String
    let subtitle: String
    let icon: String
    var action: (() -> Void)? = nil
    var showToggle: Bool = false
    var toggleBinding: Binding<Bool>? = nil
    var showChevron: Bool = true
    
    var body: some View {
        let rowContent = HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(ColorTheme.primaryWhite)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.playfairSemiBold(size: 16))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text(subtitle)
                    .font(.playfairRegular(size: 14))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            Spacer()
            
            if showToggle, let binding = toggleBinding {
                Toggle("", isOn: binding)
                    .toggleStyle(SwitchToggleStyle(tint: ColorTheme.primaryPurple))
                    .labelsHidden()
            } else if showChevron {
                Image(systemName: "chevron.right")
                    .foregroundColor(ColorTheme.secondaryText)
            }
        }
        .padding(16)
        .background(ColorTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        
        Group {
            if showToggle && toggleBinding != nil {
                rowContent
            } else if let action = action {
                Button(action: action) {
                    rowContent
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                rowContent
            }
        }
    }
}

struct EditProfileView: View {
    @Binding var profile: UserProfile
    let onSave: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var editedProfile: UserProfile
    
    init(profile: Binding<UserProfile>, onSave: @escaping () -> Void) {
        self._profile = profile
        self.onSave = onSave
        self._editedProfile = State(initialValue: profile.wrappedValue)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(.playfairSemiBold(size: 16))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            TextField("Enter your name", text: $editedProfile.name)
                                .font(.playfairRegular(size: 16))
                                .foregroundColor(ColorTheme.primaryText)
                                .padding(16)
                                .background(ColorTheme.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.playfairSemiBold(size: 16))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            TextField("Enter your email", text: $editedProfile.email)
                                .font(.playfairRegular(size: 16))
                                .foregroundColor(ColorTheme.primaryText)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding(16)
                                .background(ColorTheme.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Monthly Visit Goal")
                                .font(.playfairSemiBold(size: 16))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            Stepper(value: $editedProfile.visitGoal, in: 1...20) {
                                Text("\(editedProfile.visitGoal) visits per month")
                                    .font(.playfairRegular(size: 16))
                                    .foregroundColor(ColorTheme.primaryText)
                            }
                            .padding(16)
                            .background(ColorTheme.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.primaryPurple)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        profile = editedProfile
                        onSave()
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.primaryPurple)
                    .fontWeight(.semibold)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(ProfileViewModel())
        .environmentObject(ProgressViewModel())
}
