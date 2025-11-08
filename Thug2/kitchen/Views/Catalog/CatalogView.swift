import SwiftUI

struct CatalogView: View {
    @ObservedObject var viewModel: InteriorIdeasViewModel
    @State private var showingFilters = false
    @State private var showingAddIdea = false
    @State private var selectedIdea: InteriorIdea?
    @State private var scrollPosition: CGFloat = 0
    @State private var showingEditView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Ideas Catalog")
                            .font(AppFonts.title1())
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Button(action: { showingFilters = true }) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.system(size: 24))
                                .foregroundColor(AppColors.primaryOrange)
                        }
                        
                        Button(action: { showingAddIdea = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(AppColors.primaryOrange)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    
                    if viewModel.filteredAndSortedIdeas.isEmpty {
                        EmptyStateView(
                            icon: "house",
                            title: "No Ideas Yet",
                            description: "You haven't added any ideas yet",
                            buttonTitle: "Add First Idea",
                            buttonAction: { showingAddIdea = true }
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.filteredAndSortedIdeas) { idea in
                                    IdeaCardView(
                                        idea: idea,
                                        viewModel: viewModel,
                                        onTap: { selectedIdea = idea },
                                        onEdit: { 
                                            selectedIdea = idea
                                            showingEditView = true
                                        },
                                        onDelete: { viewModel.deleteIdea(idea) }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 100)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingFilters) {
            FiltersView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingAddIdea) {
            AddEditIdeaView(viewModel: viewModel, ideaToEdit: selectedIdea)
                .onDisappear {
                    selectedIdea = nil
                }
        }
        .sheet(item: $selectedIdea) { idea in
            IdeaDetailView(viewModel: viewModel, idea: idea)
        }
    }
}

struct IdeaCardView: View {
    let idea: InteriorIdea
    let viewModel: InteriorIdeasViewModel
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var showingDeleteAlert = false
    @State private var showingEditAlert = false
    @State private var isSwiped = false
    @State private var showingEditView = false
    
    private let swipeThreshold: CGFloat = 80
    private let maxSwipeDistance: CGFloat = 120
    private let buttonWidth: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            if offset.width > 0 {
                HStack {
                    VStack {
                        Image(systemName: "pencil")
                            .font(.title2)
                            .foregroundColor(.white)
                        Text("Edit")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .frame(width: 80)
                    .padding(.leading, 16)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue)
                .cornerRadius(12)
                
            } else if offset.width < 0 {
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: "trash")
                            .font(.title2)
                            .foregroundColor(.white)
                        Text("Delete")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .frame(width: 80)
                    .padding(.trailing, 16)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.red)
                .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(idea.title)
                            .font(AppFonts.headline())
                            .foregroundColor(AppColors.primaryText)
                            .lineLimit(1)
                        
                        Text(idea.category.rawValue)
                            .font(AppFonts.caption())
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Spacer()
                    
                    if idea.isFavorite {
                        Image(systemName: "star.fill")
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.primaryOrange)
                    }
                }
                
                if !idea.notePreview.isEmpty {
                    Text(idea.notePreview)
                        .font(AppFonts.body())
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppGradients.cardGradient)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
            .offset(x: offset.width, y: 0)
            .contentShape(Rectangle())
            .highPriorityGesture(
                DragGesture(minimumDistance: 20, coordinateSpace: .local)
                    .onChanged { value in
                        withAnimation(.interactiveSpring(response: 0.3)) {
                            offset.width = value.translation.width
                            if abs(offset.width) > maxSwipeDistance {
                                offset.width = offset.width > 0 ? maxSwipeDistance : -maxSwipeDistance
                            }
                        }
                    }
                    .onEnded { value in
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            if value.translation.width > swipeThreshold {
                                offset.width = maxSwipeDistance
                                isSwiped = true
                                showingEditAlert = true
                            } else if value.translation.width < -swipeThreshold {
                                offset.width = -maxSwipeDistance
                                isSwiped = true
                                showingDeleteAlert = true
                            } else {
                                resetCard()
                            }
                        }
                    }
            )
            .onTapGesture {
                if isSwiped {
                    resetCard()
                } else {
                    onTap()
                }
            }
        }
        .alert("Edit Idea", isPresented: $showingEditAlert) {
            Button("Cancel", role: .cancel) {
                resetCard()
            }
            Button("Edit", role: .none) {
                showingEditView = true
                resetCard()
            }
        } message: {
            Text("Do you want to edit this idea?")
        }
        .alert("Delete Idea", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {
                resetCard()
            }
            Button("Delete", role: .destructive) {
                onDelete()
                resetCard()
            }
        } message: {
            Text("Are you sure you want to delete this idea? This action cannot be undone.")
        }
        .onChange(of: showingEditAlert) { showing in
            if !showing && isSwiped {
                resetCard()
            }
        }
        .onChange(of: showingDeleteAlert) { showing in
            if !showing && isSwiped {
                resetCard()
            }
        }
        .sheet(isPresented: $showingEditView) {
            AddEditIdeaView(viewModel: viewModel, ideaToEdit: idea)
        }
    }
    
    private func resetCard() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            offset = .zero
            isSwiped = false
        }
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let description: String
    let buttonTitle: String
    let buttonAction: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 12) {
                Text(title)
                    .font(AppFonts.title2())
                    .foregroundColor(AppColors.primaryText)
                
                Text(description)
                    .font(AppFonts.body())
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: buttonAction) {
                Text(buttonTitle)
                    .font(AppFonts.button())
                    .foregroundColor(AppColors.primaryWhite)
                    .frame(width: 200, height: 50)
                    .background(AppGradients.buttonGradient)
                    .cornerRadius(25)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    CatalogView(viewModel: InteriorIdeasViewModel())
}
