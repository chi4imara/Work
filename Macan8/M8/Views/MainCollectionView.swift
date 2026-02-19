import SwiftUI

struct MainCollectionView: View {
    @ObservedObject var viewModel: NailIdeasViewModel
    @State private var showingNewIdea = false
    @State private var showingFilters = false
    @State private var showingSortOptions = false
    
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchAndFiltersView
                
                if viewModel.filteredIdeas.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    ideasListView
                }
            }
        }
        .onAppear {
            viewModel.updateFilteredIdeas()
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Nail Ideas Collection")
                .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    selectedTab = 1
                }
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(AppColors.accentYellow)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchAndFiltersView: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.secondaryText)
                
                TextField("Search by name or color", text: $viewModel.searchText)
                    .font(FontManager.playfairDisplay(size: 16))
                    .foregroundColor(AppColors.primaryText)
                    .onChange(of: viewModel.searchText) { _ in
                        viewModel.updateFilteredIdeas()
                    }
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                        viewModel.updateFilteredIdeas()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
            )
            
            HStack {
                Button(action: {
                    withAnimation {
                        selectedTab = 3
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                        Text("Filters")
                            .font(FontManager.playfairDisplay(size: 14, weight: .medium))
                    }
                    .foregroundColor(AppColors.primaryText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColors.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(AppColors.cardBorder, lineWidth: 1)
                            )
                    )
                }
                
                Spacer()
                
                Menu {
                    ForEach(NailIdeasViewModel.SortOption.allCases, id: \.self) { option in
                        Button(action: {
                            viewModel.sortOption = option
                            viewModel.updateFilteredIdeas()
                        }) {
                            HStack {
                                Text(option.rawValue)
                                if viewModel.sortOption == option {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.up.arrow.down")
                        Text("Sort")
                            .font(FontManager.playfairDisplay(size: 14, weight: .medium))
                    }
                    .foregroundColor(AppColors.primaryText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColors.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(AppColors.cardBorder, lineWidth: 1)
                            )
                    )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "paintbrush.pointed")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 8) {
                Text("No saved ideas yet")
                    .font(FontManager.playfairDisplay(size: 24, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Tap + to add your first nail art inspiration")
                    .font(FontManager.playfairDisplay(size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                withAnimation {
                    selectedTab = 1
                }
            }) {
                Text("Add New Idea")
                    .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.primaryBlue)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(AppColors.accentYellow)
                    .cornerRadius(20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var ideasListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredIdeas) { idea in
                    IdeaCardView(idea: idea, viewModel: viewModel)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
    }
}

struct IdeaCardView: View {
    let idea: NailIdea
    let viewModel: NailIdeasViewModel
    @State private var showingDetails = false
    
    var body: some View {
        Button(action: { showingDetails = true }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(idea.name)
                            .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.leading)
                        
                        Text(idea.mainColor)
                            .font(FontManager.playfairDisplay(size: 14))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: idea.status.icon)
                                .font(.system(size: 14))
                            Text(idea.status.rawValue)
                                .font(FontManager.playfairDisplay(size: 12, weight: .medium))
                        }
                        .foregroundColor(AppColors.accentYellow)
                        
                        Text(idea.seasonEvent.rawValue)
                            .font(FontManager.playfairDisplay(size: 12))
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
                
                HStack {
                    Text(DateFormatter.shortDate.string(from: idea.dateAdded))
                        .font(FontManager.playfairDisplay(size: 12))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
            )
        }
        .sheet(isPresented: $showingDetails) {
            IdeaDetailsView(idea: idea, viewModel: viewModel)
        }
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}


