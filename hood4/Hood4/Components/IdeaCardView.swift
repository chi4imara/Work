import SwiftUI

struct IdeaCardView: View {
    let idea: GiftIdea
    @ObservedObject var viewModel: GiftManagerViewModel
    let onTap: () -> Void
    
    @State private var showingDeleteAlert = false
    @State private var showingStatusAlert = false
    @State private var offset = CGSize.zero
    @State private var isSwiped = false
    
    private var person: Person? {
        viewModel.getPerson(by: idea.personId)
    }
    
    var body: some View {
        ZStack {
            if offset.width > 0 {
                HStack {
                    Button(action: { showingDeleteAlert = true }) {
                        VStack {
                            Image(systemName: "trash")
                                .font(.system(size: 20, weight: .medium))
                            Text("Delete")
                                .font(AppFonts.caption1)
                        }
                        .foregroundColor(.white)
                        .frame(width: 80)
                        .frame(maxHeight: .infinity)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.red)
                .cornerRadius(16)
            } else if offset.width < 0 {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        showingStatusAlert = true
                    }) {
                        VStack {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .font(.system(size: 20, weight: .medium))
                            Text("Status")
                                .font(AppFonts.caption1)
                        }
                        .foregroundColor(.white)
                        .frame(width: 80)
                        .frame(maxHeight: .infinity)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.green)
                .cornerRadius(16)
            }
            
            VStack(spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(idea.title)
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.textPrimary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                        
                        if let person = person {
                            Text(person.name)
                                .font(AppFonts.callout)
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 8) {
                        StatusBadgeSmall(status: idea.status)
                        
                        if let formattedBudget = idea.formattedBudget {
                            Text(formattedBudget)
                                .font(AppFonts.callout)
                                .foregroundColor(AppColors.primaryYellow)
                                .fontWeight(.semibold)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    if let eventType = idea.eventType, let eventDate = idea.eventDate {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.textTertiary)
                            
                            Text("\(eventType.displayName) - \(eventDate, formatter: dateFormatter)")
                                .font(AppFonts.caption1)
                                .foregroundColor(AppColors.textTertiary)
                            
                            Spacer()
                        }
                    } else if let eventType = idea.eventType {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.textTertiary)
                            
                            Text(eventType.displayName)
                                .font(AppFonts.caption1)
                                .foregroundColor(AppColors.textTertiary)
                            
                            Spacer()
                        }
                    } else if let eventDate = idea.eventDate {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.textTertiary)
                            
                            Text(eventDate, formatter: dateFormatter)
                                .font(AppFonts.caption1)
                                .foregroundColor(AppColors.textTertiary)
                            
                            Spacer()
                        }
                    }
                    
                    if let store = idea.store, !store.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "storefront")
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.textTertiary)
                            
                            Text(store)
                                .font(AppFonts.caption1)
                                .foregroundColor(AppColors.textTertiary)
                                .lineLimit(1)
                            
                            Spacer()
                        }
                    }
                }
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
            .offset(x: offset.width, y: 0)
            .contentShape(Rectangle())
            .highPriorityGesture(
                DragGesture(minimumDistance: 20, coordinateSpace: .local)
                    .onChanged { value in
                        withAnimation(.interactiveSpring(response: 0.3)) {
                            offset.width = value.translation.width
                            if abs(offset.width) > 120 {
                                offset.width = offset.width > 0 ? 120 : -120
                            }
                        }
                    }
                    .onEnded { value in
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            if value.translation.width > 80 {
                                offset.width = 120
                                isSwiped = true
                                showingDeleteAlert = true
                            } else if value.translation.width < -80 {
                                offset.width = -120
                                isSwiped = true
                                showingStatusAlert = true
                            } else {
                                resetCard()
                            }
                        }
                    }
            )
            .onTapGesture {
                if isSwiped {
                    resetCard()
                } else {
                    onTap()
                }
            }
        }
        .alert("Delete Idea", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { resetCard() }
            Button("Delete", role: .destructive) {
                viewModel.deleteGiftIdea(idea)
            }
        } message: {
            Text("Are you sure you want to delete this gift idea?")
        }
        .alert("Change Status", isPresented: $showingStatusAlert) {
            Button("Cancel", role: .cancel) { resetCard() }
            
            ForEach(GiftStatus.allCases, id: \.self) { status in
                Button(status.displayName) {
                    viewModel.updateGiftIdeaStatus(idea, to: status)
                    resetCard()
                }
            }
        } message: {
            Text("Select new status for '\(idea.title)'")
        }
    }
    
    private func resetCard() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            offset = .zero
            isSwiped = false
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}

struct StatusBadgeSmall: View {
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
        HStack(spacing: 4) {
            Image(systemName: status.icon)
                .font(.system(size: 7, weight: .medium))
            
            Text(status.displayName)
                .font(Font.custom("Nunito-Regular", size: 7))
                .fontWeight(.medium)
        }
        .foregroundColor(AppColors.primaryBlue)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(backgroundColor)
        .cornerRadius(12)
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
    
    return VStack {
        IdeaCardView(
            idea: idea,
            viewModel: viewModel,
            onTap: {}
        )
    }
    .padding()
    .background(BackgroundView())
}
