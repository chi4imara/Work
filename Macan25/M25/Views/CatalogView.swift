import SwiftUI

struct CatalogView: View {
    @ObservedObject var viewModel: AccessoryViewModel
    @Binding var selectedTab: TabItem
    @State private var showingAddView = false
    @State private var selectedAccessoryId: UUID?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchBarView
                
                if viewModel.filteredAccessories.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    accessoriesListView
                }
            }
        }
        .sheet(isPresented: $showingAddView) {
            AddAccessoryView(viewModel: viewModel, selectedTab: $selectedTab)
        }
        .sheet(isPresented: Binding(
            get: { selectedAccessoryId != nil },
            set: { if !$0 { selectedAccessoryId = nil } }
        )) {
            if let id = selectedAccessoryId {
                AccessoryDetailView(viewModel: viewModel, accessoryId: id)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Accessories")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.primaryWhite)
                
                if viewModel.isFiltered {
                    Text("\(viewModel.filteredAccessories.count) of \(viewModel.accessories.count) items")
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                }
            }
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    selectedTab = .add
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 13, weight: .medium))
                    Text("Add Accessory")
                        .font(.ubuntu(13, weight: .medium))
                }
                .foregroundColor(AppColors.primaryPurple)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(AppColors.primaryWhite)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var searchBarView: some View {
        HStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.primaryWhite.opacity(0.7))
                    .font(.system(size: 16))
                
                TextField("Search by name or type", text: $viewModel.searchText)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.primaryWhite)
                    .onChange(of: viewModel.searchText) { _ in
                        viewModel.applyFilters()
                    }
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                        viewModel.applyFilters()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.primaryWhite.opacity(0.7))
                            .font(.system(size: 16))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AppColors.cardBackground)
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
            
            Button(action: {
                withAnimation {
                    selectedTab = .filters
                }
            }) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(viewModel.isFiltered ? AppColors.accentOrange : AppColors.primaryWhite)
                    .frame(width: 44, height: 44)
                    .background(AppColors.cardBackground)
                    .cornerRadius(22)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    private var accessoriesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredAccessories) { accessory in
                    AccessoryCardView(accessory: accessory) {
                        selectedAccessoryId = accessory.id
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "tray")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryWhite.opacity(0.6))
            
            VStack(spacing: 8) {
                Text(viewModel.accessories.isEmpty ? "Catalog is empty" : "No matching accessories")
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(AppColors.primaryWhite)
                
                Text(viewModel.accessories.isEmpty ?
                     "Add your first accessory to get started." :
                        "Try adjusting your search or filters.")
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                .multilineTextAlignment(.center)
            }
            
            if viewModel.accessories.isEmpty {
                Button(action: {
                    withAnimation {
                        selectedTab = .add
                    }
                }) {
                    Text("Add First Accessory")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.primaryPurple)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(AppColors.primaryWhite)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
}

struct AccessoryCardView: View {
    let accessory: Accessory
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(accessory.name)
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.primaryWhite)
                            .lineLimit(1)
                        
                        Text(accessory.type.displayName)
                            .font(.ubuntu(14, weight: .regular))
                            .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    Text(accessory.status.displayName)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(AppColors.primaryWhite)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.statusColor(for: accessory.status))
                        .cornerRadius(12)
                }
                
                if !accessory.description.isEmpty {
                    Text(accessory.description)
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(AppColors.primaryWhite.opacity(0.9))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CatalogView(viewModel: AccessoryViewModel(), selectedTab: .constant(.catalog))
}
