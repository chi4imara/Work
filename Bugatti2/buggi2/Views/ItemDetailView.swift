import SwiftUI

struct ItemDetailView: View {
    let itemId: UUID
    @EnvironmentObject var inventoryViewModel: InventoryViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var item: Item? {
        inventoryViewModel.item(byId: itemId)
    }
    
    var body: some View {
        ZStack {
            GridBackgroundView()
            
            if let item = item {
                itemDetailContent(item: item)
            } else {
                itemNotFoundContent
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEditView) {
            if let item = item {
                EditItemView(item: item)
            } else {
                EmptyView()
            }
        }
        .alert("Delete Item", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let item = item {
                    inventoryViewModel.deleteItem(item)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } message: {
            if let item = item {
                Text("Are you sure you want to delete \"\(item.name)\"? This action cannot be undone.")
            }
        }
    }
    
    private func itemDetailContent(item: Item) -> some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("Back")
                            .font(.playfairDisplay(16, weight: .medium))
                    }
                    .foregroundColor(AppColors.primaryTextWhite)
                }
                
                Spacer()
                
                Text("Item Details")
                    .font(.playfairDisplay(20, weight: .bold))
                    .foregroundColor(AppColors.primaryTextWhite)
                
                Spacer()
                
                Menu {
                    Button(action: {
                        showingEditView = true
                    }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive, action: {
                        showingDeleteAlert = true
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.primaryTextWhite)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Item Name")
                                .font(.playfairDisplay(14, weight: .semibold))
                                .foregroundColor(AppColors.secondaryTextWhite)
                                .textCase(.uppercase)
                            
                            Text(item.name)
                                .font(.playfairDisplay(24, weight: .bold))
                                .foregroundColor(AppColors.primaryTextWhite)
                        }
                        
                        Divider()
                            .background(AppColors.gridWhite.opacity(0.3))
                        
                        DetailRowView(
                            icon: "location.fill",
                            title: "Storage Location",
                            value: item.location,
                            iconColor: Color.blue
                        )
                        
                        DetailRowView(
                            icon: "person.fill",
                            title: "Owner",
                            value: item.owner,
                            iconColor: AppColors.primaryYellow
                        )
                        
                        if !item.notes.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 8) {
                                    Image(systemName: "note.text")
                                        .font(.system(size: 16))
                                        .foregroundColor(AppColors.softOrange)
                                    Text("Notes")
                                        .font(.playfairDisplay(16, weight: .semibold))
                                        .foregroundColor(AppColors.primaryTextWhite)
                                }
                                
                                Text(item.notes)
                                    .font(.playfairDisplay(16, weight: .medium))
                                    .foregroundColor(AppColors.secondaryTextWhite)
                                    .lineSpacing(2)
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.cardBackground)
                            .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
                    )
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            showingEditView = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "pencil")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Edit")
                                    .font(.playfairDisplay(16, weight: .semibold))
                            }
                            .foregroundColor(AppColors.backgroundWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                LinearGradient(
                                    colors: [AppColors.primaryBlue, AppColors.accentGreen],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
                        }
                        
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "trash")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Delete")
                                    .font(.playfairDisplay(16, weight: .semibold))
                            }
                            .foregroundColor(AppColors.backgroundWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                LinearGradient(
                                    colors: [Color.red.opacity(0.8), Color.red],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
    }
    
    private var itemNotFoundContent: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "questionmark.circle")
                .font(.system(size: 60))
                .foregroundColor(AppColors.primaryTextWhite.opacity(0.7))
            Text("Item not found")
                .font(.playfairDisplay(20, weight: .bold))
                .foregroundColor(AppColors.primaryTextWhite)
            Text("This item may have been deleted.")
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(AppColors.secondaryTextWhite)
                .multilineTextAlignment(.center)
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Back to list")
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(AppColors.backgroundWhite)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(AppColors.primaryBlue)
                    .cornerRadius(12)
            }
            .padding(.top, 8)
            Spacer()
        }
    }
}

struct DetailRowView: View {
    let icon: String
    let title: String
    let value: String
    let iconColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(iconColor)
                Text(title)
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(AppColors.primaryTextWhite)
            }
            
            Text(value)
                .font(.playfairDisplay(18, weight: .medium))
                .foregroundColor(AppColors.secondaryTextWhite)
        }
    }
}

#Preview {
    NavigationView {
        ItemDetailView(itemId: Item.sampleItems[0].id)
            .environmentObject(InventoryViewModel())
    }
}
