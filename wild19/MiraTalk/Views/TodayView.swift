import SwiftUI

enum TodaySheetItem: Identifiable {
    case categories
    case history
    case questionDetail(Question)
    
    var id: String {
        switch self {
        case .categories:
            return "categories"
        case .history:
            return "history"
        case .questionDetail(let question):
            return question.id.uuidString
        }
    }
}

struct TodayView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var showingMenu = false
    @State private var questionAnimation = false
    @State private var sheetItem: TodaySheetItem?
    
    @Binding var selectedTab: TabItem
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if viewModel.selectedCategories.isEmpty || viewModel.currentQuestion == nil {
                        emptyStateView
                    } else {
                        questionContentView
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(item: $sheetItem) { item in
            switch item {
            case .categories:
                CategoriesView(viewModel: viewModel)
            case .history:
                HistoryView(viewModel: viewModel)
            case .questionDetail(let question):
                QuestionDetailView(question: question, viewModel: viewModel)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Question of the Day")
                .font(.playfairDisplay(size: 28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: {
                showingMenu.toggle()
            }) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.primaryBlue)
                    .frame(width: 40, height: 40)
                    .background(AppColors.primaryWhite.opacity(0.8))
                    .clipShape(Circle())
                    .shadow(color: AppColors.primaryBlue.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            .confirmationDialog("Menu", isPresented: $showingMenu, titleVisibility: .hidden) {
                Button("Categories") {
                    sheetItem = .categories
                }
                Button("Question History") {
                    withAnimation {
                        selectedTab = .history
                    }
                }
                Button("Cancel", role: .cancel) { }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var questionContentView: some View {
        VStack(spacing: 40) {
            if let question = viewModel.currentQuestion {
                VStack(spacing: 20) {
                    HStack {
                        Image(systemName: question.category.icon)
                            .font(.system(size: 14, weight: .medium))
                        Text(question.category.displayName)
                            .font(.playfairDisplay(size: 14, weight: .medium))
                    }
                    .foregroundColor(AppColors.primaryBlue)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(AppColors.primaryBlue.opacity(0.1))
                    .cornerRadius(20)
                    
                    Button(action: {
                        if let question = viewModel.currentQuestion {
                            sheetItem = .questionDetail(question)
                        }
                    }) {
                        Text(question.text)
                            .font(.playfairDisplay(size: 24, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .padding(.horizontal, 20)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.vertical, 40)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppColors.cardGradient)
                        .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal, 20)
                .scaleEffect(questionAnimation ? 1.0 : 0.9)
                .opacity(questionAnimation ? 1.0 : 0.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: questionAnimation)
                .onAppear {
                    questionAnimation = true
                }
                .onChange(of: question.id) { _ in
                    questionAnimation = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        questionAnimation = true
                    }
                }
            }
            
            actionButtonsView
        }
        .padding(.top, 40)
    }
    
    private var actionButtonsView: some View {
        VStack(spacing: 16) {
            Button(action: {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    viewModel.generateRandomQuestion()
                }
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 18, weight: .semibold))
                    Text("New Question")
                        .font(.playfairDisplay(size: 18, weight: .semibold))
                }
                .foregroundColor(AppColors.primaryWhite)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        colors: [AppColors.primaryBlue, AppColors.blueGradientEnd],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(28)
                .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            
            if let question = viewModel.currentQuestion {
                Button(action: {
                    viewModel.addToFavorites(question: question)
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: viewModel.isFavorite(question: question) ? "heart.fill" : "heart")
                            .font(.system(size: 18, weight: .semibold))
                        Text(viewModel.isFavorite(question: question) ? "Added to Favorites" : "Add to Favorites")
                            .font(.playfairDisplay(size: 18, weight: .semibold))
                    }
                    .foregroundColor(viewModel.isFavorite(question: question) ? AppColors.primaryWhite : AppColors.primaryBlue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        viewModel.isFavorite(question: question) ?
                        LinearGradient(
                            colors: [AppColors.accentPink, AppColors.accentPink.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        ) :
                        LinearGradient(
                            colors: [AppColors.primaryWhite, AppColors.lightGray],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(28)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(AppColors.primaryBlue.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                .disabled(viewModel.isFavorite(question: question))
            }
        }
        .padding(.horizontal, 40)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryBlue.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("No Questions Available")
                    .font(.playfairDisplay(size: 24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("No questions in selected categories. Please select at least one category.")
                    .font(.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                sheetItem = .categories
            }) {
                Text("Select Categories")
                    .font(.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.primaryWhite)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            colors: [AppColors.primaryBlue, AppColors.blueGradientEnd],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(28)
                    .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 40)
        }
        .padding(.top, 80)
    }
}

struct QuestionDetailView: View {
    let question: Question
    @ObservedObject var viewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    HStack {
                        Image(systemName: question.category.icon)
                            .font(.system(size: 16, weight: .medium))
                        Text(question.category.displayName)
                            .font(.playfairDisplay(size: 16, weight: .medium))
                    }
                    .foregroundColor(AppColors.primaryBlue)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(AppColors.primaryBlue.opacity(0.1))
                    .cornerRadius(25)
                    
                    Text(question.text)
                        .font(.playfairDisplay(size: 28, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    Button(action: {
                        UIPasteboard.general.string = question.text
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "doc.on.clipboard")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Copy Question")
                                .font(.playfairDisplay(size: 18, weight: .semibold))
                        }
                        .foregroundColor(AppColors.primaryWhite)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [AppColors.primaryYellow, AppColors.primaryYellow.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(28)
                        .shadow(color: AppColors.primaryYellow.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.top, 40)
                .padding(.bottom, 40)
            }
            .navigationTitle("Question")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
        }
    }
}

