import SwiftUI

struct ProcedureDetailView: View {
    @ObservedObject var viewModel: ProcedureViewModel
    @Environment(\.dismiss) private var dismiss
    
    let procedureId: UUID
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var procedure: Procedure? {
        viewModel.procedures.first { $0.id == procedureId }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.backgroundGradient
                    .ignoresSafeArea()
                
                if let procedure = procedure {
                    ScrollView {
                        VStack(spacing: 24) {
                            headerSection(procedure: procedure)
                            
                            detailsSection(procedure: procedure)
                            
                            actionButtonsSection(procedure: procedure)
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                } else {
                    VStack {
                        Text("Procedure not found")
                            .font(FontManager.ubuntu(18, weight: .medium))
                            .foregroundColor(ColorManager.secondaryText)
                    }
                }
            }
            .navigationTitle("Procedure Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(ColorManager.accent)
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            if let procedure = procedure {
                AddProcedureView(viewModel: viewModel, editingProcedure: procedure)
            }
        }
        .alert("Delete Procedure", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let procedure = procedure {
                    viewModel.deleteProcedure(procedure)
                }
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this procedure? This action cannot be undone.")
        }
    }
    
    private func headerSection(procedure: Procedure) -> some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(ColorManager.accentGradient)
                    .frame(width: 80, height: 80)
                
                Image(systemName: procedure.type.iconName)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
            }
            
            VStack(spacing: 8) {
                Text(procedure.type.displayName)
                    .font(FontManager.ubuntu(24, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text(procedure.formattedDate)
                    .font(FontManager.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
            }
        }
        .padding(.vertical, 20)
    }
    
    private func detailsSection(procedure: Procedure) -> some View {
        VStack(spacing: 16) {
            if !procedure.product.isEmpty {
                DetailRowView(
                    title: "Product",
                    content: procedure.product,
                    icon: "drop.fill"
                )
            }
            
            if !procedure.note.isEmpty {
                DetailRowView(
                    title: "Note",
                    content: procedure.note,
                    icon: "note.text"
                )
            }
            
            if procedure.product.isEmpty && procedure.note.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 24, weight: .light))
                        .foregroundColor(ColorManager.secondaryText)
                    
                    Text("No additional details")
                        .font(FontManager.ubuntu(16, weight: .regular))
                        .foregroundColor(ColorManager.secondaryText)
                }
                .padding(.vertical, 20)
            }
        }
    }
    
    private func actionButtonsSection(procedure: Procedure) -> some View {
        VStack(spacing: 12) {
            Button(action: {
                showingEditView = true
            }) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Edit Procedure")
                }
                .font(FontManager.ubuntu(16, weight: .medium))
                .foregroundColor(ColorManager.primaryText)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(ColorManager.accentGradient)
                .cornerRadius(25)
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete Procedure")
                }
                .font(FontManager.ubuntu(16, weight: .medium))
                .foregroundColor(ColorManager.error)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(ColorManager.cardGradient)
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(ColorManager.error.opacity(0.3), lineWidth: 1)
                )
            }
        }
        .padding(.top, 20)
    }
}

struct DetailRowView: View {
    let title: String
    let content: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorManager.accent)
                
                Text(title)
                    .font(FontManager.ubuntu(14, weight: .medium))
                    .foregroundColor(ColorManager.secondaryText)
            }
            
            Text(content)
                .font(FontManager.ubuntu(16, weight: .regular))
                .foregroundColor(ColorManager.primaryText)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(ColorManager.cardGradient)
        .cornerRadius(12)
    }
}

#Preview {
    let sampleProcedure = Procedure(
        type: .trim,
        date: Date(),
        product: "Beard Oil Premium",
        note: "Regular maintenance trim at the barbershop. Feeling fresh!"
    )
    
    let viewModel = ProcedureViewModel()
    viewModel.addProcedure(sampleProcedure)
    
    return ProcedureDetailView(viewModel: viewModel, procedureId: sampleProcedure.id)
}
