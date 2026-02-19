import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: ProcedureViewModel
    @State private var selectedProcedure: Procedure?
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("History")
                        .font(FontManager.ubuntu(28, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.procedures.isEmpty {
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
                Image(systemName: "clock")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(ColorManager.accent)
                
                Text("History is empty")
                    .font(FontManager.ubuntu(20, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Your procedure history will appear here")
                    .font(FontManager.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
    }
    
    private var contentView: some View {
        ScrollView {
            historySection
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 120)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("History")
                .font(FontManager.ubuntu(28, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
        }
    }
    
    private var historySection: some View {
        LazyVStack(spacing: 24) {
            ForEach(viewModel.proceduresGroupedByMonth(), id: \.0) { monthYear, procedures in
                HistoryMonthSection(
                    monthYear: monthYear,
                    procedures: procedures
                ) { procedure in
                    selectedProcedure = procedure
                }
            }
        }
    }
}

struct HistoryMonthSection: View {
    let monthYear: String
    let procedures: [Procedure]
    let onProcedureTap: (Procedure) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(monthYear)
                    .font(FontManager.ubuntu(20, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
                
                Text("\(procedures.count) procedure\(procedures.count == 1 ? "" : "s")")
                    .font(FontManager.ubuntu(12, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(ColorManager.surfaceBackground)
                    .cornerRadius(12)
            }
            
            LazyVStack(spacing: 8) {
                ForEach(procedures) { procedure in
                    HistoryProcedureRowView(procedure: procedure) {
                        onProcedureTap(procedure)
                    }
                }
            }
        }
        .padding(16)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
    }
}

struct HistoryProcedureRowView: View {
    let procedure: Procedure
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(ColorManager.accentGradient.opacity(0.2))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: procedure.type.iconName)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(ColorManager.accent)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(procedure.type.displayName)
                            .font(FontManager.ubuntu(14, weight: .medium))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Spacer()
                        
                        Text(procedure.formattedDate)
                            .font(FontManager.ubuntu(11, weight: .regular))
                            .foregroundColor(ColorManager.tertiaryText)
                    }
                    
                    if !procedure.product.isEmpty {
                        HStack {
                            Image(systemName: "drop.fill")
                                .font(.system(size: 8, weight: .medium))
                                .foregroundColor(ColorManager.accent)
                            
                            Text(procedure.product)
                                .font(FontManager.ubuntu(12, weight: .regular))
                                .foregroundColor(ColorManager.secondaryText)
                        }
                    }
                    
                    if !procedure.note.isEmpty {
                        Text(procedure.note)
                            .font(FontManager.ubuntu(11, weight: .regular))
                            .foregroundColor(ColorManager.tertiaryText)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
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
    HistoryView(viewModel: ProcedureViewModel())
}
