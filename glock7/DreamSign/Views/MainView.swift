import SwiftUI

struct MainView: View {
    @State private var selectedTab: AppTab = .dreams
    @State private var isShowingSidebar = false
    @State private var showOnboarding = !UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    @State private var dreamToEdit: Dream?
    @State private var showingAddDream = false
    @State private var isNewDream = true
    @State private var showingFiltersForDreams = false
    @State private var showingSortForDreams = false
    @State private var showingFiltersForSummary = false
    @State private var showinfAddTags = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                CustomNavigationBar(
                    title: selectedTab.title,
                    isShowingSidebar: $isShowingSidebar,
                    action: {
                        isNewDream = true
                        dreamToEdit = nil
                        showingAddDream = true
                    },
                    action1: { showingFiltersForDreams = true },
                    action2: { showingSortForDreams = true },
                    action3: { showingFiltersForSummary = true },
                    action4: { showinfAddTags = true }
                )
                
                contentView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            if isShowingSidebar {
                ZStack(alignment: .leading) {
                    ZStack {
                        AppColors.backgroundGradient
                            .opacity(0.95)
                        
                        GridPattern()
                            .opacity(0.1)
                    }
                    .frame(width: 280)
                    
                    HStack {
                        CustomSideBar(
                            selectedTab: $selectedTab,
                            isShowingSidebar: $isShowingSidebar
                        )
                        .transition(.move(edge: .leading))
                        
                        Spacer()
                    }
                }
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isShowingSidebar = false
                    }
                }
                .zIndex(1)
            }
        }
        .sheet(isPresented: $showOnboarding) {
            OnboardingView(isPresented: $showOnboarding)
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch selectedTab {
        case .dreams:
            DreamListView(showingAddDream: $showingAddDream, dreamToEdit: $dreamToEdit, showingFilters: $showingFiltersForDreams, showingSortOptions: $showingSortForDreams, isNewDream: $isNewDream)
        case .tags:
            TagsView(showingAddTag: $showinfAddTags)
        case .summary:
            SummaryView(showingFilters: $showingFiltersForSummary)
        case .settings:
            SettingsView()
        }
    }
}

struct CustomNavigationBar: View {
    let title: String
    @Binding var isShowingSidebar: Bool
    
    let action: () -> Void
    let action1: () -> Void
    let action2: () -> Void
    let action3: () -> Void
    let action4 : () -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isShowingSidebar = true
                }
            }) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
            }
            
            Spacer()
            
            Text(title)
                .font(AppFonts.semiBold(20))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            switcher
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    @ViewBuilder
    private var switcher: some View {
        switch title {
        case "Dreams":
            HStack {
                Button(action: {
                    action()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(AppColors.backgroundBlue)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColors.yellow)
                    )
                }
                
                Menu {
                    Button(action: { action1() }) {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    }
                    
                    Button(action: { action2() }) {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .padding(8)
                }
            }
        case "Summary":
            Button(action: {
                action3()
            }) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
            }
        case "Tags":
            Button(action: {
                action4()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(AppColors.backgroundBlue)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.yellow)
                )
            }
        default:
            Color.clear
                .frame(width: 20, height: 20)
        }
    }
}

#Preview {
    MainView()
}
