import SwiftUI

struct RitualIdentifiable: Identifiable {
    let id: UUID
}

struct RitualsView: View {
    @EnvironmentObject var store: AppDataStore
    @State private var showingAddRitual = false
    @State private var selectedRitualId: UUID?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("My Rituals")
                        .font(FontManager.playfairDisplay(size: 32, weight: .bold))
                        .foregroundColor(AppColors.text)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddRitual = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(AppColors.primary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if store.rituals.isEmpty {
                    EmptyRitualsView {
                        showingAddRitual = true
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(store.rituals) { ritual in
                                RitualCard(ritual: ritual) {
                                    selectedRitualId = ritual.id
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddRitual) {
            AddRitualSheet { ritual in
                store.addRitual(ritual)
            }
        }
        .sheet(item: Binding<RitualIdentifiable?>(
            get: { selectedRitualId.map(RitualIdentifiable.init) },
            set: { selectedRitualId = $0?.id }
        )) { ritualIdentifiable in
            RitualDetailSheet(ritualId: ritualIdentifiable.id) { updatedRitual in
                store.updateRitual(updatedRitual)
            } onDelete: { ritualId in
                store.deleteRitual(byId: ritualId)
            }
        }
    }
}

struct EmptyRitualsView: View {
    let onAddRitual: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 20) {
                Image(systemName: "leaf.circle")
                    .font(.system(size: 80))
                    .foregroundColor(AppColors.primary.opacity(0.6))
                
                Text("Add your first ritual and start taking care of yourself")
                    .font(FontManager.playfairDisplay(size: 20, weight: .medium))
                    .foregroundColor(AppColors.text)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: onAddRitual) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Add Ritual")
                        .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(25)
                .shadow(color: AppColors.primary.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
    }
}

struct RitualCard: View {
    let ritual: Ritual
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(ritual.category.color.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: ritual.category.icon)
                        .font(.system(size: 24))
                        .foregroundColor(ritual.category.color)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(ritual.title)
                        .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(ritual.category.rawValue)
                        .font(FontManager.playfairDisplay(size: 14))
                        .foregroundColor(AppColors.text.opacity(0.6))
                    
                    HStack(spacing: 6) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.secondary)
                        
                        Text("\(ritual.streakCount) day streak")
                            .font(FontManager.playfairDisplay(size: 12))
                            .foregroundColor(AppColors.text.opacity(0.6))
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.text.opacity(0.4))
            }
            .padding(20)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
            .shadow(color: AppColors.primary.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RitualDetailSheet: View {
    let ritualId: UUID
    let onUpdate: (Ritual) -> Void
    let onDelete: (UUID) -> Void
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var store: AppDataStore
    
    @State private var showingDeleteAlert = false
    @State private var showingEditSheet = false
    
    private var ritual: Ritual? {
        store.ritual(byId: ritualId)
    }
    
    var body: some View {
        NavigationView {
            Group {
                if let ritual = ritual {
                    ScrollView {
                        VStack(spacing: 32) {
                            VStack(spacing: 20) {
                                ZStack {
                                    Circle()
                                        .fill(ritual.category.color.opacity(0.1))
                                        .frame(width: 120, height: 120)
                                    
                                    Image(systemName: ritual.category.icon)
                                        .font(.system(size: 50))
                                        .foregroundColor(ritual.category.color)
                                }
                                
                                VStack(spacing: 8) {
                                    Text(ritual.title)
                                        .font(FontManager.playfairDisplay(size: 24, weight: .bold))
                                        .foregroundColor(AppColors.text)
                                        .multilineTextAlignment(.center)
                                    
                                    Text(ritual.category.rawValue)
                                        .font(FontManager.playfairDisplay(size: 16))
                                        .foregroundColor(AppColors.text.opacity(0.6))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 6)
                                        .background(
                                            Capsule()
                                                .fill(ritual.category.color.opacity(0.1))
                                        )
                                }
                            }
                            .padding(.top, 20)
                            
                            HStack(spacing: 20) {
                                RitualStatCard(
                                    title: "Streak",
                                    value: "\(ritual.streakCount)",
                                    icon: "flame.fill",
                                    color: AppColors.secondary
                                )
                                
                                RitualStatCard(
                                    title: "Total",
                                    value: "\(ritual.completionDates.count)",
                                    icon: "checkmark.circle.fill",
                                    color: AppColors.success
                                )
                            }
                            
                            if !ritual.description.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Description")
                                        .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                                        .foregroundColor(AppColors.text)
                                    
                                    Text(ritual.description)
                                        .font(FontManager.playfairDisplay(size: 16))
                                        .foregroundColor(AppColors.text.opacity(0.7))
                                        .lineSpacing(2)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(20)
                                .background(AppColors.cardGradient)
                                .cornerRadius(16)
                            }
                            
                            VStack(spacing: 16) {
                                Button(action: {
                                    showingEditSheet = true
                                }) {
                                    Text("Edit")
                                        .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                        .foregroundColor(AppColors.primary)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(AppColors.primary, lineWidth: 2)
                                        )
                                }
                                
                                Button(action: {
                                    showingDeleteAlert = true
                                }) {
                                    Text("Delete")
                                        .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                        .foregroundColor(AppColors.error)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(AppColors.error, lineWidth: 2)
                                        )
                                }
                            }
                        }
                        .padding(20)
                    }
                    .background(AppColors.backgroundGradient)
                    .alert("Delete Ritual", isPresented: $showingDeleteAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            onDelete(ritual.id)
                            dismiss()
                        }
                    } message: {
                        Text("Are you sure you want to delete this ritual? This action cannot be undone.")
                    }
                    .sheet(isPresented: $showingEditSheet) {
                        EditRitualSheet(ritual: ritual) { updatedRitual in
                            onUpdate(updatedRitual)
                        }
                    }
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 60))
                            .foregroundColor(AppColors.error)
                        
                        Text("Ritual not found")
                            .font(FontManager.playfairDisplay(size: 18, weight: .medium))
                            .foregroundColor(AppColors.text)
                    }
                    .background(AppColors.backgroundGradient)
                }
            }
            .navigationTitle("Ritual Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(FontManager.playfairDisplay(size: 16))
                    .foregroundColor(AppColors.primary)
                }
            }
        }
    }
}

