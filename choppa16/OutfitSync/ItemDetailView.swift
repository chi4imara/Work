import SwiftUI

struct ItemDetailView: View {
    let item: WardrobeItem
    @ObservedObject var viewModel: WardrobeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var currentStatus: ItemStatus
    
    init(item: WardrobeItem, viewModel: WardrobeViewModel) {
        self.item = item
        self.viewModel = viewModel
        self._currentStatus = State(initialValue: item.status)
    }
    
    var body: some View {
        ZStack {
            AppGradients.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Text(item.name)
                            .font(FontManager.playfairDisplay(size: 24, weight: .bold))
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 20) {
                            InfoChip(title: "Category", value: item.category.displayName, color: .primaryBlue)
                            InfoChip(title: "Season", value: item.season.displayName, color: .primaryPurple)
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.cardBackground)
                            .shadow(color: AppShadows.cardShadow, radius: 8, x: 0, y: 4)
                    )
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Status")
                            .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(.textPrimary)
                        
                        HStack(spacing: 12) {
                            ForEach(ItemStatus.allCases, id: \.rawValue) { status in
                                StatusToggleButton(
                                    status: status,
                                    isSelected: currentStatus == status
                                ) {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        currentStatus = status
                                        viewModel.updateItemStatus(item, newStatus: status)
                                    }
                                }
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.cardBackground)
                            .shadow(color: AppShadows.cardShadow, radius: 8, x: 0, y: 4)
                    )
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Comment")
                            .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(.textPrimary)
                        
                        if item.comment.isEmpty {
                            Text("No comment added. You can add styling tips or storage advice.")
                                .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                                .foregroundColor(.textSecondary)
                                .italic()
                        } else {
                            Text(item.comment)
                                .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                                .foregroundColor(.textPrimary)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.cardBackground)
                            .shadow(color: AppShadows.cardShadow, radius: 8, x: 0, y: 4)
                    )
                    
                    VStack(spacing: 12) {
                        Button(action: { showingEditView = true }) {
                            HStack {
                                Image(systemName: "pencil")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Edit Item")
                                    .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.textOnDark)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.primaryPurple)
                                    .shadow(color: AppShadows.buttonShadow, radius: 4, x: 0, y: 2)
                            )
                        }
                        
                        Button(action: { showingDeleteAlert = true }) {
                            HStack {
                                Image(systemName: "trash")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Delete Item")
                                    .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.textOnDark)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.accentOrange)
                                    .shadow(color: AppShadows.buttonShadow, radius: 4, x: 0, y: 2)
                            )
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationTitle("Item Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditView) {
            AddItemView(viewModel: viewModel, editingItem: item)
        }
        .alert("Delete Item", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteItem(item)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this item? This action cannot be undone.")
        }
    }
}

struct InfoChip: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(FontManager.playfairDisplay(size: 12, weight: .medium))
                .foregroundColor(.textSecondary)
            
            Text(value)
                .font(FontManager.playfairDisplay(size: 14, weight: .semibold))
                .foregroundColor(color)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
    }
}

struct StatusToggleButton: View {
    let status: ItemStatus
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: statusIcon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? .textOnDark : statusColor)
                
                Text(status.displayName)
                    .font(FontManager.playfairDisplay(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .textOnDark : statusColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? statusColor : statusColor.opacity(0.1))
                    .shadow(color: AppShadows.cardShadow, radius: isSelected ? 4 : 2, x: 0, y: 2)
            )
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
    
    private var statusColor: Color {
        switch status {
        case .inUse:
            return .accentGreen
        case .store:
            return .primaryBlue
        case .buy:
            return .accentOrange
        }
    }
    
    private var statusIcon: String {
        switch status {
        case .inUse:
            return "checkmark.circle.fill"
        case .store:
            return "archivebox.fill"
        case .buy:
            return "cart.fill"
        }
    }
}
