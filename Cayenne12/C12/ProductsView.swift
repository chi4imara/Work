import SwiftUI

struct ProductsView: View {
    @ObservedObject var viewModel: ProceduresViewModel
    @State private var expandedProducts: Set<String> = []
    @State private var selectedProcedure: Procedure?
    @State private var showingProcedureDetails = false
    
    var productStatistics: [ProductStatistics] {
        viewModel.getProductStatistics()
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Text("Products")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(AppColors.white)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                if productStatistics.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "drop.triangle")
                            .font(.system(size: 60))
                            .foregroundColor(AppColors.lightBlue.opacity(0.6))
                        
                        Text("No product information available.")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Spacer()
                    }
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(productStatistics, id: \.name) { product in
                                ProductRowView(
                                    product: product,
                                    isExpanded: expandedProducts.contains(product.name),
                                    onToggleExpand: {
                                        withAnimation {
                                            toggleExpansion(for: product.name)
                                        }
                                    },
                                    onProcedureTap: { procedure in
                                        selectedProcedure = procedure
                                        showingProcedureDetails = true
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                    }
                }
            }
        }
        .sheet(item: $selectedProcedure) { procedure in
            ProcedureDetailsView(
                procedure: procedure,
                viewModel: viewModel,
                onDismiss: {
                    showingProcedureDetails = false
                    selectedProcedure = nil
                }
            )
        }
    }
    
    private func toggleExpansion(for productName: String) {
        if expandedProducts.contains(productName) {
            expandedProducts.remove(productName)
        } else {
            expandedProducts.insert(productName)
        }
    }
}

struct ProductRowView: View {
    let product: ProductStatistics
    let isExpanded: Bool
    let onToggleExpand: () -> Void
    let onProcedureTap: (Procedure) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: onToggleExpand) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(product.name)
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(AppColors.white)
                            .multilineTextAlignment(.leading)
                        
                        Text("\(product.usageCount) procedure\(product.usageCount == 1 ? "" : "s")")
                            .font(.ubuntu(14))
                            .foregroundColor(AppColors.lightBlue)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Text("Open")
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(AppColors.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.orange)
                            )
                        
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppColors.lightBlue)
                    }
                }
                .padding(16)
            }
            
            if isExpanded {
                VStack(spacing: 8) {
                    ForEach(product.procedures.sorted { $0.date > $1.date }) { procedure in
                        Button(action: { onProcedureTap(procedure) }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(procedure.dateString)
                                        .font(.ubuntu(14, weight: .medium))
                                        .foregroundColor(AppColors.white)
                                    
                                    Text(procedure.type.displayName)
                                        .font(.ubuntu(12))
                                        .foregroundColor(AppColors.lightBlue.opacity(0.8))
                                }
                                
                                Spacer()
                                
                                Text("Open")
                                    .font(.ubuntu(12, weight: .medium))
                                    .foregroundColor(AppColors.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(AppColors.lightBlue)
                                    )
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.darkBlue.opacity(0.3))
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: isExpanded ? 12 : 12)
                .fill(AppColors.cardGradient)
        )
    }
}
