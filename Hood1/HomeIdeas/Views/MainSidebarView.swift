import SwiftUI

struct MainSidebarView: View {
    @ObservedObject var appViewModel: AppViewModel
    @StateObject private var ideasViewModel = IdeasViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                contentView
            }
            
            if appViewModel.showingSidebar {
                sidebarView
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                    .zIndex(1)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0), value: appViewModel.showingSidebar)
        .sheet(isPresented: $appViewModel.showingAddIdea) {
            AddEditIdeaView(viewModel: ideasViewModel)
        }
        .sheet(isPresented: $appViewModel.showingAddCategory) {
            AddCategoryView(viewModel: ideasViewModel)
        }
        .sheet(isPresented: $appViewModel.showingRandomIdea) {
            RandomIdeaView(viewModel: ideasViewModel)
        }
        .sheet(isPresented: $appViewModel.showingHistoryFilter) {
            HistoryFilterView(viewModel: ideasViewModel)
        }
    }
    
    private var headerView: some View {
        return HStack(spacing: 16) {
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                    appViewModel.toggleSidebar()
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                        .frame(width: 44, height: 44)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.cardBorder, lineWidth: 1)
                        )
                    
                    Image(systemName: "line.3.horizontal")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.primaryOrange)
                        .rotationEffect(.degrees(appViewModel.showingSidebar ? 90 : 0))
                        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: appViewModel.showingSidebar)
                }
            }
            .buttonStyle(ScaleButtonStyle())
            
            Text(headerTitle)
                .font(.theme.title2)
                .foregroundColor(AppColors.textPrimary)
                .fontWeight(.bold)
            
            Spacer()
            
            rightHeaderActions
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 15)
    }
    
    private var headerTitle: String {
        switch appViewModel.selectedTab {
        case 0:
            return "Home Ideas"
        case 1:
            return "Categories"
        case 2:
            return "History"
        case 3:
            return "Settings"
        default:
            return "Home Ideas"
        }
    }
    
    @ViewBuilder
    private var rightHeaderActions: some View {
        switch appViewModel.selectedTab {
        case 0:
            HStack(spacing: 12) {
                Button(action: {
                    appViewModel.showingRandomIdea = true
                }) {
                    ZStack {
                        Circle()
                            .fill(AppColors.primaryOrange.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "dice")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColors.primaryOrange)
                    }
                }
                .buttonStyle(ScaleButtonStyle())
                
                Button(action: {
                    appViewModel.showingAddIdea = true
                }) {
                    ZStack {
                        Circle()
                            .fill(AppColors.primaryOrange)
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                    }
                }
                .buttonStyle(ScaleButtonStyle())
            }
        case 1:
            Button(action: {
                appViewModel.showingAddCategory = true
            }) {
                ZStack {
                    Circle()
                        .fill(AppColors.primaryOrange)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                }
            }
            .buttonStyle(ScaleButtonStyle())
        case 2:
            Button(action: {
                appViewModel.showingHistoryFilter = true
            }) {
                ZStack {
                    Circle()
                        .fill(AppColors.primaryOrange.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "calendar")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryOrange)
                }
            }
            .buttonStyle(ScaleButtonStyle())
        default:
            Color.clear
                .frame(width: 40, height: 40)
        }
    }
    
    private var contentView: some View {
        return Group {
            switch appViewModel.selectedTab {
            case 0:
                IdeasListView()
                    .environmentObject(ideasViewModel)
            case 1:
                CategoriesView()
                    .environmentObject(ideasViewModel)
            case 2:
                HistoryView()
                    .environmentObject(ideasViewModel)
            case 3:
                SettingsView()
            default:
                IdeasListView()
                    .environmentObject(ideasViewModel)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var sidebarView: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Button(action: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            appViewModel.toggleSidebar()
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(AppColors.cardBackground)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(AppColors.cardBorder, lineWidth: 1)
                                )
                            
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .padding(.trailing, 8)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        AppColors.primaryOrange,
                                        AppColors.primaryOrange.opacity(0.8)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 64, height: 64)
                            .shadow(color: AppColors.primaryOrange.opacity(0.4), radius: 12, x: 0, y: 6)
                        
                        Image(systemName: "house.fill")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(AppColors.textPrimary)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Home Ideas")
                            .font(.theme.title2)
                            .foregroundColor(AppColors.textPrimary)
                            .fontWeight(.bold)
                        
                        Text("Your leisure assistant")
                            .font(.theme.caption1)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Spacer()
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 24)
            .padding(.top, 50)
            .padding(.bottom, 20)
            .padding(.leading, 16)
            
            VStack(spacing: 6) {
                VStack(spacing: 4) {
                    SidebarMenuItemView(
                        title: "Ideas",
                        icon: "house.fill",
                        isSelected: appViewModel.selectedTab == 0,
                        action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                appViewModel.selectedTab = 0
                                appViewModel.toggleSidebar()
                            }
                        }
                    )
                    
                    SidebarMenuItemView(
                        title: "Categories",
                        icon: "folder.fill",
                        isSelected: appViewModel.selectedTab == 1,
                        action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                appViewModel.selectedTab = 1
                                appViewModel.toggleSidebar()
                            }
                        }
                    )
                    
                    SidebarMenuItemView(
                        title: "History",
                        icon: "clock.fill",
                        isSelected: appViewModel.selectedTab == 2,
                        action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                appViewModel.selectedTab = 2
                                appViewModel.toggleSidebar()
                            }
                        }
                    )
                    
                    SidebarMenuItemView(
                        title: "Settings",
                        icon: "gearshape.fill",
                        isSelected: appViewModel.selectedTab == 3,
                        action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                appViewModel.selectedTab = 3
                                appViewModel.toggleSidebar()
                            }
                        }
                    )
                }
                .padding(.horizontal, 16)
            }
            
            Spacer()
            Spacer()
                
            VStack(spacing: 12) {
                Divider()
                    .background(AppColors.cardBorder)
                    .padding(.horizontal, 24)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 50)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(
            ZStack {
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                AppColors.backgroundGradientStart.opacity(0.95),
                                AppColors.backgroundGradientEnd.opacity(0.9)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .ignoresSafeArea()
                
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .blendMode(.overlay)
                    .ignoresSafeArea()
            }
        )
        .ignoresSafeArea(.all)
        .onTapGesture {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                appViewModel.toggleSidebar()
            }
        }
    }
    
}