struct RitualStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                .foregroundColor(AppColors.text)
            
            Text(title)
                .font(FontManager.playfairDisplay(size: 14))
                .foregroundColor(AppColors.text.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.primary.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct EditRitualSheet: View {
    let ritual: Ritual
    let onSave: (Ritual) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String
    @State private var description: String
    @State private var selectedCategory: RitualCategory
    
    init(ritual: Ritual, onSave: @escaping (Ritual) -> Void) {
        self.ritual = ritual
        self.onSave = onSave
        _title = State(initialValue: ritual.title)
        _description = State(initialValue: ritual.description)
        _selectedCategory = State(initialValue: ritual.category)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Title")
                        .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                        .foregroundColor(AppColors.text)
                    
                    TextField("Enter ritual name", text: $title)
                        .font(FontManager.playfairDisplay(size: 16))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Category")
                        .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                        .foregroundColor(AppColors.text)
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(RitualCategory.allCases, id: \.self) { category in
                            HStack {
                                Image(systemName: category.icon)
                                    .foregroundColor(category.color)
                                Text(category.rawValue)
                            }
                            .tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Description")
                        .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                        .foregroundColor(AppColors.text)
                    
                    TextField("Why is this important?", text: $description, axis: .vertical)
                        .font(FontManager.playfairDisplay(size: 16))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(3...6)
                }
                
                Spacer()
                
                Button(action: {
                    var updatedRitual = ritual
                    updatedRitual.title = title
                    updatedRitual.description = description
                    updatedRitual.category = selectedCategory
                    onSave(updatedRitual)
                    dismiss()
                }) {
                    Text("Save Changes")
                        .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [AppColors.primary, AppColors.accent],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                }
                .disabled(title.isEmpty)
                .opacity(title.isEmpty ? 0.6 : 1.0)
            }
            .padding(20)
            .background(AppColors.backgroundGradient)
            .navigationTitle("Edit Ritual")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(FontManager.playfairDisplay(size: 16))
                    .foregroundColor(AppColors.primary)
                }
            }
        }
    }
}

#Preview {
    RitualsView()
        .environmentObject(AppDataStore())
}
