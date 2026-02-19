import SwiftUI

struct CategoriesView: View {
    @ObservedObject var gadgetViewModel: GadgetViewModel
    @State private var selectedCategory: Category?
    
    var body: some View {
        ZStack {
            Color.theme.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("Categories")
                        .font(.playfairDisplay(size: 28, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                    
                    let categories = gadgetViewModel.getCategories()
                    if !categories.isEmpty {
                        Text("\(categories.count) categor\(categories.count == 1 ? "y" : "ies")")
                            .font(.playfairDisplay(size: 14))
                            .foregroundColor(Color.theme.secondaryText)
                    }
                }
                .padding(.vertical, 10)
                
                let categories = gadgetViewModel.getCategories()
                if categories.isEmpty {
                    EmptyCategoriesView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(categories) { category in
                                CategoryCard(category: category) {
                                    selectedCategory = category
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .sheet(item: $selectedCategory) { category in
            CategoryGadgetsView(category: category.name, gadgetViewModel: gadgetViewModel)
        }
    }
}

struct CategoryCard: View {
    let category: Category
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(category.name)
                            .font(.playfairDisplay(size: 20, weight: .bold))
                            .foregroundColor(Color.theme.primaryText)
                            .multilineTextAlignment(.leading)
                        
                        Text("\(category.count) device\(category.count == 1 ? "" : "s")")
                            .font(.playfairDisplay(size: 14))
                            .foregroundColor(Color.theme.secondaryText)
                    }
                    
                    Spacer()
                    
                    Image(systemName: categoryIcon(for: category.name))
                        .font(.system(size: 24))
                        .foregroundColor(Color.theme.lightBlue)
                }
                
                if category.gadgets.count > 0 {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Recent devices:")
                                .font(.playfairDisplay(size: 12))
                                .foregroundColor(Color.theme.secondaryText)
                            Spacer()
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(Array(category.gadgets.prefix(3)), id: \.id) { gadget in
                                HStack {
                                    Circle()
                                        .fill(Color.theme.orange)
                                        .frame(width: 4, height: 4)
                                    
                                    Text(gadget.name)
                                        .font(.playfairDisplay(size: 12))
                                        .foregroundColor(Color.theme.primaryText)
                                        .lineLimit(1)
                                    
                                    Spacer()
                                }
                            }
                            
                            if category.gadgets.count > 3 {
                                HStack {
                                    Circle()
                                        .fill(Color.theme.mediumGray)
                                        .frame(width: 4, height: 4)
                                    
                                    Text("and \(category.gadgets.count - 3) more...")
                                        .font(.playfairDisplay(size: 12))
                                        .foregroundColor(Color.theme.mediumGray)
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    
                    Text("Open")
                        .font(.playfairDisplay(size: 14, weight: .semibold))
                        .foregroundColor(Color.theme.primaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.theme.accentGradient)
                        )
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.theme.cardBackground)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.theme.lightBlue.opacity(0.3), lineWidth: 1)
                    }
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func categoryIcon(for category: String) -> String {
        switch category.lowercased() {
        case "phone":
            return "iphone"
        case "laptop":
            return "laptopcomputer"
        case "headphones":
            return "headphones"
        case "watch":
            return "applewatch"
        case "tablet":
            return "ipad"
        case "camera":
            return "camera"
        case "gaming console":
            return "gamecontroller"
        case "smart tv":
            return "tv"
        case "speaker":
            return "speaker.wave.2"
        default:
            return "laptopcomputer"
        }
    }
}

struct CategoryGadgetsView: View {
    let category: String
    @ObservedObject var gadgetViewModel: GadgetViewModel
    @State private var selectedGadgetId: UUID?
    @Environment(\.dismiss) private var dismiss
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    private var gadgets: [Gadget] {
        gadgetViewModel.gadgets.filter { $0.category == category }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.primaryGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    VStack(spacing: 8) {
                        Text(category)
                            .font(.playfairDisplay(size: 28, weight: .bold))
                            .foregroundColor(Color.theme.primaryText)
                        
                        Text("\(gadgets.count) device\(gadgets.count == 1 ? "" : "s")")
                            .font(.playfairDisplay(size: 14))
                            .foregroundColor(Color.theme.secondaryText)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(gadgets) { gadget in
                                CategoryGadgetCard(gadget: gadget) {
                                    selectedGadgetId = gadget.id
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color.theme.lightBlue)
                    }
                }
            }
        }
        .sheet(item: Binding(
            get: { selectedGadgetId.map { GadgetIDWrapper(id: $0) } },
            set: { selectedGadgetId = $0?.id }
        )) { wrapper in
            if let gadget = gadgetViewModel.gadgets.first(where: { $0.id == wrapper.id }) {
                GadgetDetailsView(gadgetId: gadget.id, gadgetViewModel: gadgetViewModel)
            }
        }
    }
}

struct CategoryGadgetCard: View {
    let gadget: Gadget
    let action: () -> Void
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(gadget.name)
                        .font(.playfairDisplay(size: 16, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                        .multilineTextAlignment(.leading)
                    
                    Text(dateFormatter.string(from: gadget.purchaseDate))
                        .font(.playfairDisplay(size: 12))
                        .foregroundColor(Color.theme.secondaryText)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(gadget.price)
                        .font(.playfairDisplay(size: 14, weight: .semibold))
                        .foregroundColor(Color.theme.orange)
                    
                    Text("Open")
                        .font(.playfairDisplay(size: 12, weight: .medium))
                        .foregroundColor(Color.theme.lightBlue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.theme.lightBlue.opacity(0.2))
                        )
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.theme.cardBackground)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.theme.lightBlue.opacity(0.3), lineWidth: 1)
                    }
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EmptyCategoriesView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "folder")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(Color.theme.mediumGray)
            
            VStack(spacing: 8) {
                Text("Categories not created yet.")
                    .font(.playfairDisplay(size: 18, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Add some gadgets to see categories")
                    .font(.playfairDisplay(size: 14))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
}

#Preview {
    CategoriesView(gadgetViewModel: {
        let vm = GadgetViewModel()
        vm.gadgets = [
            Gadget(name: "iPhone 13", category: "Phone", purchaseDate: Date(), price: "$899", condition: "Excellent", serviceLife: "2", comment: ""),
            Gadget(name: "MacBook Pro", category: "Laptop", purchaseDate: Date(), price: "$2499", condition: "Good", serviceLife: "5", comment: ""),
            Gadget(name: "AirPods Pro", category: "Headphones", purchaseDate: Date(), price: "$249", condition: "Good", serviceLife: "3", comment: "")
        ]
        return vm
    }())
}
