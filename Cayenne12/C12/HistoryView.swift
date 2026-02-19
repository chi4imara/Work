import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: ProceduresViewModel
    @State private var selectedProcedure: Procedure?
    @State private var showingProcedureDetails = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Text("History")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(AppColors.white)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                if viewModel.procedures.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 60))
                            .foregroundColor(AppColors.lightBlue.opacity(0.6))
                        
                        Text("You haven't added any procedures yet.")
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
                            ForEach(viewModel.procedures) { procedure in
                                ProcedureRowView(procedure: procedure) {
                                    selectedProcedure = procedure
                                    showingProcedureDetails = true
                                }
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
}

struct ProcedureRowView: View {
    let procedure: Procedure
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(procedure.dateString)
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(AppColors.white)
                        
                        Text(procedure.type.displayName)
                            .font(.ubuntu(14))
                            .foregroundColor(AppColors.lightBlue)
                    }
                    
                    Spacer()
                    
                    Button(action: onTap) {
                        Text("Open")
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(AppColors.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.orange)
                            )
                    }
                }
                
                if !procedure.products.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Products:")
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(AppColors.lightBlue.opacity(0.8))
                        
                        Text(procedure.products)
                            .font(.ubuntu(14))
                            .foregroundColor(AppColors.white.opacity(0.9))
                            .lineLimit(2)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardGradient)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
