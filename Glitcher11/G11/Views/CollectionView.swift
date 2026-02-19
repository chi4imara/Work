import SwiftUI

struct CollectionView: View {
    @ObservedObject private var viewModel = JewelryViewModel.shared
    @State private var showingAddJewelry = false
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchBar
                
                if viewModel.filteredJewelries.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    jewelryList
                }
            }
        }
        .sheet(isPresented: $showingAddJewelry) {
            AddJewelryView()
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Collection")
                .font(.playfairDisplay(28, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            Button(action: {
                showingAddJewelry = true
            }) {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundColor(ColorTheme.primaryText)
                    .frame(width: 44, height: 44)
                    .background(ColorTheme.cardGradient)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var searchBar: some View {
        ZStack(alignment: .leading) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(ColorTheme.secondaryText)
                
                TextField("", text: $viewModel.searchText)
                    .font(.playfairDisplay(16))
                    .foregroundColor(ColorTheme.primaryText)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(ColorTheme.cardGradient)
            .cornerRadius(12)
            
            if viewModel.searchText.isEmpty {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.clear)
                    
                    Text("Search jewelry")
                        .font(.playfairDisplay(16))
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .allowsHitTesting(false)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(ColorTheme.accent)
            
            Text("Collection is empty.")
                .font(.playfairDisplay(20, weight: .medium))
                .foregroundColor(ColorTheme.primaryText)
            
            Text("Add your first jewelry piece.")
                .font(.playfairDisplay(16))
                .foregroundColor(ColorTheme.secondaryText)
            
            Button(action: {
                showingAddJewelry = true
            }) {
                Text("Add Jewelry")
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(ColorTheme.primaryText)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(ColorTheme.buttonGradient)
                    .cornerRadius(25)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var jewelryList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredJewelries) { jewelry in
                    NavigationLink(destination: JewelryDetailView(jewelry: jewelry, viewModel: viewModel)) {
                        JewelryCard(jewelry: jewelry)
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

struct JewelryCard: View {
    let jewelry: Jewelry
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(jewelry.name)
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(ColorTheme.primaryText)
                    .lineLimit(1)
                
                HStack {
                    Text(jewelry.style)
                        .font(.playfairDisplay(14, weight: .medium))
                        .foregroundColor(ColorTheme.accentText)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(ColorTheme.lightBlue.opacity(0.2))
                        .cornerRadius(8)
                    
                    Text(jewelry.type.displayName)
                        .font(.playfairDisplay(14))
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                if !jewelry.note.isEmpty {
                    Text(jewelry.note)
                        .font(.playfairDisplay(14))
                        .foregroundColor(ColorTheme.secondaryText)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            VStack {
                if jewelry.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(ColorTheme.orange)
                        .font(.system(size: 16))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(ColorTheme.secondaryText)
                    .font(.system(size: 14))
            }
        }
        .padding(16)
        .background(ColorTheme.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.accent.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    CollectionView()
}
