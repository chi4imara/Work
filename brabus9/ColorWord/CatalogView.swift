import SwiftUI

struct CatalogView: View {
    @ObservedObject var viewModel: CatalogViewModel
    @State private var showingAddItem = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Catalog")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddItem = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(AppColors.buttonBackground)
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(AppColors.buttonText)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.items.isEmpty {
                    EmptyStateView(showingAddItem: $showingAddItem)
                    
                    Spacer()
                } else {
                    ItemListView(viewModel: viewModel)
                }
            }
        }
        .sheet(isPresented: $showingAddItem) {
            AddItemView(viewModel: viewModel)
        }
    }
}

struct EmptyStateView: View {
    @Binding var showingAddItem: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "heart.circle")
                .font(.system(size: 60))
                .foregroundColor(AppColors.accent)
            
            Text("Here will be collected everything you like. Add the first item to the catalog.")
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                showingAddItem = true
            }) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .medium))
                    Text("Add")
                        .font(.ubuntu(18, weight: .medium))
                }
                .foregroundColor(AppColors.buttonText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.buttonBackground)
                )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            Spacer()
        }
    }
}

struct ItemListView: View {
    @ObservedObject var viewModel: CatalogViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.items) { item in
                    NavigationLink(destination: ItemDetailView(itemId: item.id, viewModel: viewModel)) {
                        ItemRowView(item: item)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
}

struct ItemRowView: View {
    let item: CatalogItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.text)
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
            
            Text(item.dateCreated, style: .date)
                .font(.ubuntu(12, weight: .light))
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
}

#Preview {
    NavigationView {
        CatalogView(viewModel: CatalogViewModel())
    }
}
