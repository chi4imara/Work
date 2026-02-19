import SwiftUI

struct ConversationDetailView: View {
    let conversationId: UUID
    @ObservedObject var viewModel: ConversationViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var isAnimating = false
    
    private var conversation: Conversation? {
        viewModel.getConversation(by: conversationId)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if let conversation = conversation {
                        detailContent(conversation: conversation)
                    } else {
                        notFoundView
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingEditView) {
            if viewModel.getConversation(by: conversationId) != nil {
                EditConversationView(conversationId: conversationId, viewModel: viewModel)
            } else {
                EmptyView()
            }
        }
        .alert("Delete Conversation", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteConversation(by: conversationId)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this conversation? This action cannot be undone.")
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                isAnimating = true
            }
        }
    }
    
    private func detailContent(conversation: Conversation) -> some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: AppSpacing.xl) {
                    infoCard(
                        title: "Who did you talk to",
                        content: conversation.personName,
                        icon: "person.fill",
                        animationDelay: 0.2
                    )
                    infoCard(
                        title: "Conversation topic",
                        content: conversation.topic,
                        icon: "bubble.left.and.bubble.right.fill",
                        animationDelay: 0.4
                    )
                    infoCard(
                        title: "Outcome",
                        content: conversation.outcome,
                        icon: "checkmark.circle.fill",
                        animationDelay: 0.6
                    )
                    infoCard(
                        title: "Date",
                        content: conversation.formattedDate,
                        icon: "calendar",
                        animationDelay: 0.8
                    )
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.lg)
            }
            actionButtons
        }
    }
    
    private var notFoundView: some View {
        VStack(spacing: AppSpacing.xl) {
            Spacer()
            Image(systemName: "questionmark.circle")
                .font(.system(size: 50, weight: .light))
                .foregroundColor(AppColors.textSecondary)
            Text("Conversation not found")
                .font(AppFonts.headline(18))
                .foregroundColor(AppColors.textPrimary)
            Button("Back") {
                dismiss()
            }
            .font(AppFonts.button())
            .foregroundColor(AppColors.secondary)
            .padding(.top, AppSpacing.md)
            Spacer()
        }
    }
    
    private var headerView: some View {
        VStack(spacing: AppSpacing.md) {
            HStack {
                Button("Back") {
                    dismiss()
                }
                .font(AppFonts.button())
                .foregroundColor(AppColors.textSecondary)
                
                Spacer()
                
                Text("Conversation")
                    .font(AppFonts.title(20))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                if conversation != nil {
                    Menu {
                        Button("Edit") {
                            showingEditView = true
                        }
                        
                        Button("Delete", role: .destructive) {
                            showingDeleteAlert = true
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.title2)
                            .foregroundColor(AppColors.textPrimary)
                            .frame(width: 44, height: 44)
                    }
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
    
    private func infoCard(title: String, content: String, icon: String, animationDelay: Double) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(AppColors.secondary)
                
                Text(title)
                    .font(AppFonts.headline(16))
                    .foregroundColor(AppColors.textPrimary)
            }
            
            Text(content)
                .font(AppFonts.body(16))
                .foregroundColor(AppColors.textSecondary)
                .lineSpacing(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.md)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppCornerRadius.md)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
        .offset(y: isAnimating ? 0 : 50)
        .opacity(isAnimating ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.6).delay(animationDelay), value: isAnimating)
    }
    
    private var actionButtons: some View {
        Group {
            if conversation != nil {
                VStack(spacing: AppSpacing.md) {
                    Divider()
                        .background(AppColors.textTertiary)
                    
                    HStack(spacing: AppSpacing.md) {
                        Button {
                            showingEditView = true
                        } label: {
                            HStack(spacing: AppSpacing.sm) {
                                Image(systemName: "pencil")
                                Text("Edit")
                            }
                            .font(AppFonts.button())
                            .foregroundColor(AppColors.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppSpacing.md)
                            .background(
                                RoundedRectangle(cornerRadius: AppCornerRadius.md)
                                    .fill(AppColors.primary)
                            )
                        }
                        
                        Button {
                            showingDeleteAlert = true
                        } label: {
                            HStack(spacing: AppSpacing.sm) {
                                Image(systemName: "trash")
                                Text("Delete")
                            }
                            .font(AppFonts.button())
                            .foregroundColor(AppColors.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppSpacing.md)
                            .background(
                                RoundedRectangle(cornerRadius: AppCornerRadius.md)
                                    .fill(AppColors.danger)
                            )
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.lg)
                }
                .offset(y: isAnimating ? 0 : 100)
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.8).delay(1.0), value: isAnimating)
            }
        }
    }
}

