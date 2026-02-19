import SwiftUI

struct CategoryProceduresView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var procedureStore: ProcedureStore
    
    let category: ProcedureCategory
    
    private var procedures: [HairCareProcedure] {
        procedureStore.proceduresForCategory(category)
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
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
                    
                    Text(category.displayName)
                        .font(.bellGothic(24, weight: .bold))
                        .foregroundColor(AppColors.primaryWhite)
                    
                    Spacer()
                    
                    Color.clear
                        .frame(width: 18, height: 18)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                HStack(spacing: 12) {
                    Image(systemName: category.icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(AppColors.accentYellow)
                    
                    Text("\(procedures.count) \(procedures.count == 1 ? "procedure" : "procedures")")
                        .font(.bellGothic(16, weight: .regular))
                        .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                if procedures.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: category.icon)
                            .font(.system(size: 60))
                            .foregroundColor(AppColors.primaryWhite.opacity(0.6))
                        
                        Text("No records in this category yet.")
                            .font(.bellGothic(18, weight: .regular))
                            .foregroundColor(AppColors.primaryWhite)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(procedures) { procedure in
                                NavigationLink(destination: ProcedureDetailView(procedureId: procedure.id)
                                    .environmentObject(procedureStore)) {
                                    CategoryProcedureCardView(procedure: procedure)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

struct CategoryProcedureCardView: View {
    let procedure: HairCareProcedure
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: procedure.date)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 2) {
                Text(dayFromDate(procedure.date))
                    .font(.bellGothic(18, weight: .bold))
                    .foregroundColor(AppColors.accentYellow)
                
                Text(monthFromDate(procedure.date))
                    .font(.bellGothic(12, weight: .regular))
                    .foregroundColor(AppColors.darkGray.opacity(0.7))
            }
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .fill(AppColors.primaryWhite.opacity(0.9))
            )
            
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
    
    private func dayFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: date)
    }
    
    private func monthFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: date).uppercased()
    }
}

#Preview {
    let store = ProcedureStore()
    store.addProcedure(HairCareProcedure(
        name: "Keratin Hair Mask",
        category: .masks,
        date: Date(),
        effect: "Smoother hair",
        description: "Great results"
    ))
    
    return CategoryProceduresView(category: .masks)
        .environmentObject(store)
}
