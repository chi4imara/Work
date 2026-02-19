import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingImagePicker = false
    @State private var showingEditProfile = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: AppConstants.sectionSpacing) {
                        profileHeader
                        preferencesSection
                        goalsSection
                        notificationsSection
                    }
                    .padding(.horizontal, AppConstants.cardPadding)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        showingEditProfile = true
                    }
                    .foregroundColor(AppColors.textBlue)
                    .font(.playfairDisplay(16, weight: .medium))
                }
            }
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView(viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.loadProfile()
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            Button(action: { showingImagePicker = true }) {
                ZStack {
                    Circle()
                        .fill(AppColors.lightGray)
                        .frame(width: 100, height: 100)
                    
                    if let avatarURL = viewModel.profile.avatarURL, !avatarURL.isEmpty {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 100))
                            .foregroundColor(AppColors.textBlue)
                    } else {
                        Image(systemName: "person.circle")
                            .font(.system(size: 100))
                            .foregroundColor(AppColors.textBlue)
                    }
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "camera.fill")
                                .font(.system(size: 16))
                                .foregroundColor(AppColors.backgroundWhite)
                                .frame(width: 30, height: 30)
                                .background(AppColors.textBlue)
                                .clipShape(Circle())
                        }
                    }
                }
            }
            
            VStack(spacing: 4) {
                Text(viewModel.profile.name)
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(AppColors.textBlue)
                
                Text(viewModel.profile.email)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(AppColors.darkGray)
            }
        }
        .padding(AppConstants.cardPadding)
        .background(AppColors.cardGradient)
        .cornerRadius(AppConstants.cornerRadius)
        .shadow(color: .gray.opacity(0.2), radius: AppConstants.shadowRadius, x: 0, y: 4)
    }
    
    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Style Preferences")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.textBlue)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(viewModel.profile.favoriteStyles, id: \.self) { style in
                    HStack {
                        Text(style.rawValue)
                            .font(.playfairDisplay(14, weight: .medium))
                            .foregroundColor(style.color)
                        
                        Spacer()
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12))
                            .foregroundColor(style.color)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(style.color.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Favorite Brands")
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(AppColors.textBlue)
                
                FlowLayout(spacing: 8) {
                    ForEach(viewModel.profile.favoriteBrands, id: \.self) { brand in
                        Text(brand)
                            .font(.playfairDisplay(12, weight: .medium))
                            .foregroundColor(AppColors.textBlue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(AppColors.lightGray)
                            .cornerRadius(16)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Budget Range")
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(AppColors.textBlue)
                
                Text("Up to $\(Int(viewModel.profile.budget))")
                    .font(.playfairDisplay(18, weight: .bold))
                    .foregroundColor(AppColors.primaryYellow)
            }
        }
        .padding(AppConstants.cardPadding)
        .background(AppColors.cardGradient)
        .cornerRadius(AppConstants.cornerRadius)
        .shadow(color: .gray.opacity(0.2), radius: AppConstants.shadowRadius, x: 0, y: 4)
    }
    
    private var goalsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Style Goals")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.textBlue)
            
            VStack(spacing: 12) {
                GoalCard(
                    icon: "briefcase",
                    title: "Professional Style",
                    description: "Build a sophisticated work wardrobe",
                    progress: 0.7,
                    color: AppColors.textBlue
                )
                
                GoalCard(
                    icon: "heart",
                    title: "Evening Elegance",
                    description: "Perfect accessories for special occasions",
                    progress: 0.4,
                    color: AppColors.accentPink
                )
                
                GoalCard(
                    icon: "sun.max",
                    title: "Casual Comfort",
                    description: "Effortless everyday style",
                    progress: 0.9,
                    color: AppColors.accentGreen
                )
            }
        }
        .padding(AppConstants.cardPadding)
        .background(AppColors.cardGradient)
        .cornerRadius(AppConstants.cornerRadius)
        .shadow(color: .gray.opacity(0.2), radius: AppConstants.shadowRadius, x: 0, y: 4)
    }
    
    private var notificationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Notifications")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.textBlue)
            
            VStack(spacing: 16) {
                NotificationToggle(
                    title: "New Collections",
                    description: "Get notified about new accessory collections",
                    isOn: .constant(viewModel.profile.notifications.newCollections)
                )
                
                NotificationToggle(
                    title: "Stylist Tips",
                    description: "Receive personalized styling advice",
                    isOn: .constant(viewModel.profile.notifications.stylistTips)
                )
                
                NotificationToggle(
                    title: "Sales & Offers",
                    description: "Don't miss out on special deals",
                    isOn: .constant(viewModel.profile.notifications.sales)
                )
            }
        }
        .padding(AppConstants.cardPadding)
        .background(AppColors.cardGradient)
        .cornerRadius(AppConstants.cornerRadius)
        .shadow(color: .gray.opacity(0.2), radius: AppConstants.shadowRadius, x: 0, y: 4)
    }
}

