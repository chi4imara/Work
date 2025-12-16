import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var manicureStore: ManicureStore
    @State private var searchText = ""
    @State private var showingAddManicure = false
    @State private var selectedFilter: FilterType = .none
    
    enum FilterType: String, CaseIterable {
        case none = "All"
        case date = "By Date"
        case color = "By Color"
        case salon = "By Salon"
    }
    
    private var filteredManicures: [Manicure] {
        let searchResults = manicureStore.searchManicures(searchText)
        
        switch selectedFilter {
        case .none:
            return searchResults
        case .date:
            return searchResults.sorted { $0.date > $1.date }
        case .color:
            return searchResults.sorted { $0.color < $1.color }
        case .salon:
            return searchResults.sorted { $0.salon < $1.salon }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("My History")
                            .font(.playfairDisplay(28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Button(action: { showingAddManicure = true }) {
                            Image(systemName: "plus")
                                .font(.playfairDisplay(28, weight: .bold))
                                .foregroundColor(AppColors.yellowAccent)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    searchBar
                    
                    filterBar
                    
                    if manicureStore.manicures.isEmpty {
                        emptyStateView
                    } else {
                        manicuresList
                    }
                }
            }
            .sheet(isPresented: $showingAddManicure) {
                AddManicureView()
            }
            .navigationBarHidden(true)
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.secondaryText)
            
            TextField("Search by color, salon, or notes...", text: $searchText)
                .font(.playfairDisplay(16))
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(AppColors.backgroundWhite.opacity(0.8))
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(FilterType.allCases, id: \.self) { filter in
                    Button(action: { selectedFilter = filter }) {
                        Text(filter.rawValue)
                            .font(.playfairDisplay(14, weight: .medium))
                            .foregroundColor(selectedFilter == filter ? AppColors.contrastText : AppColors.blueText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                selectedFilter == filter ?
                                AnyShapeStyle(AppColors.purpleGradient) :
                                    AnyShapeStyle(AppColors.backgroundWhite.opacity(0.6))
                            )
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "paintbrush")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("Here will appear your nail history")
                    .font(.playfairDisplay(22, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Add your first record to start tracking your colors!")
                    .font(.playfairDisplay(16))
                    .foregroundColor(AppColors.blueText)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            
            Button(action: { showingAddManicure = true }) {
                Text("Add Manicure")
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(AppColors.contrastText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(AppColors.purpleGradient)
                    .cornerRadius(25)
            }
            .padding(.horizontal, 60)
            
            Spacer()
        }
    }
    
    private var manicuresList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(filteredManicures) { manicure in
                    NavigationLink(destination: ManicureDetailView(manicureId: manicure.id)) {
                        ManicureCardView(manicure: manicure)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }
}

struct ManicureCardView: View {
    let manicure: Manicure
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(manicure.color)
                        .font(.playfairDisplay(20, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(dateFormatter.string(from: manicure.date))
                        .font(.playfairDisplay(14))
                        .foregroundColor(AppColors.blueText)
                }
                
                Spacer()
                
                Circle()
                    .fill(AppColors.yellowAccent)
                    .frame(width: 12, height: 12)
            }
            
            if !manicure.salon.isEmpty {
                HStack {
                    Image(systemName: "location.fill")
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text(manicure.salon)
                        .font(.playfairDisplay(14))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            if !manicure.note.isEmpty {
                Text(manicure.note)
                    .font(.playfairDisplay(14))
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(2)
            }
        }
        .padding(16)
        .background(AppColors.backgroundWhite.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
