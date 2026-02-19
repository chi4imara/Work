import SwiftUI

struct CollectionView: View {
    @EnvironmentObject private var accessoryViewModel: AccessoryViewModel
    @EnvironmentObject private var collectionViewModel: CollectionViewModel
    @State private var showingNewCollection = false
    @State private var selectedCollection: Collection?
    @State private var groupBy: GroupingOption = .category
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 0) {
                    if collectionViewModel.collections.isEmpty {
                        emptyStateView
                    } else {
                        contentView
                    }
                }
            }
            .navigationTitle("My Collection")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewCollection = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(AppColors.textBlue)
                    }
                }
            }
            .sheet(isPresented: $showingNewCollection) {
                NewCollectionView(collectionViewModel: collectionViewModel, accessoryViewModel: accessoryViewModel)
            }
            .sheet(item: $selectedCollection) { collection in
                CollectionDetailView(collection: collection, viewModel: collectionViewModel)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "heart.circle")
                .font(.system(size: 80))
                .foregroundColor(AppColors.textBlue.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("Your collection is empty")
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(AppColors.textBlue)
                
                Text("Start building your accessory collection by saving items you love")
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(AppColors.darkGray)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingNewCollection = true }) {
                Text("Add First Accessory")
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(AppColors.backgroundWhite)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(AppColors.buttonGradient)
                    .cornerRadius(AppConstants.cornerRadius)
            }
            .padding(.horizontal, AppConstants.cardPadding)
            
            Spacer()
        }
    }
    
    private var contentView: some View {
        VStack(spacing: 0) {
            groupingControls
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(collectionViewModel.collections) { collection in
                        CollectionCard(collection: collection) {
                            selectedCollection = collection
                        } onDelete: {
                            collectionViewModel.deleteCollection(collection)
                        }
                    }
                }
                .padding(.horizontal, AppConstants.cardPadding)
                .padding(.top, 16)
            }
        }
    }
    
    private var groupingControls: some View {
        HStack {
            Text("Group by:")
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(AppColors.textBlue)
            
            Picker("Group by", selection: $groupBy) {
                ForEach(GroupingOption.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, AppConstants.cardPadding)
        .padding(.vertical, 12)
        .background(AppColors.backgroundWhite.opacity(0.8))
    }
}

struct CollectionCard: View {
    let collection: Collection
    let onTap: () -> Void
    let onDelete: () -> Void
    @State private var showingDeleteAlert = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(collection.name)
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(AppColors.textBlue)
                        
                        Text("\(collection.accessories.count) items")
                            .font(.playfairDisplay(14, weight: .medium))
                            .foregroundColor(AppColors.darkGray)
                        
                        Text("Created \(collection.createdDate, style: .date)")
                            .font(.playfairDisplay(12, weight: .medium))
                            .foregroundColor(AppColors.darkGray.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    Menu {
                        Button("Share Collection") {
                            ShareHelper.shareCollection(collection)
                        }
                        
                        Button("Delete", role: .destructive) {
                            showingDeleteAlert = true
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(AppColors.textBlue)
                            .frame(width: 30, height: 30)
                    }
                }
                
                if !collection.accessories.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(collection.accessories.prefix(4)) { accessory in
                                AccessoryPhotoView(accessory: accessory, width: 60, height: 60, cornerRadius: 8, iconSize: 24)
                            }
                            
                            if collection.accessories.count > 4 {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.textBlue.opacity(0.1))
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Text("+\(collection.accessories.count - 4)")
                                            .font(.playfairDisplay(12, weight: .semibold))
                                            .foregroundColor(AppColors.textBlue)
                                    )
                            }
                        }
                    }
                }
            }
            .padding(AppConstants.cardPadding)
            .background(AppColors.cardGradient)
            .cornerRadius(AppConstants.cornerRadius)
            .shadow(color: .gray.opacity(0.2), radius: AppConstants.shadowRadius, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .alert("Delete Collection", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete this collection? This action cannot be undone.")
        }
    }
}

struct NewCollectionView: View {
    @ObservedObject var collectionViewModel: CollectionViewModel
    @ObservedObject var accessoryViewModel: AccessoryViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var collectionName = ""
    @State private var selectedAccessories: Set<UUID> = []
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Collection Name")
                            .font(.playfairDisplay(16, weight: .semibold))
                            .foregroundColor(AppColors.textBlue)
                        
