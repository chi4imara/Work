import SwiftUI

struct ProcedureDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    let procedure: Procedure
    let dataManager: DataManager
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
    
    var body: some View {
        ZStack {
            ColorManager.shared.primaryBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text(dateFormatter.string(from: procedure.date))
                            .font(FontManager.playfairBold(size: 24))
                            .foregroundColor(ColorManager.shared.primaryText)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    if !procedure.barberName.isEmpty {
                        InfoCard(title: "Barber", content: procedure.barberName)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Services")
                            .font(FontManager.playfairSemiBold(size: 18))
                            .foregroundColor(ColorManager.shared.primaryText)
                        
                        VStack(spacing: 8) {
                            ForEach(procedure.services, id: \.id) { service in
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(ColorManager.shared.accentBlue)
                                    
                                    Text(service.displayName)
                                        .font(FontManager.playfairRegular(size: 16))
                                        .foregroundColor(ColorManager.shared.primaryText)
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(ColorManager.shared.cardBackground)
                                )
                            }
                        }
                    }
                    
                    if !procedure.comment.isEmpty {
                        InfoCard(title: "Comment", content: procedure.comment)
                    }
                    
                    VStack(spacing: 16) {
                        Button(action: { showingEditView = true }) {
                            HStack {
                                Image(systemName: "pencil")
                                    .font(.system(size: 16, weight: .medium))
                                
                                Text("Edit Procedure")
                                    .font(FontManager.playfairSemiBold(size: 16))
                            }
                            .foregroundColor(ColorManager.shared.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(ColorManager.shared.accentBlue)
                            )
                        }
                        
                        Button(action: { showingDeleteAlert = true }) {
                            HStack {
                                Image(systemName: "trash")
                                    .font(.system(size: 16, weight: .medium))
                                
                                Text("Delete Procedure")
                                    .font(FontManager.playfairSemiBold(size: 16))
                            }
                            .foregroundColor(ColorManager.shared.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(ColorManager.shared.errorColor)
                            )
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditView) {
            EditProcedureView(procedure: procedure, dataManager: dataManager)
        }
        .alert("Delete Procedure", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                dataManager.deleteProcedure(procedure)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this procedure? This action cannot be undone.")
        }
    }
}

struct InfoCard: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(FontManager.playfairSemiBold(size: 18))
                .foregroundColor(ColorManager.shared.primaryText)
            
            Text(content)
                .font(FontManager.playfairRegular(size: 16))
                .foregroundColor(ColorManager.shared.secondaryText)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorManager.shared.cardBackground)
                )
        }
    }
}

#Preview {
    NavigationView {
        ProcedureDetailView(
            procedure: Procedure(
                date: Date(),
                barberName: "Alex",
                services: [
                    Service(type: .haircut),
                    Service(type: .shave)
                ],
                comment: "Great service as always!"
            ),
            dataManager: DataManager.shared
        )
    }
}
