import SwiftUI

struct ProcedureDetailView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) private var dismiss
    
    let procedure: Procedure
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: procedure.category.icon)
                                .font(.title)
                                .foregroundColor(AppColors.primaryText)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(procedure.name)
                                    .font(.custom("PlayfairDisplay-Bold", size: 24))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Text(procedure.category.rawValue)
                                    .font(.custom("PlayfairDisplay-Regular", size: 16))
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            
                            Spacer()
                        }
                        
                        Divider()
                        
                        DetailRow(title: "Date", value: DateFormatter.longDate.string(from: procedure.date))
                        
                        if !procedure.products.isEmpty {
                            DetailRow(title: "Products Used", value: procedure.products)
                        }
                        
                        if !procedure.comment.isEmpty {
                            DetailRow(title: "Comment", value: procedure.comment)
                        } else {
                            DetailRow(title: "Comment", value: "No comment added")
                        }
                    }
                    .padding(20)
                    .background(AppColors.cardBackground)
                    .cornerRadius(16)
                    .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
                    
                    VStack(spacing: 12) {
                        Button(action: {
                            showingEditView = true
                        }) {
                            HStack {
                                Image(systemName: "pencil")
                                Text("Edit Procedure")
                                    .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppColors.purpleGradient)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete Procedure")
                                    .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppColors.warningRed.opacity(0.1))
                            .foregroundColor(AppColors.warningRed)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColors.warningRed, lineWidth: 1)
                            )
                        }
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(20)
            }
        }
        .navigationTitle("Procedure Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditView) {
            EditProcedureView(procedure: procedure)
        }
        .alert("Delete Procedure", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                dataManager.deleteProcedure(procedure)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this procedure? This action cannot be undone.")
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("PlayfairDisplay-SemiBold", size: 14))
                .foregroundColor(AppColors.primaryText)
            
            Text(value)
                .font(.custom("PlayfairDisplay-Regular", size: 16))
                .foregroundColor(AppColors.secondaryText)
        }
    }
}

#Preview {
    NavigationView {
        ProcedureDetailView(procedure: Procedure(
            name: "Face Mask",
            category: .skin,
            date: Date(),
            products: "Glow Cream Mask, Fresh Tonic",
            comment: "Great effect, skin looks fresher"
        ))
    }
    .environmentObject(DataManager())
}
