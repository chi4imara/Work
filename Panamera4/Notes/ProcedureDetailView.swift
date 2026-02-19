import SwiftUI

struct ProcedureDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var procedureStore: ProcedureStore
    
    let procedureId: UUID
    @State private var showingEditView = false
    
    private var procedure: HairCareProcedure? {
        procedureStore.procedures.first { $0.id == procedureId }
    }
    
    private var formattedDate: String {
        guard let procedure = procedure else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: procedure.date)
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            if let procedure = procedure {
                VStack(spacing: 0) {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(AppColors.primaryWhite)
                        }
                        
                        Spacer()
                        
                        Text(procedure.name.count > 20 ? String(procedure.name.prefix(20)) + "..." : procedure.name)
                            .font(.bellGothic(20, weight: .bold))
                            .foregroundColor(AppColors.primaryWhite)
                        
                        Spacer()
                        
                        Color.clear
                            .frame(width: 18, height: 18)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 20) {
                                HStack(spacing: 16) {
                                    Image(systemName: procedure.category.icon)
                                        .font(.system(size: 32, weight: .medium))
                                        .foregroundColor(AppColors.accentYellow)
                                        .frame(width: 60, height: 60)
                                        .background(
                                            Circle()
                                                .fill(AppColors.primaryWhite.opacity(0.2))
                                        )
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(procedure.name)
                                            .font(.bellGothic(24, weight: .bold))
                                            .foregroundColor(AppColors.darkGray)
                                            .lineLimit(nil)
                                        
                                        Text(procedure.category.displayName)
                                            .font(.bellGothic(16, weight: .regular))
                                            .foregroundColor(AppColors.darkGray.opacity(0.7))
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.bottom, 3)
                                
                                Divider()
                                    .background(AppColors.darkGray.opacity(0.2))
                                
                                DetailRowView(title: "Date", content: formattedDate)
                                
                                DetailRowView(
                                    title: "Effect",
                                    content: procedure.effect.isEmpty ? "No effect noted" : procedure.effect
                                )
                                
                                DetailRowView(
                                    title: "Description",
                                    content: procedure.description.isEmpty ? "No description provided" : procedure.description,
                                    isMultiline: true
                                )
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(AppColors.cardBackground)
                                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                            )
                            
                            VStack(spacing: 16) {
                                Button(action: {
                                    showingEditView = true
                                }) {
                                    HStack {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 18, weight: .medium))
                                        
                                        Text("Edit")
                                            .font(.bellGothic(18, weight: .bold))
                                    }
                                    .foregroundColor(AppColors.primaryWhite)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(AppColors.accentYellow)
                                    )
                                }
                                
                                Button(action: {
                                    deleteProcedure()
                                }) {
                                    HStack {
                                        Image(systemName: "trash")
                                            .font(.system(size: 18, weight: .medium))
                                        
                                        Text("Delete")
                                            .font(.bellGothic(18, weight: .bold))
                                    }
                                    .foregroundColor(AppColors.primaryWhite)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(AppColors.errorRed)
                                    )
                                }
                            }
                            
                            Spacer().frame(height: 100)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                    }
                }
            } else {
                VStack {
                    Text("Procedure not found")
                        .font(.bellGothic(18, weight: .regular))
                        .foregroundColor(AppColors.primaryWhite)
                    
                    Button("Go Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.bellGothic(16, weight: .bold))
                    .foregroundColor(AppColors.primaryWhite)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.accentYellow)
                    )
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEditView) {
            if let procedure = procedure {
                EditProcedureView(procedure: procedure)
            }
        }
    }
    
    private func deleteProcedure() {
        guard let procedure = procedure else { return }
        procedureStore.deleteProcedure(procedure)
        presentationMode.wrappedValue.dismiss()
    }
}

struct DetailRowView: View {
    let title: String
    let content: String
    let isMultiline: Bool
    
    init(title: String, content: String, isMultiline: Bool = false) {
        self.title = title
        self.content = content
        self.isMultiline = isMultiline
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.bellGothic(16, weight: .bold))
                .foregroundColor(AppColors.darkGray.opacity(0.7))
            
            Text(content)
                .font(.bellGothic(16, weight: .regular))
                .foregroundColor(AppColors.darkGray)
                .lineLimit(isMultiline ? nil : 3)
        }
    }
}

#Preview {
    let store = ProcedureStore()
    let sampleProcedure = HairCareProcedure(
        name: "Keratin Hair Mask",
        category: .masks,
        date: Date(),
        effect: "Smoother and shinier hair",
        description: "Applied keratin mask for 30 minutes, then rinsed with cool water. Hair feels much softer and looks healthier."
    )
    store.addProcedure(sampleProcedure)
    
    return ProcedureDetailView(procedureId: sampleProcedure.id)
        .environmentObject(store)
}
