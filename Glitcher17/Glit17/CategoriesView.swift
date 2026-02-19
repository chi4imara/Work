import SwiftUI

struct CategoriesView: View {
    @ObservedObject var appState: AppState
    
    var body: some View {
        ZStack {
            ColorManager.mainGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Categories")
                        .font(FontManager.ubuntu(28, weight: .bold))
                        .foregroundColor(ColorManager.textWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        let categoriesWithProcedures = appState.categoriesWithProcedures()
                        
                        if categoriesWithProcedures.isEmpty {
                            EmptyStateView(
                                message: "Categories will appear after adding procedures.",
                                icon: "folder.badge.plus"
                            )
                            .padding(.top, 100)
                        } else {
                            ForEach(categoriesWithProcedures.sorted(by: { $0.name < $1.name }), id: \.id) { category in
                                NavigationLink(destination: CategoryProceduresView(category: category, appState: appState)) {
                                    CategoryCardView(
                                        category: category,
                                        procedureCount: appState.procedureCount(for: category)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                    .padding(.bottom, 120)
                }
            }
        }
    }
}

struct CategoryCardView: View {
    let category: Category
    let procedureCount: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(category.name)
                    .font(FontManager.ubuntu(20, weight: .bold))
                    .foregroundColor(ColorManager.textWhite)
                
                Text("\(procedureCount) procedure\(procedureCount == 1 ? "" : "s")")
                    .font(FontManager.ubuntu(14, weight: .medium))
                    .foregroundColor(ColorManager.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(ColorManager.accentYellow)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
        )
    }
}

struct CategoryProceduresView: View {
    let category: Category
    @ObservedObject var appState: AppState
    
    private var categoryProcedures: [Procedure] {
        appState.proceduresFor(category: category)
    }
    
    var body: some View {
        ZStack {
            ColorManager.mainGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text(category.name)
                        .font(FontManager.ubuntu(24, weight: .bold))
                        .foregroundColor(ColorManager.textWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if categoryProcedures.isEmpty {
                            EmptyStateView(
                                message: "No procedures in this category yet.",
                                icon: "folder.badge.questionmark"
                            )
                            .padding(.top, 100)
                        } else {
                            ForEach(categoryProcedures) { procedure in
                                CategoryProcedureCardView(
                                    procedure: procedure,
                                    appState: appState
                                )
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                }
                
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: NavigationBackButton()
        )
    }
}

struct CategoryProcedureCardView: View {
    let procedure: Procedure
    @ObservedObject var appState: AppState
    @State private var showingDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(procedure.name)
                        .font(FontManager.ubuntu(18, weight: .bold))
                        .foregroundColor(ColorManager.textWhite)
                    
                    Label(procedure.frequency.displayText, systemImage: "clock")
                        .font(FontManager.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorManager.textSecondary)
                }
                
                Spacer()
            }
            
            Button(action: {
                showingDetails = true
            }) {
                Text("More details")
                    .font(FontManager.ubuntu(14, weight: .medium))
                    .foregroundColor(ColorManager.accentYellow)
                    .underline()
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
        )
        .sheet(isPresented: $showingDetails) {
            ProcedureDetailsView(procedureId: procedure.id, appState: appState)
        }
    }
}

struct NavigationBackButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .medium))
                Text("Back")
                    .font(FontManager.ubuntu(16, weight: .medium))
            }
            .foregroundColor(ColorManager.textWhite)
        }
    }
}

#Preview {
    CategoriesView(appState: AppState())
}
