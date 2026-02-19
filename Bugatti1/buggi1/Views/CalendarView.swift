import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: ConversationViewModel
    @State private var selectedDate = Date()
    @State private var selectedConversationId: UUID?
    @State private var isAnimating = false
    
    private var conversationsForSelectedDate: [Conversation] {
        let calendar = Calendar.current
        return viewModel.conversations.filter { conversation in
            calendar.isDate(conversation.createdAt, inSameDayAs: selectedDate)
        }
    }
    
    private var datesWithConversations: Set<DateComponents> {
        let calendar = Calendar.current
        return Set(viewModel.conversations.map { calendar.dateComponents([.year, .month, .day], from: $0.createdAt) })
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    calendarSection
                    
                    listSection
                }
            }
        }
        .sheet(isPresented: Binding(
            get: { selectedConversationId != nil },
            set: { if !$0 { selectedConversationId = nil } }
        )) {
            if let id = selectedConversationId {
                ConversationDetailView(conversationId: id, viewModel: viewModel)
            } else {
                EmptyView()
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                isAnimating = true
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: AppSpacing.md) {
            HStack {
                Text("Calendar")
                    .font(AppFonts.title(24))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.top, AppSpacing.md)
            
            Divider()
                .background(AppColors.textTertiary)
        }
        .offset(y: isAnimating ? 0 : -50)
        .opacity(isAnimating ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.8), value: isAnimating)
    }
    
    private var calendarSection: some View {
        VStack(spacing: AppSpacing.md) {
            DatePicker(
                "Select date",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .tint(AppColors.secondary)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.md)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppCornerRadius.md)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
            )
            .padding(.horizontal, AppSpacing.lg)
        }
        .padding(.vertical, AppSpacing.md)
        .offset(y: isAnimating ? 0 : 50)
        .opacity(isAnimating ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.8).delay(0.2), value: isAnimating)
    }
    
    private var listSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text(selectedDate.formatted(date: .long, time: .omitted))
                    .font(AppFonts.headline(16))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Text("\(conversationsForSelectedDate.count) conversation\(conversationsForSelectedDate.count == 1 ? "" : "s")")
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(.horizontal, AppSpacing.lg)
            
            if conversationsForSelectedDate.isEmpty {
                VStack(spacing: AppSpacing.lg) {
                    Spacer()
                    
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.system(size: 50, weight: .light))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text("No conversations on this date")
                        .font(AppFonts.body())
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                LazyVStack(spacing: AppSpacing.md) {
                    ForEach(conversationsForSelectedDate) { conversation in
                        ConversationCardView(conversation: conversation) {
                            selectedConversationId = conversation.id
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, AppSpacing.lg)
            }
        }
        .offset(y: isAnimating ? 0 : 50)
        .opacity(isAnimating ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.8).delay(0.4), value: isAnimating)
    }
}

#Preview {
    CalendarView(viewModel: ConversationViewModel())
}
