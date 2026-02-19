import SwiftUI

struct MyShoesView: View {
    @EnvironmentObject var viewModel: ShoesViewModel
    @State private var showingAddShoe = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.primaryBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    filterView
                    
                    if viewModel.filteredShoes.isEmpty {
                        emptyStateView
                    } else {
                        shoesList
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddShoe) {
            AddShoeView()
                .environmentObject(viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Shoes")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            Button(action: {
                showingAddShoe = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                    .frame(width: 40, height: 40)
                    .background(ColorTheme.primaryButton)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var filterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ShoesViewModel.ShoeFilter.allCases, id: \.self) { filter in
                    Button(action: {
                        viewModel.setFilter(filter)
                    }) {
                        Text(filter.displayName)
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(viewModel.selectedFilter == filter ? ColorTheme.primaryText : ColorTheme.secondaryText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                viewModel.selectedFilter == filter ? 
                                ColorTheme.primaryButton : ColorTheme.cardBackground
                            )
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "shoe.2")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorTheme.secondaryText)
            
            Text("Add your first pair of shoes")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(ColorTheme.secondaryText)
            
            Button(action: {
                showingAddShoe = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Pair")
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(ColorTheme.primaryText)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(ColorTheme.primaryButton)
                .cornerRadius(25)
            }
            
            Spacer()
        }
    }
    
    private var shoesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredShoes) { shoe in
                    NavigationLink(destination: ShoeDetailView(shoe: shoe).environmentObject(viewModel)) {
                        ShoeCardView(shoe: shoe)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

struct ShoeCardView: View {
    let shoe: Shoe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(shoe.model)
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                        .lineLimit(1)
                    
                    Text(shoe.category.displayName)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorTheme.accentText)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    conditionBadge(shoe.condition)
                    
                    Text(shoe.season.displayName)
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(ColorTheme.secondaryText)
                }
            }
            
            HStack {
                Text("Purchased: \(formattedDate(shoe.purchaseDate))")
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(ColorTheme.secondaryText)
                
                Spacer()
            }
        }
        .padding(16)
        .background(ColorTheme.cardBackground)
        .cornerRadius(12)
    }
    
    private func conditionBadge(_ condition: ShoeCondition) -> some View {
        Text(condition.displayName)
            .font(.ubuntu(10, weight: .medium))
            .foregroundColor(ColorTheme.primaryText)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(conditionColor(condition))
            .cornerRadius(8)
    }
    
    private func conditionColor(_ condition: ShoeCondition) -> Color {
        switch condition {
        case .excellent:
            return ColorTheme.success
        case .good:
            return ColorTheme.lightBlue
        case .average:
            return ColorTheme.warning
        case .poor:
            return ColorTheme.error
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    MyShoesView()
        .environmentObject(ShoesViewModel())
}
