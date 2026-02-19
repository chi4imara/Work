import SwiftUI

struct JewelryDetailView: View {
    let jewelryId: UUID
    @ObservedObject var jewelryStore: JewelryStore
    @ObservedObject var setsStore: SetsStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var showingSetCreation = false
    
    var jewelry: Jewelry? {
        jewelryStore.getJewelry(by: jewelryId)
    }
    
    var body: some View {
        Group {
            if let jewelry = jewelry {
                NavigationView {
                    ZStack {
                        AnimatedBackground()
                        
                        ScrollView {
                            VStack(spacing: 24) {
                                if let imageName = jewelry.imageName, !imageName.isEmpty {
                                    PhotoDisplaySection(imageName: imageName)
                                }
                                
                                VStack(spacing: 20) {
                                    InfoSection(
                                        title: "Details",
                                        content: [
                                            InfoRow(label: "Type", value: jewelry.type.rawValue, icon: jewelry.type.icon),
                                            InfoRow(label: "Suitable for", value: jewelry.suitableFor.isEmpty ? "Not specified" : jewelry.suitableFor, icon: "tag")
                                        ]
                                    )
                                    
                                    if !jewelry.notes.isEmpty {
                                        NotesSection(notes: jewelry.notes)
                                    }
                                    
                                    ActionButtonsSection(
                                        jewelryId: jewelryId,
                                        jewelryStore: jewelryStore,
                                        onAddToSet: {
                                            showingSetCreation = true
                                        },
                                        onEdit: {
                                            showingEditView = true
                                        },
                                        onDelete: {
                                            showingDeleteAlert = true
                                        }
                                    )
                                }
                                .padding(.horizontal, 20)
                                
                                Spacer(minLength: 50)
                            }
                            .padding(.top, 20)
                        }
                    }
                    .navigationTitle(jewelry.name)
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                dismiss()
                            }
                            .foregroundColor(ColorTheme.accentYellow)
                        }
                    }
                    .preferredColorScheme(.dark)
                }
                .sheet(isPresented: $showingEditView) {
                    if let jewelryToEdit = jewelryStore.getJewelry(by: jewelryId) {
                        AddEditJewelryView(jewelryStore: jewelryStore, editingJewelry: jewelryToEdit)
                    }
                }
                .sheet(isPresented: $showingSetCreation) {
                    CreateSetView(
                        jewelryStore: jewelryStore,
                        setsStore: setsStore,
                        preselectedJewelryId: jewelry.id
                    )
                }
                .alert("Delete Jewelry", isPresented: $showingDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        if let jewelry = jewelryStore.getJewelry(by: jewelryId) {
                            jewelryStore.deleteJewelry(jewelry)
                            dismiss()
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    if let jewelry = jewelryStore.getJewelry(by: jewelryId) {
                        Text("Are you sure you want to delete \"\(jewelry.name)\"? This action cannot be undone.")
                    }
                }
            }
        }
    }
}

struct PhotoDisplaySection: View {
    let imageName: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(ColorTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(ColorTheme.cardBorder, lineWidth: 1)
                )
                .frame(width: 200, height: 200)
            
            AsyncJewelryImage(imageName: imageName, placeholder: "photo", size: CGSize(width: 200, height: 200))
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

struct InfoSection: View {
    let title: String
    let content: [InfoRow]
    
    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.lumierepolis(20, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                ForEach(content, id: \.label) { row in
                    InfoRowView(row: row)
                }
            }
        }
    }
}

struct InfoRow {
    let label: String
    let value: String
    let icon: String
}

struct InfoRowView: View {
    let row: InfoRow
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: row.icon)
                .font(.system(size: 20))
                .foregroundColor(ColorTheme.accentYellow)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(row.label)
                    .font(.lumierepolis(14, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text(row.value)
                    .font(.lumierepolis(14))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(ColorTheme.cardBorder, lineWidth: 1)
                )
        )
    }
}

struct NotesSection: View {
    let notes: String
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Notes")
                .font(.lumierepolis(20, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "note.text")
                        .font(.system(size: 16))
                        .foregroundColor(ColorTheme.accentYellow)
                    
                    Text("Additional Notes")
                        .font(.lumierepolis(14, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Spacer()
                }
                
                Text(notes)
                    .font(.lumierepolis(14))
                    .foregroundColor(ColorTheme.secondaryText)
                    .lineSpacing(4)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorTheme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ColorTheme.cardBorder, lineWidth: 1)
                    )
            )
        }
    }
}

struct ActionButtonsSection: View {
    let jewelryId: UUID
    @ObservedObject var jewelryStore: JewelryStore
    let onAddToSet: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var jewelry: Jewelry? {
        jewelryStore.getJewelry(by: jewelryId)
    }
    
    var isFavorite: Bool {
        guard let jewelry = jewelry else { return false }
        return jewelryStore.isFavorite(jewelry)
    }
    
    var body: some View {
        Group {
            if let jewelry = jewelry {
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        ActionButton(
                            title: isFavorite ? "Remove from Favorites" : "Add to Favorites",
                            icon: isFavorite ? "heart.fill" : "heart",
                            backgroundColor: isFavorite ? ColorTheme.accentYellow.opacity(0.2) : ColorTheme.buttonSecondary,
                            foregroundColor: isFavorite ? ColorTheme.accentYellow : ColorTheme.buttonSecondaryText,
                            action: {
                                jewelryStore.toggleFavorite(jewelry)
                            }
                        )
                        
                        ActionButton(
                            title: "Add to Set",
                            icon: "square.stack.3d.up",
                            backgroundColor: ColorTheme.buttonPrimary,
                            foregroundColor: ColorTheme.buttonText,
                            action: onAddToSet
                        )
                    }
                    
                    HStack(spacing: 12) {
                        ActionButton(
                            title: "Edit",
                            icon: "pencil",
                            backgroundColor: ColorTheme.buttonSecondary,
                            foregroundColor: ColorTheme.buttonSecondaryText,
                            action: onEdit
                        )
                        
                        ActionButton(
                            title: "Delete",
                            icon: "trash",
                            backgroundColor: ColorTheme.error.opacity(0.2),
                            foregroundColor: ColorTheme.error,
                            action: onDelete
                        )
                    }
                }
            }
        }
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let backgroundColor: Color
    let foregroundColor: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .semibold))
                
                Text(title)
                    .font(.lumierepolis(13, weight: .bold))
            }
            .foregroundColor(foregroundColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(backgroundColor)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    let store = JewelryStore()
    let setsStore = SetsStore()
    let jewelry = Jewelry(
        name: "Diamond Earrings",
        type: .earrings,
        suitableFor: "Evening events",
        notes: "Beautiful diamond earrings perfect for special occasions."
    )
    store.addJewelry(jewelry)
    return JewelryDetailView(jewelryId: jewelry.id, jewelryStore: store, setsStore: setsStore)
}
