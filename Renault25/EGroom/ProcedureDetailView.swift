import SwiftUI

struct ProcedureDetailView: View {
    @EnvironmentObject var viewModel: GroomingViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showEditView = false
    @State private var showDeleteAlert = false
    
    let procedureId: UUID
    
    private var procedure: Procedure? {
        viewModel.procedure(byId: procedureId)
    }
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button("Close") { dismiss() }
                        .font(FontManager.playfairDisplay(.medium, size: 16))
                        .foregroundColor(.primaryWhite.opacity(0.8))
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if let procedure = procedure {
                    detailContent(procedure: procedure)
                } else {
                    VStack(spacing: 16) {
                        Text("Procedure not found")
                            .font(FontManager.playfairDisplay(.medium, size: 18))
                            .foregroundColor(.primaryWhite.opacity(0.8))
                        Button("Close") { dismiss() }
                            .font(FontManager.playfairDisplay(.semibold, size: 16))
                            .foregroundColor(.primaryOrange)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .sheet(isPresented: $showEditView) {
            if procedure != nil {
                EditProcedureView(procedureId: procedureId)
            }
        }
        .alert("Delete Procedure", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let p = procedure {
                    viewModel.deleteProcedure(p)
                }
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this procedure? This action cannot be undone.")
        }
    }
    
    private func detailContent(procedure: Procedure) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.cardGradient)
                            .frame(width: 80, height: 80)
                        Image(systemName: procedure.category.icon)
                            .font(.system(size: 32, weight: .medium))
                            .foregroundColor(.primaryOrange)
                    }
                    VStack(spacing: 8) {
                        Text(procedure.name)
                            .font(FontManager.playfairDisplay(.bold, size: 24))
                            .foregroundColor(.primaryWhite)
                            .multilineTextAlignment(.center)
                        Text(procedure.category.rawValue)
                            .font(FontManager.playfairDisplay(.medium, size: 16))
                            .foregroundColor(.primaryOrange)
                    }
                }
                .padding(.top, 20)
                
                VStack(spacing: 20) {
                    DetailRow(title: "Frequency", value: procedure.frequency, icon: "clock")
                    if !procedure.notes.isEmpty {
                        DetailRow(title: "Notes", value: procedure.notes, icon: "note.text")
                    }
                    DetailRow(
                        title: "Completed",
                        value: "\(procedure.completionDates.count) times",
                        icon: "checkmark.circle"
                    )
                    if let lastCompletion = procedure.completionDates.last {
                        DetailRow(
                            title: "Last Completed",
                            value: formatDate(lastCompletion),
                            icon: "calendar"
                        )
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.cardGradient)
                )
                .padding(.horizontal, 20)
                
                VStack(spacing: 16) {
                    Button(action: {
                        withAnimation(.spring()) {
                            viewModel.toggleProcedureFavorite(procedure)
                        }
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: procedure.isFavorite ? "star.fill" : "star")
                                .font(.system(size: 18, weight: .medium))
                            Text(procedure.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                                .font(FontManager.playfairDisplay(.semibold, size: 16))
                        }
                        .foregroundColor(.primaryWhite)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(procedure.isFavorite ? AnyShapeStyle(Color.primaryOrange) : AnyShapeStyle(Color.cardGradient))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.primaryOrange, lineWidth: 1)
                                )
                        )
                    }
                    
                    Button(action: { showEditView = true }) {
                        HStack(spacing: 12) {
                            Image(systemName: "pencil")
                                .font(.system(size: 18, weight: .medium))
                            Text("Edit")
                                .font(FontManager.playfairDisplay(.semibold, size: 16))
                        }
                        .foregroundColor(.primaryWhite)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.cardGradient)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.primaryWhite.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                    
                    Button(action: { showDeleteAlert = true }) {
                        HStack(spacing: 12) {
                            Image(systemName: "trash")
                                .font(.system(size: 18, weight: .medium))
                            Text("Delete")
                                .font(FontManager.playfairDisplay(.semibold, size: 16))
                        }
                        .foregroundColor(.warningRed)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.cardGradient)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.warningRed.opacity(0.5), lineWidth: 1)
                                )
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer(minLength: 100)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.primaryOrange)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(FontManager.playfairDisplay(.medium, size: 14))
                    .foregroundColor(.primaryWhite.opacity(0.7))
                
                Text(value)
                    .font(FontManager.playfairDisplay(.regular, size: 16))
                    .foregroundColor(.primaryWhite)
            }
            
            Spacer()
        }
    }
}

struct ProcedureDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = GroomingViewModel()
        let id = UUID()
        return ProcedureDetailView(procedureId: id)
            .environmentObject(vm)
    }
}
