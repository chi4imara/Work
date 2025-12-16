import SwiftUI

struct PlantsListView: View {
    @StateObject private var viewModel: PlantsListViewModel
    @State private var showingAddView = false
    @State private var showingQuickAdd = false
    @State private var showingAddOptions = false
    
    let journalViewModel: RepotJournalViewModel
    let onPlantSelected: (String) -> Void
    
    init(journalViewModel: RepotJournalViewModel, onPlantSelected: @escaping (String) -> Void) {
        self.journalViewModel = journalViewModel
        self.onPlantSelected = onPlantSelected
        self._viewModel = StateObject(wrappedValue: PlantsListViewModel(journalViewModel: journalViewModel))
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                searchBarView
                
                if viewModel.filteredSummaries.isEmpty {
                    emptyStateView
                } else {
                    plantsListView
                }
            }
        }
        .sheet(isPresented: $showingAddView) {
            RepotFormView(viewModel: journalViewModel, editingRecord: nil)
        }
        .sheet(isPresented: $showingQuickAdd) {
            QuickAddView(journalViewModel: journalViewModel, showingQuickAdd: $showingQuickAdd, showingAddView: $showingAddView)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Plants")
                .font(AppFonts.largeTitle(.bold))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Button(action: { showingAddOptions = true }) {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundColor(AppColors.accentYellow)
                    .frame(width: 44, height: 44)
                    .background(AppColors.cardBackground)
                    .clipShape(Circle())
                    .shadow(color: AppColors.primaryBlue.opacity(0.2), radius: 5, x: 0, y: 2)
            }
            .confirmationDialog("Add", isPresented: $showingAddOptions) {
                Button("Quick Add") { showingQuickAdd = true }
                Button("Full Form") { showingAddView = true }
                Button("Cancel", role: .cancel) { }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchBarView: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.textTertiary)
                
                TextField("Search by name", text: $viewModel.searchText)
                    .font(AppFonts.body(.regular))
                    .foregroundColor(AppColors.textPrimary)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.clearSearch() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.textTertiary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "leaf.circle")
                .font(.system(size: 80))
                .foregroundColor(AppColors.textTertiary)
            
            VStack(spacing: 12) {
                Text(viewModel.plantSummaries.isEmpty ? "No plants in journal yet" : "No plants found")
                    .font(AppFonts.title2(.semiBold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text(viewModel.plantSummaries.isEmpty ? 
                     "Add your first repotting record to get started" : 
                     "Try adjusting your search")
                    .font(AppFonts.body(.regular))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingAddView = true }) {
                Text(viewModel.plantSummaries.isEmpty ? "Add First Record" : "Add Record")
                    .font(AppFonts.headline(.semiBold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(AppColors.primaryBlue)
                    .cornerRadius(25)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var plantsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredSummaries) { summary in
                    PlantSummaryCard(
                        summary: summary,
                        onTap: {
                            onPlantSelected(summary.plantName)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
    }
}

struct PlantSummaryCard: View {
    let summary: PlantSummary
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.accentGreen.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "leaf.fill")
                        .font(.title2)
                        .foregroundColor(AppColors.accentGreen)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(summary.displayName)
                        .font(AppFonts.headline(.semiBold))
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(1)
                    
                    Text(summary.statusDescription)
                        .font(AppFonts.subheadline(.regular))
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppColors.textTertiary)
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PlantsListView(
        journalViewModel: RepotJournalViewModel(),
        onPlantSelected: { _ in }
    )
}
