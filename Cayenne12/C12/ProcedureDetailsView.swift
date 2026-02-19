import SwiftUI

struct ProcedureDetailsView: View {
    let procedure: Procedure
    @ObservedObject var viewModel: ProceduresViewModel
    let onDismiss: () -> Void
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Image(systemName: iconForType(procedure.type))
                                    .font(.system(size: 24))
                                    .foregroundColor(AppColors.orange)
                                
                                Text(procedure.type.displayName)
                                    .font(.ubuntu(24, weight: .bold))
                                    .foregroundColor(AppColors.white)
                                
                                Spacer()
                            }
                            
                            Divider()
                                .background(AppColors.white.opacity(0.3))
                            
                            DetailRow(
                                title: "Date",
                                content: procedure.dateString,
                                icon: "calendar"
                            )
                            
                            DetailRow(
                                title: "Products Used",
                                content: procedure.products,
                                icon: "drop.fill"
                            )
                            
                            DetailRow(
                                title: "Comment",
                                content: procedure.comment.isEmpty ? "No comment added." : procedure.comment,
                                icon: "text.quote",
                                isOptional: procedure.comment.isEmpty
                            )
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppColors.cardGradient)
                        )
                        
                        VStack(spacing: 16) {
                            Button(action: { showingEditView = true }) {
                                HStack {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 16, weight: .medium))
                                    
                                    Text("Edit")
                                        .font(.ubuntu(18, weight: .medium))
                                }
                                .foregroundColor(AppColors.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(AppColors.lightBlue)
                                )
                            }
                            
                            Button(action: { showingDeleteAlert = true }) {
                                HStack {
                                    Image(systemName: "trash")
                                        .font(.system(size: 16, weight: .medium))
                                    
                                    Text("Delete")
                                        .font(.ubuntu(18, weight: .medium))
                                }
                                .foregroundColor(AppColors.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(AppColors.red)
                                )
                            }
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(procedure.dateString)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onDismiss()
                    }
                    .foregroundColor(AppColors.orange)
                }
            }
            .sheet(isPresented: $showingEditView) {
                EditProcedureView(
                    procedure: procedure,
                    viewModel: viewModel,
                    onDismiss: onDismiss
                )
            }
            .alert("Delete Procedure", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    viewModel.deleteProcedure(procedure)
                    onDismiss()
                }
            } message: {
                Text("Are you sure you want to delete this procedure? This action cannot be undone.")
            }
        }
    }
    
    private func iconForType(_ type: ProcedureType) -> String {
        switch type {
        case .shaving:
            return "scissors"
        case .trimming:
            return "scissors.badge.ellipsis"
        case .beardCut:
            return "scissors.circle"
        }
    }
}

struct DetailRow: View {
    let title: String
    let content: String
    let icon: String
    var isOptional: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.lightBlue)
                
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.lightBlue)
            }
            
            Text(content)
                .font(.ubuntu(16))
                .foregroundColor(isOptional ? AppColors.white.opacity(0.6) : AppColors.white)
                .multilineTextAlignment(.leading)
        }
    }
}
