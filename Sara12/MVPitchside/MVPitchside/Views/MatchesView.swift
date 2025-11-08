import SwiftUI

struct MatchesView: View {
    @ObservedObject var viewModel: MatchViewModel
    @State private var showingAddMatch = false
    @State private var showingMenu = false
    @State private var selectedMatches: Set<UUID> = []
    @State private var isMultiSelectMode = false
    @State private var showingDeleteAlert = false
    @State private var matchToDelete: Match?
    @State private var matchesToDelete: [Match] = []
    @State private var showingFilterOptions = false
    @State private var showingSortOptions = false
    @State private var selectedMatch: Match?
    @State private var matchToEdit: Match?
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradient.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if viewModel.matches.isEmpty {
                        emptyStateView
                    } else {
                        matchesListView
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddMatch) {
            AddEditMatchView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingMenu) {
            menuSheet
        }
        .sheet(item: $matchToEdit) { match in
            AddEditMatchView(viewModel: viewModel, matchToEdit: match)
        }
        .alert("Delete Match", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let match = matchToDelete {
                    viewModel.deleteMatch(match)
                } else if !matchesToDelete.isEmpty {
                    viewModel.deleteMatches(matchesToDelete)
                    exitMultiSelectMode()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            if let match = matchToDelete {
                Text("Are you sure you want to delete this match?")
            } else if matchesToDelete.count > 1 {
                Text("Are you sure you want to delete \(matchesToDelete.count) matches?")
            } else {
                Text("Are you sure you want to delete this match?")
            }
        }
        .sheet(isPresented: $showingFilterOptions) {
            filterSheet
        }
        .sheet(isPresented: $showingSortOptions) {
            sortSheet
        }
    }
    
    private var headerView: some View {
        HStack {
            if isMultiSelectMode {
                Button("Cancel") {
                    exitMultiSelectMode()
                }
                .foregroundColor(.primaryAccent)
                
                Spacer()
            }
            
            
            Text("My Matches")
                .customTitle()
            
            Spacer()
            
            HStack(spacing: 16) {
                if isMultiSelectMode {
                    Button("Delete") {
                        matchesToDelete = Array(selectedMatches.compactMap { id in
                            viewModel.matches.first { $0.id == id }
                        })
                        showingDeleteAlert = true
                    }
                    .foregroundColor(.errorColor)
                    .disabled(selectedMatches.isEmpty)
                } else {
                    Button(action: { showingMenu = true }) {
                        Image(systemName: "ellipsis")
                            .font(.title2)
                            .foregroundColor(.primaryText)
                    }
                    
                    Button(action: { showingAddMatch = true }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.primaryAccent)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "sportscourt")
                .font(.custom("Poppins-Light", size: 80))
                .foregroundColor(.secondaryText)
            
            VStack(spacing: 12) {
                Text("No matches yet")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primaryText)
                
                Text("Start tracking your games and build your match history")
                    .font(.body)
                    .foregroundColor(.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: { showingAddMatch = true }) {
                Text("Add First Match")
                    .font(.buttonText)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.primaryAccent)
                    .cornerRadius(25)
            }
            
            Spacer()
        }
    }
    
