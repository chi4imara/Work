import SwiftUI

struct StoreListView: View {
    @EnvironmentObject var viewModel: StoreViewModel
    @State private var showingAddStore = false
    @State private var showingFilters = false
    @State private var selectedStoreId: UUID?
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    HStack {
                        Text("Favorite Stores")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(.appText)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                selectedTab = 2
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.appAccent)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    HStack(spacing: 12) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.appTextSecondary)
                            
                            TextField("Search by name or category", text: $viewModel.searchText)
                                .font(.ubuntu(16))
                                .onChange(of: viewModel.searchText) { _ in
                                    viewModel.searchStores()
                                }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.appCardBackground)
                        .cornerRadius(12)
                        .shadow(color: Color.appShadow, radius: 5, x: 0, y: 2)
                        
                        Button(action: { showingFilters = true }) {
                            ZStack {
                                Circle()
                                    .fill(viewModel.isFiltering ? Color.appAccent : Color.appCardBackground)
                                    .frame(width: 44, height: 44)
                                    .shadow(color: Color.appShadow, radius: 5, x: 0, y: 2)
                                
                                Image(systemName: "line.3.horizontal.decrease.circle")
                                    .font(.system(size: 20))
                                    .foregroundColor(viewModel.isFiltering ? .white : .appPrimary)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                if viewModel.filteredStores.isEmpty {
                    EmptyStateView(
                        title: viewModel.stores.isEmpty ? "No saved stores yet" : "No stores found",
                        subtitle: viewModel.stores.isEmpty ?
                        "Tap ➕ to add your first store" :
                            "Try adjusting your search or filters",
                        systemImage: viewModel.stores.isEmpty ? "bag" : "magnifyingglass"
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.filteredStores) { store in
                                StoreCardView(storeId: store.id, viewModel: viewModel) {
                                    selectedStoreId = store.id
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                    .id(viewModel.filteredStores.count)
                }
            }
        }
        .sheet(isPresented: $showingFilters) {
            FiltersView(viewModel: viewModel)
        }
        .sheet(item: Binding(
            get: { selectedStoreId.map { IdentifiableUUID(id: $0) } },
            set: { selectedStoreId = $0?.id }
        )) { identifiableId in
            StoreDetailView(storeId: identifiableId.id, viewModel: viewModel)
        }
        .onChange(of: viewModel.stores.count) { _ in
            viewModel.updateFilteredStores()
        }
    }
}

struct AddStoreSheetView: View {
    @ObservedObject var viewModel: StoreViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var storeName = ""
    @State private var selectedType = StoreType.boutique
    @State private var selectedCategory = StoreCategory.clothing
    @State private var selectedPriceLevel = PriceLevel.medium
    @State private var review = ""
    
    private var isFormValid: Bool {
        !storeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("New Store")
                                .font(.ubuntu(28, weight: .bold))
                                .foregroundColor(.appText)
                            
                            Text("Add your favorite shopping destination")
                                .font(.ubuntu(16))
                                .foregroundColor(.appTextSecondary)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            FormFieldView(title: "Store Name") {
                                TextField("Enter store name", text: $storeName)
                                    .font(.ubuntu(16))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color.appCardBackground)
                                    .cornerRadius(12)
                                    .shadow(color: Color.appShadow, radius: 5, x: 0, y: 2)
                            }
                            
                            FormFieldView(title: "Store Type") {
                                SegmentedPickerView(
                                    selection: $selectedType,
                                    options: StoreType.allCases,
                                    displayName: { $0.displayName }
                                )
                            }
                            
                            FormFieldView(title: "Category") {
                                SegmentedPickerView(
                                    selection: $selectedCategory,
                                    options: StoreCategory.allCases,
                                    displayName: { $0.displayName }
                                )
                            }
                            
