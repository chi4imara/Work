import SwiftUI

struct IdeasListView: View {
    @ObservedObject var viewModel: GiftManagerViewModel
    @State private var searchText = ""
    @State private var sortOption: IdeasSortOption = .dateCreated
    @State private var showingFilters = false
    @State private var showingAddIdea = false
    @State private var selectedIdeaForDetail: GiftIdea?
    
    @State private var selectedPeople: Set<UUID> = []
    @State private var selectedStatuses: Set<GiftStatus> = []
    @State private var selectedEventTypes: Set<EventType> = []
    @State private var budgetFrom = ""
    @State private var budgetTo = ""
    @State private var dateFilter: DateFilter = .all
    
    var filteredAndSortedIdeas: [GiftIdea] {
        var ideas = viewModel.giftIdeas
        
        if !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let searchTerm = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            ideas = ideas.filter { idea in
                idea.title.lowercased().contains(searchTerm) ||
                (viewModel.getPerson(by: idea.personId)?.name.lowercased().contains(searchTerm) ?? false) ||
                (idea.store?.lowercased().contains(searchTerm) ?? false)
            }
        }
        
        if !selectedPeople.isEmpty {
            ideas = ideas.filter { selectedPeople.contains($0.personId) }
        }
        
        if !selectedStatuses.isEmpty {
            ideas = ideas.filter { selectedStatuses.contains($0.status) }
        }
        
        if !selectedEventTypes.isEmpty {
            ideas = ideas.filter { idea in
                guard let eventType = idea.eventType else { return false }
                return selectedEventTypes.contains(eventType)
            }
        }
        
        let budgetFromValue = Double(budgetFrom)
        let budgetToValue = Double(budgetTo)
        
        if budgetFromValue != nil || budgetToValue != nil {
            ideas = ideas.filter { idea in
                guard let budget = idea.budget else { return false }
                
                if let from = budgetFromValue, budget < from { return false }
                if let to = budgetToValue, budget > to { return false }
                
                return true
            }
        }
        
        switch dateFilter {
        case .all:
            break
        case .future:
            ideas = ideas.filter { idea in
                guard let eventDate = idea.eventDate else { return false }
                return eventDate >= Date()
            }
        case .past:
            ideas = ideas.filter { idea in
                guard let eventDate = idea.eventDate else { return false }
                return eventDate < Date()
            }
        }
        
