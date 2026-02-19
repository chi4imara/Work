import SwiftUI

struct TermDetailView: View {
    let termId: UUID
    @ObservedObject var dataManager: TermsDataManager
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditTerm = false
    @State private var showingDeleteAlert = false
    
    private var term: Term? {
        dataManager.getTerm(by: termId)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            if let term = term {
                termContent(term: term)
            } else {
                termNotFoundView
            }
        }
        .navigationBarHidden(true)
        .onChange(of: dataManager.terms.count) { _ in
            if dataManager.getTerm(by: termId) == nil {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private func termContent(term: Term) -> some View {
        VStack(spacing: 0) {
            HStack {
                Button("Back") {
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.ubuntu(16))
                .foregroundColor(AppColors.accentYellow)
                
                Spacer()
                
                Menu {
                    Button("Edit") {
                        showingEditTerm = true
                    }
                    
                    Button("Delete", role: .destructive) {
                        showingDeleteAlert = true
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title2)
                        .foregroundColor(AppColors.accentYellow)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 10)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text(term.name)
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Explanation")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.accentYellow)
                        
                        Text(term.explanation)
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.primaryText)
                            .lineSpacing(4)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Created:")
                                .font(.ubuntu(12, weight: .medium))
                                .foregroundColor(AppColors.secondaryText)
                            
                            Text(term.dateCreated, style: .date)
                                .font(.ubuntu(12))
                                .foregroundColor(AppColors.secondaryText)
                        }
                        
                        if term.dateModified != term.dateCreated {
                            HStack {
                                Text("Modified:")
                                    .font(.ubuntu(12, weight: .medium))
                                    .foregroundColor(AppColors.secondaryText)
                                
                                Text(term.dateModified, style: .date)
                                    .font(.ubuntu(12))
                                    .foregroundColor(AppColors.secondaryText)
                            }
                        }
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            
            HStack(spacing: 16) {
                Button("Edit") {
                    showingEditTerm = true
                }
                .buttonStyle(.secondary)
                .frame(maxWidth: .infinity)
                
                Button("Delete") {
                    showingDeleteAlert = true
                }
                .buttonStyle(.destructive)
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .sheet(isPresented: $showingEditTerm) {
            if let currentTerm = dataManager.getTerm(by: termId) {
                EditTermView(term: currentTerm, dataManager: dataManager)
            }
        }
        .alert("Delete Term", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                dataManager.deleteTerm(term)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete '\(term.name)'? This action cannot be undone.")
        }
    }
    
    private var termNotFoundView: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "questionmark.circle")
                .font(.system(size: 50))
                .foregroundColor(AppColors.secondaryText)
            Text("Term not found")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            Button("Back") {
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(.primary)
            Spacer()
        }
    }
}

#Preview {
    NavigationView {
        TermDetailView(
            termId: UUID(),
            dataManager: TermsDataManager()
        )
    }
}
