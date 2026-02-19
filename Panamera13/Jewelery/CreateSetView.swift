import SwiftUI

struct CreateSetView: View {
    @ObservedObject var jewelryStore: JewelryStore
    @ObservedObject var setsStore: SetsStore
    @Environment(\.dismiss) private var dismiss
    
    let editingSet: JewelrySet?
    let preselectedJewelryId: UUID?
    
    @State private var setName: String = ""
    @State private var selectedJewelryIds: Set<UUID> = []
    
    init(jewelryStore: JewelryStore, setsStore: SetsStore, editingSet: JewelrySet? = nil, preselectedJewelryId: UUID? = nil) {
        self.jewelryStore = jewelryStore
        self.setsStore = setsStore
        self.editingSet = editingSet
        self.preselectedJewelryId = preselectedJewelryId
        
        if let set = editingSet {
            _setName = State(initialValue: set.name)
            _selectedJewelryIds = State(initialValue: Set(set.jewelryIds))
        } else if let jewelryId = preselectedJewelryId {
            _selectedJewelryIds = State(initialValue: Set([jewelryId]))
        }
    }
    
    private var isFormValid: Bool {
        !setName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        CustomTextField(
                            title: "Set Name",
                            text: $setName,
                            placeholder: "Enter set name"
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        Divider()
                            .background(ColorTheme.cardBorder)
                            .padding(.horizontal, 20)
                    }
                    
                    if jewelryStore.jewelries.isEmpty {
                        EmptyJewelryForSetState()
                    } else {
                        JewelrySelectionList(
                            jewelries: jewelryStore.jewelries,
                            selectedIds: $selectedJewelryIds
                        )
                    }
                }
            }
            .navigationTitle(editingSet == nil ? "New Set" : "Edit Set")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveSet()
                    }
                    .foregroundColor(isFormValid ? ColorTheme.accentYellow : ColorTheme.secondaryText)
                    .disabled(!isFormValid)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private func saveSet() {
        let trimmedName = setName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let editingSet = editingSet {
            var updatedSet = editingSet
            updatedSet.name = trimmedName
            updatedSet.jewelryIds = Array(selectedJewelryIds)
            
            setsStore.updateSet(updatedSet)
        } else {
            let newSet = JewelrySet(
                name: trimmedName,
                jewelryIds: Array(selectedJewelryIds)
            )
            
            setsStore.addSet(newSet)
        }
        
        dismiss()
    }
}

