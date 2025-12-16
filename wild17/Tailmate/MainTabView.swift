import SwiftUI

struct MainTabView: View {
    @ObservedObject var dataManager = DataManager.shared
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MainView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)
            
            AnalyticsView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "chart.bar.fill" : "chart.bar")
                    Text("Analytics")
                }
                .tag(1)
            
            AddEventCenterView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Add")
                }
                .tag(2)
            
            PetProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "pawprint.fill" : "pawprint")
                    Text("Pet")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "gearshape.fill" : "gearshape")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(.purple)
    }
}

struct AddEventCenterView: View {
    @State private var showingAddEvent = false
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                VStack(spacing: 20) {
                    Text("Quick Add Event")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(.white)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 20) {
                        ForEach(EventType.allCases, id: \.self) { eventType in
                            QuickAddButton(eventType: eventType) {
                                showingAddEvent = true
                            }
                        }
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                Button {
                    showingAddEvent = true
                } label: {
                    Text("Custom Event")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.theme.primaryPurple, Color.theme.secondaryPurple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                        .shadow(color: Color.theme.primaryPurple.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                
                Spacer()
            }
            .padding(.top, 50)
        }
        .sheet(isPresented: $showingAddEvent) {
            AddEventView()
        }
    }
}

struct QuickAddButton: View {
    let eventType: EventType
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            let newEvent = PetEvent(
                type: eventType,
                date: Date(),
                time: Date(),
                comment: ""
            )
            DataManager.shared.addEvent(newEvent)
            
            withAnimation(.easeInOut(duration: 0.2)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isPressed = false
                }
            }
        }) {
            VStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(eventColor.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: eventType.iconName)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(eventColor)
                }
                
                Text(eventType.displayName)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(.white)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.15),
                        Color.white.opacity(0.05)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(eventColor.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.9 : 1.0)
            .shadow(color: eventColor.opacity(0.2), radius: isPressed ? 2 : 8, x: 0, y: isPressed ? 1 : 4)
        }
    }
    
    private var eventColor: Color {
        switch eventType {
        case .feeding:
            return Color.theme.accentOrange
        case .walk:
            return Color.theme.accentGreen
        case .vitamins:
            return Color.theme.accentYellow
        case .veterinarian:
            return Color.theme.accentRed
        }
    }
}

#Preview {
    MainTabView()
}
