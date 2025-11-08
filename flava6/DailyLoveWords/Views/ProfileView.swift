import SwiftUI
import StoreKit

struct ProfileView: View {
    @ObservedObject var wordStore: WordStore
    @StateObject private var profileStore = ProfileStore()
    @State private var storageSize: String = "0 KB"
    @State private var fileCount: Int = 0
    @Environment(\.requestReview) var requestReview
    @State private var showingEditProfile = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 30) {
                        profileHeader
                        
                        statsSection
                        
                        settingsSection
                        
                        appInfoSection
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        showingEditProfile = true
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(profileStore: profileStore)
        }
        .onAppear {
            updateStorageInfo()
        }
    }
    
    private var profileHeader: some View {
        PixelCard {
            VStack(spacing: 16) {
                AvatarView(image: profileStore.profile.avatar, size: 80)
                
                VStack(spacing: 4) {
                    Text(profileStore.profile.displayName)
                        .font(FontManager.title2)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Building vocabulary daily")
                        .font(FontManager.subheadline)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            .padding(.vertical, 10)
        }
    }
    
    private var statsSection: some View {
        VStack(spacing: 16) {
            Text("Your Progress")
                .font(FontManager.title3)
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 16) {
                StatCard(
                    icon: "books.vertical.fill",
                    title: "Total Words",
                    value: "\(wordStore.totalWordsCount)",
                    color: AppColors.primaryBlue
                )
                
                StatCard(
                    icon: "calendar.badge.plus",
                    title: "Today's Word",
                    value: wordStore.todaysWord != nil ? "Added" : "Pending",
                    color: wordStore.todaysWord != nil ? AppColors.success : AppColors.warning
                )
            }
            
            HStack(spacing: 16) {
                StatCard(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "This Week",
                    value: "\(wordsThisWeek)",
                    color: AppColors.pixelPurple
                )
                
                StatCard(
                    icon: "star.fill",
                    title: "Streak",
                    value: "\(currentStreak) days",
                    color: AppColors.pixelYellow
                )
            }
        }
    }
    
    private var settingsSection: some View {
        VStack(spacing: 16) {
            Text("Settings")
                .font(FontManager.title3)
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                SettingRow(
                    icon: "person.circle",
                    title: "Edit Profile",
                    action: {
                        showingEditProfile = true
                    }
                )
                
                SettingRow(
                    icon: "star.bubble",
                    title: "Rate App",
                    action: {
                        requestReview()
                    }
                )
                
                SettingRow(
                    icon: "envelope",
                    title: "Contact Us",
                    action: {
                        openURL("https://forms.gle/gzmLVD8XiXoV1QaH9")
                    }
                )
                
                SettingRow(
                    icon: "doc.text",
                    title: "Terms of Use",
                    action: {
                        openURL("https://docs.google.com/document/d/1KujHtPqPtrZStq_DcjfGq_aIVJkF0pplZ5uyh7Olq6A/edit?usp=sharing")
                    }
                )
                
                SettingRow(
                    icon: "hand.raised",
                    title: "Privacy Policy",
                    action: {
                        openURL("https://docs.google.com/document/d/1hNNUqjpK_Pt9MzaY3RC5aKb0wCrXVeX27vp4sVYOfR0/edit?usp=sharing")
                    }
                )
            }
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            Text("About")
                .font(FontManager.title3)
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            PixelCard {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "heart.text.square")
                            .foregroundColor(AppColors.primaryBlue)
                        
                        Text("Daily Love Words")
                            .font(FontManager.headline)
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                    }
                    
                    Text("Build your personal word collection, one day at a time. Simple, focused, and designed for language learners.")
                        .font(FontManager.body)
                        .foregroundColor(AppColors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)

                }
            }
        }
    }
    
    private var wordsThisWeek: Int {
        let calendar = Calendar.current
        let now = Date()
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        
        return wordStore.words.filter { word in
            word.dateAdded >= weekAgo && word.dateAdded <= now
        }.count
    }
    
    private var currentStreak: Int {
        let calendar = Calendar.current
        let sortedWords = wordStore.words.sorted { $0.dateAdded > $1.dateAdded }
        
        var streak = 0
        var currentDate = Date()
        
        for word in sortedWords {
            if calendar.isDate(word.dateAdded, inSameDayAs: currentDate) {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        
        return streak
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func updateStorageInfo() {
        let (totalSize, count) = FileStorageManager.shared.getStorageInfo()
        
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        storageSize = formatter.string(fromByteCount: totalSize)
        fileCount = count
    }
    
    private var storageSection: some View {
        PixelCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "externaldrive.fill")
                        .foregroundColor(AppColors.primaryBlue)
                    
                    Text("Storage")
                        .font(FontManager.headline)
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Total size:")
                            .font(FontManager.callout)
                            .foregroundColor(AppColors.secondaryText)
                        
                        Spacer()
                        
                        Text(storageSize)
                            .font(FontManager.callout)
                            .foregroundColor(AppColors.primaryText)
                    }
                    
                    HStack {
                        Text("Files:")
                            .font(FontManager.callout)
                            .foregroundColor(AppColors.secondaryText)
                        
                        Spacer()
                        
                        Text("\(fileCount)")
                            .font(FontManager.callout)
                            .foregroundColor(AppColors.primaryText)
                    }
                    
                    HStack {
                        Text("Status:")
                            .font(FontManager.callout)
                            .foregroundColor(AppColors.secondaryText)
                        
                        Spacer()
                        
                        Text("Optimized")
                            .font(FontManager.callout)
                            .foregroundColor(AppColors.primaryBlue)
                    }
                }
            }
        }
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        PixelCard {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                
                Text(value)
                    .font(FontManager.title3)
                    .foregroundColor(AppColors.primaryText)
                
                Text(title)
                    .font(FontManager.caption)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct SettingRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            PixelCard {
                HStack(spacing: 16) {
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.primaryBlue)
                        .frame(width: 24)
                    
                    Text(title)
                        .font(FontManager.body)
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ProfileView(wordStore: {
        let store = WordStore()
        store.addWord(Word(word: "Hello", translation: "Привет"))
        store.addWord(Word(word: "World", translation: "Мир"))
        return store
    }())
}
