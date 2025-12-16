import SwiftUI

struct InfoView: View {
    @StateObject private var bagViewModel = BagViewModel()
    @StateObject private var notesViewModel = NotesViewModel()
    @Binding var selectedTab: TabItem
    
    @State private var showingAddBag = false
    @State private var showingAddNote = false
    
    init(selectedTab: Binding<TabItem> = .constant(.info)) {
        self._selectedTab = selectedTab
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                    
                    quickStatsSection
                    
                    tipsSection
                    
                    quickActionsSection
                    
                    aboutSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 120)
            }
        }
        .sheet(isPresented: $showingAddBag) {
            AddEditBagView(viewModel: bagViewModel)
        }
        .sheet(isPresented: $showingAddNote) {
            AddEditNoteView(viewModel: notesViewModel)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryYellow.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(AppColors.primaryYellow)
            }
            
            Text("About Your Collection")
                .font(FontManager.ubuntu(.bold, size: 28))
                .foregroundColor(AppColors.primaryText)
            
            Text("Quick insights and helpful tips")
                .font(FontManager.ubuntu(.regular, size: 16))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(.bottom, 10)
    }
    
    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Stats")
                .font(FontManager.ubuntu(.bold, size: 20))
                .foregroundColor(AppColors.primaryText)
            
            HStack(spacing: 12) {
                StatCard(
                    icon: "handbag.fill",
                    value: "\(bagViewModel.bags.count)",
                    label: "Total Bags",
                    color: AppColors.primaryYellow
                )
                
                StatCard(
                    icon: "chart.bar.fill",
                    value: "\(Set(bagViewModel.bags.map { $0.style }).count)",
                    label: "Styles",
                    color: AppColors.primaryPurple
                )
                
                StatCard(
                    icon: "clock.fill",
                    value: "\(bagViewModel.bags.filter { $0.usageFrequency == .often }.count)",
                    label: "Used Often",
                    color: AppColors.primaryBlue
                )
            }
        }
    }
    
    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tips & Tricks")
                .font(FontManager.ubuntu(.bold, size: 20))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                TipCard(
                    icon: "tag.fill",
                    title: "Organize by Style",
                    description: "Categorize your bags by style to quickly find the perfect match for any occasion.",
                    color: AppColors.primaryPurple
                )
                
                TipCard(
                    icon: "clock.fill",
                    title: "Track Usage",
                    description: "Mark how often you use each bag to identify your favorites and discover underused pieces.",
                    color: AppColors.primaryBlue
                )
                
                TipCard(
                    icon: "note.text",
                    title: "Add Notes",
                    description: "Use notes to remember outfit ideas, shopping lists, or style inspirations.",
                    color: AppColors.primaryYellow
                )
            }
        }
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(FontManager.ubuntu(.bold, size: 20))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                if bagViewModel.bags.isEmpty {
                    ActionCard(
                        icon: "plus.circle.fill",
                        title: "Add Your First Bag",
                        description: "Start building your collection",
                        color: AppColors.success
                    ) {
                        showingAddBag = true
                    }
                } else {
                    ActionCard(
                        icon: "chart.bar.fill",
                        title: "View Statistics",
                        description: "See detailed insights about your collection",
                        color: AppColors.primaryBlue
                    ) {
                        withAnimation {
                            selectedTab = .statistics
                        }
                    }
                    
                    ActionCard(
                        icon: "note.text",
                        title: "Create a Note",
                        description: "Save ideas and inspirations",
                        color: AppColors.primaryYellow
                    ) {
                        showingAddNote = true
                    }
                }
            }
        }
    }
    
    private var aboutSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                Image(systemName: "handbag.fill")
                    .font(.system(size: 40))
                    .foregroundColor(AppColors.primaryYellow)
                
                Text("PurseLog")
                    .font(FontManager.ubuntu(.bold, size: 22))
                    .foregroundColor(AppColors.darkText)
                
                Text("Your personal handbag collection manager")
                    .font(FontManager.ubuntu(.regular, size: 14))
                    .foregroundColor(AppColors.darkText)
                    .multilineTextAlignment(.center)
                
                Text("Organize, track, and discover your perfect bag collection. Built for those who love style with structure.")
                    .font(FontManager.ubuntu(.regular, size: 13))
                    .foregroundColor(AppColors.darkText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.top, 8)
            }
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
            .cardStyle()
        }
    }
}

struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(FontManager.ubuntu(.bold, size: 20))
                .foregroundColor(AppColors.darkText)
            
            Text(label)
                .font(FontManager.ubuntu(.regular, size: 11))
                .foregroundColor(AppColors.darkText.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .cardStyle()
    }
}

struct TipCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(FontManager.ubuntu(.bold, size: 16))
                    .foregroundColor(AppColors.darkText)
                
                Text(description)
                    .font(FontManager.ubuntu(.regular, size: 13))
                    .foregroundColor(AppColors.darkText.opacity(0.7))
                    .lineSpacing(2)
            }
            
            Spacer()
        }
        .padding(16)
        .cardStyle()
    }
}

struct ActionCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(FontManager.ubuntu(.bold, size: 16))
                        .foregroundColor(AppColors.darkText)
                    
                    Text(description)
                        .font(FontManager.ubuntu(.regular, size: 13))
                        .foregroundColor(AppColors.darkText.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.darkText.opacity(0.4))
            }
            .padding(16)
            .cardStyle()
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .opacity(isPressed ? 0.8 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}

