import SwiftUI

enum NavigationTab: String, CaseIterable {
    case subjects = "Subjects"
    case calendar = "Calendar"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .subjects:
            return "book.fill"
        case .calendar:
            return "calendar"
        case .statistics:
            return "chart.bar.fill"
        case .settings:
            return "gear"
        }
    }
}

struct CustomSideBar: View {
    @Binding var selectedTab: NavigationTab
    @Binding var isShowingSidebar: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("SmartDesk")
                            .font(.appTitle)
                            .foregroundColor(.appText)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                isShowingSidebar = false
                            }
                        }) {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .foregroundColor(.appText)
                        }
                    }
                    
                    Rectangle()
                        .fill(AppColors.lightBlue)
                        .frame(height: 1)
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
                .padding(.bottom, 30)
                
                VStack(spacing: 8) {
                    ForEach(NavigationTab.allCases, id: \.self) { tab in
                        SideBarItem(
                            tab: tab,
                            isSelected: selectedTab == tab,
                            action: {
                                selectedTab = tab
                                withAnimation(.spring()) {
                                    isShowingSidebar = false
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 12)
                
                Spacer()
            }
            .frame(width: 280)
            .background(.white)
            .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 10, x: 5, y: 0)
            .onTapGesture {
                withAnimation(.spring()) {
                    isShowingSidebar = false
                }
            }
            
            if isShowingSidebar {
                Color.clear
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring()) {
                            isShowingSidebar = false
                        }
                    }
            }
        }
    }
}

struct SideBarItem: View {
    let tab: NavigationTab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: tab.icon)
                    .font(.title3)
                    .foregroundColor(isSelected ? .white : .appText)
                    .frame(width: 24)
                
                Text(tab.rawValue)
                    .font(.appSubheadline)
                    .foregroundColor(isSelected ? .white : .appText)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColors.primaryBlue : Color.clear)
            )
        }
    }
}
