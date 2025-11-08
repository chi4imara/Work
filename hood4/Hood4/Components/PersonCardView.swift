import SwiftUI

struct PersonCardView: View {
    let person: Person
    @ObservedObject var viewModel: GiftManagerViewModel
    let onTap: () -> Void
    let onAddIdea: () -> Void
    
    @State private var showingDeleteAlert = false
    @State private var showingRenameAlert = false
    @State private var newName = ""
    @State private var offset = CGSize.zero
    @State private var isSwiped = false
    
    private var stats: (ideas: Int, purchased: Int, gifted: Int, nextEventDate: Date?) {
        viewModel.getPersonStats(person)
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
                        newName = person.name
                        showingRenameAlert = true
                    }) {
                        VStack {
                            Image(systemName: "pencil")
                                .font(.system(size: 20, weight: .medium))
                            Text("Rename")
                                .font(AppFonts.caption1)
                        }
                        .foregroundColor(.white)
                        .frame(width: 80)
                        .frame(maxHeight: .infinity)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.orange)
                .cornerRadius(16)
            }
            
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.primaryYellow.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Text(String(person.name.prefix(1).uppercased()))
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.primaryYellow)
                        .fontWeight(.bold)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(person.name)
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(1)
                    
                    HStack(spacing: 8) {
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
                    
                    if let nextEventDate = stats.nextEventDate {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.textTertiary)
                            
                            Text("Next: \(nextEventDate, formatter: dateFormatter)")
                                .font(AppFonts.caption1)
                                .foregroundColor(AppColors.textTertiary)
                        }
                    }
                }
                
                Spacer()
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
                                showingRenameAlert = true
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
        .alert("Delete Person", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { resetCard() }
            Button("Delete", role: .destructive) {
                viewModel.deletePerson(person)
            }
        } message: {
            Text("Are you sure you want to delete \(person.name)? This will also delete all their gift ideas.")
        }
        .alert("Rename Person", isPresented: $showingRenameAlert) {
            TextField("Name", text: $newName)
            Button("Cancel", role: .cancel) { resetCard() }
            Button("Save") {
                viewModel.updatePerson(person, newName: newName)
                resetCard()
            }
        } message: {
            Text("Enter a new name for \(person.name)")
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

struct StatsBadge: View {
    let icon: String
    let count: Int
    let color: Color
    let label: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(color)
            
            Text("\(count)")
                .font(AppFonts.caption2)
                .foregroundColor(AppColors.textPrimary)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.2))
        .cornerRadius(8)
    }
}

#Preview {
    VStack {
        PersonCardView(
            person: Person(name: "John Doe"),
            viewModel: GiftManagerViewModel(),
            onTap: {},
            onAddIdea: {}
        )
    }
    .padding()
    .background(BackgroundView())
}
