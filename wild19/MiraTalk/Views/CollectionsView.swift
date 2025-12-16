import SwiftUI

struct CollectionsView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var selectedCollection: QuestionCollection?
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    collectionsGridView
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(item: $selectedCollection) { collection in
            CollectionDetailView(collection: collection, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Collections")
                    .font(.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            
            Text("Curated question sets for different occasions")
                .font(.playfairDisplay(size: 16, weight: .regular))
                .foregroundColor(AppColors.secondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var collectionsGridView: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(viewModel.getCollections()) { collection in
                    CollectionCard(
                        collection: collection,
                        onTap: {
                            selectedCollection = collection
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 30)
            .padding(.bottom, 70)
        }
    }
}

struct CollectionCard: View {
    let collection: QuestionCollection
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 16) {
                Image(systemName: collection.icon)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(AppColors.primaryBlue)
                    .frame(width: 60, height: 60)
                    .background(
                        Circle()
                            .fill(AppColors.primaryBlue.opacity(0.1))
                    )
                
                Text(collection.title)
                    .font(.playfairDisplay(size: 18, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Text("\(collection.questions.count) questions")
                    .font(.playfairDisplay(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 160)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.cardGradient)
                    .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct CollectionDetailView: View {
    let collection: QuestionCollection
    @ObservedObject var viewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedQuestion: Question?
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        VStack(spacing: 12) {
                            Image(systemName: collection.icon)
                                .font(.system(size: 50, weight: .medium))
                                .foregroundColor(AppColors.primaryBlue)
                                .frame(width: 80, height: 80)
                                .background(
                                    Circle()
                                        .fill(AppColors.primaryBlue.opacity(0.1))
                                )
                            
                            Text(collection.title)
                                .font(.playfairDisplay(size: 24, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                                .multilineTextAlignment(.center)
                        }
                        
                        Text("\(collection.questions.count) carefully selected questions")
                            .font(.playfairDisplay(size: 16, weight: .regular))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(collection.questions, id: \.text) { question in
                                CollectionQuestionCard(
                                    question: question,
                                    viewModel: viewModel,
                                    onTap: {
                                        selectedQuestion = question
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 30)
                    }
                }
            }
            .navigationTitle(collection.title)
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
        .sheet(item: $selectedQuestion) { question in
            CollectionQuestionDetailView(question: question, viewModel: viewModel)
        }
    }
}

struct CollectionQuestionCard: View {
    let question: Question
    @ObservedObject var viewModel: AppViewModel
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: question.category.icon)
                        .font(.system(size: 12, weight: .medium))
                    Text(question.category.displayName)
                        .font(.playfairDisplay(size: 12, weight: .medium))
                    
                    Spacer()
                }
                .foregroundColor(AppColors.primaryBlue)
                
                Text(question.text)
                    .font(.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                
                HStack(spacing: 12) {
                    Button(action: {
                        UIPasteboard.general.string = question.text
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "doc.on.clipboard")
                                .font(.system(size: 12, weight: .medium))
                            Text("Copy")
                                .font(.playfairDisplay(size: 12, weight: .medium))
                        }
                        .foregroundColor(AppColors.primaryBlue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(AppColors.primaryBlue.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    Button(action: {
                        viewModel.addToFavorites(question: question)
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: viewModel.isFavorite(question: question) ? "heart.fill" : "heart")
                                .font(.system(size: 12, weight: .medium))
                            Text(viewModel.isFavorite(question: question) ? "Saved" : "Save")
                                .font(.playfairDisplay(size: 12, weight: .medium))
                        }
                        .foregroundColor(viewModel.isFavorite(question: question) ? AppColors.accentPink : AppColors.accentPink.opacity(0.7))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(AppColors.accentPink.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .disabled(viewModel.isFavorite(question: question))
                    
                    Spacer()
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CollectionQuestionDetailView: View {
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
                    
                    VStack(spacing: 16) {
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
                        
                        Button(action: {
                            viewModel.addToFavorites(question: question)
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: viewModel.isFavorite(question: question) ? "heart.fill" : "heart")
                                    .font(.system(size: 18, weight: .semibold))
                                Text(viewModel.isFavorite(question: question) ? "Already in Favorites" : "Add to Favorites")
                                    .font(.playfairDisplay(size: 18, weight: .semibold))
                            }
                            .foregroundColor(viewModel.isFavorite(question: question) ? AppColors.primaryWhite : AppColors.accentPink)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                viewModel.isFavorite(question: question) ?
                                AnyShapeStyle(LinearGradient(
                                    colors: [AppColors.accentPink, AppColors.accentPink.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )) :
                                    AnyShapeStyle(AppColors.primaryWhite)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(AppColors.accentPink.opacity(0.3), lineWidth: viewModel.isFavorite(question: question) ? 0 : 1)
                            )
                            .cornerRadius(28)
                            .shadow(color: AppColors.accentPink.opacity(0.2), radius: 4, x: 0, y: 2)
                        }
                        .disabled(viewModel.isFavorite(question: question))
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

#Preview {
    CollectionsView(viewModel: AppViewModel())
}
