import SwiftUI

enum SideBarItem: String, CaseIterable {
    case calendar = "Calendar"
    case tasks = "All Tasks"
    case progress = "Progress"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .calendar:
            return "calendar"
        case .tasks:
            return "list.bullet"
        case .progress:
            return "chart.pie"
        case .settings:
            return "gear"
        }
    }
}

struct CustomSideBar: View {
    @Binding var selectedItem: SideBarItem
    @Binding var isShowingSidebar: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Home Projects")
                            .font(AppFonts.title2)
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isShowingSidebar = false
                            }
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppColors.secondaryText)
                        }
                    }
                    
                    Divider()
                        .background(AppColors.lightBlue)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                VStack(spacing: 8) {
                    ForEach(SideBarItem.allCases, id: \.self) { item in
                        SideBarMenuButton(
                            item: item,
                            isSelected: selectedItem == item
                        ) {
                            selectedItem = item
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isShowingSidebar = false
                            }
                        }
                    }
                }
                .padding(.horizontal, 12)
                
                Spacer()
                
                VStack(spacing: 12) {
                    Divider()
                        .background(AppColors.lightBlue)
                    
                    Text("Plan with Clarity")
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.secondaryText)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
            }
            .frame(width: 280)
            .background(
                LinearGradient(
                    colors: [
                        AppColors.sidebarBackground,
                        Color.white.opacity(0.95)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                Rectangle()
                    .fill(AppColors.lightBlue.opacity(0.3))
                    .frame(width: 1),
                alignment: .trailing
            )
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isShowingSidebar = false
                }
            }
            
            if isShowingSidebar {
                Color.clear
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isShowingSidebar = false
                        }
                    }
            }
        }
    }
}

struct SideBarMenuButton: View {
    let item: SideBarItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: item.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.secondaryText)
                    .frame(width: 24)
                
                Text(item.rawValue)
                    .font(AppFonts.bodyMedium)
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.primaryText)
                
                Spacer()
                
                if isSelected {
                    Circle()
                        .fill(AppColors.primaryBlue)
                        .frame(width: 6, height: 6)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColors.lightBlue.opacity(0.3) : Color.clear)
            )
        }
    }
}

#Preview {
    CustomSideBar(
        selectedItem: .constant(.calendar),
        isShowingSidebar: .constant(true)
    )
}
