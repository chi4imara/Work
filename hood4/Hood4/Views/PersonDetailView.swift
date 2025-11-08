import SwiftUI

struct PersonDetailView: View {
    let personId: UUID
    @ObservedObject var viewModel: GiftManagerViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingAddIdea = false
    @State private var showingEditPerson = false
    @State private var selectedIdeaForDetail: GiftIdea?
    @State private var newName = ""
    @State private var sortOption: IdeasSortOption = .dateCreated
    
    init(person: Person, viewModel: GiftManagerViewModel) {
        self.personId = person.id
        self.viewModel = viewModel
    }
    
    private var person: Person? {
        viewModel.getPerson(by: personId)
    }
    
    private var personIdeas: [GiftIdea] {
        guard let person = person else { return [] }
        let ideas = viewModel.getGiftIdeas(for: person.id)
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
    
    private var stats: (ideas: Int, purchased: Int, gifted: Int, nextEventDate: Date?) {
        guard let person = person else { return (0, 0, 0, nil) }
        return viewModel.getPersonStats(person)
    }
    
    private var budgetStats: (total: Double, average: Double, max: Double, min: Double, count: Int) {
        viewModel.getBudgetStats(for: personId)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            if let person = person {
                VStack(spacing: 0) {
                    headerView
                    
                    if personIdeas.isEmpty {
                        emptyStateView
                    } else {
                        ideasListView
                    }
                }
            } else {
                VStack {
                    Spacer()
                    Text("Person not found")
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.textPrimary)
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showingAddIdea) {
            AddEditIdeaView(
                viewModel: viewModel,
                editingIdea: nil,
                preselectedPersonId: personId
            )
        }
        .sheet(isPresented: $showingEditPerson) {
            editPersonSheet
        }
        .sheet(item: $selectedIdeaForDetail) { idea in
            IdeaDetailView(viewModel: viewModel, giftIdea: idea)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            if let person = person {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.textPrimary)
                        .frame(width: 44, height: 44)
                        .background(AppColors.cardBackground)
                        .cornerRadius(22)
                }
                
                Spacer()
                
                Text("Person Detail")
                    .font(AppFonts.title1)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Menu {
                    Button(action: { showingEditPerson = true }) {
                        Label("Edit Person", systemImage: "pencil")
                    }
                    
                    Menu("Sort Ideas") {
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
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.textPrimary)
                        .frame(width: 44, height: 44)
                        .background(AppColors.cardBackground)
                        .cornerRadius(22)
                }
            }
            
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(AppColors.primaryYellow.opacity(0.2))
                            .frame(width: 80, height: 80)
                        
                        Text(String(person.name.prefix(1).uppercased()))
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(AppColors.primaryYellow)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(person.name)
                            .font(AppFonts.title2)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("Added \(person.createdAt, formatter: dateFormatter)")
                            .font(AppFonts.caption1)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Spacer()
                }
                
                HStack(spacing: 16) {
                    StatsBadge(
                        icon: "lightbulb",
                        count: stats.ideas,
                        color: AppColors.statusIdea,
                        label: "Ideas"
                    )
                    
                    StatsBadge(
                        icon: "cart",
                        count: stats.purchased,
                        color: AppColors.statusPurchased,
                        label: "Purchased"
                    )
                    
                    StatsBadge(
                        icon: "gift",
                        count: stats.gifted,
                        color: AppColors.statusGifted,
                        label: "Gifted"
                    )
                }
                
                if budgetStats.count > 0 {
                    VStack(spacing: 8) {
                        HStack {
                            Text("Budget Statistics")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.textPrimary)
                            Spacer()
                        }
                        
                        HStack(spacing: 16) {
                            BudgetStatItem(
                                title: "Total",
                                value: String(format: "$%.2f", budgetStats.total)
                            )
                            
                            BudgetStatItem(
                                title: "Average",
                                value: String(format: "$%.2f", budgetStats.average)
                            )
                            
                            BudgetStatItem(
                                title: "Max",
                                value: String(format: "$%.2f", budgetStats.max)
                            )
                        }
                    }
                    .padding(.top, 8)
                }
                
                if let nextEventDate = stats.nextEventDate {
                    HStack(spacing: 8) {
                        Image(systemName: "calendar")
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.primaryYellow)
                        
                        Text("Next Event: \(nextEventDate, formatter: dateFormatter)")
                            .font(AppFonts.callout)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Spacer()
                    }
                    .padding(.top, 8)
                }
            }
            .padding(20)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
            
            Button(action: { showingAddIdea = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Add Gift Idea")
                        .font(AppFonts.buttonMedium)
                }
                .foregroundColor(AppColors.primaryBlue)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(AppColors.primaryYellow)
                .cornerRadius(24)
            }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
    
    private var ideasListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(personIdeas) { idea in
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
                
                Text("Add your first gift idea for \(person?.name ?? "this person")")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingAddIdea = true }) {
                Text("Add First Idea")
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
    
    private var editPersonSheet: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 24) {
                Text("Edit Person")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.textPrimary)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    TextField("Enter name", text: $newName)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textPrimary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(AppColors.cardBackground)
                        .cornerRadius(12)
                }
                
                HStack(spacing: 16) {
                    Button {
                        showingEditPerson = false
                        newName = ""
                    } label: {
                        Text("Cancel")
                            .font(AppFonts.buttonMedium)
                            .foregroundColor(AppColors.textSecondary)
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .background(AppColors.cardBackground)
                            .cornerRadius(24)
                    }
                    
                    Button {
                        if let person = person {
                            viewModel.updatePerson(person, newName: newName)
                        }
                        showingEditPerson = false
                        newName = ""
                    } label: {
                        Text("Save")
                            .font(AppFonts.buttonMedium)
                            .foregroundColor(AppColors.primaryBlue)
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .background(AppColors.primaryYellow)
                            .cornerRadius(24)
                    }
                    .disabled(newName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.bottom, 6)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .presentationDetents([.height(240)])
        .onAppear {
            newName = person?.name ?? ""
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}


#Preview {
    let viewModel = GiftManagerViewModel()
    let person = Person(name: "John Doe")
    
    return PersonDetailView(
        person: person,
        viewModel: viewModel
    )
}
