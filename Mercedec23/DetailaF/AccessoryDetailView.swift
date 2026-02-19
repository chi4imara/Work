import SwiftUI

struct AccessoryDetailView: View {
    let accessoryId: UUID
    @EnvironmentObject private var accessoryViewModel: AccessoryViewModel
    @EnvironmentObject private var collectionViewModel: CollectionViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingARTryOn = false
    @State private var showingAddToCollection = false
    
    private var accessory: Accessory? {
        accessoryViewModel.accessory(byId: accessoryId)
    }
    
    var body: some View {
        Group {
            if let accessory = accessory {
                detailContent(accessory: accessory)
            } else {
                notFoundView
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingARTryOn) {
            ARTryOnView(accessoryId: accessoryId)
        }
        .sheet(isPresented: $showingAddToCollection) {
            if let accessory = accessory {
                AddToCollectionSheet(accessory: accessory, viewModel: collectionViewModel)
            }
        }
    }
    
    private func detailContent(accessory: Accessory) -> some View {
        ScrollView {
            ZStack {
                AnimatedBackground()
                
                VStack(alignment: .leading, spacing: AppConstants.sectionSpacing) {
                    imageSection(accessory: accessory)
                    infoSection(accessory: accessory)
                    descriptionSection(accessory: accessory)
                    actionsSection(accessory: accessory)
                }
                .padding(.horizontal, AppConstants.cardPadding)
            }
        }
        .background(AppColors.backgroundGradient)
        .navigationTitle(accessory.name)
    }
    
    private func imageSection(accessory: Accessory) -> some View {
        ZStack {
            AccessoryPhotoView(accessory: accessory, height: 220, cornerRadius: 16, iconSize: 80)
            
            if accessory.isFavorite {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "heart.fill")
                            .font(.system(size: 24))
                            .foregroundColor(AppColors.accentPink)
                            .padding(16)
                    }
                    Spacer()
                }
            }
        }
        .padding(.top, 8)
    }
    
    private func infoSection(accessory: Accessory) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(accessory.brand)
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(AppColors.textBlue)
                
                Spacer()
                
                Text("$\(Int(accessory.price))")
                    .font(.playfairDisplay(22, weight: .bold))
                    .foregroundColor(AppColors.primaryYellow)
            }
            
            HStack(spacing: 8) {
                Text(accessory.category.rawValue)
                    .font(.playfairDisplay(14, weight: .medium))
                    .foregroundColor(accessory.style.color)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(accessory.style.color.opacity(0.1))
                    .cornerRadius(10)
                
                Text(accessory.style.rawValue)
                    .font(.playfairDisplay(14, weight: .medium))
                    .foregroundColor(AppColors.darkGray)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppColors.lightGray)
                    .cornerRadius(10)
            }
            
            if !accessory.colors.isEmpty {
                HStack(spacing: 8) {
                    Text("Colors:")
                        .font(.playfairDisplay(14, weight: .semibold))
                        .foregroundColor(AppColors.textBlue)
                    
                    ForEach(accessory.colors, id: \.self) { color in
                        Text(color)
                            .font(.playfairDisplay(12, weight: .medium))
                            .foregroundColor(AppColors.darkGray)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(AppColors.lightGray)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding(AppConstants.cardPadding)
        .background(AppColors.cardGradient)
        .cornerRadius(AppConstants.cornerRadius)
        .shadow(color: .gray.opacity(0.2), radius: AppConstants.shadowRadius, x: 0, y: 4)
    }
    
    private func descriptionSection(accessory: Accessory) -> some View {
        Group {
            if !accessory.description.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(AppColors.textBlue)
                    
                    Text(accessory.description)
                        .font(.playfairDisplay(14, weight: .medium))
                        .foregroundColor(AppColors.darkGray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(AppConstants.cardPadding)
                .background(AppColors.cardGradient)
                .cornerRadius(AppConstants.cornerRadius)
                .shadow(color: .gray.opacity(0.2), radius: AppConstants.shadowRadius, x: 0, y: 4)
            }
        }
    }
    
    private func actionsSection(accessory: Accessory) -> some View {
        VStack(spacing: 12) {
            Button(action: { showingAddToCollection = true }) {
                HStack {
                    Image(systemName: "heart.badge.plus")
                    Text("Add to Collection")
                        .font(.playfairDisplay(16, weight: .semibold))
                }
                .foregroundColor(AppColors.textBlue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColors.backgroundWhite)
                .cornerRadius(AppConstants.cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                        .stroke(AppColors.textBlue, lineWidth: 1)
                )
            }
            
            Button(action: { accessoryViewModel.toggleFavorite(for: accessory) }) {
                HStack {
                    Image(systemName: accessory.isFavorite ? "heart.slash" : "heart")
                    Text(accessory.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                        .font(.playfairDisplay(16, weight: .semibold))
                }
                .foregroundColor(accessory.isFavorite ? AppColors.accentPink : AppColors.textBlue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColors.lightGray.opacity(0.5))
                .cornerRadius(AppConstants.cornerRadius)
            }
        }
        .padding(.bottom, 24)
    }
    
    private var notFoundView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "questionmark.circle")
                .font(.system(size: 60))
                .foregroundColor(AppColors.darkGray.opacity(0.6))
            
            Text("Accessory not found")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.textBlue)
            
            Text("This item may have been removed")
                .font(.playfairDisplay(14, weight: .medium))
                .foregroundColor(AppColors.darkGray)
            
            Button("Go Back") {
                dismiss()
            }
            .font(.playfairDisplay(16, weight: .semibold))
            .foregroundColor(AppColors.primaryYellow)
            .padding(.top, 16)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(AnimatedBackground())
    }
}

