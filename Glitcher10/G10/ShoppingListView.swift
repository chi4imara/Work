import SwiftUI

struct ShoppingListView: View {
    @ObservedObject var viewModel: ShoppingViewModel
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("Shopping List")
                        .font(FontManager.ubuntu(size: 28, weight: .bold))
                        .foregroundColor(ColorManager.white)
                    
                    if viewModel.hasItems {
                        Text("\(viewModel.items.count) items")
                            .font(FontManager.ubuntu(size: 16))
                            .foregroundColor(ColorManager.white.opacity(0.7))
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
                
                if viewModel.hasItems {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.items) { item in
                                NavigationLink(destination: ItemDetailView(itemId: item.id, viewModel: viewModel)) {
                                    ShoppingItemCard(item: item)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                } else {
                    EmptyStateView(
                        iconName: "list.bullet",
                        title: "No Items Yet",
                        description: "You haven't created any items yet.",
                        actionTitle: "Add First Item",
                        action: {
                            viewModel.selectedTab = .add
                        }
                    )
                }
            }
        }
    }
}

struct ShoppingItemCard: View {
    let item: ShoppingItem
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(ColorManager.lightBlue.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: categoryIcon(for: item.category))
                    .font(.system(size: 20))
                    .foregroundColor(ColorManager.lightBlue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(FontManager.ubuntu(size: 18, weight: .medium))
                    .foregroundColor(ColorManager.white)
                    .lineLimit(2)
                
                HStack(spacing: 12) {
                    Label(item.category, systemImage: "folder")
                        .font(FontManager.ubuntu(size: 14))
                        .foregroundColor(ColorManager.lightBlue)
                        .lineLimit(2)
                    
                    Label(item.quantity, systemImage: "number")
                        .font(FontManager.ubuntu(size: 14))
                        .foregroundColor(ColorManager.orange)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(ColorManager.white.opacity(0.6))
                
                Text("Open")
                    .font(FontManager.ubuntu(size: 12))
                    .foregroundColor(ColorManager.white.opacity(0.6))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorManager.lightBlue.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: ColorManager.darkBlue.opacity(0.3), radius: 8, x: 0, y: 4)
    }
    
    private func categoryIcon(for category: String) -> String {
        switch category.lowercased() {
        case "oils", "oil":
            return "drop.fill"
        case "parts", "part":
            return "gearshape.fill"
        case "tools", "tool":
            return "wrench.fill"
        case "materials", "material":
            return "cube.fill"
        default:
            return "tag.fill"
        }
    }
}

struct EmptyStateView: View {
    let iconName: String
    let title: String
    let description: String
    let actionTitle: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(ColorManager.cardGradient)
                    .frame(width: 100, height: 100)
                
                Image(systemName: iconName)
                    .font(.system(size: 40))
                    .foregroundColor(ColorManager.lightBlue.opacity(0.6))
            }
            
            VStack(spacing: 12) {
                Text(title)
                    .font(FontManager.ubuntu(size: 24, weight: .bold))
                    .foregroundColor(ColorManager.white)
                
                Text(description)
                    .font(FontManager.ubuntu(size: 16))
                    .foregroundColor(ColorManager.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: action) {
                Text(actionTitle)
                    .font(FontManager.ubuntu(size: 16, weight: .medium))
                    .foregroundColor(ColorManager.white)
                    .frame(width: 200, height: 50)
                    .background(ColorManager.buttonGradient)
                    .cornerRadius(12)
            }
            
            Spacer()
        }
    }
}

#Preview {
    ShoppingListView(viewModel: ShoppingViewModel())
}
