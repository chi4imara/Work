import SwiftUI

struct PeopleView: View {
    @ObservedObject var viewModel: GiftManagerViewModel
    @State private var searchText = ""
    @State private var sortOption: PeopleSortOption = .name
    @State private var showingAddPerson = false
    @State private var showingSearch = false
    @State private var newPersonName = ""
    @State private var showNewIdea = false
    @State private var selectPersonId: UUID? = nil
    @State private var selectedPersonForDetail: Person? = nil
    
    var filteredAndSortedPeople: [Person] {
        let filtered = searchText.isEmpty ? viewModel.people : 
            viewModel.people.filter { 
                $0.name.localizedCaseInsensitiveContains(searchText.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        
        return filtered.sorted { person1, person2 in
            switch sortOption {
            case .name:
                return person1.name.localizedCompare(person2.name) == .orderedAscending
            case .ideasCount:
                let stats1 = viewModel.getPersonStats(person1)
                let stats2 = viewModel.getPersonStats(person2)
                let total1 = stats1.ideas + stats1.purchased + stats1.gifted
                let total2 = stats2.ideas + stats2.purchased + stats2.gifted
                
                if total1 == total2 {
                    return person1.name.localizedCompare(person2.name) == .orderedAscending
                }
                return total1 > total2
            }
        }
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                if showingSearch {
                    searchBarView
                }
                
                if viewModel.people.isEmpty {
                    emptyStateView
                } else if filteredAndSortedPeople.isEmpty {
                    noResultsView
                } else {
                    peopleListView
                }
            }
        }
        .sheet(isPresented: $showingAddPerson) {
            addPersonSheet
        }
        .sheet(isPresented: $showNewIdea) {
            AddEditIdeaView(viewModel: viewModel, editingIdea: nil, preselectedPersonId: selectPersonId)
        }
        .sheet(item: $selectedPersonForDetail) { person in
            PersonDetailView(person: person, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Gift Manager")
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            HStack(spacing: 16) {
                Menu {
                    Button(action: { showingSearch.toggle() }) {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    
                    Menu("Sort By") {
                        Button(action: { sortOption = .name }) {
                            Label("By Name", systemImage: sortOption == .name ? "checkmark" : "")
                        }
                        
                        Button(action: { sortOption = .ideasCount }) {
                            Label("By Ideas Count", systemImage: sortOption == .ideasCount ? "checkmark" : "")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.textPrimary)
                        .frame(width: 44, height: 44)
                        .background(AppColors.cardBackground)
                        .cornerRadius(22)
                }
                
                Button(action: { showingAddPerson = true }) {
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
            
            TextField("Search people...", text: $searchText)
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
    
    private var peopleListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredAndSortedPeople) { person in
                    PersonCardView(
                        person: person,
                        viewModel: viewModel,
                        onTap: {
                            selectedPersonForDetail = person
                        },
                        onAddIdea: {
                            selectPersonId = person.id
                            showNewIdea = true
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
            
            Image(systemName: "person.3")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.textSecondary)
            
            VStack(spacing: 12) {
                Text("No People Yet")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Add your first person to start collecting gift ideas")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingAddPerson = true }) {
                Text("Add Person")
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
            
            Text("Nothing Found")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
        }
    }
    
    private var addPersonSheet: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 24) {
                    Text("Add New Person")
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.textPrimary)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    TextField("Enter name", text: $newPersonName)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textPrimary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(AppColors.cardBackground)
                        .cornerRadius(12)
                }
                
                HStack(spacing: 16) {
                    Button {
                        showingAddPerson = false
                        newPersonName = ""
                    } label: {
                        Text("Cancel")
                            .font(AppFonts.buttonMedium)
                            .foregroundColor(AppColors.textSecondary)
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .background(AppColors.cardBackground)
                            .cornerRadius(24)
                    }
                    
                    Button {
                        viewModel.addPerson(name: newPersonName)
                        showingAddPerson = false
                        newPersonName = ""
                    } label: {
                        Text("Add")
                            .font(AppFonts.buttonMedium)
                            .foregroundColor(AppColors.primaryBlue)
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .background(AppColors.primaryYellow)
                            .cornerRadius(24)
                    }
                    .disabled(newPersonName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.bottom, 6)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .presentationDetents([.height(240)])
    }
}

enum PeopleSortOption {
    case name
    case ideasCount
}