    private var matchesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredAndSortedMatches) { match in
                    MatchCardView(
                        match: match,
                        isSelected: selectedMatches.contains(match.id),
                        isMultiSelectMode: isMultiSelectMode,
                        onTap: {
                            if isMultiSelectMode {
                                toggleSelection(for: match)
                            } else {
                                selectedMatch = match
                            }
                        },
                        onLongPress: {
                            if !isMultiSelectMode {
                                enterMultiSelectMode(with: match)
                            }
                        },
                        onEdit: {
                            matchToEdit = match
                        },
                        onDelete: {
                            matchToDelete = match
                            showingDeleteAlert = true
                        }
                    )
                    .sheet(item: $selectedMatch) { match in
                            MatchDetailView(viewModel: viewModel, matchId: match.id)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var menuSheet: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Options")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryText)
                    .padding(.top)
                
                VStack(spacing: 16) {
                    Button(action: {
                        showingMenu = false
                        showingFilterOptions = true
                    }) {
                        HStack {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .foregroundColor(.primaryAccent)
                            Text("Filter by Date")
                                .foregroundColor(.primaryText)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondaryText)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.cardBackground)
                                .shadow(color: Color.shadowColor, radius: 2, x: 0, y: 1)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        showingMenu = false
                        showingSortOptions = true
                    }) {
                        HStack {
                            Image(systemName: "arrow.up.arrow.down.circle")
                                .foregroundColor(.primaryAccent)
                            Text("Sort Options")
                                .foregroundColor(.primaryText)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondaryText)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.cardBackground)
                                .shadow(color: Color.shadowColor, radius: 2, x: 0, y: 1)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .background(AppGradient.background)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    showingMenu = false
                }
            )
        }
    }
    
    private func toggleSelection(for match: Match) {
        if selectedMatches.contains(match.id) {
            selectedMatches.remove(match.id)
        } else {
            selectedMatches.insert(match.id)
        }
    }
    
    private func enterMultiSelectMode(with match: Match) {
        isMultiSelectMode = true
        selectedMatches.insert(match.id)
    }
    
    private func exitMultiSelectMode() {
        isMultiSelectMode = false
        selectedMatches.removeAll()
    }
    
    private var filterSheet: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Filter by Date")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryText)
                    .padding(.top)
                
                VStack(spacing: 12) {
                    ForEach(DateFilter.allCases, id: \.self) { filter in
                        Button(action: {
                            viewModel.dateFilter = filter
                            showingFilterOptions = false
                        }) {
                            HStack {
                                Text(filter.rawValue)
                                    .foregroundColor(.primaryText)
                                Spacer()
                                if viewModel.dateFilter == filter {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.primaryAccent)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(viewModel.dateFilter == filter ? Color.primaryAccent.opacity(0.1) : Color.cardBackground)
                                    .shadow(color: Color.shadowColor, radius: 2, x: 0, y: 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .background(AppGradient.background)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    showingFilterOptions = false
                }
            )
        }
    }
    
    private var sortSheet: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Sort Options")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryText)
                    .padding(.top)
                
                VStack(spacing: 12) {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Button(action: {
                            viewModel.sortOption = option
                            showingSortOptions = false
                        }) {
                            HStack {
                                Text(option.rawValue)
                                    .foregroundColor(.primaryText)
                                Spacer()
                                if viewModel.sortOption == option {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.primaryAccent)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(viewModel.sortOption == option ? Color.primaryAccent.opacity(0.1) : Color.cardBackground)
                                    .shadow(color: Color.shadowColor, radius: 2, x: 0, y: 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .background(AppGradient.background)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    showingSortOptions = false
                }
            )
        }
    }
}

struct MatchCardView: View {
    let match: Match
    let isSelected: Bool
    let isMultiSelectMode: Bool
    let onTap: () -> Void
    let onLongPress: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    private let swipeThreshold: CGFloat = 60
    
    var body: some View {
        ZStack {
            if dragOffset.width < -10 && !isMultiSelectMode {
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
            
            if dragOffset.width > 10 && !isMultiSelectMode {
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
            }
            
            HStack {
                if isMultiSelectMode {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isSelected ? .primaryAccent : .secondaryText)
                        .font(.title3)
                        .padding(.trailing, 8)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(match.displayTeams)
                            .cardTitle()
                        
                        Spacer()
                        
                        Text(match.displayScore)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryAccent)
                    }
                    
                    HStack {
                        Text(match.formattedDate)
                            .font(.cardSubtitle)
                            .foregroundColor(.secondaryText)
                        
                        Spacer()
                        
                        if let mvp = match.mvp {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .font(.caption)
                                    .foregroundColor(.warningColor)
                                Text(mvp)
                                    .font(.cardSubtitle)
                                    .foregroundColor(.secondaryText)
                            }
                        }
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.primaryAccent.opacity(0.1) : Color.cardBackground)
                    .shadow(color: Color.shadowColor, radius: 4, x: 0, y: 2)
            )
            .offset(x: isMultiSelectMode ? 0 : dragOffset.width, y: 0)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if !isMultiSelectMode {
                            dragOffset = CGSize(width: value.translation.width, height: 0)
                        }
                    }
                    .onEnded { value in
                        if !isMultiSelectMode {
                            if value.translation.width < -swipeThreshold {
                                onDelete()
                            } else if value.translation.width > swipeThreshold {
                                onEdit()
                            }
                            
                            withAnimation(.spring()) {
                                dragOffset = .zero
                            }
                        }
                    }
            )
        }
        .onTapGesture {
            onTap()
        }
        .onLongPressGesture {
            onLongPress()
        }
    }
}
