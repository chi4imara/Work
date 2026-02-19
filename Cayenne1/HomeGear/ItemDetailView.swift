import SwiftUI

struct ItemDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: InventoryViewModel
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    let itemId: UUID
    
    private var item: InventoryItem? {
        viewModel.getItem(by: itemId)
    }
    
    var body: some View {
        Group {
            if let item = item {
                NavigationView {
                    ZStack {
                        AppColors.backgroundGradient
                            .ignoresSafeArea()
                        
                        ScrollView {
                            VStack(spacing: 25) {
                                headerCard(item: item)
                                
                                detailsSection(item: item)
                                
                                actionButtons(item: item)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 20)
                        }
                    }
                    .navigationTitle(item.name)
                    .navigationBarTitleDisplayMode(.large)
                    .navigationBarBackButtonHidden()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Back") {
                                dismiss()
                            }
                            .foregroundColor(AppColors.accentText)
                        }
                    }
                }
                .sheet(isPresented: $showingEditView) {
                    if let currentItem = viewModel.getItem(by: itemId) {
                        EditItemView(item: currentItem) { updatedItem in
                            viewModel.updateItem(updatedItem)
                        }
                    }
                }
                .alert("Delete Item?", isPresented: $showingDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        if let currentItem = viewModel.getItem(by: itemId) {
                            viewModel.deleteItem(currentItem)
                            dismiss()
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("This action cannot be undone.")
                }
            } else {
                Text("Item not found")
                    .foregroundColor(AppColors.primaryText)
            }
        }
    }
    
    private func headerCard(item: InventoryItem) -> some View {
        VStack(spacing: 15) {
            HStack {
                ZStack {
                    Circle()
                        .fill(AppColors.lightBlue.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: categoryIcon(for: item.category))
                        .font(.system(size: 28, weight: .light))
                        .foregroundColor(AppColors.lightBlue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.playfairDisplay(24, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(2)
                    
                    Text(item.category.displayName)
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(AppColors.accentText)
                }
                
                Spacer()
            }
            
            HStack {
                StatusBadge(status: item.status)
                Spacer()
            }
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(20)
        .shadow(color: AppColors.shadowColor, radius: 10, x: 0, y: 5)
    }
    
    private func detailsSection(item: InventoryItem) -> some View {
        VStack(spacing: 15) {
            DetailCard(
                title: "Storage Location",
                content: item.location,
                icon: "location.fill"
            )
            
            if !item.comment.isEmpty {
                DetailCard(
                    title: "Comment",
                    content: item.comment,
                    icon: "text.alignleft"
                )
            }
            
            DetailCard(
                title: "Created",
                content: formatDate(item.dateCreated),
                icon: "calendar"
            )
            
            if item.dateModified != item.dateCreated {
                DetailCard(
                    title: "Last Modified",
                    content: formatDate(item.dateModified),
                    icon: "clock"
                )
            }
        }
    }
    
    private func actionButtons(item: InventoryItem) -> some View {
        VStack(spacing: 15) {
            Button(action: { showingEditView = true }) {
                HStack(spacing: 10) {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Edit")
                        .font(.playfairDisplay(18, weight: .semibold))
                }
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColors.buttonGradient)
                .cornerRadius(25)
                .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
            }
            
            Button(action: { showingDeleteAlert = true }) {
                HStack(spacing: 10) {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Delete")
                        .font(.playfairDisplay(18, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [AppColors.brokenStatus, AppColors.brokenStatus.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(25)
                .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
            }
        }
        .padding(.top, 10)
    }
    
    private func categoryIcon(for category: ItemCategory) -> String {
        switch category {
        case .tools: return "wrench.and.screwdriver"
        case .gadgets: return "iphone"
        case .parts: return "gearshape"
        case .equipment: return "desktopcomputer"
        case .accessories: return "cable.connector"
        case .other: return "archivebox"
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct DetailCard: View {
    let title: String
    let content: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.lightBlue)
                    .frame(width: 20)
                
                Text(title)
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            
            Text(content)
                .font(.playfairDisplay(16, weight: .regular))
                .foregroundColor(AppColors.secondaryText)
                .lineLimit(nil)
                .padding(.leading, 30)
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(15)
        .shadow(color: AppColors.shadowColor, radius: 5, x: 0, y: 2)
    }
}

#Preview {
    let viewModel = InventoryViewModel()
    let testItem = InventoryItem(
        name: "Drill",
        category: .tools,
        location: "Garage, top shelf",
        status: .working,
        comment: "Has charger and two batteries"
    )
    viewModel.addItem(testItem)
    
    return ItemDetailView(
        viewModel: viewModel,
        itemId: testItem.id
    )
}
