import SwiftUI

struct ShoppingListView: View {
    @EnvironmentObject var viewModel: WardrobeViewModel
    @State private var showingAddItem = false
    
    var body: some View {
        ZStack {
            AppColorScheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Shopping List")
                        .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                        .foregroundColor(Color.textPrimary)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddItem = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(Color.primaryYellow)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.textSecondary)
                        
                        TextField("Search by name", text: $viewModel.searchText)
                            .font(FontManager.playfairDisplay(size: 16))
                            .foregroundColor(Color.textPrimary)
                        
                        if !viewModel.searchText.isEmpty {
                            Button(action: {
                                viewModel.searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(Color.textSecondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(12)
                    
                    Menu {
                        ForEach(viewModel.allCategoryNames, id: \.self) { category in
                            Button(category) {
                                viewModel.selectedCategory = category
                            }
                        }
                    } label: {
                        HStack {
                            Text(viewModel.selectedCategory)
                                .font(FontManager.playfairDisplay(size: 16))
                                .foregroundColor(Color.textPrimary)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(Color.textSecondary)
                        }
                        .padding()
                        .background(Color.cardBackground)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical)
                
                if viewModel.filteredItems.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Image(systemName: "tshirt")
                            .font(.system(size: 60))
                            .foregroundColor(Color.textSecondary)
                        
                        Text("List is empty. Add your first wardrobe item.")
                            .font(FontManager.playfairDisplay(size: 18))
                            .foregroundColor(Color.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.filteredItems) { item in
                                NavigationLink(destination: ItemDetailView(itemId: item.id, viewModel: viewModel)) {
                                    ItemCardView(item: item, viewModel: viewModel)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddItem) {
            AddItemView(viewModel: viewModel)
        }
    }
}

struct ItemCardView: View {
    let item: WardrobeItem
    let viewModel: WardrobeViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(item.name)
                    .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(Color.textPrimary)
                    .lineLimit(2)
                
                Text(item.category)
                    .font(FontManager.playfairDisplay(size: 14))
                    .foregroundColor(Color.primaryYellow)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.primaryYellow.opacity(0.2))
                    .cornerRadius(8)
                
                if !item.description.isEmpty {
                    Text(item.description)
                        .font(FontManager.playfairDisplay(size: 14))
                        .foregroundColor(Color.textSecondary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            Button(action: {
                viewModel.togglePurchased(item)
            }) {
                Image(systemName: item.isPurchased ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(item.isPurchased ? Color.secondaryGreen : Color.textSecondary)
            }
        }
        .padding()
        .background(AppColorScheme.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
}

#Preview {
    ShoppingListView()
}
