import SwiftUI

struct JournalView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var searchText = ""
    @State private var selectedCategory: ServiceCategory = .all
    @State private var showingAddProcedure = false
    @Binding var selectedTab: TabItem
    
    private var filteredProcedures: [Procedure] {
        dataManager.filteredProcedures(searchText: searchText, category: selectedCategory)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                HStack {
                    Text("Procedure Journal")
                        .font(FontManager.playfairBold(size: 24))
                        .foregroundColor(ColorManager.shared.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            selectedTab = .add
                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(ColorManager.shared.primaryText)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(ColorManager.shared.accentBlue)
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(ColorManager.shared.secondaryText)
                    
                    TextField("Search procedures or barber...", text: $searchText)
                        .font(FontManager.playfairRegular(size: 16))
                        .foregroundColor(ColorManager.shared.primaryText)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorManager.shared.cardBackground)
                )
                .padding(.horizontal, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(ServiceCategory.allCases, id: \.self) { category in
                            CategoryButton(
                                category: category,
                                isSelected: selectedCategory == category
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.bottom, 20)
            
            if filteredProcedures.isEmpty {
                EmptyStateView(selectedTab: $selectedTab, showingAddProcedure: $showingAddProcedure)
                
                Spacer()
            } else {
                ProceduresList(procedures: filteredProcedures, dataManager: dataManager)
            }
        }
        .sheet(isPresented: $showingAddProcedure) {
            AddProcedureView(selectedTab: $selectedTab)
        }
    }
}

struct CategoryButton: View {
    let category: ServiceCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(category.rawValue)
                .font(FontManager.playfairMedium(size: 14))
                .foregroundColor(isSelected ? ColorManager.shared.primaryText : ColorManager.shared.secondaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? ColorManager.shared.accentBlue : ColorManager.shared.cardBackground)
                )
        }
    }
}

struct EmptyStateView: View {
    @Binding var selectedTab: TabItem
    @Binding var showingAddProcedure: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "scissors")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorManager.shared.secondaryText)
            
            VStack(spacing: 12) {
                Text("Add your first procedure")
                    .font(FontManager.playfairSemiBold(size: 20))
                    .foregroundColor(ColorManager.shared.primaryText)
                
                Text("Start tracking your barber visits")
                    .font(FontManager.playfairRegular(size: 16))
                    .foregroundColor(ColorManager.shared.secondaryText)
            }
            
            Button(action: {
                withAnimation {
                    selectedTab = .add
                }
            }) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .medium))
                    
                    Text("Add Procedure")
                        .font(FontManager.playfairSemiBold(size: 18))
                }
                .foregroundColor(ColorManager.shared.primaryText)
                .padding(.horizontal, 30)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorManager.shared.accentOrange)
                )
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

struct ProceduresList: View {
    let procedures: [Procedure]
    let dataManager: DataManager
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(procedures) { procedure in
                    NavigationLink(destination: ProcedureDetailView(procedure: procedure, dataManager: dataManager)) {
                        ProcedureRowView(procedure: procedure)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
}

struct ProcedureRowView: View {
    let procedure: Procedure
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(dateFormatter.string(from: procedure.date))
                    .font(FontManager.playfairSemiBold(size: 16))
                    .foregroundColor(ColorManager.shared.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(ColorManager.shared.secondaryText)
            }
            
            Text(procedure.servicesDisplayText)
                .font(FontManager.playfairRegular(size: 14))
                .foregroundColor(ColorManager.shared.accentBlue)
                .lineLimit(2)
            
            if !procedure.barberName.isEmpty {
                Text("Barber: \(procedure.barberName)")
                    .font(FontManager.playfairRegular(size: 14))
                    .foregroundColor(ColorManager.shared.secondaryText)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorManager.shared.cardBackground)
        )
    }
}

