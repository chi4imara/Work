import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: ListViewModel
    
    private var completedItems: [ListItemModel] {
        viewModel.getCompletedItems()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("History")
                            .font(.appLargeTitle)
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    if completedItems.isEmpty {
                        EmptyHistoryView()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(completedItems) { item in
                                    HistoryItemCardView(
                                        item: item,
                                        listName: viewModel.getList(by: item.listId)?.name ?? "Unknown List"
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct EmptyHistoryView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "clock")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 16) {
                Text("No completed items yet")
                    .font(.appTitle2)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Complete your first task to see it here!")
                    .font(.appBody)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct HistoryItemCardView: View {
    let item: ListItemModel
    let listName: String
    
    private var formattedDate: String {
        guard let completedAt = item.completedAt else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: completedAt)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(AppColors.success)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Completed \"\(item.name)\"")
                        .font(.appBody)
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(2)
                    
                    Text("from \(listName)")
                        .font(.appCaption)
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Text(formattedDate)
                    .font(.appCaption)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            if !item.notes.isEmpty {
                Text(item.notes)
                    .font(.appCaption)
                    .foregroundColor(AppColors.secondaryText)
                    .padding(.leading, 32)
                    .lineLimit(3)
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    HistoryView(viewModel: ListViewModel())
}