struct EditConversationView: View {
    let conversationId: UUID
    @ObservedObject var viewModel: ConversationViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var personName: String
    @State private var topic: String
    @State private var outcome: String
    @State private var isAnimating = false
    @FocusState private var focusedField: AddConversationView.Field?
    
    private var conversation: Conversation? {
        viewModel.getConversation(by: conversationId)
    }
    
    init(conversationId: UUID, viewModel: ConversationViewModel) {
        self.conversationId = conversationId
        self.viewModel = viewModel
        let conv = viewModel.getConversation(by: conversationId)
        self._personName = State(initialValue: conv?.personName ?? "")
        self._topic = State(initialValue: conv?.topic ?? "")
        self._outcome = State(initialValue: conv?.outcome ?? "")
    }
    
    private var isFormValid: Bool {
        !personName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !topic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !outcome.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var hasChanges: Bool {
        guard let conversation = conversation else { return false }
        return personName != conversation.personName ||
            topic != conversation.topic ||
            outcome != conversation.outcome
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 0) {
                    headerView
                    
                    ScrollView {
                        VStack(spacing: AppSpacing.lg) {
                            CustomTextField(
                                title: "Who did you talk to",
                                text: $personName,
                                placeholder: "Enter person name or identifier",
                                isAnimating: isAnimating,
                                animationDelay: 0.2
                            )
                            .focused($focusedField, equals: .personName)
                            .onSubmit {
                                focusedField = .topic
                            }
                            
                            CustomTextField(
                                title: "Conversation topic",
                                text: $topic,
                                placeholder: "What was the conversation about?",
                                isAnimating: isAnimating,
                                animationDelay: 0.4
                            )
                            .focused($focusedField, equals: .topic)
                            .onSubmit {
                                focusedField = .outcome
                            }
                            
                            CustomTextField(
                                title: "Outcome",
                                text: $outcome,
                                placeholder: "One line summary of the result",
                                isAnimating: isAnimating,
                                animationDelay: 0.6
                            )
                            .focused($focusedField, equals: .outcome)
                            .onSubmit {
                                if isFormValid && hasChanges {
                                    saveChanges()
                                }
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.vertical, AppSpacing.lg)
                    }
                    
                    actionButtons
                }
            }
            .navigationBarHidden(true)
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
                Button("Cancel") {
                    dismiss()
                }
                .font(AppFonts.button())
                .foregroundColor(AppColors.textSecondary)
                
                Spacer()
                
                Text("Edit")
                    .font(AppFonts.title(20))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Button("Save") {
                    saveChanges()
                }
                .font(AppFonts.button())
                .foregroundColor((isFormValid && hasChanges) ? AppColors.secondary : AppColors.textTertiary)
                .disabled(!isFormValid || !hasChanges)
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
    
    private var actionButtons: some View {
        VStack(spacing: AppSpacing.md) {
            Divider()
                .background(AppColors.textTertiary)
            
            HStack(spacing: AppSpacing.md) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .font(AppFonts.button())
                        .foregroundColor(AppColors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppSpacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: AppCornerRadius.md)
                                .stroke(AppColors.textTertiary, lineWidth: 1)
                        )
                }
                
                Button {
                    saveChanges()
                } label: {
                    Text("Save Changes")
                        .font(AppFonts.button())
                        .foregroundColor(AppColors.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppSpacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: AppCornerRadius.md)
                                .fill((isFormValid && hasChanges) ? AppColors.secondary : AppColors.textTertiary)
                        )
                }
                .disabled(!isFormValid || !hasChanges)
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.bottom, AppSpacing.lg)
        }
        .offset(y: isAnimating ? 0 : 100)
        .opacity(isAnimating ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.8).delay(0.8), value: isAnimating)
    }
    
    private func saveChanges() {
        guard let conversation = conversation else {
            dismiss()
            return
        }
        let trimmedPersonName = personName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedTopic = topic.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedOutcome = outcome.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateConversation(
            conversation,
            personName: trimmedPersonName,
            topic: trimmedTopic,
            outcome: trimmedOutcome
        )
        
        dismiss()
    }
}

#Preview {
    ConversationDetailView(
        conversationId: Conversation.sampleData[0].id,
        viewModel: ConversationViewModel()
    )
}
