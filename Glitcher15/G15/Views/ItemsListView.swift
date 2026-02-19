import SwiftUI

struct ItemsListView: View {
    @ObservedObject var viewModel: ItemsViewModel
    @State private var showingAddItem = false
    @State private var showingSetPicker = false
    @State private var selectedItemId: UUID?
    @State private var showingCreateSetDialog = false
    @State private var newSetName = ""
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                setPickerView
                
                if viewModel.currentItems.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    itemsListView
                }
            }
        }
        .sheet(item: Binding(
            get: { selectedItemId.map(IdentifiableUUID.init) },
            set: { selectedItemId = $0?.id }
        )) { wrapper in
            ItemDetailView(itemId: wrapper.id, viewModel: viewModel)
        }
        .sheet(isPresented: $showingCreateSetDialog) {
            CreateSetView(
                viewModel: viewModel,
                setName: $newSetName,
                isPresented: $showingCreateSetDialog
            )
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Items List")
                .font(FontManager.playfairBold(size: 28))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: {
                showingAddItem = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(AppColors.lightBlue)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var setPickerView: some View {
        HStack {
            Menu {
                ForEach(Array(viewModel.itemSets.enumerated()), id: \.offset) { index, set in
                    Button(action: {
                        viewModel.switchToSet(at: index)
                    }) {
                        HStack {
                            Text(set.name)
                            if index == viewModel.currentSetIndex {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
                
                Divider()
                
                Button("Create New Set") {
                    showingCreateSetDialog = true
                }
            } label: {
                HStack {
                    Text(viewModel.currentSet.name)
                        .font(FontManager.playfairMedium(size: 16))
                        .foregroundColor(AppColors.primaryText)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.secondaryText)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardGradient)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.yellow.opacity(0.3), lineWidth: 1)
                        )
                )
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "bag")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText)
            
            Text("This set is empty. Add items.")
                .font(FontManager.playfairMedium(size: 18))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var itemsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.currentItems) { item in
                    ItemCardView(item: item, viewModel: viewModel) {
                        selectedItemId = item.id
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 120)
        }
    }
}

struct ItemCardView: View {
    let item: Item
    let viewModel: ItemsViewModel
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Button(action: {
                    viewModel.toggleItemInBag(item)
                }) {
                    Image(systemName: item.isInBag ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24))
                        .foregroundColor(item.isInBag ? AppColors.success : AppColors.secondaryText)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(FontManager.playfairSemiBold(size: 16))
                        .foregroundColor(AppColors.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(item.category.displayName)
                        .font(FontManager.playfairRegular(size: 14))
                        .foregroundColor(AppColors.yellow)
                    
                    if !item.note.isEmpty {
                        Text(item.note)
                            .font(FontManager.playfairRegular(size: 12))
                            .foregroundColor(AppColors.secondaryText)
                            .lineLimit(2)
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppColors.yellow.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
}

struct CreateSetView: View {
    @ObservedObject var viewModel: ItemsViewModel
    @Binding var setName: String
    @Binding var isPresented: Bool
    
    private var isFormValid: Bool {
        !setName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                HStack {
                    Text("Create New Set")
                        .font(FontManager.playfairBold(size: 28))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        setName = ""
                        isPresented = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Set Name")
                        .font(FontManager.playfairMedium(size: 16))
                        .foregroundColor(AppColors.primaryText)
                    
                    TextField("Enter set name", text: $setName)
                        .font(FontManager.playfairRegular(size: 16))
                        .foregroundColor(AppColors.primaryText)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.yellow.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .autocapitalization(.words)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    let trimmedName = setName.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !trimmedName.isEmpty {
                        viewModel.createNewSet(name: trimmedName)
                        setName = ""
                        isPresented = false
                    }
                }) {
                    Text("Create Set")
                        .font(FontManager.playfairSemiBold(size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(isFormValid ? AnyShapeStyle(AppColors.accentGradient) : AnyShapeStyle(AppColors.cardBackground))
                        )
                }
                .disabled(!isFormValid)
                .opacity(isFormValid ? 1.0 : 0.6)
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
    }
}

struct IdentifiableUUID: Identifiable {
    let id: UUID
}