struct AddToCollectionSheet: View {
    let accessory: Accessory
    @ObservedObject var viewModel: CollectionViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var newCollectionName = ""
    @State private var selectedCollectionId: UUID?
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Add to collection")
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(AppColors.textBlue)
                        
                        if viewModel.collections.isEmpty {
                            Text("Create your first collection")
                                .font(.playfairDisplay(14, weight: .medium))
                                .foregroundColor(AppColors.darkGray)
                            
                            TextField("Collection name", text: $newCollectionName)
                                .font(.playfairDisplay(16, weight: .medium))
                                .padding(12)
                                .background(AppColors.backgroundWhite)
                                .cornerRadius(12)
                            
                            Button("Create and Add") {
                                viewModel.createNewCollection(name: newCollectionName, accessories: [accessory])
                                dismiss()
                            }
                            .font(.playfairDisplay(16, weight: .semibold))
                            .foregroundColor(AppColors.backgroundWhite)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(newCollectionName.isEmpty ? AnyShapeStyle(AppColors.lightGray) : AnyShapeStyle(AppColors.buttonGradient))
                            .cornerRadius(12)
                            .disabled(newCollectionName.isEmpty)
                        } else {
                            ForEach(viewModel.collections) { collection in
                                Button(action: {
                                    viewModel.addToCollection(accessory, collectionName: collection.name)
                                    dismiss()
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(collection.name)
                                                .font(.playfairDisplay(16, weight: .semibold))
                                                .foregroundColor(AppColors.textBlue)
                                            Text("\(collection.accessories.count) items")
                                                .font(.playfairDisplay(12, weight: .medium))
                                                .foregroundColor(AppColors.darkGray)
                                        }
                                        Spacer()
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundColor(AppColors.accentGreen)
                                    }
                                    .padding(12)
                                    .background(AppColors.cardGradient)
                                    .cornerRadius(12)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            Divider()
                                .padding(.vertical, 8)
                            
                            Text("Or create new")
                                .font(.playfairDisplay(14, weight: .semibold))
                                .foregroundColor(AppColors.textBlue)
                            
                            TextField("New collection name", text: $newCollectionName)
                                .font(.playfairDisplay(16, weight: .medium))
                                .padding(12)
                                .background(AppColors.backgroundWhite)
                                .cornerRadius(12)
                            
                            Button("Create and Add") {
                                viewModel.createNewCollection(name: newCollectionName, accessories: [accessory])
                                dismiss()
                            }
                            .font(.playfairDisplay(16, weight: .semibold))
                            .foregroundColor(AppColors.backgroundWhite)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(newCollectionName.isEmpty ? AnyShapeStyle(AppColors.lightGray) : AnyShapeStyle(AppColors.buttonGradient))
                            .cornerRadius(12)
                            .disabled(newCollectionName.isEmpty)
                        }
                    }
                    .padding(AppConstants.cardPadding)
                }
            }
            .navigationTitle("Add to Collection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.darkGray)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AccessoryDetailView(accessoryId: UUID())
            .environmentObject(AccessoryViewModel())
            .environmentObject(CollectionViewModel())
    }
}
