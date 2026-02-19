import SwiftUI

struct ItemDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ItemsViewModel()
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    let itemId: UUID
    
    private var item: Item? {
        viewModel.items.first { $0.id == itemId }
    }
    
    var body: some View {
        Group {
            if let item = item {
                ZStack {
                    AnimatedBackground()
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            headerView
                            
                            VStack(spacing: 20) {
                                itemInfoView(item: item)
                                
                                if !item.characteristics.isEmpty {
                                    characteristicsView(item: item)
                                }
                                
                                if !item.notes.isEmpty {
                                    notesView(item: item)
                                }
                                
                                dateInfoView(item: item)
                            }
                            .padding(.horizontal, 20)
                            
                            Spacer(minLength: 100)
                        }
                    }
                    
                    VStack {
                        Spacer()
                        bottomButtonsView(item: item)
                    }
                }
                .navigationBarHidden(true)
                .sheet(isPresented: $showingEditView) {
                    EditItemView(item: item)
                }
                .alert("Delete Item", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        deleteItem(item: item)
                    }
                } message: {
                    Text("Are you sure you want to delete this item? This action cannot be undone.")
                }
            } else {
                ZStack {
                    AnimatedBackground()
                    VStack {
                        Text("Item not found")
                            .font(.playfairDisplay(20, weight: .semibold))
                            .foregroundColor(ColorTheme.textSecondary)
                    }
                }
                .navigationBarHidden(true)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
            }
            
            Spacer()
            
            Text("Item")
                .font(.playfairDisplay(24, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.clear)
            }
            .disabled(true)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private func itemInfoView(item: Item) -> some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(ColorTheme.lightBlue)
                    .frame(width: 80, height: 80)
                
                Image(systemName: item.category.icon)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
            }
            
            Text(item.name)
                .font(.playfairDisplay(28, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text(item.category.displayName)
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(ColorTheme.textSecondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(ColorTheme.lightBlue.opacity(0.5))
                )
        }
        .padding(.vertical, 20)
    }
    
    private func characteristicsView(item: Item) -> some View {
        InfoSectionView(
            title: "Characteristics",
            content: item.characteristics,
            icon: "list.bullet.clipboard"
        )
    }
    
    private func notesView(item: Item) -> some View {
        InfoSectionView(
            title: "Notes",
            content: item.notes,
            icon: "note.text"
        )
    }
    
    private func dateInfoView(item: Item) -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("Created:")
                    .font(.playfairDisplay(14, weight: .medium))
                    .foregroundColor(ColorTheme.textSecondary)
                
                Spacer()
                
                Text(item.dateCreated, style: .date)
                    .font(.playfairDisplay(14, weight: .medium))
                    .foregroundColor(ColorTheme.textPrimary)
            }
            
            if item.dateModified != item.dateCreated {
                HStack {
                    Text("Modified:")
                        .font(.playfairDisplay(14, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                    
                    Spacer()
                    
                    Text(item.dateModified, style: .date)
                        .font(.playfairDisplay(14, weight: .medium))
                        .foregroundColor(ColorTheme.textPrimary)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTheme.cardGradient)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(ColorTheme.lightBlue.opacity(0.3), lineWidth: 1)
                }
        )
    }
    
    private func bottomButtonsView(item: Item) -> some View {
        HStack(spacing: 16) {
            Button {
                showingDeleteAlert = true
            } label: {
                Text("Delete")
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                    )
            }
            
            Button {
                showingEditView = true
            } label: {
                Text("Edit")
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(ColorTheme.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(ColorTheme.primaryButtonGradient)
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    private func deleteItem(item: Item) {
        HapticManager.notification(.warning)
        viewModel.deleteItem(item)
        dismiss()
    }
}

struct InfoSectionView: View {
    let title: String
    let content: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
                
                Text(title)
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(ColorTheme.textPrimary)
            }
            
            Text(content)
                .font(.playfairDisplay(16, weight: .regular))
                .foregroundColor(ColorTheme.textSecondary)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTheme.cardGradient)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(ColorTheme.lightBlue.opacity(0.3), lineWidth: 1)
                }
        )
    }
}

#Preview {
    ItemDetailView(itemId: UUID())
}
