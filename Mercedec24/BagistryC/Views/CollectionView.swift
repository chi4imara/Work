import SwiftUI
import UIKit

struct CollectionView: View {
    @EnvironmentObject private var bagViewModel: BagViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    @State private var sortOption: SortOption = .brand
    @State private var showingSortOptions = false
    @State private var showingAddBag = false
    @State private var bagToShare: Bag?
    @State private var showAddedToOutfitAlert = false
    @State private var addedToOutfitBagName: String?
    
    var body: some View {
        ZStack {
            backgroundView
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerSection
                
                if bagViewModel.favoriteBags.isEmpty {
                    emptyStateView
                } else {
                    sortControlsSection
                    
                    collectionGridSection
                }
            }
        }
        .sheet(isPresented: $showingSortOptions) {
            SortOptionsView(selectedSort: $sortOption)
        }
        .sheet(isPresented: $showingAddBag) {
            AddBagView()
                .environmentObject(bagViewModel)
        }
        .sheet(item: $bagToShare) { bag in
            ActivityView(activityItems: shareActivityItems(for: bag))
        }
        .alert("Added to Outfit", isPresented: $showAddedToOutfitAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("\(addedToOutfitBagName ?? "Bag") added to your outfit.")
        }
    }
    
    private var backgroundView: some View {
        ZStack {
            LinearGradient(
                colors: [Color.theme.gradientStart, Color.theme.gradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            GridPattern()
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("My Collection")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Text("\(bagViewModel.favoriteBags.count) bags saved")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(Color.theme.secondaryText)
        }
        .padding(.top, 20)
        .padding(.horizontal, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "heart")
                    .font(.system(size: 80))
                    .foregroundColor(Color.theme.secondaryText)
                
                Text("Your collection is empty")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                
                Text("Start building your perfect bag collection by saving your favorite bags")
                    .font(.ubuntu(16))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Button(action: { showingAddBag = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                    Text("Add First Bag")
                        .font(.ubuntu(18, weight: .bold))
                }
                .foregroundColor(Color.theme.primaryText)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(Color.theme.primaryButton)
                .cornerRadius(25)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    private var sortControlsSection: some View {
        HStack(spacing: 12) {
            Button(action: { showingSortOptions = true }) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.up.arrow.down")
                    Text("Sort by \(sortOption.rawValue)")
                        .font(.ubuntu(14, weight: .medium))
                }
                .foregroundColor(Color.theme.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.theme.cardBackground)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.theme.cardBorder, lineWidth: 1)
                )
            }
            
            Spacer()
            
            Button(action: { showingAddBag = true }) {
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                    Text("Add Bag")
                        .font(.ubuntu(14, weight: .medium))
                }
                .foregroundColor(Color.theme.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.theme.primaryButton)
                .cornerRadius(20)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 10)
    }
    
    private var collectionGridSection: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 10),
                GridItem(.flexible(), spacing: 10)
            ], spacing: 12) {
                ForEach(sortedBags) { bag in
                    CollectionBagCardView(
                        bag: bag,
                        onRemove: { removeBag(bag) },
                        onShare: { shareBag(bag) },
                        onAddToOutfit: { addToOutfit(bag) }
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
    }
    
    private var sortedBags: [Bag] {
        switch sortOption {
        case .brand:
            return bagViewModel.favoriteBags.sorted { $0.brand < $1.brand }
        case .category:
            return bagViewModel.favoriteBags.sorted { $0.category.rawValue < $1.category.rawValue }
        case .color:
            return bagViewModel.favoriteBags.sorted { $0.color < $1.color }
        case .price:
            return bagViewModel.favoriteBags.sorted { $0.price < $1.price }
        case .name:
            return bagViewModel.favoriteBags.sorted { $0.name < $1.name }
        }
    }
    
    private func removeBag(_ bag: Bag) {
        bagViewModel.toggleFavorite(bag)
    }
    
    private func shareBag(_ bag: Bag) {
        bagToShare = bag
    }
    
    private func shareActivityItems(for bag: Bag) -> [Any] {
        let text = "\(bag.name) by \(bag.brand)\n\(bag.category.rawValue) · \(bag.color) · \(bag.size.rawValue)\n$\(String(format: "%.0f", bag.price))\(bag.description.isEmpty ? "" : "\n\(bag.description)")"
        var items: [Any] = [text]
        if !bag.imageURL.isEmpty, let image = BagPhotoStorage.loadImage(filename: bag.imageURL) {
            items.append(image)
        }
        return items
    }
    
    private func addToOutfit(_ bag: Bag) {
        OutfitStorage.addBag(bag.id)
        addedToOutfitBagName = bag.name
        showAddedToOutfitAlert = true
    }
}

enum SortOption: String, CaseIterable {
    case brand = "Brand"
    case category = "Category"
    case color = "Color"
    case price = "Price"
    case name = "Name"
}

struct CollectionBagCardView: View {
    let bag: Bag
    let onRemove: () -> Void
    let onShare: () -> Void
    let onAddToOutfit: () -> Void
    
    @State private var showingActions = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.theme.cardBackground)
                    .frame(height: 120)
                
                if !bag.imageURL.isEmpty, let image = BagPhotoStorage.loadImage(filename: bag.imageURL) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()
                } else {
                    Image(systemName: bag.category.icon)
                        .font(.system(size: 32))
                        .foregroundColor(Color.theme.accentYellow)
                }
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: { showingActions = true }) {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 14))
                                .foregroundColor(Color.theme.primaryText)
                                .frame(width: 32, height: 32)
                                .background(Color.theme.cardBackground)
                                .cornerRadius(16)
                        }
                        .padding(8)
                    }
                    Spacer()
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(bag.name)
                    .font(.ubuntu(12, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                    .lineLimit(1)
                
                Text(bag.brand)
                    .font(.ubuntu(10, weight: .medium))
                    .foregroundColor(Color.theme.accentText)
                    .lineLimit(1)
                
                HStack {
                    Text(bag.category.rawValue)
                        .font(.ubuntu(9))
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Spacer()
                    
                    Text(bag.size.rawValue)
                        .font(.ubuntu(9))
                        .foregroundColor(Color.theme.secondaryText)
                }
                
                Text("$\(String(format: "%.0f", bag.price))")
                    .font(.ubuntu(12, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
            }
            .padding(.horizontal, 6)
            .padding(.bottom, 6)
        }
        .background(Color.theme.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
        .actionSheet(isPresented: $showingActions) {
            ActionSheet(
                title: Text(bag.name),
                buttons: [
                    .default(Text("Share")) { onShare() },
                    .destructive(Text("Remove from Collection")) { onRemove() },
                    .cancel()
                ]
            )
        }
    }
}

struct SortOptionsView: View {
    @Binding var selectedSort: SortOption
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.theme.gradientStart, Color.theme.gradientEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Button(action: {
                            selectedSort = option
                            dismiss()
                        }) {
                            HStack {
                                Text(option.rawValue)
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(Color.theme.primaryText)
                                
                                Spacer()
                                
                                if selectedSort == option {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(Color.theme.accentYellow)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(Color.theme.cardBackground)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedSort == option ? Color.theme.accentYellow : Color.theme.cardBorder, lineWidth: 1)
                            )
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
            }
            .navigationTitle("Sort Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.accentYellow)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    CollectionView()
        .environmentObject(BagViewModel())
        .environmentObject(UserViewModel())
}
