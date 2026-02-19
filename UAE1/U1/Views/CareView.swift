import SwiftUI

struct CareView: View {
    @ObservedObject var viewModel: ProcedureViewModel
    @State private var showingAddProcedure = false
    @State private var selectedProcedure: Procedure?
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                headerView
                
                if let lastProcedure = viewModel.lastProcedure {
                    lastProcedureSection(lastProcedure)
                }
                
                if viewModel.procedures.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    contentView
                }
            }
        }
        .sheet(isPresented: $showingAddProcedure) {
            AddProcedureView(viewModel: viewModel)
        }
        .sheet(item: $selectedProcedure) { procedure in
            ProcedureDetailView(viewModel: viewModel, procedureId: procedure.id)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "scissors")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(ColorManager.accent)
                
                Text("Add your first beard care procedure")
                    .font(FontManager.ubuntu(20, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Start tracking your beard care routine")
                    .font(FontManager.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                showingAddProcedure = true
            }) {
                Text("Add Procedure")
                    .font(FontManager.ubuntu(18, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(ColorManager.accentGradient)
                    .cornerRadius(25)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var contentView: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                allProceduresSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Care")
                .font(FontManager.ubuntu(28, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
            
            Button(action: {
                showingAddProcedure = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("Add")
                }
                .font(FontManager.ubuntu(16, weight: .medium))
                .foregroundColor(ColorManager.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(ColorManager.accentGradient)
                .cornerRadius(20)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private func lastProcedureSection(_ procedure: Procedure) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Last Procedure")
                .font(FontManager.ubuntu(18, weight: .medium))
                .foregroundColor(ColorManager.primaryText)
            
            Button(action: {
                selectedProcedure = procedure
            }) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(ColorManager.accentGradient)
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: procedure.type.iconName)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(ColorManager.primaryText)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(procedure.type.displayName)
                            .font(FontManager.ubuntu(16, weight: .medium))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Text(procedure.formattedDate)
                            .font(FontManager.ubuntu(14, weight: .regular))
                            .foregroundColor(ColorManager.secondaryText)
                        
                        if !procedure.note.isEmpty {
                            Text(procedure.note)
                                .font(FontManager.ubuntu(12, weight: .regular))
                                .foregroundColor(ColorManager.tertiaryText)
                                .lineLimit(2)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(ColorManager.tertiaryText)
                }
                .padding(16)
                .background(ColorManager.cardGradient)
                .cornerRadius(16)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
    
    private var allProceduresSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All Procedures")
                .font(FontManager.ubuntu(18, weight: .medium))
                .foregroundColor(ColorManager.primaryText)
            
            LazyVStack(spacing: 12) {
                ForEach(viewModel.sortedProcedures) { procedure in
                    ProcedureRowView(procedure: procedure) {
                        selectedProcedure = procedure
                    }
                }
            }
        }
    }
}

#Preview {
    CareView(viewModel: ProcedureViewModel())
}
