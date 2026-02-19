import SwiftUI

struct IdeasListView: View {
    @ObservedObject var viewModel: IdeasViewModel
    @Binding var selectedTab: Int
    @State private var showingAddIdea = false
    @State private var selectedIdeaId: UUID?
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Ideas")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            selectedTab = 2
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(AppColors.accentYellow)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppColors.secondaryText)
                    
                    TextField("Search ideas", text: $viewModel.searchText)
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.primaryText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.hasIdeas {
                    if viewModel.hasSearchResults {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.filteredIdeas) { idea in
                                    IdeaCardView(idea: idea, viewModel: viewModel) {
                                        selectedIdeaId = idea.id
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 120)
                        }
                    } else {
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 60))
                                .foregroundColor(AppColors.secondaryText)
                            
                            Text("No ideas match your search.")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(AppColors.secondaryText)
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                        }
                    }
                } else {
                    VStack(spacing: 30) {
                        Spacer()
                        
                        Image(systemName: "lightbulb")
                            .font(.system(size: 80))
                            .foregroundColor(AppColors.accentYellow.opacity(0.6))
                        
                        VStack(spacing: 16) {
                            Text("Here you can store ideas of any kind — gifts, trips, projects, thoughts. Add the first note to start your collection.")
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.secondaryText)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                            
                            Button(action: {
                                withAnimation {
                                    selectedTab = 2
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "plus")
                                    Text("Add idea")
                                }
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.buttonText)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(AppColors.buttonBackground)
                                .cornerRadius(20)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                }
            }
        }
        .sheet(isPresented: $showingAddIdea) {
            AddIdeaView(viewModel: viewModel, selectedTab: .constant(0))
        }
        .sheet(isPresented: Binding(
            get: { selectedIdeaId != nil },
            set: { if !$0 { selectedIdeaId = nil } }
        )) {
            if let ideaId = selectedIdeaId {
                IdeaDetailView(ideaId: ideaId, viewModel: viewModel)
            }
        }
    }
}

struct IdeaCardView: View {
    let idea: Idea
    @ObservedObject var viewModel: IdeasViewModel
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                viewModel.toggleFavorite(ideaId: idea.id)
            }) {
                Image(systemName: idea.isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 18))
                    .foregroundColor(idea.isFavorite ? AppColors.accentYellow : AppColors.secondaryText)
            }
            
            Button(action: onTap) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(idea.text)
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                    
                    HStack {
                        Text(idea.formattedDate)
                            .font(.ubuntu(12))
                            .foregroundColor(AppColors.secondaryText)
                        
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(idea.isFavorite ? AppColors.accentYellow.opacity(0.3) : AppColors.primaryText.opacity(0.1), lineWidth: 1)
        )
    }
}