struct SidebarMenuItemView: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            isSelected ? 
                            AppColors.primaryOrange.opacity(0.2) : 
                            AppColors.cardBackground.opacity(0.6)
                        )
                        .frame(width: 44, height: 44)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    isSelected ? 
                                    AppColors.primaryOrange.opacity(0.4) : 
                                    AppColors.cardBorder.opacity(0.4),
                                    lineWidth: 1.5
                                )
                        )
                        .shadow(
                            color: isSelected ? AppColors.primaryOrange.opacity(0.2) : Color.clear,
                            radius: isSelected ? 4 : 0,
                            x: 0,
                            y: 2
                        )
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? AppColors.primaryOrange : AppColors.textSecondary)
                }
                
                Text(title)
                    .font(.theme.body)
                    .foregroundColor(isSelected ? AppColors.textPrimary : AppColors.textSecondary)
                    .fontWeight(isSelected ? .semibold : .medium)
                
                Spacer()
                
                if isSelected {
                    ZStack {
                        Circle()
                            .fill(AppColors.primaryOrange)
                            .frame(width: 22, height: 22)
                            .shadow(color: AppColors.primaryOrange.opacity(0.3), radius: 3, x: 0, y: 1)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        isSelected ? 
                        AppColors.primaryOrange.opacity(0.12) : 
                        (isPressed ? AppColors.cardBackground.opacity(0.4) : Color.clear)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(
                                isSelected ? 
                                AppColors.primaryOrange.opacity(0.25) : 
                                Color.clear,
                                lineWidth: 1
                            )
                    )
                    .shadow(
                        color: isSelected ? AppColors.primaryOrange.opacity(0.1) : Color.clear,
                        radius: isSelected ? 6 : 0,
                        x: 0,
                        y: 3
                    )
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: isPressed)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    MainSidebarView(appViewModel: AppViewModel())
}
