import SwiftUI

struct TermsListView: View {
    @EnvironmentObject var dataManager: TermsDataManager
    @State private var showingAddTerm = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Terms")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if dataManager.terms.isEmpty {
                    VStack(spacing: 30) {
                        Spacer()
                        
                        Image(systemName: "book.closed")
                            .font(.system(size: 60))
                            .foregroundColor(AppColors.accentYellow)
                        
                        VStack(spacing: 16) {
                            Text("Your saved terms will appear here. Add the first one to start your glossary.")
                                .font(.ubuntu(18))
                                .foregroundColor(AppColors.secondaryText)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                            
                            Button("Add term") {
                                showingAddTerm = true
                            }
                            .buttonStyle(.primary)
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(dataManager.terms.sorted(by: { $0.dateModified > $1.dateModified })) { term in
                                NavigationLink(destination: TermDetailView(termId: term.id, dataManager: dataManager)) {
                                    TermRowView(term: term)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 120)
                    }
                }
                
                if !dataManager.terms.isEmpty {
                    Button("Add term") {
                        showingAddTerm = true
                    }
                    .buttonStyle(.primary)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .sheet(isPresented: $showingAddTerm) {
            AddTermView(dataManager: dataManager)
        }
    }
}

struct TermRowView: View {
    let term: Term
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(term.name)
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
                .lineLimit(1)
            
            Text(term.shortExplanation)
                .font(.ubuntu(14))
                .foregroundColor(AppColors.secondaryText)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.primaryText.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#Preview {
    TermsListView()
        .environmentObject(TermsDataManager())
}
