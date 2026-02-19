import SwiftUI

struct InventoryView: View {
    @EnvironmentObject var inventoryViewModel: InventoryViewModel
    @State private var showingAddItem = false
    
    var body: some View {
        ZStack {
            GridBackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Inventory")
                        .font(.playfairDisplay(28, weight: .bold))
                        .foregroundColor(AppColors.primaryTextWhite)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddItem = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Add")
                                .font(.playfairDisplay(16, weight: .semibold))
                        }
                        .foregroundColor(AppColors.backgroundWhite)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(
                                colors: [AppColors.primaryBlue, AppColors.accentGreen],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(20)
                        .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if inventoryViewModel.items.isEmpty {
                    EmptyInventoryView(showingAddItem: $showingAddItem)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(inventoryViewModel.items) { item in
                                NavigationLink(destination: ItemDetailView(itemId: item.id).environmentObject(inventoryViewModel)) {
                                    ItemCardView(item: item)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddItem) {
            AddItemView()
        }
    }
}

struct EmptyInventoryView: View {
    @Binding var showingAddItem: Bool
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.primaryYellow.opacity(0.2), AppColors.primaryBlue.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: "archivebox")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(AppColors.primaryTextWhite)
            }
            
            VStack(spacing: 16) {
                Text("Here will be your items")
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(AppColors.primaryTextWhite)
                    .multilineTextAlignment(.center)
                
                Text("Add your first item to record what you have.")
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(AppColors.secondaryTextWhite)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: {
                showingAddItem = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 20))
                    Text("Add Item")
                        .font(.playfairDisplay(18, weight: .semibold))
                }
                .foregroundColor(AppColors.backgroundWhite)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [AppColors.primaryBlue, AppColors.accentGreen],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(25)
                .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
            }
            
            Spacer()
        }
    }
}

struct ItemCardView: View {
    let item: Item
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.name)
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(AppColors.primaryTextWhite)
                        .lineLimit(2)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "location")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.primaryTextWhite)
                        Text(item.location)
                            .font(.playfairDisplay(14, weight: .medium))
                            .foregroundColor(AppColors.secondaryTextWhite)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.primaryTextWhite.opacity(0.8))
            }
            
            if !item.notes.isEmpty {
                Text(item.notes)
                    .font(.playfairDisplay(14, weight: .regular))
                    .foregroundColor(AppColors.secondaryTextWhite)
                    .lineLimit(2)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    InventoryView()
        .environmentObject(InventoryViewModel())
}
