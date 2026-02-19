import SwiftUI

struct ProceduresView: View {
    @ObservedObject var viewModel: ProcedureViewModel
    @State private var showingNewProcedure = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Procedures")
                        .font(.bellGothic(size: 28, weight: .bold))
                        .foregroundColor(AppColors.primaryBlue)
                    
                    Spacer()
                    
                    Button(action: {
                        showingNewProcedure = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(AppColors.primaryYellow)
                            .clipShape(Circle())
                            .shadow(color: AppColors.primaryYellow.opacity(0.3), radius: 4, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.procedures.isEmpty {
                    VStack(spacing: 30) {
                        Spacer()
                        
                        Image(systemName: "list.clipboard")
                            .font(.system(size: 80))
                            .foregroundColor(AppColors.primaryBlue.opacity(0.3))
                        
                        VStack(spacing: 15) {
                            Text("No procedures yet.")
                                .font(.bellGothic(size: 22, weight: .bold))
                                .foregroundColor(AppColors.primaryBlue)
                            
                            Text("Add your first procedure to get started.")
                                .font(.bellGothic(size: 16))
                                .foregroundColor(AppColors.darkGray)
                                .multilineTextAlignment(.center)
                        }
                        
                        Button(action: {
                            showingNewProcedure = true
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                    .font(.system(size: 16, weight: .bold))
                                Text("Add Procedure")
                                    .font(.bellGothic(size: 16, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(AppColors.primaryYellow)
                            .cornerRadius(25)
                            .shadow(color: AppColors.primaryYellow.opacity(0.3), radius: 6, x: 0, y: 3)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.procedures) { procedure in
                                NavigationLink(destination: ProcedureDetailView(procedureId: procedure.id, viewModel: viewModel)) {
                                    ProcedureCardView(procedure: procedure)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                    }
                }
            }
        }
        .sheet(isPresented: $showingNewProcedure) {
            NewProcedureView(viewModel: viewModel)
        }
    }
}

struct ProcedureCardView: View {
    let procedure: Procedure
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(procedure.name)
                        .font(.bellGothic(size: 18, weight: .bold))
                        .foregroundColor(AppColors.primaryBlue)
                        .lineLimit(2)
                    
                    if !procedure.description.isEmpty {
                        Text(procedure.description)
                            .font(.bellGothic(size: 14))
                            .foregroundColor(AppColors.darkGray)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
                
                VStack {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.primaryYellow)
                    
                    Text("\(procedure.steps.count)")
                        .font(.bellGothic(size: 14, weight: .bold))
                        .foregroundColor(AppColors.primaryBlue)
                }
            }
            
            if !procedure.steps.isEmpty {
                Text("\(procedure.steps.count) steps")
                    .font(.bellGothic(size: 12))
                    .foregroundColor(AppColors.darkGray.opacity(0.7))
            }
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(12)
        .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    ProceduresView(viewModel: ProcedureViewModel())
}
