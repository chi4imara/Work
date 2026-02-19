import SwiftUI

struct DiaryView: View {
    @ObservedObject var viewModel: PullUpViewModel
    @State private var showingAddEntry = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                BackgroundView()
                
                VStack(spacing: 20) {
                    headerView
                    
                    periodFilterView
                    
                    if viewModel.filteredEntries.isEmpty {
                        emptyStateView
                        
                        Spacer()
                    } else {
                        entriesListView
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .sheet(isPresented: $showingAddEntry) {
            AddEntryView(viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Pull-up Diary")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: { showingAddEntry = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(AppColors.lightBlue)
            }
        }
        .padding(.vertical, 10)
    }
    
    private var periodFilterView: some View {
        HStack(spacing: 12) {
            ForEach(TimePeriod.allCases, id: \.self) { period in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.selectedPeriod = period
                    }
                }) {
                    Text(period.rawValue)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(viewModel.selectedPeriod == period ? .white : AppColors.secondaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(viewModel.selectedPeriod == period ? AppColors.lightBlue : Color.clear)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(AppColors.cardBorder, lineWidth: 1)
                        )
                }
            }
            
            Spacer()
        }
        .padding(.bottom, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 80))
                .foregroundColor(AppColors.lightBlue.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("Add your first workout entry")
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Start tracking your pull-up progress today")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingAddEntry = true }) {
                HStack {
                    Image(systemName: "plus")
                    Text("New Entry")
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            
            Spacer()
        }
    }
    
    private var entriesListView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredEntries) { entry in
                    NavigationLink(destination: EntryDetailView(entry: entry, viewModel: viewModel)) {
                        EntryRowView(entry: entry)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.bottom, 120) 
        }
    }
}

struct EntryRowView: View {
    let entry: PullUpEntry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.shortDateString)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                if !entry.comment.isEmpty {
                    Text(entry.comment)
                        .font(.ubuntu(14))
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(entry.count)")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.lightBlue)
                
                Text("pull-ups")
                    .font(.ubuntu(12))
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .padding(16)
        .cardStyle()
    }
}

#Preview {
    DiaryView(viewModel: PullUpViewModel())
}
