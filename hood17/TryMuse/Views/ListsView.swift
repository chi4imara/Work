import SwiftUI

struct ListsView: View {
    @ObservedObject var viewModel: ListViewModel
    @State private var showingAddList = false
    @State private var listToEdit: ListModel?
    @State private var listToDelete: ListModel?
    @State private var showingDeleteAlert = false
    @State private var selectedListId: UUID?
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("My Lists")
                            .font(.appLargeTitle)
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Button(action: {
                            showingAddList = true
                        }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(AppColors.yellow)
                                .frame(width: 44, height: 44)
                                .background(AppColors.cardBackground)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    if viewModel.lists.isEmpty {
                        EmptyListsView {
                            showingAddList = true
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.lists) { list in
                                    ListCardView(
                                        list: list,
                                        progress: viewModel.getProgress(for: list.id),
                                        onTap: {
                                            selectedListId = list.id
                                        },
                                        onEdit: {
                                            listToEdit = list
                                        },
                                        onDelete: {
                                            listToDelete = list
                                            showingDeleteAlert = true
                                        }
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
        .sheet(isPresented: $showingAddList) {
            AddEditListView(viewModel: viewModel, listToEdit: nil)
        }
        .sheet(item: $listToEdit) { list in
            AddEditListView(viewModel: viewModel, listToEdit: list)
        }
        .sheet(item: Binding<IdentifiableUUID?>(
            get: { selectedListId.map(IdentifiableUUID.init) },
            set: { selectedListId = $0?.id }
        )) { identifiableId in
            ListDetailView(viewModel: viewModel, listId: identifiableId.id)
        }
        .alert("Delete List", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let list = listToDelete {
                    viewModel.deleteList(list)
                }
            }
        } message: {
            Text("Are you sure you want to delete this list? All items will be permanently removed.")
        }
    }
}

struct EmptyListsView: View {
    let onCreateList: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "book.closed")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 16) {
                Text("No lists yet")
                    .font(.appTitle2)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Create your first list to get started!")
                    .font(.appBody)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: onCreateList) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("Create List")
                }
                .font(.appButton)
                .foregroundColor(AppColors.primaryText)
                .frame(height: 50)
                .frame(minWidth: 160)
                .background(AppColors.yellow)
                .cornerRadius(25)
                .shadow(color: AppColors.yellow.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct ListCardView: View {
    let list: ListModel
    let progress: (completed: Int, total: Int)
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(list.name)
                            .font(.appHeadline)
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.leading)
                        
                        Text(list.category.displayName)
                            .font(.appCaption)
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Spacer()
                    
                    Text("\(progress.completed) of \(progress.total)")
                        .font(.appFootnote)
                        .foregroundColor(AppColors.yellow)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(AppColors.yellow.opacity(0.2))
                        .cornerRadius(12)
                }
                
                if progress.total > 0 {
                    ProgressView(value: Double(progress.completed), total: Double(progress.total))
                        .progressViewStyle(LinearProgressViewStyle(tint: AppColors.yellow))
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                }
            }
            .padding(20)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .contextMenu {
            Button(action: onEdit) {
                Label("Edit", systemImage: "pencil")
            }
            
            Button(action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

#Preview {
    ListsView(viewModel: ListViewModel())
}