struct EditProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var editedProfile: UserProfile
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        self._editedProfile = State(initialValue: viewModel.profile)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: AppConstants.sectionSpacing) {
                        basicInfoSection
                        stylePreferencesSection
                        brandsSection
                        budgetSection
                    }
                    .padding(.horizontal, AppConstants.cardPadding)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.darkGray)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.updateProfile(editedProfile)
                        dismiss()
                    }
                    .foregroundColor(AppColors.textBlue)
                    .font(.playfairDisplay(16, weight: .semibold))
                }
            }
        }
    }
    
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Basic Information")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.textBlue)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Name")
                    .font(.playfairDisplay(14, weight: .semibold))
                    .foregroundColor(AppColors.textBlue)
                
                TextField("Enter your name", text: $editedProfile.name)
                    .font(.playfairDisplay(16, weight: .medium))
                    .padding(12)
                    .background(AppColors.backgroundWhite)
                    .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Email")
                    .font(.playfairDisplay(14, weight: .semibold))
                    .foregroundColor(AppColors.textBlue)
                
                TextField("Enter your email", text: $editedProfile.email)
                    .font(.playfairDisplay(16, weight: .medium))
                    .padding(12)
                    .background(AppColors.backgroundWhite)
                    .cornerRadius(12)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
        }
        .padding(AppConstants.cardPadding)
        .background(AppColors.cardGradient)
        .cornerRadius(AppConstants.cornerRadius)
        .shadow(color: .gray.opacity(0.2), radius: AppConstants.shadowRadius, x: 0, y: 4)
    }
    
    private var stylePreferencesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Style Preferences")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.textBlue)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(AccessoryStyle.allCases, id: \.self) { style in
                    Button(action: {
                        if editedProfile.favoriteStyles.contains(style) {
                            editedProfile.favoriteStyles.removeAll { $0 == style }
                        } else {
                            editedProfile.favoriteStyles.append(style)
                        }
                    }) {
                        HStack {
                            Text(style.rawValue)
                                .font(.playfairDisplay(14, weight: .medium))
                            
                            Spacer()
                            
                            if editedProfile.favoriteStyles.contains(style) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12))
                            }
                        }
                        .foregroundColor(editedProfile.favoriteStyles.contains(style) ? AppColors.backgroundWhite : style.color)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(editedProfile.favoriteStyles.contains(style) ? style.color : style.color.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(AppConstants.cardPadding)
        .background(AppColors.cardGradient)
        .cornerRadius(AppConstants.cornerRadius)
        .shadow(color: .gray.opacity(0.2), radius: AppConstants.shadowRadius, x: 0, y: 4)
    }
    
    private var brandsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Favorite Brands")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.textBlue)
            
            Text("Select your preferred brands")
                .font(.playfairDisplay(14, weight: .medium))
                .foregroundColor(AppColors.darkGray)
            
            FlowLayout(spacing: 8) {
                ForEach(["Chanel", "Gucci", "Prada", "Hermès", "Tiffany & Co", "Cartier", "Louis Vuitton"], id: \.self) { brand in
                    Button(action: {
                        if editedProfile.favoriteBrands.contains(brand) {
                            editedProfile.favoriteBrands.removeAll { $0 == brand }
                        } else {
                            editedProfile.favoriteBrands.append(brand)
                        }
                    }) {
                        Text(brand)
                            .font(.playfairDisplay(12, weight: .medium))
                            .foregroundColor(editedProfile.favoriteBrands.contains(brand) ? AppColors.backgroundWhite : AppColors.textBlue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(editedProfile.favoriteBrands.contains(brand) ? AppColors.textBlue : AppColors.lightGray)
                            .cornerRadius(16)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(AppConstants.cardPadding)
        .background(AppColors.cardGradient)
        .cornerRadius(AppConstants.cornerRadius)
        .shadow(color: .gray.opacity(0.2), radius: AppConstants.shadowRadius, x: 0, y: 4)
    }
    
    private var budgetSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Budget Range")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.textBlue)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Maximum budget per item: $\(Int(editedProfile.budget))")
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(AppColors.textBlue)
                
                Slider(value: $editedProfile.budget, in: 100...5000, step: 50)
                    .tint(AppColors.primaryYellow)
                
                HStack {
                    Text("$100")
                        .font(.playfairDisplay(12, weight: .medium))
                        .foregroundColor(AppColors.darkGray)
                    
                    Spacer()
                    
                    Text("$5000")
                        .font(.playfairDisplay(12, weight: .medium))
                        .foregroundColor(AppColors.darkGray)
                }
            }
        }
        .padding(AppConstants.cardPadding)
        .background(AppColors.cardGradient)
        .cornerRadius(AppConstants.cornerRadius)
        .shadow(color: .gray.opacity(0.2), radius: AppConstants.shadowRadius, x: 0, y: 4)
    }
}

