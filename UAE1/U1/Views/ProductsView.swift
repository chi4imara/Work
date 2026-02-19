import SwiftUI

struct ProductsView: View {
    @ObservedObject var viewModel: ProcedureViewModel
    @State private var selectedProduct: String?
    @State private var selectedProcedure: Procedure?
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                headerView
                
                if viewModel.allProducts.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    contentView
                }
            }
        }
        .sheet(item: $selectedProcedure) { procedure in
            ProcedureDetailView(viewModel: viewModel, procedureId: procedure.id)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "drop")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(ColorManager.accent)
                
                Text("No products yet")
                    .font(FontManager.ubuntu(20, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Add products when creating procedures")
                    .font(FontManager.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
    }
    
    private var contentView: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                productsSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Products")
                .font(FontManager.ubuntu(28, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var productsSection: some View {
        LazyVStack(spacing: 12) {
            ForEach(viewModel.allProducts, id: \.self) { product in
                ProductRowView(
                    product: product,
                    usageCount: viewModel.productUsageCount(product: product),
                    isExpanded: selectedProduct == product
                ) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedProduct = selectedProduct == product ? nil : product
                    }
                }
                
                if selectedProduct == product {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.proceduresUsing(product: product)) { procedure in
                            ProductProcedureRowView(procedure: procedure) {
                                selectedProcedure = procedure
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
            }
        }
    }
}

struct ProductRowView: View {
    let product: String
    let usageCount: Int
    let isExpanded: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(ColorManager.accentGradient)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "drop.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(ColorManager.primaryText)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(product)
                        .font(FontManager.ubuntu(16, weight: .medium))
                        .foregroundColor(ColorManager.primaryText)
                        .multilineTextAlignment(.leading)
                    
                    Text("Used \(usageCount) time\(usageCount == 1 ? "" : "s")")
                        .font(FontManager.ubuntu(12, weight: .regular))
                        .foregroundColor(ColorManager.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorManager.tertiaryText)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
            }
            .padding(16)
            .background(ColorManager.cardGradient)
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.3), value: isExpanded)
    }
}

struct ProductProcedureRowView: View {
    let procedure: Procedure
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: procedure.type.iconName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorManager.accent)
                    .frame(width: 20, height: 20)
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(procedure.type.displayName)
                            .font(FontManager.ubuntu(14, weight: .medium))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Spacer()
                        
                        Text(procedure.shortFormattedDate)
                            .font(FontManager.ubuntu(12, weight: .regular))
                            .foregroundColor(ColorManager.tertiaryText)
                    }
                    
                    if !procedure.note.isEmpty {
                        Text(procedure.note)
                            .font(FontManager.ubuntu(11, weight: .regular))
                            .foregroundColor(ColorManager.tertiaryText)
                            .lineLimit(1)
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(ColorManager.tertiaryText)
            }
            .padding(12)
            .background(ColorManager.surfaceBackground)
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ProductsView(viewModel: ProcedureViewModel())
}
