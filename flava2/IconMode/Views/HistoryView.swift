import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var viewModel: VictoryViewModel
    @State private var showingFilters = false
    @State private var selectedVictory: Victory?
    @State private var showingVictoryDetail = false
    @State private var showingDeleteConfirmation = false
    @State private var victoryToDelete: Victory?
    @State private var editingVictory: Victory?
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                GridBackgroundView()
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    searchAndFiltersView
                    
                    if viewModel.filteredVictories.isEmpty {
                        emptyStateView
                    } else {
                        victoriesListView
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(item: $selectedVictory) { victory in
                VictoryDetailView(victory: victory, editingVictory: $editingVictory)
                    .environmentObject(viewModel)
        }
        .sheet(item: $editingVictory) { victory in
            EditVictoryView(victory: victory) {
                editingVictory = nil
            }
            .environmentObject(viewModel)
        }
        .alert("Delete Victory", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) {
                victoryToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let victory = victoryToDelete {
                    viewModel.deleteVictory(victory)
                }
                victoryToDelete = nil
            }
        } message: {
            Text("Are you sure you want to delete this victory? This action cannot be undone.")
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Victory History")
                    .font(AppFonts.title1)
                    .foregroundColor(AppColors.textPrimary)
                
                Text("\(viewModel.filteredVictories.count) victories")
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Button(action: { showingFilters.toggle() }) {
                Image(systemName: viewModel.showOnlyFavorites || !viewModel.searchText.isEmpty ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppColors.primary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    private var searchAndFiltersView: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.textSecondary)
                
                TextField("Search victories...", text: $viewModel.searchText)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textPrimary)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(0)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(AppColors.primary.opacity(0.3), lineWidth: 1)
            )
            
            if showingFilters {
                VStack(spacing: 8) {
                    HStack {
                        Button(action: { viewModel.showOnlyFavorites.toggle() }) {
                            HStack {
                                Image(systemName: viewModel.showOnlyFavorites ? "star.fill" : "star")
                                    .foregroundColor(viewModel.showOnlyFavorites ? AppColors.accent : AppColors.textSecondary)
                                Text("Favorites only")
                                    .font(AppFonts.callout)
                                    .foregroundColor(AppColors.textPrimary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(viewModel.showOnlyFavorites ? AppColors.accent.opacity(0.1) : Color.clear)
                            .cornerRadius(0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 0)
                                    .stroke(viewModel.showOnlyFavorites ? AppColors.accent : AppColors.textSecondary.opacity(0.3), lineWidth: 1)
                            )
                        }
                        
                        Spacer()
                        
                        if viewModel.showOnlyFavorites || !viewModel.searchText.isEmpty {
                            Button("Clear All") {
                                viewModel.clearSearch()
                            }
                            .font(AppFonts.callout)
                            .foregroundColor(AppColors.primary)
                        }
                    }
                }
                .padding(.horizontal, 4)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .animation(.easeInOut(duration: 0.3), value: showingFilters)
    }
    
    private var victoriesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredVictories) { victory in
                    VictoryRowView(victory: victory)
                        .onTapGesture {
                            selectedVictory = victory
                            showingVictoryDetail = true
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                victoryToDelete = victory
                                showingDeleteConfirmation = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
                                viewModel.toggleFavorite(victory)
                            } label: {
                                Label(victory.isFavorite ? "Remove from Favorites" : "Add to Favorites", 
                                      systemImage: victory.isFavorite ? "star.slash" : "star.fill")
                            }
                            .tint(AppColors.accent)
                        }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        EmptyStateView(
            icon: viewModel.victories.isEmpty ? "doc.text" : "magnifyingglass",
            title: viewModel.victories.isEmpty ? "No Victories Yet" : "No Results Found",
            message: viewModel.victories.isEmpty ? 
                "Start adding your daily victories to see them here" :
                "Try adjusting your search or clearing filters",
            actionTitle: viewModel.victories.isEmpty ? nil : "Clear Filters"
        ) {
            if !viewModel.victories.isEmpty {
                viewModel.clearSearch()
            }
        }
    }
}

struct VictoryRowView: View {
    let victory: Victory
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 2) {
                Text(victory.dayString)
                    .font(AppFonts.pixelTitle)
                    .foregroundColor(AppColors.textPrimary)
                
                Text(victory.shortDateString)
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.textSecondary)
            }
            .frame(width: 50)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(victory.truncatedText)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textPrimary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    if victory.isFavorite {
                        Image(systemName: "star.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(AppColors.accent)
                    }
                }
                
                Text(victory.dateString)
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(AppColors.textSecondary.opacity(0.5))
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(0)
        .overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(AppColors.primary.opacity(0.2), lineWidth: 1)
        )
    }
}

struct VictoryDetailView: View {
    let victory: Victory
    @Binding var editingVictory: Victory?
    @EnvironmentObject var viewModel: VictoryViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteConfirmation = false
    var victorySecond: Victory {
        if let index = viewModel.victories.firstIndex(where: { $0.id == victory.id }) {
             viewModel.victories[index]
        } else {
            victory
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                GridBackgroundView()
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "trophy.fill")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(AppColors.accent)
                                
                                Spacer()
                                
                                Button(action: { viewModel.toggleFavorite(victory) }) {
                                    Image(systemName: victorySecond.isFavorite ? "star.fill" : "star")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(AppColors.accent)
                                }
                            }
                            
                            HStack {
                                Text(victory.dateString)
                                    .font(AppFonts.title2)
                                    .foregroundColor(AppColors.textPrimary)
                                Spacer()
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Victory")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text(victory.text)
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.textPrimary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(20)
                        .background(AppColors.cardGradient)
                        .cornerRadius(0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(AppColors.primary.opacity(0.3), lineWidth: 1)
                        )
                        
                        VStack(spacing: 12) {
                            PixelButton("Edit Victory", icon: "pencil", style: .secondary) {
                                editingVictory = victory
                                dismiss()
                            }
                            
                            PixelButton("Delete Victory", icon: "trash", style: .danger) {
                                showingDeleteConfirmation = true
                            }
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Victory Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.primary)
                }
            }
        }
        .alert("Delete Victory", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteVictory(victory)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this victory? This action cannot be undone.")
        }
    }
}

#Preview {
    HistoryView()
        .environmentObject(VictoryViewModel())
}
