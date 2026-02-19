import SwiftUI

struct BagDetailView: View {
    @EnvironmentObject var bagViewModel: BagViewModel
    @Environment(\.dismiss) private var dismiss
    
    let bagId: UUID
    @State private var showingAddItem = false
    @State private var showingEditBag = false
    @State private var showingDeleteAlert = false
    
    var currentBag: Bag? {
        bagViewModel.getBag(by: bagId)
    }
    
    var bag: Bag {
        currentBag ?? Bag(name: "Unknown", type: .bag, description: "")
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(spacing: 24) {
                    BagInfoSection(bag: currentBag)
                    
                    ItemsSection(bag: currentBag, showingAddItem: $showingAddItem)
                    
                    ActionButtonsSection(
                        showingAddItem: $showingAddItem,
                        showingEditBag: $showingEditBag,
                        showingDeleteAlert: $showingDeleteAlert
                    )
                }
                .padding()
            }
        }
        .navigationTitle(bag.name.isEmpty ? "Bag Details" : bag.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    bagViewModel.toggleFavorite(bagId: bagId)
                }) {
                    Image(systemName: bagViewModel.isFavorite(bagId: bagId) ? "heart.fill" : "heart")
                        .foregroundColor(bagViewModel.isFavorite(bagId: bagId) ? AppColors.error : AppColors.yellow)
                }
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingAddItem) {
            if let bag = currentBag {
                AddItemView(bag: bag)
                    .environmentObject(bagViewModel)
            }
        }
        .sheet(isPresented: $showingEditBag) {
            if let bag = currentBag {
                AddEditBagView(editingBag: bag)
                    .environmentObject(bagViewModel)
            }
        }
        .alert("Delete Bag", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let bag = currentBag {
                    bagViewModel.deleteBag(bag)
                }
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this bag and all its items? This action cannot be undone.")
        }
    }
}

struct BagInfoSection: View {
    let bag: Bag?
    
    var displayBag: Bag {
        bag ?? Bag(name: "Unknown", type: .bag, description: "")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: displayBag.type.icon)
                    .font(.title)
                    .foregroundColor(AppColors.yellow)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(displayBag.type.displayName)
                        .font(.bellGothic(size: 18, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Created \(displayBag.createdAt.formatted(date: .abbreviated, time: .omitted))")
                        .font(.bellGothic(size: 14))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
            }
            
            if !displayBag.description.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Suitable for:")
                        .font(.bellGothic(size: 16, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(displayBag.description)
                        .font(.bellGothic(size: 14))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
        .cornerRadius(12)
    }
}

struct ItemsSection: View {
    let bag: Bag?
    @Binding var showingAddItem: Bool
    
    var displayBag: Bag {
        bag ?? Bag(name: "Unknown", type: .bag, description: "")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Items (\(displayBag.items.count))")
                    .font(.bellGothic(size: 20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Button(action: {
                    showingAddItem = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(AppColors.yellow)
                }
            }
            
            if displayBag.items.isEmpty {
                EmptyItemsView()
            } else {
                ItemsListView(items: displayBag.items)
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
        .cornerRadius(12)
    }
}

struct EmptyItemsView: View {
    var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "tray")
                    .font(.system(size: 40))
                    .foregroundColor(AppColors.yellow.opacity(0.6))
                
                VStack(spacing: 8) {
                    Text("No items in this bag yet")
                        .font(.bellGothic(size: 16, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Add items so you don't forget what's inside")
                        .font(.bellGothic(size: 14))
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.vertical, 20)
            
            Spacer()
        }
    }
}

struct ItemsListView: View {
    let items: [Item]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(items) { item in
                HStack {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 6))
                        .foregroundColor(AppColors.yellow)
                    
                    Text(item.name.isEmpty ? "Unnamed item" : item.name)
                        .font(.bellGothic(size: 16))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.vertical, 4)
            }
        }
    }
}

struct ActionButtonsSection: View {
    @Binding var showingAddItem: Bool
    @Binding var showingEditBag: Bool
    @Binding var showingDeleteAlert: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Button(action: {
                showingAddItem = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Item")
                }
                .font(.bellGothic(size: 16, weight: .bold))
                .foregroundColor(AppColors.buttonText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(AppColors.buttonPrimary)
                .cornerRadius(8)
            }
            
            HStack(spacing: 12) {
                Button(action: {
                    showingEditBag = true
                }) {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Edit Bag")
                    }
                    .font(.bellGothic(size: 16))
                    .foregroundColor(AppColors.primaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(AppColors.buttonSecondary)
                    .cornerRadius(8)
                }
                
                Button(action: {
                    showingDeleteAlert = true
                }) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete")
                    }
                    .font(.bellGothic(size: 16))
                    .foregroundColor(AppColors.error)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(AppColors.error.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        let testBag = Bag(name: "Work Bag", type: .bag, description: "For office days")
        BagDetailView(bagId: testBag.id)
            .environmentObject(BagViewModel())
    }
}
