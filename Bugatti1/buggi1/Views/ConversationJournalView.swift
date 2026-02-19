import SwiftUI

struct ConversationJournalView: View {
    @ObservedObject var viewModel: ConversationViewModel
    @State private var showingAddConversation = false
    @State private var selectedConversationId: UUID?
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.hasConversations {
                    conversationsList
                } else {
                    emptyStateView
                }
            }
        }
        .sheet(isPresented: $showingAddConversation) {
            AddConversationView(viewModel: viewModel)
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
                Text("Conversation Journal")
                    .font(AppFonts.title(24))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Button(action: {
                    showingAddConversation = true
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(AppColors.textPrimary)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(AppColors.secondary)
                        )
                }
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
    
    private var conversationsList: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.md) {
                ForEach(Array(viewModel.conversations.enumerated()), id: \.element.id) { index, conversation in
                    ConversationCardView(conversation: conversation) {
                        selectedConversationId = conversation.id
                    }
                    .offset(y: isAnimating ? 0 : 100)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .animation(
                        .easeOut(duration: 0.6)
                        .delay(Double(index) * 0.1),
                        value: isAnimating
                    )
                }
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.xl) {
            Spacer()
            
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.textSecondary)
                .scaleEffect(isAnimating ? 1.0 : 0.5)
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.8).delay(0.2), value: isAnimating)
            
            VStack(spacing: AppSpacing.md) {
                Text("Here will be your conversations and meetings. Add your first entry to record a communication fact.")
                    .font(AppFonts.body(18))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .offset(y: isAnimating ? 0 : 30)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: isAnimating)
                
                Button {
                    showingAddConversation = true
                } label: {
                    HStack(spacing: AppSpacing.sm) {
                        Image(systemName: "plus")
                        Text("Add")
                    }
                    .font(AppFonts.button(18))
                    .foregroundColor(AppColors.textPrimary)
                    .padding(.horizontal, AppSpacing.xl)
                    .padding(.vertical, AppSpacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: AppCornerRadius.md)
                            .fill(AppColors.secondary)
                    )
                }
                .scaleEffect(isAnimating ? 1.0 : 0.8)
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.8).delay(0.6), value: isAnimating)
            }
            .padding(.horizontal, AppSpacing.xl)
            
            Spacer()
        }
    }
}

struct ConversationCardView: View {
    let conversation: Conversation
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                HStack {
                    Text(conversation.personName)
                        .font(AppFonts.headline(18))
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(conversation.formattedDate)
                        .font(AppFonts.caption(12))
                        .foregroundColor(AppColors.textTertiary)
                }
                
                Text(conversation.topic)
                    .font(AppFonts.body(16))
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(conversation.outcome)
                    .font(AppFonts.caption(14))
                    .foregroundColor(AppColors.textTertiary)
                    .lineLimit(1)
            }
            .padding(AppSpacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.md)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppCornerRadius.md)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

#Preview {
    ConversationJournalView(viewModel: ConversationViewModel())
}
