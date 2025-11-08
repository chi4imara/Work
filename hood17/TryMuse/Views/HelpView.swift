import SwiftUI

struct HelpView: View {
    @State private var expandedSections: Set<FAQSection> = []
    
    private let faqSections: [FAQSection] = [
        FAQSection(
            title: "Getting Started",
            icon: "play.circle.fill",
            questions: [
                FAQQuestion(
                    question: "How do I create my first list?",
                    answer: "Tap the '+' button in the top-right corner of the Lists screen, enter a name for your list, select a category, and tap 'Save List'."
                ),
                FAQQuestion(
                    question: "What categories are available?",
                    answer: "You can choose from Movies, Books, Food, Ideas, or Other. Categories help you organize your lists by type."
                ),
                FAQQuestion(
                    question: "How do I add items to a list?",
                    answer: "Open any list by tapping on it, then tap the 'Add Item' button at the bottom. Enter the item name and optional notes, then tap 'Save Item'."
                )
            ]
        ),
        FAQSection(
            title: "Managing Lists",
            icon: "list.bullet",
            questions: [
                FAQQuestion(
                    question: "How do I edit a list?",
                    answer: "Swipe right on any list card or tap the 'Edit' button when viewing list details. You can change the name and category."
                ),
                FAQQuestion(
                    question: "How do I delete a list?",
                    answer: "Swipe left on any list card and tap 'Delete', or use the context menu. All items in the list will be permanently removed."
                ),
                FAQQuestion(
                    question: "Can I reorder my lists?",
                    answer: "Currently, lists are displayed in the order they were created. We're working on drag-and-drop reordering for future updates."
                )
            ]
        ),
        FAQSection(
            title: "Managing Items",
            icon: "checkmark.circle",
            questions: [
                FAQQuestion(
                    question: "How do I mark an item as completed?",
                    answer: "Simply tap the circle next to any item in your list. Completed items will move to the bottom and appear in your History."
                ),
                FAQQuestion(
                    question: "How do I edit an item?",
                    answer: "Swipe right on any item or use the context menu to edit. You can change the name and notes."
                ),
                FAQQuestion(
                    question: "How do I delete an item?",
                    answer: "Swipe left on any item and tap 'Delete', or use the context menu. The item will be permanently removed."
                )
            ]
        ),
        FAQSection(
            title: "History & Statistics",
            icon: "chart.bar.fill",
            questions: [
                FAQQuestion(
                    question: "What is the History tab?",
                    answer: "The History tab shows all your completed items from all lists, sorted by completion date. It's a great way to see your progress."
                ),
                FAQQuestion(
                    question: "What statistics are available?",
                    answer: "View your total lists, items, completion rate, category distribution, recent activity, and productivity insights in the Statistics tab."
                ),
                FAQQuestion(
                    question: "How is completion rate calculated?",
                    answer: "Completion rate is the percentage of completed items out of total items across all your lists."
                )
            ]
        ),
        FAQSection(
            title: "Data & Privacy",
            icon: "lock.shield.fill",
            questions: [
                FAQQuestion(
                    question: "Where is my data stored?",
                    answer: "All your data is stored locally on your device. We don't collect or store any of your personal information on our servers."
                ),
                FAQQuestion(
                    question: "Can I backup my data?",
                    answer: "Currently, data is stored locally only. We're working on iCloud sync and export features for future updates."
                ),
                FAQQuestion(
                    question: "What happens if I delete the app?",
                    answer: "All your data will be permanently lost. Make sure to complete your important lists before deleting the app."
                )
            ]
        ),
        FAQSection(
            title: "Troubleshooting",
            icon: "wrench.and.screwdriver.fill",
            questions: [
                FAQQuestion(
                    question: "The app is running slowly",
                    answer: "Try closing and reopening the app. If the problem persists, restart your device or check for iOS updates."
                ),
                FAQQuestion(
                    question: "I can't see my custom fonts",
                    answer: "Make sure you're running iOS 16.0 or later. The app uses custom Nunito fonts that require modern iOS versions."
                ),
                FAQQuestion(
                    question: "The app crashes when I open it",
                    answer: "Try force-closing the app and reopening it. If crashes continue, restart your device or reinstall the app."
                )
            ]
        )
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Help & FAQ")
                            .font(.appLargeTitle)
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            WelcomeCard()
                                .padding(.horizontal, 20)
                            
                            ForEach(faqSections, id: \.title) { section in
                                FAQSectionView(
                                    section: section,
                                    isExpanded: expandedSections.contains(section)
                                ) {
                                    toggleSection(section)
                                }
                                .padding(.horizontal, 20)
                            }
                            
                            ContactCard()
                                .padding(.horizontal, 20)
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.top, 20)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func toggleSection(_ section: FAQSection) {
        if expandedSections.contains(section) {
            expandedSections.remove(section)
        } else {
            expandedSections.insert(section)
        }
    }
}

struct FAQSection: Hashable {
    let title: String
    let icon: String
    let questions: [FAQQuestion]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    static func == (lhs: FAQSection, rhs: FAQSection) -> Bool {
        return lhs.title == rhs.title
    }
}

struct FAQQuestion {
    let question: String
    let answer: String
}

struct WelcomeCard: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "questionmark.circle.fill")
                .font(.system(size: 50, weight: .light))
                .foregroundColor(AppColors.yellow)
            
            VStack(spacing: 8) {
                Text("Welcome to TryMuse!")
                    .font(.appTitle2)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Your personal notebook for all your ideas. Here's everything you need to know to get the most out of the app.")
                    .font(.appBody)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(24)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

struct FAQSectionView: View {
    let section: FAQSection
    let isExpanded: Bool
    let onToggle: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: onToggle) {
                HStack(spacing: 16) {
                    Image(systemName: section.icon)
                        .font(.title2)
                        .foregroundColor(AppColors.yellow)
                        .frame(width: 24, height: 24)
                    
                    Text(section.title)
                        .font(.appHeadline)
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                        .animation(.easeInOut(duration: 0.2), value: isExpanded)
                }
                .padding(20)
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(Array(section.questions.enumerated()), id: \.offset) { index, question in
                        FAQQuestionView(question: question)
                        
                        if index < section.questions.count - 1 {
                            Divider()
                                .background(Color.white.opacity(0.1))
                        }
                    }
                }
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.3), value: isExpanded)
    }
}

struct FAQQuestionView: View {
    let question: FAQQuestion
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(question.question)
                .font(.appBody)
                .foregroundColor(AppColors.primaryText)
                .fontWeight(.medium)
            
            Text(question.answer)
                .font(.appBody)
                .foregroundColor(AppColors.secondaryText)
                .lineSpacing(2)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ContactCard: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "envelope.fill")
                .font(.title2)
                .foregroundColor(AppColors.yellow)
            
            VStack(spacing: 8) {
                Text("Still need help?")
                    .font(.appHeadline)
                    .foregroundColor(AppColors.primaryText)
                
                Text("If you can't find the answer you're looking for, feel free to contact us through the Settings screen.")
                    .font(.appBody)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                if let url = URL(string: "https://google.com") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("Contact Support")
                    .font(.appButton)
                    .foregroundColor(AppColors.accentText)
                    .frame(height: 44)
                    .frame(minWidth: 160)
                    .background(AppColors.yellow)
                    .cornerRadius(22)
                    .shadow(color: AppColors.yellow.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .padding(24)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    HelpView()
}
