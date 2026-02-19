import SwiftUI

struct CatalogView: View {
    @ObservedObject var gadgetViewModel: GadgetViewModel
    @State private var selectedGadgetId: UUID?
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    private var selectedGadget: Gadget? {
        guard let id = selectedGadgetId else { return nil }
        return gadgetViewModel.gadgets.first { $0.id == id }
    }
    
    var body: some View {
        ZStack {
            Color.theme.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("Gadget Catalog")
                        .font(.playfairDisplay(size: 28, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                    
                    if !gadgetViewModel.gadgets.isEmpty {
                        Text("\(gadgetViewModel.gadgets.count) device\(gadgetViewModel.gadgets.count == 1 ? "" : "s")")
                            .font(.playfairDisplay(size: 14))
                            .foregroundColor(Color.theme.secondaryText)
                    }
                }
                .padding(.vertical, 10)
                
                if gadgetViewModel.gadgets.isEmpty {
                    EmptyStateView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(gadgetViewModel.gadgets) { gadget in
                                GadgetCard(gadget: gadget) {
                                    selectedGadgetId = gadget.id
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .sheet(item: Binding(
            get: { selectedGadget.map { GadgetIDWrapper(id: $0.id) } },
            set: { selectedGadgetId = $0?.id }
        )) { wrapper in
            if let gadget = gadgetViewModel.gadgets.first(where: { $0.id == wrapper.id }) {
                GadgetDetailsView(gadgetId: gadget.id, gadgetViewModel: gadgetViewModel)
            }
        }
    }
}

struct GadgetCard: View {
    let gadget: Gadget
    let action: () -> Void
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(gadget.name)
                            .font(.playfairDisplay(size: 18, weight: .bold))
                            .foregroundColor(Color.theme.primaryText)
                            .multilineTextAlignment(.leading)
                        
                        Text(gadget.category)
                            .font(.playfairDisplay(size: 12, weight: .medium))
                            .foregroundColor(Color.theme.lightBlue)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.theme.lightBlue.opacity(0.2))
                            )
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.theme.lightBlue)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Purchase Date")
                            .font(.playfairDisplay(size: 11))
                            .foregroundColor(Color.theme.secondaryText)
                        
                        Text(dateFormatter.string(from: gadget.purchaseDate))
                            .font(.playfairDisplay(size: 13, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Price")
                            .font(.playfairDisplay(size: 11))
                            .foregroundColor(Color.theme.secondaryText)
                        
                        Text(gadget.price)
                            .font(.playfairDisplay(size: 13, weight: .medium))
                            .foregroundColor(Color.theme.orange)
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
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(Color.theme.mediumGray)
            
            VStack(spacing: 8) {
                Text("You haven't added any gadgets yet.")
                    .font(.playfairDisplay(size: 18, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Add your first device to get started")
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
    CatalogView(gadgetViewModel: {
        let vm = GadgetViewModel()
        vm.gadgets = [
            Gadget(
                name: "iPhone 13",
                category: "Phone",
                purchaseDate: Date(),
                price: "$899",
                condition: "Excellent",
                serviceLife: "2",
                comment: "Used for work"
            ),
            Gadget(
                name: "MacBook Pro",
                category: "Laptop",
                purchaseDate: Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date(),
                price: "$2499",
                condition: "Good",
                serviceLife: "5",
                comment: ""
            )
        ]
        return vm
    }())
}
