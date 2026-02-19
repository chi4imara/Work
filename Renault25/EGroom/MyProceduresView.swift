import SwiftUI

private struct ProcedureIdItem: Identifiable {
    let id: UUID
}

struct MyProceduresView: View {
    @EnvironmentObject var viewModel: GroomingViewModel
    @State private var showAddProcedure = false
    @State private var selectedProcedureItem: ProcedureIdItem?
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("My Procedures")
                        .font(FontManager.playfairDisplay(.bold, size: 28))
                        .foregroundColor(.primaryWhite)
                    Spacer()
                    Button(action: { showAddProcedure = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.primaryOrange)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.procedures.isEmpty {
                    EmptyProceduresView {
                        showAddProcedure = true
                    }
                    
                    Spacer()
                } else {
                    ProceduresListView(onProcedureTap: { procedure in
                        selectedProcedureItem = ProcedureIdItem(id: procedure.id)
                    })
                }
            }
        }
        .sheet(isPresented: $showAddProcedure) {
            AddProcedureView()
        }
        .sheet(item: $selectedProcedureItem) { item in
            ProcedureDetailView(procedureId: item.id)
                .environmentObject(viewModel)
        }
    }
}

struct EmptyProceduresView: View {
    let onAddTap: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "list.clipboard")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(.primaryWhite.opacity(0.3))
                
                VStack(spacing: 8) {
                    Text("No Procedures Yet")
                        .font(FontManager.playfairDisplay(.semibold, size: 24))
                        .foregroundColor(.primaryWhite)
                    
                    Text("Add your first procedure or task and start your day productively")
                        .font(FontManager.playfairDisplay(.regular, size: 16))
                        .foregroundColor(.primaryWhite.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Button(action: onAddTap) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text("Add Procedure")
                            .font(FontManager.playfairDisplay(.semibold, size: 16))
                    }
                    .foregroundColor(.primaryWhite)
                    .frame(width: 160, height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.primaryOrange)
                    )
                }
                .padding(.top, 20)
            }
            
            Spacer()
        }
    }
}

struct ProceduresListView: View {
    @EnvironmentObject var viewModel: GroomingViewModel
    let onProcedureTap: (Procedure) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(groupedProcedures.keys.sorted(), id: \.self) { category in
                    ProcedureCategorySection(
                        category: category,
                        procedures: groupedProcedures[category] ?? [],
                        onProcedureTap: onProcedureTap
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var groupedProcedures: [Procedure.ProcedureCategory: [Procedure]] {
        Dictionary(grouping: viewModel.procedures) { $0.category }
    }
}

struct ProcedureCategorySection: View {
    let category: Procedure.ProcedureCategory
    let procedures: [Procedure]
    let onProcedureTap: (Procedure) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: category.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.primaryOrange)
                
                Text(category.rawValue)
                    .font(FontManager.playfairDisplay(.semibold, size: 20))
                    .foregroundColor(.primaryWhite)
                
                Spacer()
                
                Text("\(procedures.count)")
                    .font(FontManager.playfairDisplay(.medium, size: 14))
                    .foregroundColor(.primaryWhite.opacity(0.6))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.primaryWhite.opacity(0.1))
                    )
            }
            
            LazyVStack(spacing: 12) {
                ForEach(procedures) { procedure in
                    ProcedureCard(procedure: procedure) {
                        onProcedureTap(procedure)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardGradient)
        )
    }
}

struct ProcedureCard: View {
    @EnvironmentObject var viewModel: GroomingViewModel
    let procedure: Procedure
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Button(action: {
                    withAnimation(.spring()) {
                        viewModel.toggleProcedureCompletion(procedure)
                    }
                }) {
                    ZStack {
                        Circle()
                            .stroke(procedure.isCompleted ? Color.successGreen : Color.primaryWhite.opacity(0.3), lineWidth: 2)
                            .frame(width: 24, height: 24)
                        
                        if procedure.isCompleted {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.successGreen)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(procedure.name)
                            .font(FontManager.playfairDisplay(.semibold, size: 16))
                            .foregroundColor(.primaryWhite)
                            .strikethrough(procedure.isCompleted)
                        
                        if procedure.isFavorite {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.primaryOrange)
                        }
                    }
                    
                    Text(procedure.frequency)
                        .font(FontManager.playfairDisplay(.regular, size: 14))
                        .foregroundColor(.primaryWhite.opacity(0.6))
                    
                    if !procedure.notes.isEmpty {
                        Text(procedure.notes)
                            .font(FontManager.playfairDisplay(.regular, size: 12))
                            .foregroundColor(.primaryWhite.opacity(0.5))
                            .lineLimit(2)
                    }
                }
                
                Spacer()
                
                if !procedure.completionDates.isEmpty {
                    VStack(spacing: 4) {
                        Text("\(procedure.completionDates.count)")
                            .font(FontManager.playfairDisplay(.semibold, size: 16))
                            .foregroundColor(.primaryOrange)
                        
                        Text("times")
                            .font(FontManager.playfairDisplay(.regular, size: 10))
                            .foregroundColor(.primaryWhite.opacity(0.6))
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primaryWhite.opacity(0.4))
            }
            .padding(.vertical, 8)
        }
    }
}

struct MyProceduresView_Previews: PreviewProvider {
    static var previews: some View {
        MyProceduresView()
            .environmentObject(GroomingViewModel())
    }
}
