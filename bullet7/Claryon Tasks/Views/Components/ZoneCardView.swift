import SwiftUI

struct ZoneCardView: View {
    let zone: CleaningZone
    let onToggleCompletion: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onTap: () -> Void
    
    @State private var showingDeleteAlert = false
    @State private var showingActionSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Button(action: onToggleCompletion) {
                    Image(systemName: zone.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(zone.isCompleted ? .successGreen : .accentYellow)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(zone.name)
                        .font(.titleSmall)
                        .foregroundColor(zone.isCompleted ? .completedText : .primaryWhite)
                        .strikethrough(zone.isCompleted)
                    
                    Text(zone.category)
                        .font(.bodySmall)
                        .foregroundColor(.secondaryText)
                    
                    if !zone.description.isEmpty {
                        Text(zone.description)
                            .font(.bodySmall)
                            .foregroundColor(.secondaryText)
                            .lineLimit(2)
                    }
                    
                    Text(zone.formattedLastCleanedDate)
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                }
                
                Spacer()
                
                Button(action: { showingActionSheet = true }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondaryText)
                        .padding(8)
                }
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .onTapGesture {
            onTap()
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button("Delete", role: .destructive) {
                showingDeleteAlert = true
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button("Edit") {
                onEdit()
            }
            .tint(.accentYellow)
        }
        .onLongPressGesture {
            showingActionSheet = true
        }
        .confirmationDialog(zone.name, isPresented: $showingActionSheet) {
            Button("Open") { onTap() }
            Button("Delete", role: .destructive) { showingDeleteAlert = true }
            Button("Cancel", role: .cancel) { }
        }
        .alert("Delete Zone", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) { onDelete() }
        } message: {
            Text("Are you sure you want to delete \"\(zone.name)\"?")
        }
    }
}

#Preview {
    ZStack {
        Color.backgroundGradient
            .ignoresSafeArea()
        
        VStack {
            ZoneCardView(
                zone: CleaningZone(
                    name: "Kitchen",
                    category: "Room",
                    description: "Clean counters, wash dishes, mop floor",
                    isCompleted: false
                ),
                onToggleCompletion: {},
                onEdit: {},
                onDelete: {},
                onTap: {}
            )
            
            ZoneCardView(
                zone: CleaningZone(
                    name: "Bathroom",
                    category: "Room",
                    description: "Clean sink, mirror, floor",
                    isCompleted: true,
                    lastCleanedDate: Date()
                ),
                onToggleCompletion: {},
                onEdit: {},
                onDelete: {},
                onTap: {}
            )
        }
        .padding()
    }
}
