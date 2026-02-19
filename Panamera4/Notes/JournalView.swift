import SwiftUI

struct JournalView: View {
    @EnvironmentObject var procedureStore: ProcedureStore
    @State private var searchText = ""
    @State private var showingAddProcedure = false
    
    var filteredProcedures: [HairCareProcedure] {
        procedureStore.filteredProcedures(searchText: searchText)
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Journal")
                        .font(.bellGothic(28, weight: .bold))
                        .foregroundColor(AppColors.primaryWhite)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddProcedure = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(AppColors.primaryWhite)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(AppColors.accentYellow)
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppColors.darkGray.opacity(0.6))
                    
                    TextField("Search procedures...", text: $searchText)
                        .font(.bellGothic(16, weight: .regular))
                        .foregroundColor(AppColors.darkGray)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(AppColors.cardBackground)
                )
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                if filteredProcedures.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "book.closed")
                            .font(.system(size: 60))
                            .foregroundColor(AppColors.primaryWhite.opacity(0.6))
                        
                        Text(searchText.isEmpty ? "No records yet. Add your first procedure." : "No procedures found.")
                            .font(.bellGothic(18, weight: .regular))
                            .foregroundColor(AppColors.primaryWhite)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredProcedures) { procedure in
                                NavigationLink(destination: ProcedureDetailView(procedureId: procedure.id)
                                    .environmentObject(procedureStore)) {
                                    ProcedureCardView(procedure: procedure)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddProcedure) {
            AddProcedureView()
        }
    }
}

struct ProcedureCardView: View {
    let procedure: HairCareProcedure
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: procedure.date)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            VStack {
                Image(systemName: procedure.category.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(AppColors.accentYellow)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(AppColors.primaryWhite.opacity(0.2))
                    )
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(procedure.name)
                    .font(.bellGothic(18, weight: .bold))
                    .foregroundColor(AppColors.darkGray)
                    .lineLimit(2)
                
                Text(formattedDate)
                    .font(.bellGothic(14, weight: .regular))
                    .foregroundColor(AppColors.darkGray.opacity(0.7))
                
                if !procedure.effect.isEmpty {
                    Text(procedure.effect)
                        .font(.bellGothic(14, weight: .regular))
                        .foregroundColor(AppColors.darkGray.opacity(0.8))
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppColors.darkGray.opacity(0.4))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}

#Preview {
    JournalView()
        .environmentObject(ProcedureStore())
        .primaryBackground()
}