struct EmptyJewelryForSetState: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "sparkles")
                .font(.system(size: 50, weight: .light))
                .foregroundColor(ColorTheme.accentYellow)
            
            VStack(spacing: 8) {
                Text("No jewelry available")
                    .font(.lumierepolis(20, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Add some jewelry first to create a set")
                    .font(.lumierepolis(14))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct JewelrySelectionList: View {
    let jewelries: [Jewelry]
    @Binding var selectedIds: Set<UUID>
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Select Jewelry")
                    .font(.lumierepolis(18, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Text("\(selectedIds.count) selected")
                    .font(.lumierepolis(14))
                    .foregroundColor(ColorTheme.accentYellow)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(jewelries) { jewelry in
                        JewelrySelectionRow(
                            jewelry: jewelry,
                            isSelected: selectedIds.contains(jewelry.id),
                            onToggle: {
                                if selectedIds.contains(jewelry.id) {
                                    selectedIds.remove(jewelry.id)
                                } else {
                                    selectedIds.insert(jewelry.id)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
    }
}

struct JewelrySelectionRow: View {
    let jewelry: Jewelry
    let isSelected: Bool
    let onToggle: () -> Void
    
    @State private var rowScale: CGFloat = 1.0
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(isSelected ? ColorTheme.accentYellow : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(isSelected ? ColorTheme.accentYellow : ColorTheme.cardBorder, lineWidth: 2)
                        )
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(ColorTheme.buttonText)
                    }
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(ColorTheme.cardBackground)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: jewelry.type.icon)
                        .font(.system(size: 18))
                        .foregroundColor(ColorTheme.accentYellow)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(jewelry.name)
                        .font(.lumierepolis(16, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                        .lineLimit(1)
                    
                    Text(jewelry.type.rawValue)
                        .font(.lumierepolis(12))
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? ColorTheme.accentYellow.opacity(0.1) : ColorTheme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? ColorTheme.accentYellow.opacity(0.3) : ColorTheme.cardBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(rowScale)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                rowScale = pressing ? 0.98 : 1.0
            }
        }, perform: {})
    }
}

struct SetDetailView: View {
    let setId: UUID
    @ObservedObject var jewelryStore: JewelryStore
    @ObservedObject var setsStore: SetsStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var selectedJewelryId: UUID?
    
    var set: JewelrySet? {
        setsStore.sets.first(where: { $0.id == setId })
    }
    
    var jewelriesInSet: [Jewelry] {
        guard let set = set else { return [] }
        return setsStore.getJewelriesInSet(set, from: jewelryStore)
    }
    
    var body: some View {
        Group {
            if let set = set {
                NavigationView {
                    ZStack {
                        AnimatedBackground()
                        
                        ScrollView {
                            VStack(spacing: 20) {
                                VStack(spacing: 12) {
                                    Text("\(jewelriesInSet.count) item\(jewelriesInSet.count == 1 ? "" : "s")")
                                        .font(.lumierepolis(16))
                                        .foregroundColor(ColorTheme.accentYellow)
                                    
                                    Text("Created \(set.dateCreated.formatted(date: .abbreviated, time: .omitted))")
                                        .font(.lumierepolis(14))
                                        .foregroundColor(ColorTheme.secondaryText)
                                }
                                .padding(.top, 20)
                                
                                if jewelriesInSet.isEmpty {
                                    VStack(spacing: 16) {
                                        Image(systemName: "tray")
                                            .font(.system(size: 40))
                                            .foregroundColor(ColorTheme.secondaryText)
                                        
                                        Text("This set is empty")
                                            .font(.lumierepolis(16))
                                            .foregroundColor(ColorTheme.secondaryText)
                                    }
                                    .padding(.vertical, 40)
                                } else {
                                    LazyVStack(spacing: 12) {
                                        ForEach(jewelriesInSet) { jewelry in
                                            JewelryCard(
                                                jewelry: jewelry,
                                                jewelryStore: jewelryStore,
                                                onTap: {
                                                    selectedJewelryId = jewelry.id
                                                }
                                            )
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                                
                                VStack(spacing: 12) {
                                    ActionButton(
                                        title: "Edit Set",
                                        icon: "pencil",
                                        backgroundColor: ColorTheme.buttonPrimary,
                                        foregroundColor: ColorTheme.buttonText,
                                        action: {
                                            showingEditView = true
                                        }
                                    )
                                    
                                    ActionButton(
                                        title: "Delete Set",
                                        icon: "trash",
                                        backgroundColor: ColorTheme.error.opacity(0.2),
                                        foregroundColor: ColorTheme.error,
                                        action: {
                                            showingDeleteAlert = true
                                        }
                                    )
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 50)
                            }
                        }
                    }
                    .navigationTitle(set.name)
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                dismiss()
                            }
                            .foregroundColor(ColorTheme.accentYellow)
                        }
                    }
                    .preferredColorScheme(.dark)
                }
                .sheet(isPresented: $showingEditView) {
                    CreateSetView(jewelryStore: jewelryStore, setsStore: setsStore, editingSet: set)
                }
                .sheet(item: Binding(
                    get: { selectedJewelryId.flatMap { jewelryStore.getJewelry(by: $0) } },
                    set: { _ in selectedJewelryId = nil }
                )) { jewelry in
                    JewelryDetailView(jewelryId: jewelry.id, jewelryStore: jewelryStore, setsStore: setsStore)
                }
                .alert("Delete Set", isPresented: $showingDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        setsStore.deleteSet(set)
                        dismiss()
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Are you sure you want to delete \"\(set.name)\"? This action cannot be undone.")
                }
            }
        }
    }
}

#Preview {
    CreateSetView(jewelryStore: JewelryStore(), setsStore: SetsStore())
}
