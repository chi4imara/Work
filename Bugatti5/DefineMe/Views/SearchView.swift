import SwiftUI

struct SearchView: View {
    @EnvironmentObject var dataManager: TermsDataManager
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    
    private var filteredTerms: [Term] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if query.isEmpty {
            return dataManager.terms.sorted(by: { $0.dateModified > $1.dateModified })
        }
        return dataManager.terms.filter {
            $0.name.lowercased().contains(query) ||
            $0.explanation.lowercased().contains(query)
        }.sorted(by: { $0.dateModified > $1.dateModified })
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Search")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppColors.secondaryText)
                    
                    TextField("Search terms or explanations", text: $searchText)
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.primaryText)
                        .focused($isSearchFocused)
                        .submitLabel(.search)
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(AppColors.secondaryText)
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.primaryText.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                if dataManager.terms.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(AppColors.accentYellow)
                        Text("No terms yet. Add terms in the Terms tab to search them.")
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        Spacer()
                    }
                } else if filteredTerms.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(AppColors.secondaryText)
                        Text("No results for \"\(searchText)\"")
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredTerms) { term in
                                NavigationLink(destination: TermDetailView(termId: term.id, dataManager: dataManager)) {
                                    TermRowView(term: term)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(TermsDataManager())
}
