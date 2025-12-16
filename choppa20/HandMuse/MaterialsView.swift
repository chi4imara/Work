import SwiftUI

struct MaterialsView: View {
    @StateObject private var viewModel = MaterialsViewModel()
    @State private var showingAddMaterial = false
    @State private var selectedMaterialId: UUID?
    @State private var editingMaterial: Material?
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.sortedMaterials.isEmpty {
                    emptyStateView
                } else {
                    materialsListView
                }
            }
        }
        .sheet(isPresented: $showingAddMaterial) {
            AddMaterialView(viewModel: viewModel)
        }
        .sheet(item: Binding(
            get: { selectedMaterialId.map { MaterialDetailItem(id: $0) } },
            set: { selectedMaterialId = $0?.id }
        )) { item in
            MaterialDetailView(materialId: item.id, viewModel: viewModel)
        }
        .sheet(item: $editingMaterial) { material in
            EditMaterialView(material: material, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Materials")
                .font(.playfairDisplay(32, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Spacer()
            
            Button(action: {
                showingAddMaterial = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(Color.theme.primaryYellow)
                    .background(
                        Circle()
                            .fill(Color.theme.primaryText)
                            .frame(width: 32, height: 32)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "list.bullet")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.primaryPurple.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No materials yet")
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                
                Text("Keep track of your craft supplies and materials here.")
                    .font(.playfairDisplay(16))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: {
                showingAddMaterial = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("Add Material")
                }
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(Color.theme.buttonText)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.theme.buttonBackground)
                        .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
                )
            }
            
            Spacer()
        }
    }
    
    private var materialsListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.sortedMaterials) { material in
                    MaterialCardView(material: material) {
                        selectedMaterialId = material.id
                    } onDelete: {
                        viewModel.deleteMaterial(material)
                    } onEdit: {
                        editingMaterial = material
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
}

struct MaterialCardView: View {
    let material: Material
    let onTap: () -> Void
    let onDelete: () -> Void
    let onEdit: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    Text(material.name)
                        .font(.playfairDisplay(20, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    if !material.quantity.isEmpty {
                        Text(material.quantity)
                            .font(.playfairDisplay(14, weight: .semibold))
                            .foregroundColor(Color.theme.primaryBlue)
                    }
                }
                
                if !material.category.isEmpty {
                    Text(material.category)
                        .font(.playfairDisplay(14, weight: .medium))
                        .foregroundColor(Color.theme.primaryPurple)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.theme.lightPurple.opacity(0.3))
                        )
                }
                
                if !material.notes.isEmpty {
                    Text(material.notes)
                        .font(.playfairDisplay(14))
                        .foregroundColor(Color.theme.secondaryText)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.theme.cardBackground)
                    .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
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
    MaterialsView()
}
