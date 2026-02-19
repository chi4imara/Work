import SwiftUI

struct LocationsView: View {
    @ObservedObject var viewModel: GarageViewModel
    @Binding var selectedTab: Int
    
    var body: some View {
            VStack(spacing: 0) {
                HStack {
                    Text("Locations")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(AppColors.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.locations.isEmpty {
                    EmptyStateView(
                        icon: "location",
                        title: "No locations yet",
                        subtitle: "Locations will appear here automatically when you add items to your garage.",
                        buttonTitle: "Add First Item",
                        action: {
                            withAnimation {
                                selectedTab = 2
                            }
                        }
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.locations, id: \.id) { location in
                                NavigationLink(destination: LocationDetailView(location: location, viewModel: viewModel, selectedTab: $selectedTab)) {
                                    LocationRowView(location: location)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
    }
}

struct LocationRowView: View {
    let location: Location
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "location.fill")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(AppColors.orange)
                .frame(width: 50, height: 50)
                .background(AppColors.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(location.name)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.white)
                    .lineLimit(2)
                
                Text("\(location.itemCount) item\(location.itemCount == 1 ? "" : "s")")
                    .font(.ubuntu(12))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
        )
    }
}

struct LocationDetailView: View {
    let location: Location
    @ObservedObject var viewModel: GarageViewModel
    @Binding var selectedTab: Int
    @Environment(\.presentationMode) var presentationMode
    
    var items: [GarageItem] {
        viewModel.getItemsForLocation(location.name)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(location.name)
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(AppColors.white)
                            
                            Text("\(items.count) item\(items.count == 1 ? "" : "s")")
                                .font(.ubuntu(14))
                                .foregroundColor(AppColors.secondaryText)
                        }
                        
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if items.isEmpty {
                    VStack {
                        EmptyStateView(
                            icon: "cube.box",
                            title: "No items here",
                            subtitle: "This location doesn't contain any items yet.",
                            buttonTitle: "Add Item",
                            action: {
                                withAnimation {
                                    presentationMode.wrappedValue.dismiss()
                                    selectedTab = 2
                                }
                            }
                        )
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(items) { item in
                                NavigationLink(destination: ItemDetailView(item: item, viewModel: viewModel)) {
                                    ItemRowView(item: item)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("Locations")
                            .font(.ubuntu(16))
                    }
                    .foregroundColor(AppColors.lightBlue)
                }
            }
        }
    }
}