                            FormFieldView(title: "Price Level") {
                                HStack(spacing: 16) {
                                    ForEach(PriceLevel.allCases, id: \.self) { level in
                                        Button(action: {
                                            selectedPriceLevel = level
                                        }) {
                                            Text(level.displayName)
                                                .font(.ubuntu(16, weight: .medium))
                                                .foregroundColor(selectedPriceLevel == level ? .white : .appPrimary)
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 12)
                                                .background(
                                                    selectedPriceLevel == level ? 
                                                    Color.appAccent : Color.appCardBackground
                                                )
                                                .cornerRadius(12)
                                                .shadow(color: Color.appShadow, radius: 5, x: 0, y: 2)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                            
                            FormFieldView(title: "Review (Optional)") {
                                TextField("Share your thoughts about this store", text: $review, axis: .vertical)
                                    .font(.ubuntu(16))
                                    .lineLimit(3...6)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color.appCardBackground)
                                    .cornerRadius(12)
                                    .shadow(color: Color.appShadow, radius: 5, x: 0, y: 2)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            Button(action: saveStore) {
                                Text("Save Store")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(
                                        isFormValid ? 
                                        LinearGradient(
                                            colors: [Color.appPrimary, Color.appAccent],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ) : 
                                        LinearGradient(
                                            colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.3)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(25)
                                    .shadow(color: Color.appShadow, radius: isFormValid ? 10 : 5, x: 0, y: 5)
                            }
                            .disabled(!isFormValid)
                            
                            Button(action: { dismiss() }) {
                                Text("Cancel")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.appTextSecondary)
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func saveStore() {
        let newStore = Store(
            name: storeName.trimmingCharacters(in: .whitespacesAndNewlines),
            type: selectedType,
            category: selectedCategory,
            priceLevel: selectedPriceLevel,
            review: review.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addStore(newStore)
        dismiss()
    }
}

struct StoreCardView: View {
    let storeId: UUID
    @ObservedObject var viewModel: StoreViewModel
    let onTap: () -> Void
    @State private var isPressed = false
    
    private var store: Store? {
        viewModel.stores.first(where: { $0.id == storeId })
    }
    
    var body: some View {
        if let store = store {
            Button(action: onTap) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.appPrimary.opacity(0.2), Color.appAccent.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: store.type == .online ? "globe" : "storefront")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.appPrimary)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(store.name)
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(.appText)
                            
                            Spacer()
                            
                            Text(store.priceLevel.displayName)
                                .font(.ubuntu(14, weight: .bold))
                                .foregroundColor(.appAccent)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.appAccent.opacity(0.2))
                                .cornerRadius(8)
                        }
                        
                        Text(store.category.displayName)
                            .font(.ubuntu(14))
                            .foregroundColor(.appTextSecondary)
                        
                        if !store.review.isEmpty {
                            Text(store.review)
                                .font(.ubuntu(12))
                                .foregroundColor(.appTextSecondary)
                                .lineLimit(2)
                        }
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.appTextSecondary)
                }
                .padding(16)
                .background(Color.appCardBackground)
                .cornerRadius(16)
                .shadow(color: Color.appShadow, radius: isPressed ? 2 : 8, x: 0, y: isPressed ? 1 : 4)
                .scaleEffect(isPressed ? 0.98 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
            }
            .buttonStyle(PlainButtonStyle())
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                isPressed = pressing
            }, perform: {})
        }
    }
}

struct EmptyStateView: View {
    let title: String
    let subtitle: String
    let systemImage: String
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.appAccent.opacity(0.2),
                                Color.appPrimary.opacity(0.1)
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 60
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: systemImage)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(.appPrimary)
            }
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(.appText)
                
                Text(subtitle)
                    .font(.ubuntu(16))
                    .foregroundColor(.appTextSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct FormFieldView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(.appText)
            
            content
        }
    }
}

struct IdentifiableUUID: Identifiable {
    let id: UUID
}

struct SegmentedPickerView<T: Hashable>: View {
    @Binding var selection: T
    let options: [T]
    let displayName: (T) -> String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        selection = option
                    }) {
                        Text(displayName(option))
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(selection == option ? .white : .appPrimary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                selection == option ? 
                                Color.appAccent : Color.appCardBackground
                            )
                            .cornerRadius(20)
                            .shadow(color: Color.appShadow, radius: 3, x: 0, y: 1)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
        }
        .padding(.horizontal, -20)
    }
}