                        TextField("Enter collection name", text: $collectionName)
                            .font(.playfairDisplay(16, weight: .medium))
                            .padding(12)
                            .background(AppColors.backgroundWhite)
                            .cornerRadius(12)
                    }
                    
                    Text("Select Accessories (Optional)")
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(AppColors.textBlue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if accessoryViewModel.accessories.isEmpty {
                        Text("Add accessories from Home first")
                            .font(.playfairDisplay(14, weight: .medium))
                            .foregroundColor(AppColors.darkGray)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                ForEach(accessoryViewModel.accessories) { accessory in
                                    AccessorySelectionCard(
                                        accessory: accessory,
                                        isSelected: selectedAccessories.contains(accessory.id)
                                    ) {
                                        if selectedAccessories.contains(accessory.id) {
                                            selectedAccessories.remove(accessory.id)
                                        } else {
                                            selectedAccessories.insert(accessory.id)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: createCollection) {
                        Text("Create Collection")
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(AppColors.backgroundWhite)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppColors.buttonGradient)
                            .cornerRadius(AppConstants.cornerRadius)
                    }
                    .disabled(collectionName.isEmpty)
                    .opacity(collectionName.isEmpty ? 0.6 : 1.0)
                }
                .padding(AppConstants.cardPadding)
            }
            .navigationTitle("New Collection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.darkGray)
                }
            }
        }
    }
    
    private func createCollection() {
        let selectedItems = accessoryViewModel.accessories.filter { selectedAccessories.contains($0.id) }
        collectionViewModel.createNewCollection(name: collectionName, accessories: selectedItems)
        dismiss()
    }
}

struct AccessorySelectionCard: View {
    let accessory: Accessory
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .topTrailing) {
                    AccessoryPhotoView(accessory: accessory, height: 80, cornerRadius: 12, iconSize: 30)
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(AppColors.accentGreen)
                            .font(.system(size: 24))
                            .padding(8)
                    }
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(accessory.name)
                        .font(.playfairDisplay(12, weight: .semibold))
                        .foregroundColor(AppColors.textBlue)
                        .lineLimit(2)
                    
                    Text(accessory.brand)
                        .font(.playfairDisplay(10, weight: .medium))
                        .foregroundColor(AppColors.darkGray)
                }
            }
            .padding(8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.cardGradient)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? AppColors.accentGreen : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CollectionDetailView: View {
    let collection: Collection
    @ObservedObject var viewModel: CollectionViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(collection.accessories) { accessory in
                            CollectionAccessoryCard(accessory: accessory) {
                                viewModel.removeFromCollection(accessory, from: collection)
                            }
                        }
                    }
                    .padding(AppConstants.cardPadding)
                }
            }
            .navigationTitle(collection.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Share") {
                        ShareHelper.shareCollection(collection)
                    }
                    .foregroundColor(AppColors.textBlue)
                }
            }
        }
    }
}

struct CollectionAccessoryCard: View {
    let accessory: Accessory
    let onRemove: () -> Void
    @State private var showingRemoveAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                AccessoryPhotoView(accessory: accessory, height: 100, cornerRadius: 12, iconSize: 40)
                
                Button(action: { showingRemoveAlert = true }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.accentPink)
                        .font(.system(size: 20))
                        .background(AppColors.backgroundWhite)
                        .clipShape(Circle())
                }
                .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(accessory.name)
                    .font(.playfairDisplay(14, weight: .semibold))
                    .foregroundColor(AppColors.textBlue)
                    .lineLimit(2)
                
                Text(accessory.brand)
                    .font(.playfairDisplay(12, weight: .medium))
                    .foregroundColor(AppColors.darkGray)
                
                Text("$\(Int(accessory.price))")
                    .font(.playfairDisplay(12, weight: .bold))
                    .foregroundColor(AppColors.textBlue)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.cardGradient)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
        .alert("Remove from Collection", isPresented: $showingRemoveAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                onRemove()
            }
        } message: {
            Text("Are you sure you want to remove this accessory from the collection?")
        }
    }
}

enum GroupingOption: String, CaseIterable {
    case category = "Category"
    case brand = "Brand"
    case style = "Style"
    case date = "Date"
}

#Preview {
    CollectionView()
}