        return ideas.sorted { idea1, idea2 in
            switch sortOption {
            case .dateCreated:
                return idea1.createdAt > idea2.createdAt
            case .eventDate:
                let date1 = idea1.eventDate ?? Date.distantFuture
                let date2 = idea2.eventDate ?? Date.distantFuture
                return date1 < date2
            case .budgetAsc:
                let budget1 = idea1.budget ?? Double.infinity
                let budget2 = idea2.budget ?? Double.infinity
                return budget1 < budget2
            case .budgetDesc:
                let budget1 = idea1.budget ?? -1
                let budget2 = idea2.budget ?? -1
                return budget1 > budget2
            }
        }
    }
    
    private var hasActiveFilters: Bool {
        !selectedPeople.isEmpty || !selectedStatuses.isEmpty || !selectedEventTypes.isEmpty ||
        !budgetFrom.isEmpty || !budgetTo.isEmpty || dateFilter != .all
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                searchBarView
                
                if viewModel.giftIdeas.isEmpty {
                    emptyStateView
                } else if filteredAndSortedIdeas.isEmpty {
                    noResultsView
                } else {
                    ideasListView
                }
            }
        }
        .sheet(isPresented: $showingFilters) {
            filtersSheet
        }
        .sheet(isPresented: $showingAddIdea) {
            AddEditIdeaView(
                viewModel: viewModel,
                editingIdea: nil,
                preselectedPersonId: nil
            )
        }
        .sheet(item: $selectedIdeaForDetail) { idea in
            IdeaDetailView(viewModel: viewModel, giftIdea: idea)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Ideas")
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: { showingFilters = true }) {
                    ZStack {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(hasActiveFilters ? AppColors.primaryYellow : AppColors.textPrimary)
                        
                        if hasActiveFilters {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                                .offset(x: 8, y: -8)
                        }
                    }
                    .frame(width: 44, height: 44)
                    .background(AppColors.cardBackground)
                    .cornerRadius(22)
                }
                
                Menu {
                    Button(action: { sortOption = .dateCreated }) {
                        Label("By Date Created", systemImage: sortOption == .dateCreated ? "checkmark" : "")
                    }
                    
                    Button(action: { sortOption = .eventDate }) {
                        Label("By Event Date", systemImage: sortOption == .eventDate ? "checkmark" : "")
                    }
                    
                    Button(action: { 
                        sortOption = sortOption == .budgetAsc ? .budgetDesc : .budgetAsc 
                    }) {
                        Label("By Budget", systemImage: (sortOption == .budgetAsc || sortOption == .budgetDesc) ? "checkmark" : "")
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.textPrimary)
                        .frame(width: 44, height: 44)
                        .background(AppColors.cardBackground)
                        .cornerRadius(22)
                }
                
                Button(action: { showingAddIdea = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppColors.primaryBlue)
                        .frame(width: 44, height: 44)
                        .background(AppColors.primaryYellow)
                        .cornerRadius(22)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.textSecondary)
            
            TextField("Search ideas, people, stores...", text: $searchText)
                .font(AppFonts.body)
                .foregroundColor(AppColors.textPrimary)
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var ideasListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredAndSortedIdeas) { idea in
                    IdeaCardView(
                        idea: idea,
                        viewModel: viewModel,
                        onTap: {
                            selectedIdeaForDetail = idea
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "lightbulb")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.textSecondary)
            
            VStack(spacing: 12) {
                Text("No Ideas Yet")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Add your first gift idea for any person")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingAddIdea = true }) {
                Text("Add Idea")
                    .font(AppFonts.buttonMedium)
                    .foregroundColor(AppColors.primaryBlue)
                    .frame(width: 160, height: 48)
                    .background(AppColors.primaryYellow)
                    .cornerRadius(24)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var noResultsView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.textSecondary)
            
            VStack(spacing: 12) {
                Text("No Results Found")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.textPrimary)
                
                Text("No ideas match your current search and filters")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if hasActiveFilters {
                Button("Reset Filters") {
                    resetFilters()
                }
                .font(AppFonts.buttonMedium)
                .foregroundColor(AppColors.primaryBlue)
                .frame(width: 160, height: 48)
                .background(AppColors.primaryYellow)
                .cornerRadius(24)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var filtersSheet: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        FilterSectionView(title: "People") {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(viewModel.people) { person in
                                    FilterToggleButton(
                                        title: person.name,
                                        isSelected: selectedPeople.contains(person.id)
                                    ) {
                                        if selectedPeople.contains(person.id) {
                                            selectedPeople.remove(person.id)
                                        } else {
                                            selectedPeople.insert(person.id)
                                        }
                                    }
                                }
                            }
                        }
                        
                        FilterSectionView(title: "Status") {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(GiftStatus.allCases, id: \.self) { status in
                                    FilterToggleButton(
                                        title: status.displayName,
                                        isSelected: selectedStatuses.contains(status)
                                    ) {
                                        if selectedStatuses.contains(status) {
                                            selectedStatuses.remove(status)
                                        } else {
                                            selectedStatuses.insert(status)
                                        }
                                    }
                                }
                            }
                        }
                        
                        FilterSectionView(title: "Event Types") {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(EventType.allCases, id: \.self) { eventType in
                                    FilterToggleButton(
                                        title: eventType.displayName,
                                        isSelected: selectedEventTypes.contains(eventType)
                                    ) {
                                        if selectedEventTypes.contains(eventType) {
                                            selectedEventTypes.remove(eventType)
                                        } else {
                                            selectedEventTypes.insert(eventType)
                                        }
                                    }
                                }
                            }
                        }
                        
                        FilterSectionView(title: "Budget Range") {
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("From")
                                        .font(AppFonts.caption1)
                                        .foregroundColor(AppColors.textSecondary)
                                    
                                    TextField("$0", text: $budgetFrom)
                                        .font(AppFonts.body)
                                        .foregroundColor(AppColors.textPrimary)
                                        .keyboardType(.decimalPad)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(AppColors.cardBackground)
                                        .cornerRadius(8)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("To")
                                        .font(AppFonts.caption1)
                                        .foregroundColor(AppColors.textSecondary)
                                    
                                    TextField("$1000", text: $budgetTo)
                                        .font(AppFonts.body)
                                        .foregroundColor(AppColors.textPrimary)
                                        .keyboardType(.decimalPad)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(AppColors.cardBackground)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        
                        FilterSectionView(title: "Event Date") {
                            VStack(spacing: 12) {
                                ForEach(DateFilter.allCases, id: \.self) { filter in
                                    FilterToggleButton(
                                        title: filter.displayName,
                                        isSelected: dateFilter == filter
                                    ) {
                                        dateFilter = filter
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        resetFilters()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        showingFilters = false
                    }
                    .foregroundColor(AppColors.primaryYellow)
                }
            }
        }
    }
    
    private func resetFilters() {
        selectedPeople.removeAll()
        selectedStatuses.removeAll()
        selectedEventTypes.removeAll()
        budgetFrom = ""
        budgetTo = ""
        dateFilter = .all
        searchText = ""
    }
}

enum IdeasSortOption {
    case dateCreated
    case eventDate
    case budgetAsc
    case budgetDesc
}

enum DateFilter: CaseIterable {
    case all
    case future
    case past
    
    var displayName: String {
        switch self {
        case .all:
            return "All"
        case .future:
            return "Future Events"
        case .past:
            return "Past Events"
        }
    }
}

struct FilterSectionView<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)
            
            content
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

struct FilterToggleButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.subheadline)
                .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.textSecondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(isSelected ? AppColors.primaryYellow : AppColors.cardBackground)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? AppColors.primaryYellow : AppColors.cardBorder, lineWidth: 1)
                )
        }
    }
}

#Preview {
    IdeasListView(viewModel: GiftManagerViewModel())
}
