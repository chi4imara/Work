import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: ConversationViewModel
    @State private var selectedConversationId: UUID?
    @State private var isAnimating = false
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                searchBar
                
                if !viewModel.hasConversations {
                    noDataView
                } else if viewModel.searchText.isEmpty {
                    allConversationsView
                } else if viewModel.hasSearchResults {
                    searchResultsView
                } else {
                    noResultsView
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
                Text("Search")
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
    
    private var searchBar: some View {
        HStack(spacing: AppSpacing.md) {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.textSecondary)
                
                TextField("Search conversations...", text: $viewModel.searchText)
                    .font(AppFonts.body())
                    .foregroundColor(AppColors.textPrimary)
                    .focused($isSearchFocused)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
            .padding(AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.md)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppCornerRadius.md)
                            .stroke(isSearchFocused ? AppColors.secondary : AppColors.cardBorder, lineWidth: 1)
                    )
            )
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
        .offset(y: isAnimating ? 0 : 50)
        .opacity(isAnimating ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.8).delay(0.2), value: isAnimating)
    }
    
    private var allConversationsView: some View {
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
                        .delay(0.4 + Double(index) * 0.1),
                        value: isAnimating
                    )
                }
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
        }
    }
    
    private var searchResultsView: some View {
        VStack(spacing: AppSpacing.md) {
            HStack {
                Text("\(viewModel.filteredConversations.count) result\(viewModel.filteredConversations.count == 1 ? "" : "s") found")
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.textSecondary)
                
                Spacer()
            }
            .padding(.horizontal, AppSpacing.lg)
            
            ScrollView {
                LazyVStack(spacing: AppSpacing.md) {
                    ForEach(viewModel.filteredConversations) { conversation in
                        SearchResultCardView(
                            conversation: conversation,
                            searchText: viewModel.searchText
                        ) {
                            selectedConversationId = conversation.id
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, AppSpacing.md)
            }
        }
    }
    
    private var noResultsView: some View {
        VStack(spacing: AppSpacing.xl) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.textSecondary)
            
            VStack(spacing: AppSpacing.md) {
                Text("Nothing found")
                    .font(AppFonts.headline(20))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Try different keywords or check your spelling")
                    .font(AppFonts.body())
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.xl)
    }
    
    private var noDataView: some View {
        VStack(spacing: AppSpacing.xl) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.textSecondary)
            
            VStack(spacing: AppSpacing.md) {
                Text("No data to search yet")
                    .font(AppFonts.headline(20))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Add some conversations first to be able to search through them")
                    .font(AppFonts.body())
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.xl)
        .offset(y: isAnimating ? 0 : 50)
        .opacity(isAnimating ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.8).delay(0.4), value: isAnimating)
    }
}

struct SearchResultCardView: View {
    let conversation: Conversation
    let searchText: String
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                HStack {
                    highlightedText(conversation.personName, searchText: searchText)
                        .font(AppFonts.headline(18))
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(conversation.formattedDate)
                        .font(AppFonts.caption(12))
                        .foregroundColor(AppColors.textTertiary)
                }
                
                highlightedText(conversation.topic, searchText: searchText)
                    .font(AppFonts.body(16))
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                highlightedText(conversation.outcome, searchText: searchText)
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
                            .stroke(AppColors.secondary.opacity(0.3), lineWidth: 1)
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
    
    @ViewBuilder
    private func highlightedText(_ text: String, searchText: String) -> some View {
        if searchText.isEmpty {
            Text(text)
        } else {
            let parts = text.components(separatedBy: searchText)
            if parts.count > 1 {
                HStack(spacing: 0) {
                    ForEach(0..<parts.count, id: \.self) { index in
                        Text(parts[index])
                        if index < parts.count - 1 {
                            Text(searchText)
                                .background(AppColors.secondary.opacity(0.3))
                        }
                    }
                }
            } else {
                Text(text)
            }
        }
    }
}

#Preview {
    SearchView(viewModel: ConversationViewModel())
}
