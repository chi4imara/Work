import SwiftUI

struct TournamentsView: View {
    @ObservedObject var viewModel: TournamentViewModel
    @State private var showingAddTournament = false
    @State private var showingMenu = false
    @State private var selectedTournaments: Set<UUID> = []
    @State private var isMultiSelectMode = false
    @State private var showingDeleteAlert = false
    @State private var tournamentToDelete: Tournament?
    @State private var tournamentsToDelete: [Tournament] = []
    @State private var showingFilterOptions = false
    @State private var showingSortOptions = false
    @State private var tournamentToEdit: Tournament?
    @State private var selectedTournament: Tournament?
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradient.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if viewModel.tournaments.isEmpty {
                        emptyStateView
                    } else {
                        tournamentsListView
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddTournament) {
            AddEditTournamentView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingMenu) {
            menuSheet
        }
        .sheet(item: $tournamentToEdit) { tournament in
            AddEditTournamentView(viewModel: viewModel, tournamentToEdit: tournament)
        }
        .sheet(item: $selectedTournament) { tournament in
            TournamentDetailView(viewModel: viewModel, tournament: tournament)
        }
        .alert("Delete Tournament", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let tournament = tournamentToDelete {
                    print("DEBUG: Deleting single tournament: \(tournament.name)")
                    viewModel.deleteTournament(tournament)
                    tournamentToDelete = nil
                } else if !tournamentsToDelete.isEmpty {
                    print("DEBUG: Deleting \(tournamentsToDelete.count) tournaments")
                    for tournament in tournamentsToDelete {
                        print("DEBUG: - \(tournament.name)")
                    }
                    viewModel.deleteTournaments(tournamentsToDelete)
                    tournamentsToDelete = []
                    exitMultiSelectMode()
                } else {
                    print("DEBUG: No tournaments to delete!")
                }
            }
            Button("Cancel", role: .cancel) { 
                tournamentToDelete = nil
                tournamentsToDelete = []
            }
        } message: {
            if let tournament = tournamentToDelete {
                Text("Are you sure you want to delete this tournament?")
            } else if tournamentsToDelete.count > 1 {
                Text("Are you sure you want to delete \(tournamentsToDelete.count) tournaments?")
            } else {
                Text("Are you sure you want to delete this tournament?")
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
            
            Text("Tournaments")
                .customTitle()
            
            Spacer()
            
            HStack(spacing: 16) {
                if isMultiSelectMode {
                    Button("Delete") {
                        tournamentsToDelete = Array(selectedTournaments.compactMap { id in
                            viewModel.tournaments.first { $0.id == id }
                        })
                        print("DEBUG: Selected tournaments count: \(selectedTournaments.count)")
                        print("DEBUG: Tournaments to delete count: \(tournamentsToDelete.count)")
                        showingDeleteAlert = true
                    }
                    .foregroundColor(.errorColor)
                    .disabled(selectedTournaments.isEmpty)
                } else {
                    Button(action: { showingMenu = true }) {
                        Image(systemName: "ellipsis")
                            .font(.title2)
                            .foregroundColor(.primaryText)
                    }
                    
                    Button(action: { showingAddTournament = true }) {
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
            
            Image(systemName: "trophy")
                .font(.custom("Poppins-Light", size: 80))
                .foregroundColor(.secondaryText)
            
            VStack(spacing: 12) {
                Text("No tournaments yet")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primaryText)
                
                Text("Create your first tournament and start organizing competitions")
                    .font(.body)
                    .foregroundColor(.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: { showingAddTournament = true }) {
                Text("Create Tournament")
                    .font(.buttonText)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.primaryAccent)
                    .cornerRadius(25)
            }
            
            Spacer()
        }
    }
    
    private var tournamentsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredAndSortedTournaments) { tournament in
                    TournamentCardView(
                        tournament: tournament,
                        isSelected: selectedTournaments.contains(tournament.id),
                        isMultiSelectMode: isMultiSelectMode,
                        onTap: {
                            if isMultiSelectMode {
                                toggleSelection(for: tournament)
                            } else {
                                selectedTournament = tournament
                            }
                        },
                        onLongPress: {
                            if !isMultiSelectMode {
                                enterMultiSelectMode(with: tournament)
                            }
                        },
                        onEdit: {
                            tournamentToEdit = tournament
                        },
                        onDelete: {
                            tournamentToDelete = tournament
                            showingDeleteAlert = true
                        }
                    )
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
                            Text("Filter by Status")
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
    
    private func toggleSelection(for tournament: Tournament) {
        if selectedTournaments.contains(tournament.id) {
            selectedTournaments.remove(tournament.id)
        } else {
            selectedTournaments.insert(tournament.id)
        }
    }
    
    private func enterMultiSelectMode(with tournament: Tournament) {
        isMultiSelectMode = true
        selectedTournaments.insert(tournament.id)
    }
    
    private func exitMultiSelectMode() {
        isMultiSelectMode = false
        selectedTournaments.removeAll()
    }
    
    private var filterSheet: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Filter by Status")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryText)
                    .padding(.top)
                
                VStack(spacing: 12) {
                    ForEach(TournamentStatusFilter.allCases, id: \.self) { filter in
                        Button(action: {
                            viewModel.statusFilter = filter
                            showingFilterOptions = false
                        }) {
                            HStack {
                                Text(filter.displayName)
                                    .foregroundColor(.primaryText)
                                Spacer()
                                if viewModel.statusFilter == filter {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.primaryAccent)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(viewModel.statusFilter == filter ? Color.primaryAccent.opacity(0.1) : Color.cardBackground)
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
                    ForEach(TournamentSortOption.allCases, id: \.self) { option in
                        Button(action: {
                            viewModel.sortOption = option
                            showingSortOptions = false
                        }) {
                            HStack {
                                Text(option.displayName)
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

struct TournamentCardView: View {
    let tournament: Tournament
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
                        Text(tournament.name)
                            .cardTitle()
                            .lineLimit(1)
                        
                        Spacer()
                        
                        StatusBadge(status: tournament.status)
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(tournament.dateRange)
                                .font(.cardSubtitle)
                                .foregroundColor(.secondaryText)
                            
                            HStack(spacing: 16) {
                                HStack(spacing: 4) {
                                    Image(systemName: "person.2")
                                        .font(.caption)
                                        .foregroundColor(.secondaryText)
                                    Text("\(tournament.teamsCount) teams")
                                        .font(.cardSubtitle)
                                        .foregroundColor(.secondaryText)
                                }
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "gamecontroller")
                                        .font(.caption)
                                        .foregroundColor(.secondaryText)
                                    Text("\(tournament.completedMatchesCount)/\(tournament.matchesCount)")
                                        .font(.cardSubtitle)
                                        .foregroundColor(.secondaryText)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        if tournament.matchesCount > 0 {
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("\(Int(tournament.progress * 100))%")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primaryAccent)
                                
                                ProgressView(value: tournament.progress)
                                    .progressViewStyle(LinearProgressViewStyle(tint: .primaryAccent))
                                    .frame(width: 60)
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


struct StatusBadge: View {
    let status: TournamentStatus
    
    var body: some View {
        Text(status.displayName)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(statusColor)
            )
    }
    
    private var statusColor: Color {
        switch status {
        case .upcoming:
            return .infoColor
        case .active:
            return .successColor
        case .completed:
            return .secondaryText
        case .cancelled:
            return .errorColor
        }
    }
}

struct AddEditTournamentView: View {
    @ObservedObject var viewModel: TournamentViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let tournamentToEdit: Tournament?
    
    @State private var name = ""
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(7 * 24 * 60 * 60)
    @State private var description = ""
    @State private var prize = ""
    @State private var teams: [String] = []
    @State private var newTeamName = ""
    
    init(viewModel: TournamentViewModel, tournamentToEdit: Tournament? = nil) {
        self.viewModel = viewModel
        self.tournamentToEdit = tournamentToEdit
    }
    
    var isEditing: Bool {
        tournamentToEdit != nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradient.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tournament Name")
                                .font(.headline)
                                .foregroundColor(.primaryText)
                            
                            TextField("Enter tournament name", text: $name)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Start Date")
                                    .font(.headline)
                                    .foregroundColor(.primaryText)
                                
                                DatePicker("", selection: $startDate, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("End Date")
                                    .font(.headline)
                                    .foregroundColor(.primaryText)
                                
                                DatePicker("", selection: $endDate, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description (Optional)")
                                .font(.headline)
                                .foregroundColor(.primaryText)
                            
                            TextField("Enter description", text: $description, axis: .vertical)
                                .textFieldStyle(CustomTextFieldStyle())
                                .lineLimit(3...6)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Prize (Optional)")
                                .font(.headline)
                                .foregroundColor(.primaryText)
                            
                            TextField("Enter prize", text: $prize)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Teams")
                                .font(.headline)
                                .foregroundColor(.primaryText)
                            
                            HStack {
                                TextField("Add team", text: $newTeamName)
                                    .textFieldStyle(CustomTextFieldStyle())
                                
                                Button("Add") {
                                    if !newTeamName.isEmpty && !teams.contains(newTeamName) {
                                        teams.append(newTeamName)
                                        newTeamName = ""
                                    }
                                }
                                .foregroundColor(.primaryAccent)
                                .disabled(newTeamName.isEmpty)
                            }
                            
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 8) {
                                ForEach(teams, id: \.self) { team in
                                    HStack {
                                        Text(team)
                                            .font(.caption)
                                            .foregroundColor(.primaryText)
                                        
                                        Button(action: {
                                            teams.removeAll { $0 == team }
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.errorColor)
                                                .font(.caption)
                                        }
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.secondaryBackground)
                                    )
                                }
                            }
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding(20)
                }
            }
            .navigationTitle(isEditing ? "Edit Tournament" : "New Tournament")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                    .foregroundColor(.primaryAccent),
                trailing: Button("Save") {
                    saveTournament()
                }
                    .foregroundColor(name.isEmpty || teams.count < 2 ? .gray : .primaryAccent)
                    .disabled(name.isEmpty || teams.count < 2)
            )
            .onAppear {
                setupInitialValues()
            }
        }
    }
    
    private func setupInitialValues() {
        if let tournament = tournamentToEdit {
            name = tournament.name
            startDate = tournament.startDate
            endDate = tournament.endDate
            description = tournament.description ?? ""
            prize = tournament.prize ?? ""
            teams = tournament.teams
        }
    }
    
    private func saveTournament() {
        if let existingTournament = tournamentToEdit {
            var updatedTournament = existingTournament
            updatedTournament.name = name
            updatedTournament.startDate = startDate
            updatedTournament.endDate = endDate
            updatedTournament.teams = teams
            updatedTournament.description = description.isEmpty ? nil : description
            updatedTournament.prize = prize.isEmpty ? nil : prize
            
            viewModel.updateTournament(updatedTournament)
        } else {
            let tournament = Tournament(
                name: name,
                startDate: startDate,
                endDate: endDate,
                teams: teams,
                matches: [],
                status: .upcoming,
                description: description.isEmpty ? nil : description,
                prize: prize.isEmpty ? nil : prize
            )
            
            viewModel.addTournament(tournament)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct TournamentDetailView: View {
    @ObservedObject var viewModel: TournamentViewModel
    let tournament: Tournament
    
    var body: some View {
        ZStack {
            AppGradient.background
                .ignoresSafeArea()
            VStack{
                HStack {
                    Spacer()
                    
                    Text("Tournament Detail")
                        .font(.headline)
                        .fontWeight(.semibold)
                
                    Spacer()
                }
                .padding(.vertical)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(tournament.name)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primaryText)
                                
                                Spacer()
                                
                                StatusBadge(status: tournament.status)
                            }
                            
                            Text(tournament.dateRange)
                                .font(.subheadline)
                                .foregroundColor(.secondaryText)
                            
                            if let description = tournament.description {
                                Text(description)
                                    .font(.body)
                                    .foregroundColor(.primaryText)
                            }
                            
                            if let prize = tournament.prize {
                                HStack {
                                    Image(systemName: "trophy.fill")
                                        .foregroundColor(.warningColor)
                                    Text("Prize: \(prize)")
                                        .font(.subheadline)
                                        .foregroundColor(.primaryText)
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.cardBackground)
                                .shadow(color: Color.shadowColor, radius: 4, x: 0, y: 2)
                        )
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Teams (\(tournament.teamsCount))")
                                .font(.headline)
                                .foregroundColor(.primaryText)
                            
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 8) {
                                ForEach(tournament.teams, id: \.self) { team in
                                    Text(team)
                                        .font(.subheadline)
                                        .foregroundColor(.primaryText)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.secondaryBackground)
                                        )
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.cardBackground)
                                .shadow(color: Color.shadowColor, radius: 4, x: 0, y: 2)
                        )
                        
                        if !tournament.matches.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Matches (\(tournament.completedMatchesCount)/\(tournament.matchesCount))")
                                    .font(.headline)
                                    .foregroundColor(.primaryText)
                                
                                ForEach(tournament.matches) { match in
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(match.displayTeams)
                                                .font(.subheadline)
                                                .foregroundColor(.primaryText)
                                            
                                            Text(match.formattedDate)
                                                .font(.caption)
                                                .foregroundColor(.secondaryText)
                                            
                                            if let round = match.round {
                                                Text(round)
                                                    .font(.caption)
                                                    .foregroundColor(.secondaryText)
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        Text(match.displayScore)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(match.isCompleted ? .primaryAccent : .secondaryText)
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.secondaryBackground)
                                    )
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.cardBackground)
                                    .shadow(color: Color.shadowColor, radius: 4, x: 0, y: 2)
                            )
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(20)
                }
            }
        }
        .navigationTitle("Tournament")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    TournamentsView(viewModel: TournamentViewModel())
}

