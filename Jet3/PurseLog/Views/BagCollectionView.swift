import SwiftUI

struct BagDetailItem: Identifiable {
    let id: UUID
}

struct BagCollectionView: View {
    @StateObject private var viewModel = BagViewModel()
    @State private var showingAddBag = false
    @State private var selectedBagId: UUID?
    @State private var showFavoritesOnly = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                searchAndFiltersView
                
                if (showFavoritesOnly ? viewModel.getFavoriteBags() : viewModel.filteredBags).isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    bagListView
                }
            }
        }
        .sheet(isPresented: $showingAddBag) {
            AddEditBagView(viewModel: viewModel)
        }
        .sheet(item: Binding(
            get: { selectedBagId.map { BagDetailItem(id: $0) } },
            set: { selectedBagId = $0?.id }
        )) { item in
            BagDetailView(bagId: item.id, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            HStack {
                Text("My Bags")
                    .font(FontManager.ubuntu(.bold, size: 28))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Button(action: { showFavoritesOnly.toggle() }) {
                    Image(systemName: showFavoritesOnly ? "heart.fill" : "heart")
                        .font(.system(size: 24))
                        .foregroundColor(showFavoritesOnly ? AppColors.error : AppColors.primaryYellow)
                }
                
                Button(action: { showingAddBag = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(AppColors.primaryYellow)
                }
            }
            
            Menu {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Button(action: {
                        viewModel.sortOption = option
                    }) {
                        HStack {
                            Text(option.displayName)
                            if viewModel.sortOption == option {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 14))
                    Text("Sort: \(viewModel.sortOption.displayName)")
                        .font(FontManager.ubuntu(.medium, size: 14))
                }
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity)
                .background(AppColors.buttonSecondary)
                .cornerRadius(16)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchAndFiltersView: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.secondaryText)
                
                TextField("Search by name or brand...", text: $viewModel.searchText)
                    .font(FontManager.ubuntu(.regular, size: 16))
                    .foregroundColor(AppColors.primaryText)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AppColors.buttonSecondary)
            .cornerRadius(25)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    FilterChip(
                        title: "All",
                        isSelected: viewModel.selectedStyle == nil && viewModel.selectedFrequency == nil && viewModel.selectedColor == nil,
                        action: {
                            viewModel.selectedStyle = nil
                            viewModel.selectedFrequency = nil
                            viewModel.selectedColor = nil
                        }
                    )
                    
                    ForEach(BagStyle.allCases) { style in
                        FilterChip(
                            title: style.displayName,
                            isSelected: viewModel.selectedStyle == style,
                            action: {
                                if viewModel.selectedStyle == style {
                                    viewModel.selectedStyle = nil
                                } else {
                                    viewModel.selectedStyle = style
                                    viewModel.selectedFrequency = nil
                                    viewModel.selectedColor = nil
                                }
                            }
                        )
                    }
                    
                    ForEach(UsageFrequency.allCases) { frequency in
                        FilterChip(
                            title: frequency.displayName,
                            isSelected: viewModel.selectedFrequency == frequency,
                            action: {
                                if viewModel.selectedFrequency == frequency {
                                    viewModel.selectedFrequency = nil
                                } else {
                                    viewModel.selectedFrequency = frequency
                                    viewModel.selectedStyle = nil
                                    viewModel.selectedColor = nil
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, -20)
            
            if !viewModel.getAllColors().isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.getAllColors(), id: \.self) { color in
                            ColorFilterChip(
                                colorName: color,
                                isSelected: viewModel.selectedColor?.lowercased() == color.lowercased(),
                                action: {
                                    if viewModel.selectedColor?.lowercased() == color.lowercased() {
                                        viewModel.selectedColor = nil
                                    } else {
                                        viewModel.selectedColor = color
                                        viewModel.selectedStyle = nil
                                        viewModel.selectedFrequency = nil
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.horizontal, -20)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var bagListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(showFavoritesOnly ? viewModel.getFavoriteBags() : viewModel.filteredBags) { bag in
                    BagCard(bag: bag, viewModel: viewModel, onTap: {
                        selectedBagId = bag.id
                    }, onDelete: {
                        viewModel.deleteBag(bag)
                    })
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "handbag")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryYellow.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No bags added yet")
                    .font(FontManager.ubuntu(.bold, size: 24))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Start with your favorite — the one you can't go a day without.")
                    .font(FontManager.ubuntu(.regular, size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 40)
            
            Button("Add Bag") {
                showingAddBag = true
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, 60)
            .padding(.bottom, 20)
            
            Spacer()
        }
    }
}

struct BagCard: View {
    let bag: Bag
    @ObservedObject var viewModel: BagViewModel
    let onTap: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var showingDeleteConfirmation = false
    @State private var showingQuickActions = false
    
    private var deleteThreshold: CGFloat = -100
    private var currentBag: Bag {
        viewModel.bags.first { $0.id == bag.id } ?? bag
    }
    
    init(bag: Bag, viewModel: BagViewModel, onTap: @escaping () -> Void, onDelete: @escaping () -> Void) {
        self.bag = bag
        self.viewModel = viewModel
        self.onTap = onTap
        self.onDelete = onDelete
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            if offset.width < 0 {
                HStack {
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Delete")
                            .font(FontManager.ubuntu(.bold, size: 14))
                            .foregroundColor(.white)
                    }
                    .frame(width: 80)
                    .opacity(min(abs(offset.width) / 100.0, 1.0))
                }
                .padding(.trailing, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.error)
                )
            }
            
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.primaryYellow.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "handbag.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.primaryYellow)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(currentBag.name)
                        .font(FontManager.ubuntu(.bold, size: 18))
                        .foregroundColor(AppColors.darkText)
                        .lineLimit(1)
                    
                    Text(currentBag.brand)
                        .font(FontManager.ubuntu(.medium, size: 14))
                        .foregroundColor(AppColors.darkText.opacity(0.7))
                        .lineLimit(1)
                    
                    HStack(spacing: 12) {
                        Label(currentBag.style.displayName, systemImage: "tag")
                        
                        HStack(spacing: 6) {
                            Circle()
                                .fill(ColorPalette.getColorSwatch(for: currentBag.color))
                                .frame(width: 12, height: 12)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.8), lineWidth: 1)
                                )
                            
                            Text(currentBag.color)
                                .font(FontManager.ubuntu(.regular, size: 12))
                        }
                        
                        Label(currentBag.usageFrequency.displayName, systemImage: "clock")
                    }
                    .font(FontManager.ubuntu(.regular, size: 12))
                    .foregroundColor(AppColors.darkText.opacity(0.6))
                    .lineLimit(1)
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button(action: {
                        viewModel.toggleFavorite(currentBag)
                    }) {
                        Image(systemName: currentBag.isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 18))
                            .foregroundColor(currentBag.isFavorite ? AppColors.error : AppColors.darkText.opacity(0.4))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Circle()
                        .fill(usageFrequencyColor)
                        .frame(width: 12, height: 12)
                }
            }
            .padding(16)
            .cardStyle()
            .offset(x: offset.width, y: 0)
            .contextMenu {
                Button(action: {
                    viewModel.toggleFavorite(currentBag)
                }) {
                    Label(currentBag.isFavorite ? "Remove from Favorites" : "Add to Favorites", systemImage: currentBag.isFavorite ? "heart.slash" : "heart.fill")
                }
                
                Button(action: {
                    viewModel.markAsUsed(currentBag)
                }) {
                    Label("Mark as Used Today", systemImage: "checkmark.circle.fill")
                }
                
                Menu("Change Usage Frequency") {
                    Button("Often") {
                        viewModel.updateUsageFrequency(currentBag, frequency: .often)
                    }
                    Button("Sometimes") {
                        viewModel.updateUsageFrequency(currentBag, frequency: .sometimes)
                    }
                    Button("Rarely") {
                        viewModel.updateUsageFrequency(currentBag, frequency: .rarely)
                    }
                }
            }
        }
        .onTapGesture {
            onTap()
        }
        .highPriorityGesture(
            DragGesture(minimumDistance: 25)
                .onChanged { value in
                    if value.translation.width < 0 {
                        withAnimation(.interactiveSpring()) {
                            offset = value.translation
                        }
                    }
                }
                .onEnded { value in
                    if value.translation.width < deleteThreshold {
                        showingDeleteConfirmation = true
                    }
                    withAnimation(.spring()) {
                        offset = .zero
                    }
                }
        )
        .alert("Delete Bag", isPresented: $showingDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                onDelete()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this bag?")
        }
    }
    
    private var usageFrequencyColor: Color {
        switch currentBag.usageFrequency {
        case .often:
            return AppColors.success
        case .sometimes:
            return AppColors.warning
        case .rarely:
            return AppColors.error
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(FontManager.ubuntu(.medium, size: 14))
                .foregroundColor(isSelected ? AppColors.darkText : AppColors.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? AppColors.primaryYellow : AppColors.buttonSecondary)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ColorFilterChip: View {
    let colorName: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Circle()
                    .fill(ColorPalette.getColorSwatch(for: colorName))
                    .frame(width: 16, height: 16)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? AppColors.primaryYellow : Color.white.opacity(0.5), lineWidth: isSelected ? 2 : 1)
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 1)
                
                Text(colorName)
                    .font(FontManager.ubuntu(.medium, size: 14))
                    .foregroundColor(isSelected ? AppColors.darkText : AppColors.primaryText)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? AppColors.primaryYellow : AppColors.buttonSecondary)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct BagCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        BagCollectionView()
    }
}
