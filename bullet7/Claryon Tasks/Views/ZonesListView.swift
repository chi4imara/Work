import SwiftUI

struct ZonesListView: View {
    @ObservedObject var viewModel: CleaningZoneViewModel
    @State private var showingAddZone = false
    @State private var showingMenu = false
    @State private var showingSortOptions = false
    @State private var showingDeleteAllAlert = false
    @State private var selectedZone: CleaningZone?
    
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    HStack {
                        Text("Cleaning Zones")
                            .font(Font.titleLarge)
                            .foregroundColor(.primaryText)
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            Button(action: { showingAddZone = true }) {
                                Image(systemName: "plus")
                                    .foregroundColor(.accentYellow)
                            }
                            
                            Button(action: { showingMenu = true }) {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.accentYellow)
                            }
                            .confirmationDialog("Menu", isPresented: $showingMenu) {
                                Button("Zone Categories", role: .none) {
                                    withAnimation {
                                        selectedTab = 1
                                    }
                                }
                                Button("Cleaning Tips", role: .none) {
                                    withAnimation {
                                        selectedTab = 2
                                    }
                                }
                                Button("Delete All Zones", role: .destructive) {
                                    showingDeleteAllAlert = true
                                }
                                Button("Cancel", role: .cancel) { }
                            }
                        }
                    }
                    .padding()
                    
                    SearchBar(text: $viewModel.searchText)
                        .padding(.horizontal, 16)
                        .padding(.top, 10)
                    
                    if viewModel.filteredAndSortedZones.isEmpty {
                        EmptyStateView(onAddZone: { showingAddZone = true })
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.filteredAndSortedZones) { zone in
                                ZoneCardView(
                                    zone: zone,
                                    onToggleCompletion: { viewModel.toggleZoneCompletion(zone) },
                                    onEdit: { selectedZone = zone },
                                    onDelete: { viewModel.deleteZone(zone) },
                                    onTap: { selectedZone = zone }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 10)
                        
                        Button(action: { showingSortOptions = true }) {
                            HStack {
                                Image(systemName: "arrow.up.arrow.down")
                                Text("Sort")
                            }
                            .font(.bodyMedium)
                            .foregroundColor(.primaryWhite)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color.cardBackground)
                            .cornerRadius(20)
                        }
                        .padding(.top, 10)
                        .confirmationDialog("Sort by", isPresented: $showingSortOptions) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Button(option.rawValue) {
                                    viewModel.sortOption = option
                                }
                            }
                            Button("Cancel", role: .cancel) { }
                        }
                    }
                }
                .padding(.bottom, 100)
            }
        }
        .sheet(isPresented: $showingAddZone) {
            AddEditZoneView(viewModel: viewModel)
        }
        .sheet(item: $selectedZone) { zone in
            ZoneDetailView(zoneId: zone.id, viewModel: viewModel)
        }
        .alert("Clear zone list?", isPresented: $showingDeleteAllAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete All", role: .destructive) {
                viewModel.deleteAllZones()
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondaryText)
            
            TextField("Search by name or category...", text: $text)
                .font(.bodyMedium)
                .foregroundColor(.primaryWhite)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.cardBackground)
        .cornerRadius(10)
    }
}

struct EmptyStateView: View {
    let onAddZone: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "sparkles")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.accentYellow)
            
            VStack(spacing: 10) {
                Text("No zones yet")
                    .font(.titleMedium)
                    .foregroundColor(.primaryWhite)
                
                Text("Add your first zone to start cleaning")
                    .font(.bodyMedium)
                    .foregroundColor(.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: onAddZone) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Zone")
                }
                .font(.bodyLarge)
                .foregroundColor(.primaryPurple)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.accentYellow)
                .cornerRadius(25)
                .padding(.horizontal, 40)
            }
        }
        .padding(.top, 100)
    }
}
