import SwiftUI

struct MainContainerView: View {
    @StateObject private var subjectStore = SubjectStore()
    @State private var selectedTab: NavigationTab = .subjects
    @State private var isShowingSidebar = false
    @State private var selectedSubject: Subject?
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .subjects:
                    SubjectsView(subjectStore: subjectStore, isShowingSidebar: $isShowingSidebar)
                case .calendar:
                    CalendarView(subjectStore: subjectStore)
                case .statistics:
                    StatisticsView(subjectStore: subjectStore)
                case .settings:
                    SettingsView()
                }
            }
            .overlay(
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation(.spring()) {
                                isShowingSidebar = true
                            }
                        }) {
                            Image(systemName: "line.3.horizontal")
                                .font(.title2)
                                .foregroundColor(.appText)
                                .padding(12)
                                .background(
                                    Circle()
                                        .fill(AppColors.cardBackground.opacity(0.9))
                                        .shadow(color: AppColors.primaryBlue.opacity(0.2), radius: 4, x: 0, y: 2)
                                )
                        }
                        .padding(.leading, 20)
                        .padding(.top, 16)
                        
                        Spacer()
                    }
                    
                    Spacer()
                },
                alignment: .topLeading
            )
            
            if isShowingSidebar {
                CustomSideBar(
                    selectedTab: $selectedTab,
                    isShowingSidebar: $isShowingSidebar
                )
                .transition(.move(edge: .leading))
                .zIndex(1)
            }
        }
        .sheet(item: $selectedSubject) { subject in
            SubjectDetailView(subjectStore: subjectStore, subject: subject)
        }
        .onReceive(NotificationCenter.default.publisher(for: .subjectSelected)) { notification in
            if let subject = notification.object as? Subject {
                selectedSubject = subject
            }
        }
    }
}

extension Notification.Name {
    static let subjectSelected = Notification.Name("subjectSelected")
}

#Preview {
    MainContainerView()
}
