import SwiftUI

struct AddMaterialView: View {
    @ObservedObject var viewModel: MaterialsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var category = ""
    @State private var quantity = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            TextField("Yarn, needles, fabric...", text: $name)
                                .font(.playfairDisplay(16))
                                .foregroundColor(Color.theme.primaryText)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.theme.cardBackground)
                                        .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            TextField("Knitting, Sewing, General...", text: $category)
                                .font(.playfairDisplay(16))
                                .foregroundColor(Color.theme.primaryText)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.theme.cardBackground)
                                        .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Quantity")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            TextField("2 skeins, 5 pieces...", text: $quantity)
                                .font(.playfairDisplay(16))
                                .foregroundColor(Color.theme.primaryText)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.theme.cardBackground)
                                        .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            ZStack(alignment: .topLeading) {
                                if notes.isEmpty {
                                    Text("Additional information...")
                                        .font(.playfairDisplay(16))
                                        .foregroundColor(Color.theme.secondaryText.opacity(0.5))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 16)
                                }
                                
                                TextEditor(text: $notes)
                                    .font(.playfairDisplay(16))
                                    .foregroundColor(Color.theme.primaryText)
                                    .frame(minHeight: 100)
                                    .scrollContentBackground(.hidden)
                                    .padding(8)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.theme.cardBackground)
                                    .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                            )
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("New Material")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.playfairDisplay(16))
                    .foregroundColor(Color.theme.secondaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveMaterial()
                    }
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(Color.theme.primaryYellow)
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func saveMaterial() {
        let material = Material(name: name, category: category, quantity: quantity, notes: notes)
        viewModel.addMaterial(material)
        presentationMode.wrappedValue.dismiss()
    }
}

struct MaterialDetailItem: Identifiable {
    let id: UUID
}

struct MaterialDetailView: View {
    let materialId: UUID
    @ObservedObject var viewModel: MaterialsViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var material: Material? {
        viewModel.materials.first { $0.id == materialId }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        Group {
            if let material = material {
                NavigationView {
                    ZStack {
                        Color.theme.backgroundGradient
                            .ignoresSafeArea()
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 24) {
                                VStack(alignment: .leading, spacing: 12) {
                                    if !material.category.isEmpty {
                                        Text(material.category)
                                            .font(.playfairDisplay(14, weight: .semibold))
                                            .foregroundColor(Color.theme.primaryPurple)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(Color.theme.lightPurple.opacity(0.3))
                                            )
                                    }
                                    
                                    if !material.quantity.isEmpty {
                                        HStack {
                                            Text("Quantity:")
                                                .font(.playfairDisplay(16, weight: .semibold))
                                                .foregroundColor(Color.theme.primaryText)
                                            
                                            Text(material.quantity)
                                                .font(.playfairDisplay(16))
                                                .foregroundColor(Color.theme.secondaryText)
                                        }
                                    }
                                }
                                .padding(16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.theme.cardBackground)
                                        .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                                )
                                
                                if !material.notes.isEmpty {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("Notes")
                                            .font(.playfairDisplay(20, weight: .bold))
                                            .foregroundColor(Color.theme.primaryText)
                                        
                                        Text(material.notes)
                                            .font(.playfairDisplay(16))
                                            .foregroundColor(Color.theme.secondaryText)
                                    }
                                    .padding(16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.theme.cardBackground)
                                            .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                                    )
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Added")
                                        .font(.playfairDisplay(14, weight: .semibold))
                                        .foregroundColor(Color.theme.secondaryText)
                                    
                                    Text(dateFormatter.string(from: material.dateAdded))
                                        .font(.playfairDisplay(14))
                                        .foregroundColor(Color.theme.secondaryText.opacity(0.8))
                                }
                                .padding(16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.theme.cardBackground)
                                        .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                                )
                                
                                VStack(spacing: 16) {
                                    Button(action: {
                                        showingEditView = true
                                    }) {
                                        HStack {
                                            Image(systemName: "pencil")
                                            Text("Edit Material")
                                        }
                                        .font(.playfairDisplay(18, weight: .semibold))
                                        .foregroundColor(Color.theme.buttonText)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 25)
                                                .fill(Color.theme.buttonBackground)
                                                .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
                                        )
                                    }
                                    
                                    Button(action: {
                                        showingDeleteAlert = true
                                    }) {
                                        HStack {
                                            Image(systemName: "trash")
                                            Text("Delete Material")
                                        }
                                        .font(.playfairDisplay(18, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 25)
                                                .fill(Color.red)
                                                .shadow(color: Color.red.opacity(0.3), radius: 8, x: 0, y: 4)
                                        )
                                    }
                                }
                                
                                Spacer(minLength: 100)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                    .navigationTitle(material.name)
                    .navigationBarTitleDisplayMode(.large)
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(Color.theme.primaryBlue)
                            }
                        }
                    }
                    .alert("Delete Material", isPresented: $showingDeleteAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            if let material = self.material {
                                viewModel.deleteMaterial(material)
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    } message: {
                        Text("Are you sure you want to delete this material? This action cannot be undone.")
                    }
                    .sheet(isPresented: $showingEditView) {
                        if let material = self.material {
                            EditMaterialView(material: material, viewModel: viewModel)
                        }
                    }
                }
            }
        }
    }
}

struct EditMaterialView: View {
    let material: Material
    @ObservedObject var viewModel: MaterialsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var category: String
    @State private var quantity: String
    @State private var notes: String
    
    init(material: Material, viewModel: MaterialsViewModel) {
        self.material = material
        self.viewModel = viewModel
        
        _name = State(initialValue: material.name)
        _category = State(initialValue: material.category)
        _quantity = State(initialValue: material.quantity)
        _notes = State(initialValue: material.notes)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            TextField("Yarn, needles, fabric...", text: $name)
                                .font(.playfairDisplay(16))
                                .foregroundColor(Color.theme.primaryText)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.theme.cardBackground)
                                        .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            TextField("Knitting, Sewing, General...", text: $category)
                                .font(.playfairDisplay(16))
                                .foregroundColor(Color.theme.primaryText)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.theme.cardBackground)
                                        .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Quantity")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            TextField("2 skeins, 5 pieces...", text: $quantity)
                                .font(.playfairDisplay(16))
                                .foregroundColor(Color.theme.primaryText)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.theme.cardBackground)
                                        .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            ZStack(alignment: .topLeading) {
                                if notes.isEmpty {
                                    Text("Additional information...")
                                        .font(.playfairDisplay(16))
                                        .foregroundColor(Color.theme.secondaryText.opacity(0.5))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 16)
                                }
                                
                                TextEditor(text: $notes)
                                    .font(.playfairDisplay(16))
                                    .foregroundColor(Color.theme.primaryText)
                                    .frame(minHeight: 100)
                                    .scrollContentBackground(.hidden)
                                    .padding(8)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.theme.cardBackground)
                                    .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                            )
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit Material")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.playfairDisplay(16))
                    .foregroundColor(Color.theme.secondaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(Color.theme.primaryYellow)
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func saveChanges() {
        var updatedMaterial = material
        updatedMaterial.name = name
        updatedMaterial.category = category
        updatedMaterial.quantity = quantity
        updatedMaterial.notes = notes
        
        viewModel.updateMaterial(updatedMaterial)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddMaterialView(viewModel: MaterialsViewModel())
}
