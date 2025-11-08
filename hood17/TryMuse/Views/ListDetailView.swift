import SwiftUI

struct ListDetailView: View {
    @ObservedObject var viewModel: ListViewModel
    let listId: UUID
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAddItem = false
    @State private var itemToEdit: ListItemModel?
    @State private var showingEditList = false
    
    private var list: ListModel? {
        viewModel.getList(by: listId)
    }
    
    private var items: [ListItemModel] {
        viewModel.getItems(for: listId)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(AppColors.primaryText)
                    }
                    
                    Spacer()
                    
                    Text(list?.name ?? "List")
                        .font(.appNavTitle)
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Button(action: {
                        showingEditList = true
                    }) {
                        Text("Edit")
                            .font(.appBody)
                            .foregroundColor(AppColors.yellow)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                if items.isEmpty {
                    EmptyItemsView {
                        showingAddItem = true
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(items) { item in
                                ListItemCardView(
                                    item: item,
                                    onToggle: {
                                        viewModel.toggleItemCompletion(item)
                                    },
                                    onEdit: {
                                        itemToEdit = item
                                    },
                                    onDelete: {
                                        viewModel.deleteItem(item)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
                
                Spacer()
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        showingAddItem = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                            Text("Add Item")
                        }
                        .font(.appButton)
                        .foregroundColor(AppColors.primaryText)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(AppColors.yellow)
                        .cornerRadius(25)
                        .shadow(color: AppColors.yellow.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    Spacer()
                }
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingAddItem) {
            AddEditItemView(viewModel: viewModel, listId: listId, itemToEdit: nil)
        }
        .sheet(item: $itemToEdit) { item in
            AddEditItemView(viewModel: viewModel, listId: listId, itemToEdit: item)
        }
        .sheet(isPresented: $showingEditList) {
            if let list = list {
                AddEditListView(viewModel: viewModel, listToEdit: list)
            }
        }
    }
}

struct EmptyItemsView: View {
    let onAddItem: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "list.bullet")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 16) {
                Text("No items yet")
                    .font(.appTitle2)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add your first item to this list!")
                    .font(.appBody)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct ListItemCardView: View {
    let item: ListItemModel
    let onToggle: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: onToggle) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(item.isCompleted ? AppColors.success : AppColors.secondaryText)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.appBody)
                    .foregroundColor(item.isCompleted ? AppColors.secondaryText : AppColors.primaryText)
                    .strikethrough(item.isCompleted)
                
                if !item.notes.isEmpty {
                    Text(item.notes)
                        .font(.appCaption)
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(2)
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
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
    ListDetailView(viewModel: ListViewModel(), listId: UUID())
}
