import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(
                icon: "book.closed",
                title: "Diary",
                isSelected: selectedTab == 0,
                action: { selectedTab = 0 }
            )
            
            TabBarButton(
                icon: "note.text",
                title: "Notes",
                isSelected: selectedTab == 1,
                action: { selectedTab = 1 }
            )
            
            TabBarButton(
                icon: "heart",
                title: "Favorites",
                isSelected: selectedTab == 2,
                action: { selectedTab = 2 }
            )
            
            TabBarButton(
                icon: "calendar",
                title: "Calendar",
                isSelected: selectedTab == 3,
                action: { selectedTab = 3 }
            )
            
            TabBarButton(
                icon: "gearshape",
                title: "Settings",
                isSelected: selectedTab == 4,
                action: { selectedTab = 4 }
            )
        }
        .padding(.horizontal, 4)
        .padding(.top, 8)
        .padding(.bottom, 8)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [Color.white, Color.white.opacity(0.95)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -2)
        )
        .padding(.horizontal, 20)
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                action()
            }
        }) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(Color.theme.primaryBlue.opacity(0.15))
                            .frame(width: 40, height: 40)
                    }
                    
                    Image(systemName: icon)
                        .font(.system(size: isSelected ? 22 : 20, weight: isSelected ? .semibold : .regular))
                        .foregroundColor(isSelected ? Color.theme.primaryBlue : Color.gray)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                .frame(height: 40)
                
                Text(title)
                    .font(.playfairDisplay(10, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? Color.theme.primaryBlue : Color.gray)
                    .opacity(isSelected ? 1.0 : 0.7)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(0))
        .padding()
}
