import SwiftUI

struct DiagnosticsView: View {
    @State private var searchText = ""
    @State private var searchResults: [DiagnosticSymptom] = []
    @State private var commonSymptoms: [String] = []
    @State private var isSearching = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradients.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    searchBarView
                    
                    if searchText.isEmpty {
                        suggestionsView
                    } else if searchResults.isEmpty && !searchText.isEmpty {
                        noResultsView
                    } else {
                        resultsView
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            loadCommonSymptoms()
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Plant Diagnostics")
                .font(.titleLarge)
                .foregroundColor(.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchBarView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondaryText)
                
                TextField("Describe the problem (e.g., yellow leaves)", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .onChange(of: searchText) { newValue in
                        performSearch(newValue)
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        searchResults = []
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondaryText)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.cardBackground)
            .cornerRadius(12)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 3)
    }
    
    private var suggestionsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Common symptoms:")
                .font(.titleSmall)
                .foregroundColor(.primaryText)
                .padding(.horizontal, 20)
                .padding(.top, 12)
            
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 8) {
                    ForEach(commonSymptoms, id: \.self) { symptom in
                        Button(action: {
                            searchText = symptom
                        }) {
                            HStack {
                                Image(systemName: "leaf")
                                    .font(.system(size: 16))
                                    .foregroundColor(.accentGreen)
                                
                                Text(symptom.capitalized)
                                    .font(.bodyMedium)
                                    .foregroundColor(.primaryText)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondaryText)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.cardBackground)
                            .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    private var noResultsView: some View {
        VStack(spacing: 20) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 60))
                .foregroundColor(.secondaryText)
            
            Text("No matches found")
                .font(.titleMedium)
                .foregroundColor(.primaryText)
            
            Text("Try rephrasing your search or add more details like leaf color, spots, or plant behavior.")
                .font(.bodyMedium)
                .foregroundColor(.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var resultsView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                ForEach(searchResults) { symptom in
                    SymptomResultView(symptom: symptom)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
    }
    
    private func loadCommonSymptoms() {
        commonSymptoms = DiagnosticDataManager.shared.getCommonSymptoms()
    }
    
    private func performSearch(_ query: String) {
        if query.isEmpty {
            searchResults = []
            return
        }
        
        isSearching = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            searchResults = DiagnosticDataManager.shared.searchSymptoms(query)
            isSearching = false
        }
    }
}

struct SymptomResultView: View {
    let symptom: DiagnosticSymptom
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.accentOrange)
                
                Text("Possible causes for: \(symptom.symptom)")
                    .font(.titleSmall)
                    .foregroundColor(.primaryText)
                
                Spacer()
            }
            
            VStack(spacing: 8) {
                ForEach(symptom.possibleCauses) { cause in
                    NavigationLink(destination: DiagnosticDetailView(cause: cause)) {
                        CauseCardView(cause: cause)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.cardShadow, radius: 4, x: 0, y: 2)
    }
}

struct CauseCardView: View {
    let cause: PossibleCause
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(cause.name)
                    .font(.bodyLarge)
                    .foregroundColor(.primaryText)
                    .fontWeight(.semibold)
                
                Text(cause.description)
                    .font(.bodySmall)
                    .foregroundColor(.secondaryText)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.secondaryText)
        }
        .padding(12)
        .background(Color.accentBackground.opacity(0.3))
        .cornerRadius(10)
    }
}

#Preview {
    DiagnosticsView()
}