struct GoalCard: View {
    let icon: String
    let title: String
    let description: String
    let progress: Double
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .cornerRadius(20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.playfairDisplay(14, weight: .semibold))
                    .foregroundColor(AppColors.textBlue)
                
                Text(description)
                    .font(.playfairDisplay(12, weight: .medium))
                    .foregroundColor(AppColors.darkGray)
                
                SwiftUI.ProgressView(value: progress)
                    .tint(color)
                    .frame(height: 4)
                    .scaleEffect(y: 0.5)
            }
            
            Spacer()
            
            Text("\(Int(progress * 100))%")
                .font(.playfairDisplay(12, weight: .semibold))
                .foregroundColor(color)
        }
        .padding(12)
        .background(AppColors.backgroundWhite)
        .cornerRadius(12)
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
                    .font(.playfairDisplay(14, weight: .semibold))
                    .foregroundColor(AppColors.textBlue)
                
                Text(description)
                    .font(.playfairDisplay(12, weight: .medium))
                    .foregroundColor(AppColors.darkGray)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .tint(AppColors.primaryYellow)
        }
        .padding(12)
        .background(AppColors.backgroundWhite)
        .cornerRadius(12)
    }
}

struct FlowLayout: Layout {
    let spacing: CGFloat
    
    init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        var height: CGFloat = 0
        var currentRowWidth: CGFloat = 0
        var currentRowHeight: CGFloat = 0
        
        for subview in subviews {
            let subviewSize = subview.sizeThatFits(.unspecified)
            
            if currentRowWidth + subviewSize.width + spacing > width && currentRowWidth > 0 {
                height += currentRowHeight + spacing
                currentRowWidth = subviewSize.width
                currentRowHeight = subviewSize.height
            } else {
                currentRowWidth += subviewSize.width + (currentRowWidth > 0 ? spacing : 0)
                currentRowHeight = max(currentRowHeight, subviewSize.height)
            }
        }
        
        height += currentRowHeight
        return CGSize(width: width, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var currentX = bounds.minX
        var currentY = bounds.minY
        var currentRowHeight: CGFloat = 0
        
        for subview in subviews {
            let subviewSize = subview.sizeThatFits(.unspecified)
            
            if currentX + subviewSize.width > bounds.maxX && currentX > bounds.minX {
                currentY += currentRowHeight + spacing
                currentX = bounds.minX
                currentRowHeight = 0
            }
            
            subview.place(
                at: CGPoint(x: currentX, y: currentY),
                proposal: ProposedViewSize(subviewSize)
            )
            
            currentX += subviewSize.width + spacing
            currentRowHeight = max(currentRowHeight, subviewSize.height)
        }
    }
}

#Preview {
    ProfileView()
}
