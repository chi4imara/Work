import SwiftUI

struct MySalonView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddProcedure = false
    @State private var showingTemplates = false
    @State private var showingCalendar = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("My Salon")
                            .font(.custom("PlayfairDisplay-Bold", size: 32))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        HStack(spacing: 12) {
                            Button(action: {
                                showingCalendar = true
                            }) {
                                Image(systemName: "calendar")
                                    .font(.title3)
                                    .foregroundColor(AppColors.primaryText)
                                    .padding(8)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(8)
                            }
                            
                            Button(action: {
                                showingTemplates = true
                            }) {
                                Image(systemName: "doc.text.fill")
                                    .font(.title3)
                                    .foregroundColor(AppColors.primaryText)
                                    .padding(8)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(8)
                            }
                            
                            Button(action: {
                                showingAddProcedure = true
                            }) {
                                Image(systemName: "plus")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(AppColors.purpleGradient)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    SearchBar(text: $searchText)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 8)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            CategoryFilterButton(
                                title: "All Procedures",
                                isSelected: dataManager.selectedCategory == nil && dataManager.selectedProduct == nil
                            ) {
                                dataManager.clearFilters()
                            }
                            
                            ForEach(ProcedureCategory.allCases, id: \.self) { category in
                                CategoryFilterButton(
                                    title: category.rawValue,
                                    isSelected: dataManager.selectedCategory == category && dataManager.selectedProduct == nil
                                ) {
                                    dataManager.selectedCategory = category
                                    dataManager.selectedProduct = nil
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 16)
                    
                    if let selectedProduct = dataManager.selectedProduct {
                        HStack {
                            Text("Filtered by product: \(selectedProduct)")
                                .font(.custom("PlayfairDisplay-Medium", size: 14))
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                            
                            Button(action: {
                                dataManager.selectedProduct = nil
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(AppColors.secondaryText)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(AppColors.accentYellow.opacity(0.2))
                        .padding(.bottom, 6)
                    }
                    
                    if dataManager.filteredAndSearchedProcedures(searchText: searchText).isEmpty {
                        EmptyStateView()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(dataManager.filteredAndSearchedProcedures(searchText: searchText)) { procedure in
                                    NavigationLink(destination: ProcedureDetailView(procedure: procedure)) {
                                        ProcedureCardView(procedure: procedure)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddProcedure) {
                AddProcedureView()
            }
            .sheet(isPresented: $showingTemplates) {
                TemplatesView()
            }
            .sheet(isPresented: $showingCalendar) {
                CalendarView()
            }
            .navigationBarHidden(true)
        }
    }
}

struct CategoryFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("PlayfairDisplay-Medium", size: 14))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ? AnyShapeStyle(AppColors.purpleGradient) : AnyShapeStyle(Color.clear)
                )
                .foregroundColor(isSelected ? .white : AppColors.primaryText)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AppColors.primaryText.opacity(0.3), lineWidth: 1)
                )
                .cornerRadius(20)
        }
    }
}

struct ProcedureCardView: View {
    let procedure: Procedure
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: procedure.category.icon)
                    .foregroundColor(AppColors.primaryText)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(procedure.name)
                        .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(procedure.category.rawValue)
                        .font(.custom("PlayfairDisplay-Regular", size: 14))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Text(DateFormatter.shortDate.string(from: procedure.date))
                    .font(.custom("PlayfairDisplay-Regular", size: 12))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            if !procedure.products.isEmpty {
                Text("Products: \(procedure.products)")
                    .font(.custom("PlayfairDisplay-Regular", size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(2)
            }
            
            if !procedure.comment.isEmpty {
                Text(procedure.comment)
                    .font(.custom("PlayfairDisplay-Italic", size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(2)
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText)
            
            Text("No records yet. Add your first procedure to start your beauty salon.")
                .font(.custom("PlayfairDisplay-Regular", size: 16))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.secondaryText)
            
            TextField("Search procedures...", text: $text)
                .font(.custom("PlayfairDisplay-Regular", size: 16))
                .foregroundColor(AppColors.primaryText)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
        .padding(12)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.primaryText.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    MySalonView()
        .environmentObject(DataManager())
}
