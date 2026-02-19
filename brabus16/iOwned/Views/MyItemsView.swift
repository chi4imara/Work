import SwiftUI

struct MyItemsView: View {
    @EnvironmentObject var viewModel: ItemsViewModel
    @State private var showingAddItem = false
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.items.isEmpty {
                    emptyStateView
                } else {
                    itemsListView
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Items")
                .font(.playfairDisplay(32, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    selectedTab = 2
                }
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(ColorTheme.primaryYellow)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "tray")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.primaryBlue.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("Here will appear information about your personal items. Add your first item to start the catalog.")
                    .font(.playfairDisplay(18, weight: .medium))
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Button(action: {
                    withAnimation {
                        selectedTab = 2
                    }
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Item")
                    }
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(ColorTheme.textPrimary)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(ColorTheme.primaryButtonGradient)
                    .cornerRadius(25)
                    .shadow(color: ColorTheme.primaryYellow.opacity(0.3), radius: 8, x: 0, y: 4)
                }
            }
            
            Spacer()
        }
    }
    
    private var itemsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.items) { item in
                    NavigationLink(destination: ItemDetailView(itemId: item.id)) {
                        ItemRowView(item: item)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
}

struct ItemRowView: View {
    let item: Item
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(ColorTheme.lightBlue)
                    .frame(width: 50, height: 50)
                
                Image(systemName: item.category.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(ColorTheme.textPrimary)
                    .lineLimit(1)
                
                Text(item.category.displayName)
                    .font(.playfairDisplay(14, weight: .medium))
                    .foregroundColor(ColorTheme.textSecondary)
                
                if !item.notes.isEmpty {
                    Text(item.notes)
                        .font(.playfairDisplay(12, weight: .regular))
                        .foregroundColor(ColorTheme.textSecondary.opacity(0.8))
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(ColorTheme.textSecondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}
