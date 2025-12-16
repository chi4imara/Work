import SwiftUI

struct HistoryView: View {
    @ObservedObject var momentsViewModel: DailyMomentsViewModel
    @State private var searchText = ""
    @State private var showingFilters = false
    @State private var selectedModal: ModalType?
    @State private var filteredMoments: [DailyMoment] = []
    
    var body: some View {
        ZStack {
            AppGradients.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchBar
                
                if filteredMoments.isEmpty && momentsViewModel.moments.isEmpty {
                    emptyStateView
                } else if filteredMoments.isEmpty && !searchText.isEmpty {
                    noResultsView
                } else {
                    momentsList
                }
            }
        }
        .onAppear {
            updateFilteredMoments()
        }
        .onChange(of: searchText) { _ in
            updateFilteredMoments()
        }
        .onChange(of: momentsViewModel.moments) { _ in
            updateFilteredMoments()
        }
        .sheet(item: $selectedModal) { modal in
            switch modal {
            case .momentDetail(let id):
                if let moment = momentsViewModel.moments.first(where: { $0.id == id }) {
                    MomentDetailView(moment: moment, momentsViewModel: momentsViewModel)
                } else {
                    EmptyView()
                }
            case .editMoment(let id):
                if let moment = momentsViewModel.moments.first(where: { $0.id == id }) {
                    EditMomentView(moment: moment, momentsViewModel: momentsViewModel)
                } else {
                    EmptyView()
                }
            default:
                EmptyView()
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("History")
                .font(.builderSans(size: 24, weight: .bold))
                .foregroundColor(.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondaryText)
            
            TextField("Search moments...", text: $searchText)
                .font(.builderSans(size: 16, weight: .regular))
                .foregroundColor(.primaryText)
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondaryText)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.9))
        )
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 10)
    }
    
    private var momentsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                    ForEach(filteredMoments) { moment in
                        MomentCard(moment: moment) {
                            selectedModal = .momentDetail(moment.id)
                        }
                    }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "moon")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(.lavender)
                
                VStack(spacing: 8) {
                    Text("Your living moments will appear here.")
                        .font(.builderSans(size: 18, weight: .medium))
                        .foregroundColor(.primaryText)
                        .multilineTextAlignment(.center)
                    
                    Text("Start today.")
                        .font(.builderSans(size: 16, weight: .regular))
                        .foregroundColor(.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var noResultsView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50, weight: .light))
                .foregroundColor(.secondaryText)
            
            Text("No moments found")
                .font(.builderSans(size: 18, weight: .medium))
                .foregroundColor(.primaryText)
            
            Text("Try adjusting your search")
                .font(.builderSans(size: 14, weight: .regular))
                .foregroundColor(.secondaryText)
            
            Spacer()
        }
    }
    
    private func updateFilteredMoments() {
        if searchText.isEmpty {
            filteredMoments = momentsViewModel.moments
        } else {
            filteredMoments = momentsViewModel.filteredMoments(searchText: searchText, dateRange: nil)
        }
    }
}

struct MomentCard: View {
    let moment: DailyMoment
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(systemName: "leaf")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.softGreen)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(moment.dateString)
                        .font(.builderSans(size: 16, weight: .semibold))
                        .foregroundColor(.primaryText)
                        .lineLimit(1)
                    
                    Text(moment.shortText)
                        .font(.builderSans(size: 14, weight: .regular))
                        .foregroundColor(.secondaryText)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(moment.timeString)
                        .font(.builderSans(size: 12, weight: .medium))
                        .foregroundColor(.secondaryText)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondaryText)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppGradients.cardGradient)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MomentDetailView: View {
    let moment: DailyMoment
    @ObservedObject var momentsViewModel: DailyMomentsViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedModal: ModalType?
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradients.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(moment.dateString)
                                .font(.builderSans(size: 20, weight: .bold))
                                .foregroundColor(.primaryText)
                            
                            Text("Recorded at \(moment.timeString)")
                                .font(.builderSans(size: 14, weight: .medium))
                                .foregroundColor(.secondaryText)
                        }
                        
                        Text(moment.text)
                            .font(.builderSans(size: 16, weight: .regular))
                            .foregroundColor(.primaryText)
                            .lineSpacing(6)
                        
                        Spacer(minLength: 100)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                }
            }
            .navigationTitle("Moment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Edit") {
                            selectedModal = .editMoment(moment.id)
                        }
                        
                        Button("Delete", role: .destructive) {
                            showingDeleteAlert = true
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.primaryText)
                    }
                }
            }
        }
        .sheet(item: $selectedModal) { modal in
            switch modal {
            case .editMoment(let id):
                if let moment = momentsViewModel.moments.first(where: { $0.id == id }) {
                    EditMomentView(moment: moment, momentsViewModel: momentsViewModel)
                } else {
                    EmptyView()
                }
            default:
                EmptyView()
            }
        }
        .alert("Delete Moment", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                momentsViewModel.deleteMoment(moment)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this moment? This action cannot be undone.")
        }
    }
}

#Preview {
    HistoryView(momentsViewModel: DailyMomentsViewModel())
}
