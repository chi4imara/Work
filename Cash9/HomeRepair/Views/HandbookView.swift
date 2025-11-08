import SwiftUI

struct HandbookView: View {
    @ObservedObject var viewModel: RepairInstructionViewModel
    @State private var showingSearch = false
    @State private var showingFilters = false
    @State private var showingFavoritesOnly = false
    @State private var selectedInstruction: RepairInstruction?
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if viewModel.showFavoritesOnly || viewModel.selectedCategories.count < RepairCategory.allCases.count {
                        filterStatusView
                    }
                    
                    if viewModel.filteredInstructions.isEmpty {
                        emptyStateView
                    } else {
                        instructionsList
                    }
                }
            }
        }
        .sheet(isPresented: $showingSearch) {
            SearchView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingFilters) {
            FilterView(viewModel: viewModel)
        }
        .sheet(item: $selectedInstruction) { instruction in
            InstructionDetailView(instruction: instruction, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Handbook")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Button(action: { showingSearch = true }) {
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundColor(.primaryBlue)
            }
            
            Menu {
                Button("Filter...") {
                    showingFilters = true
                }
                
                Button(viewModel.showFavoritesOnly ? "Show All" : "Show Favorites Only") {
                    viewModel.showFavoritesOnly.toggle()
                    viewModel.updateFilteredInstructions()
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.title2)
                    .foregroundColor(.primaryBlue)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var filterStatusView: some View {
        HStack {
            Text(filterStatusText)
                .font(.caption)
                .foregroundColor(.textSecondary)
            
            Spacer()
            
            Button("Reset") {
                viewModel.showFavoritesOnly = false
                viewModel.selectedCategories = Set(RepairCategory.allCases)
                viewModel.updateFilteredInstructions()
            }
            .font(.caption)
            .foregroundColor(.primaryBlue)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(Color.lightBlue.opacity(0.3))
    }
    
    private var filterStatusText: String {
        var components: [String] = []
        
        if viewModel.showFavoritesOnly {
            components.append("Favorites only")
        }
        
        if viewModel.selectedCategories.count < RepairCategory.allCases.count {
            components.append("\(viewModel.selectedCategories.count) categories")
        }
        
        return components.joined(separator: " • ")
    }
    
    private var instructionsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredInstructions) { instruction in
                    InstructionCard(instruction: instruction) {
                        selectedInstruction = instruction
                    } onFavoriteToggle: {
                        viewModel.toggleFavorite(for: instruction)
                    } onArchive: {
                        viewModel.archiveInstruction(instruction)
                    }
                    .id("\(instruction.id)-\(instruction.isFavorite)")
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "wrench.and.screwdriver")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text("No instructions found")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            Text("Try adjusting your filters or search terms")
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
            
            Button("Reset Filters") {
                viewModel.showFavoritesOnly = false
                viewModel.selectedCategories = Set(RepairCategory.allCases)
                viewModel.searchText = ""
                viewModel.updateFilteredInstructions()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.primaryBlue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
}

#Preview {
    HandbookView(viewModel: RepairInstructionViewModel())
}

