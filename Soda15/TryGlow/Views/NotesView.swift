import SwiftUI

struct NotesView: View {
    @ObservedObject var viewModel: BeautyProductViewModel
    @State private var selectedCategory: ProductCategory?
    @State private var showingClearAlert = false
    
    private let colorManager = ColorManager.shared
    
    var body: some View {
        ZStack {
            colorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                categoryFilters
                
                if viewModel.commentsByCategory(selectedCategory).isEmpty {
                    emptyStateView
                } else {
                    notesListView
                }
            }
        }
        .alert("Clear all notes?", isPresented: $showingClearAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                viewModel.clearAllComments()
            }
        } message: {
            Text("This will remove all comments but keep your discoveries.")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Notes")
                .font(.custom("PlayfairDisplay-Bold", size: 28))
                .foregroundColor(colorManager.primaryWhite)
            
            Spacer()
            
            if !viewModel.allComments().isEmpty {
                Button(action: {
                    showingClearAlert = true
                }) {
                    Text("Clear Notes")
                        .font(.custom("PlayfairDisplay-Medium", size: 14))
                        .foregroundColor(colorManager.primaryWhite)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(colorManager.primaryWhite.opacity(0.2))
                        .cornerRadius(15)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var categoryFilters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryFilterButton(
                    title: "All",
                    isSelected: selectedCategory == nil
                ) {
                    selectedCategory = nil
                }
                
                ForEach(ProductCategory.allCases, id: \.self) { category in
                    CategoryFilterButton(
                        title: category.rawValue,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 15)
        .padding(.bottom, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "note.text")
                .font(.system(size: 60))
                .foregroundColor(colorManager.primaryWhite.opacity(0.7))
            
            Text("No notes yet. Add a comment to any discovery — it will appear here.")
                .font(.custom("PlayfairDisplay-Regular", size: 18))
                .foregroundColor(colorManager.primaryWhite)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var notesListView: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(Array(viewModel.commentsByCategory(selectedCategory).enumerated()), id: \.offset) { index, item in
                    NoteCard(product: item.product, comment: item.comment, viewModel: viewModel)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
}

struct NoteCard: View {
    let product: BeautyProduct
    let comment: String
    @ObservedObject var viewModel: BeautyProductViewModel
    @State private var showingDetails = false
    
    private let colorManager = ColorManager.shared
    
    var body: some View {
        Button(action: {
            showingDetails = true
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(product.name)
                            .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                            .foregroundColor(colorManager.secondaryText)
                            .multilineTextAlignment(.leading)
                        
                        Text(product.category.rawValue)
                            .font(.custom("PlayfairDisplay-Regular", size: 12))
                            .foregroundColor(colorManager.accentText)
                    }
                    
                    Spacer()
                    
                    Image(systemName: product.category.icon)
                        .font(.system(size: 16))
                        .foregroundColor(colorManager.accentText)
                }
                
                Text("\"\(comment)\"")
                    .font(.custom("PlayfairDisplay-Regular", size: 14))
                    .foregroundColor(colorManager.secondaryText.opacity(0.8))
                    .italic()
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= product.rating ? "star.fill" : "star")
                            .font(.system(size: 12))
                            .foregroundColor(colorManager.primaryYellow)
                    }
                    
                    Spacer()
                    
                    Text(product.dateAdded, style: .date)
                        .font(.custom("PlayfairDisplay-Regular", size: 12))
                        .foregroundColor(colorManager.secondaryText.opacity(0.6))
                }
            }
            .padding(16)
            .background(colorManager.cardGradient)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.1), radius: 5)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetails) {
            ProductDetailView(product: product, viewModel: viewModel)
        }
    }
}

#Preview {
    NotesView(viewModel: BeautyProductViewModel())
}
