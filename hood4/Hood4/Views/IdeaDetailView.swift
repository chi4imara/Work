import SwiftUI

struct IdeaDetailView: View {
    @ObservedObject var viewModel: GiftManagerViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var giftIdea: GiftIdea
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    init(viewModel: GiftManagerViewModel, giftIdea: GiftIdea) {
        self.viewModel = viewModel
        self._giftIdea = State(initialValue: giftIdea)
    }
    
    private var person: Person? {
        viewModel.getPerson(by: giftIdea.personId)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerCardView
                        
                        if giftIdea.eventType != nil || giftIdea.eventDate != nil {
                            eventSectionView
                        }
                        
                        if giftIdea.budget != nil {
                            budgetSectionView
                        }
                        
                        if let store = giftIdea.store, !store.isEmpty {
                            storeSectionView
                        }
                        
                        if let notes = giftIdea.notes, !notes.isEmpty {
                            notesSectionView
                        }
                        
                        actionButtonsView
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Gift Idea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        showingEditView = true
                    }
                    .foregroundColor(AppColors.primaryYellow)
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            AddEditIdeaView(
                viewModel: viewModel,
                editingIdea: giftIdea,
                preselectedPersonId: giftIdea.personId
            )
        }
        .alert("Delete Idea", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteGiftIdea(giftIdea)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this gift idea?")
        }
        .onReceive(viewModel.$giftIdeas) { _ in
            if let updatedIdea = viewModel.giftIdeas.first(where: { $0.id == giftIdea.id }) {
                giftIdea = updatedIdea
            }
        }
    }
    
    private var headerCardView: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                if let person = person {
                    HStack {
                        Text("For:")
                            .font(AppFonts.callout)
                            .foregroundColor(AppColors.textSecondary)
                        
                        Text(person.name)
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.primaryYellow)
                        
                        Spacer()
                    }
                }
                
                HStack {
                    Text(giftIdea.title)
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
            }
            
            HStack {
                StatusBadge(status: giftIdea.status)
                Spacer()
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
    
    private var eventSectionView: some View {
        DetailSectionView(title: "Event", icon: "calendar") {
            VStack(alignment: .leading, spacing: 8) {
                if let eventType = giftIdea.eventType {
                    DetailRowView(label: "Type", value: eventType.displayName)
                }
                
                if let eventDate = giftIdea.eventDate {
                    DetailRowView(label: "Date", value: eventDate.formatted(date: .abbreviated, time: .omitted))
                }
            }
        }
    }
    
    private var budgetSectionView: some View {
        DetailSectionView(title: "Budget", icon: "dollarsign.circle") {
            if let formattedBudget = giftIdea.formattedBudget {
                Text(formattedBudget)
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.primaryYellow)
                    .fontWeight(.semibold)
            }
        }
    }
    
    private var storeSectionView: some View {
        DetailSectionView(title: "Store", icon: "storefront") {
            Text(giftIdea.store!)
                .font(AppFonts.body)
                .foregroundColor(AppColors.textPrimary)
        }
    }
    
    private var notesSectionView: some View {
        DetailSectionView(title: "Notes", icon: "note.text") {
            Text(giftIdea.notes!)
                .font(AppFonts.body)
                .foregroundColor(AppColors.textPrimary)
                .multilineTextAlignment(.leading)
        }
    }
    
    private var actionButtonsView: some View {
        VStack(spacing: 16) {
            Button(action: { showingEditView = true }) {
                HStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Edit Idea")
                        .font(AppFonts.buttonMedium)
                }
                .foregroundColor(AppColors.primaryBlue)
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(AppColors.primaryYellow)
                .cornerRadius(24)
            }
            
            Button(action: { showingDeleteAlert = true }) {
                HStack {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Delete Idea")
                        .font(AppFonts.buttonMedium)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(Color.red)
                .cornerRadius(24)
            }
        }
    }
}

struct StatusBadge: View {
    let status: GiftStatus
    
    private var backgroundColor: Color {
        switch status {
        case .idea:
            return AppColors.statusIdea
        case .purchased:
            return AppColors.statusPurchased
        case .gifted:
            return AppColors.statusGifted
        }
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: status.icon)
                .font(.system(size: 14, weight: .medium))
            
            Text(status.displayName)
                .font(AppFonts.callout)
                .fontWeight(.medium)
        }
        .foregroundColor(AppColors.primaryBlue)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(backgroundColor)
        .cornerRadius(20)
    }
}

struct DetailSectionView<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryYellow)
                
                Text(title)
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            
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

struct DetailRowView: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label + ":")
                .font(AppFonts.callout)
                .foregroundColor(AppColors.textSecondary)
            
            Text(value)
                .font(AppFonts.callout)
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
        }
    }
}

#Preview {
    let viewModel = GiftManagerViewModel()
    let person = Person(name: "John Doe")
    var idea = GiftIdea(personId: person.id, title: "Wireless Headphones")
    idea.status = .purchased
    idea.eventType = .birthday
    idea.eventDate = Date()
    idea.budget = 150.00
    idea.store = "Apple Store"
    idea.notes = "He mentioned wanting noise-canceling ones"
    
    return IdeaDetailView(viewModel: viewModel, giftIdea: idea)
}
