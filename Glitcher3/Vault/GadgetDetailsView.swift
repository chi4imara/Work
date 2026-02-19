import SwiftUI

struct GadgetDetailsView: View {
    let gadgetId: UUID
    @ObservedObject var gadgetViewModel: GadgetViewModel
    @State private var showingDeleteAlert = false
    @State private var editingGadgetId: UUID?
    @Environment(\.dismiss) private var dismiss
    
    private var gadget: Gadget? {
        gadgetViewModel.gadgets.first { $0.id == gadgetId }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        Group {
            if let gadget = gadget {
                NavigationView {
                    ZStack {
                        Color.theme.primaryGradient
                            .ignoresSafeArea()
                        
                        ScrollView {
                            VStack(spacing: 24) {
                                VStack(spacing: 12) {
                                    Text(gadget.name)
                                        .font(.playfairDisplay(size: 28, weight: .bold))
                                        .foregroundColor(Color.theme.primaryText)
                                        .multilineTextAlignment(.center)
                                    
                                    Text(gadget.category)
                                        .font(.playfairDisplay(size: 16, weight: .medium))
                                        .foregroundColor(Color.theme.lightBlue)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 6)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.theme.lightBlue.opacity(0.2))
                                        )
                                }
                                .padding(.top, 20)
                                
                                VStack(spacing: 20) {
                                    DetailSection(title: "Purchase Information") {
                                        VStack(spacing: 12) {
                                            DetailItem(
                                                icon: "calendar",
                                                title: "Purchase Date",
                                                value: dateFormatter.string(from: gadget.purchaseDate)
                                            )
                                            
                                            DetailItem(
                                                icon: "dollarsign.circle",
                                                title: "Price",
                                                value: gadget.price
                                            )
                                        }
                                    }
                                    
                                    DetailSection(title: "Device Information") {
                                        VStack(spacing: 12) {
                                            DetailItem(
                                                icon: "checkmark.shield",
                                                title: "Condition",
                                                value: gadget.condition
                                            )
                                            
                                            DetailItem(
                                                icon: "clock",
                                                title: "Service Life",
                                                value: "\(gadget.serviceLife) years"
                                            )
                                        }
                                    }
                                    
                                    if !gadget.comment.isEmpty {
                                        DetailSection(title: "Comment") {
                                            DetailItem(
                                                icon: "text.bubble",
                                                title: "Note",
                                                value: gadget.comment
                                            )
                                        }
                                    } else {
                                        DetailSection(title: "Comment") {
                                            DetailItem(
                                                icon: "text.bubble",
                                                title: "Note",
                                                value: "Comment not added."
                                            )
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                
                                VStack(spacing: 12) {
                                    Button(action: {
                                        editingGadgetId = gadget.id
                                    }) {
                                        HStack {
                                            Image(systemName: "pencil")
                                                .font(.system(size: 16, weight: .medium))
                                            
                                            Text("Edit")
                                                .font(.playfairDisplay(size: 16, weight: .semibold))
                                        }
                                        .foregroundColor(Color.theme.primaryText)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.theme.accentGradient)
                                        )
                                    }
                                    
                                    Button(action: {
                                        showingDeleteAlert = true
                                    }) {
                                        HStack {
                                            Image(systemName: "trash")
                                                .font(.system(size: 16, weight: .medium))
                                            
                                            Text("Delete Gadget")
                                                .font(.playfairDisplay(size: 16, weight: .semibold))
                                        }
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.theme.dangerButton)
                                        )
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 30)
                            }
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(Color.theme.lightBlue)
                            }
                        }
                    }
                    .alert("Delete Gadget", isPresented: $showingDeleteAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            gadgetViewModel.deleteGadget(gadget)
                            dismiss()
                        }
                    } message: {
                        Text("Are you sure you want to delete this gadget? This action cannot be undone.")
                    }
                }
                .sheet(item: Binding(
                    get: { editingGadgetId.map { GadgetIDWrapper(id: $0) } },
                    set: { editingGadgetId = $0?.id }
                )) { wrapper in
                    if let editingGadget = gadgetViewModel.gadgets.first(where: { $0.id == wrapper.id }) {
                        EditGadgetView(gadgetId: editingGadget.id, gadgetViewModel: gadgetViewModel)
                    }
                }
            }
        }
    }
}

struct DetailSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.playfairDisplay(size: 18, weight: .semibold))
                .foregroundColor(Color.theme.primaryText)
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.theme.cardBackground)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.theme.lightBlue.opacity(0.3), lineWidth: 1)
                }
        )
    }
}

struct DetailItem: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(Color.theme.lightBlue)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.playfairDisplay(size: 12))
                    .foregroundColor(Color.theme.secondaryText)
                
                Text(value)
                    .font(.playfairDisplay(size: 14, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
    }
}

#Preview {
    NavigationView {
        GadgetDetailsView(
            gadgetId: {
                let vm = GadgetViewModel()
                let gadget = Gadget(
                    name: "iPhone 13 Pro Max",
                    category: "Phone",
                    purchaseDate: Date(),
                    price: "$1099",
                    condition: "Excellent",
                    serviceLife: "3",
                    comment: "Primary device for work and personal use. Purchased with AppleCare+"
                )
                vm.gadgets = [gadget]
                return gadget.id
            }(),
            gadgetViewModel: {
                let vm = GadgetViewModel()
                let gadget = Gadget(
                    name: "iPhone 13 Pro Max",
                    category: "Phone",
                    purchaseDate: Date(),
                    price: "$1099",
                    condition: "Excellent",
                    serviceLife: "3",
                    comment: "Primary device for work and personal use. Purchased with AppleCare+"
                )
                vm.gadgets = [gadget]
                return vm
            }()
        )
    }
}
