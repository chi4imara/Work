import SwiftUI

struct CatalogView: View {
    @ObservedObject var viewModel: RitualViewModel
    @State private var showAddRitual = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("My Rituals")
                        .font(.appTitle())
                        .foregroundColor(AppColors.textWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.rituals.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    ritualsList
                }
            }
            
            if !viewModel.rituals.isEmpty {
                VStack {
                    Spacer()
                    
                    Button(action: {
                        showAddRitual = true
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Ritual")
                        }
                        .font(.appButton())
                        .foregroundColor(AppColors.textWhite)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppColors.accentPurple)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
            }
        }
        .sheet(isPresented: $showAddRitual) {
            NewRitualView(viewModel: viewModel)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "book.closed")
                .font(.system(size: 80))
                .foregroundColor(AppColors.accentPurple.opacity(0.6))
                .padding(.bottom, 20)
            
            Text("Here will be your little rituals and quirks. Add the first one to capture what makes you you.")
                .font(.appBody())
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                showAddRitual = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Ritual")
                }
                .font(.appButton())
                .foregroundColor(AppColors.textWhite)
                .padding()
                .frame(maxWidth: .infinity)
                .background(AppColors.accentPurple)
                .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var ritualsList: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.rituals) { ritual in
                        NavigationLink(destination: RitualDetailView(viewModel: viewModel, ritualId: ritual.id)) {
                            RitualRowView(ritual: ritual)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
    }
}

struct RitualRowView: View {
    let ritual: Ritual
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(ritual.title)
                .font(.appHeadline())
                .foregroundColor(AppColors.textWhite)
            
            Text(ritual.shortDescription)
                .font(.appBody())
                .foregroundColor(AppColors.textSecondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(12)
    }
}
