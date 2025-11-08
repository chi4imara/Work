import SwiftUI

struct ReferenceView: View {
    @ObservedObject private var viewModel = ReferenceViewModel.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingAddReference = false
    @State private var selectedReference: MedicineReference?
    @State private var showingReferenceDetail = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        HStack {
                            Text("Medicine Reference")
                                .font(AppFonts.largeTitle().bold())
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        
                        searchBar
                        
                        if viewModel.filteredReferences.isEmpty {
                            if viewModel.references.isEmpty {
                                emptyStateView
                            } else {
                                noResultsView
                            }
                        } else {
                            referencesList
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddReference = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(AppColors.primaryText)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddReference) {
            if let selectedRef = selectedReference {
                EditReferenceView(reference: selectedRef) { updatedReference in
                    viewModel.updateReference(updatedReference)
                    selectedReference = nil
                }
            } else {
                AddReferenceView { reference in
                    viewModel.addReference(reference)
                }
            }
        }
        .sheet(isPresented: $showingReferenceDetail) {
            if let reference = selectedReference {
                ReferenceDetailView(
                    reference: reference,
                    onUpdate: { updatedReference in
                        viewModel.updateReference(updatedReference)
                    },
                    onDelete: {
                        if let ref = selectedReference {
                            viewModel.deleteReference(ref)
                        }
                        selectedReference = nil
                    }
                )
            }
        }
        .onAppear {
            viewModel.loadReferences()
        }
        .onReceive(NotificationCenter.default.publisher(for: .dataCleared)) { _ in
            viewModel.loadReferences()
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.cardSecondaryText)
            
            TextField("Search medicines...", text: $viewModel.searchText)
                .font(AppFonts.body())
                .foregroundColor(AppColors.cardText)
        }
        .padding(12)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var referencesList: some View {
        LazyVStack(spacing: 12) {
            ForEach(viewModel.filteredReferences) { reference in
                ReferenceCard(reference: reference) {
                    selectedReference = reference
                    showingReferenceDetail = true
                } onEdit: {
                    selectedReference = reference
                    showingAddReference = true
                } onDelete: {
                    viewModel.deleteReference(reference)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 100)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            Spacer()
            
            Image(systemName: "book")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText)
            
            Text("Reference is empty")
                .font(AppFonts.title2())
                .foregroundColor(AppColors.primaryText)
            
            Text("Add your first medicine reference to keep track of important information")
                .font(AppFonts.callout())
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button {
                showingAddReference = true
            } label: {
                Text("Add First Reference")
                    .font(AppFonts.callout())
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .concaveCard(color: AppColors.primaryButton)
            }
            
            Spacer()
        }
    }
    
    private var noResultsView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(AppColors.secondaryText)
            
            Text("No results found")
                .font(AppFonts.title3())
                .foregroundColor(AppColors.primaryText)
            
            Text("Try adjusting your search terms")
                .font(AppFonts.callout())
                .foregroundColor(AppColors.secondaryText)
            
            Spacer()
        }
    }
}

struct ReferenceCard: View {
    let reference: MedicineReference
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var showingDeleteAlert = false
    
    private var lastModifiedString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: reference.lastModified)
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(reference.name)
                            .font(AppFonts.headline())
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.cardText)
                            .multilineTextAlignment(.leading)
                        
                        Text("Purpose: \(reference.purpose)")
                            .font(AppFonts.callout())
                            .foregroundColor(AppColors.cardSecondaryText)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    Menu {
                        Button("Edit") {
                            onEdit()
                        }
                        
                        Button("Delete", role: .destructive) {
                            showingDeleteAlert = true
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(AppColors.cardSecondaryText)
                            .padding(8)
                    }
                }
                
                HStack {
                    Spacer()
                    
                    Text("Last modified: \(lastModifiedString)")
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.cardSecondaryText)
                }
            }
            .padding(16)
            .concaveCard(color: AppColors.cardBackground)
        }
        .buttonStyle(PlainButtonStyle())
        .alert("Delete Reference", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete the reference for \(reference.name)?")
        }
    }
}

struct AddReferenceView: View {
    let onSave: (MedicineReference) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var purpose = ""
    @State private var recommendations = ""
    @State private var sideEffects = ""
    @State private var doctorNotes = ""
    
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Medicine Name *")
                                .font(AppFonts.callout())
                                .fontWeight(.medium)
                                .foregroundColor(AppColors.cardText)
                            
                            TextField("Enter medicine name", text: $name)
                                .font(AppFonts.body())
                                .padding(12)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding(20)
                        .concaveCard(color: AppColors.cardBackground)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Purpose")
                                .font(AppFonts.callout())
                                .fontWeight(.medium)
                                .foregroundColor(AppColors.cardText)
                            
                            TextField("e.g., for blood pressure", text: $purpose)
                                .font(AppFonts.body())
                                .padding(12)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding(20)
                        .concaveCard(color: AppColors.cardBackground)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Recommendations")
                                .font(AppFonts.callout())
                                .fontWeight(.medium)
                                .foregroundColor(AppColors.cardText)
                            
                            TextField("Usage recommendations", text: $recommendations, axis: .vertical)
                                .font(AppFonts.body())
                                .padding(12)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .lineLimit(3...6)
                        }
                        .padding(20)
                        .concaveCard(color: AppColors.cardBackground)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Side Effects (Optional)")
                                .font(AppFonts.callout())
                                .fontWeight(.medium)
                                .foregroundColor(AppColors.cardText)
                            
                            TextField("Possible side effects", text: $sideEffects, axis: .vertical)
                                .font(AppFonts.body())
                                .padding(12)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .lineLimit(3...6)
                        }
                        .padding(20)
                        .concaveCard(color: AppColors.cardBackground)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Doctor Notes / Personal Notes (Optional)")
                                .font(AppFonts.callout())
                                .fontWeight(.medium)
                                .foregroundColor(AppColors.cardText)
                            
                            TextField("Additional notes", text: $doctorNotes, axis: .vertical)
                                .font(AppFonts.body())
                                .padding(12)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .lineLimit(3...6)
                        }
                        .padding(20)
                        .concaveCard(color: AppColors.cardBackground)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("New Reference")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveReference()
                    }
                    .foregroundColor(AppColors.primaryText)
                    .fontWeight(.semibold)
                }
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func saveReference() {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please enter medicine name"
            showingError = true
            return
        }
        
        let reference = MedicineReference(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            purpose: purpose.trimmingCharacters(in: .whitespacesAndNewlines),
            recommendations: recommendations.trimmingCharacters(in: .whitespacesAndNewlines),
            sideEffects: sideEffects.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : sideEffects.trimmingCharacters(in: .whitespacesAndNewlines),
            doctorNotes: doctorNotes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : doctorNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        onSave(reference)
        dismiss()
    }
}

struct EditReferenceView: View {
    let reference: MedicineReference
    let onSave: (MedicineReference) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var purpose: String
    @State private var recommendations: String
    @State private var sideEffects: String
    @State private var doctorNotes: String
    
    @State private var showingError = false
    @State private var errorMessage = ""
    
    init(reference: MedicineReference, onSave: @escaping (MedicineReference) -> Void) {
        self.reference = reference
        self.onSave = onSave
        
        _name = State(initialValue: reference.name)
        _purpose = State(initialValue: reference.purpose)
        _recommendations = State(initialValue: reference.recommendations)
        _sideEffects = State(initialValue: reference.sideEffects ?? "")
        _doctorNotes = State(initialValue: reference.doctorNotes ?? "")
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Medicine Name *")
                                .font(AppFonts.callout())
                                .fontWeight(.medium)
                                .foregroundColor(AppColors.cardText)
                            
                            TextField("Enter medicine name", text: $name)
                                .font(AppFonts.body())
                                .padding(12)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding(20)
                        .concaveCard(color: AppColors.cardBackground)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Purpose")
                                .font(AppFonts.callout())
                                .fontWeight(.medium)
                                .foregroundColor(AppColors.cardText)
                            
                            TextField("e.g., for blood pressure", text: $purpose)
                                .font(AppFonts.body())
                                .padding(12)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding(20)
                        .concaveCard(color: AppColors.cardBackground)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Recommendations")
                                .font(AppFonts.callout())
                                .fontWeight(.medium)
                                .foregroundColor(AppColors.cardText)
                            
                            TextField("Usage recommendations", text: $recommendations, axis: .vertical)
                                .font(AppFonts.body())
                                .padding(12)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .lineLimit(3...6)
                        }
                        .padding(20)
                        .concaveCard(color: AppColors.cardBackground)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Side Effects (Optional)")
                                .font(AppFonts.callout())
                                .fontWeight(.medium)
                                .foregroundColor(AppColors.cardText)
                            
                            TextField("Possible side effects", text: $sideEffects, axis: .vertical)
                                .font(AppFonts.body())
                                .padding(12)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .lineLimit(3...6)
                        }
                        .padding(20)
                        .concaveCard(color: AppColors.cardBackground)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Doctor Notes / Personal Notes (Optional)")
                                .font(AppFonts.callout())
                                .fontWeight(.medium)
                                .foregroundColor(AppColors.cardText)
                            
                            TextField("Additional notes", text: $doctorNotes, axis: .vertical)
                                .font(AppFonts.body())
                                .padding(12)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .lineLimit(3...6)
                        }
                        .padding(20)
                        .concaveCard(color: AppColors.cardBackground)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Edit Reference")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveReference()
                    }
                    .foregroundColor(AppColors.primaryText)
                    .fontWeight(.semibold)
                }
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func saveReference() {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please enter medicine name"
            showingError = true
            return
        }
        
        let updatedReference = MedicineReference(
            id: reference.id,
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            purpose: purpose.trimmingCharacters(in: .whitespacesAndNewlines),
            recommendations: recommendations.trimmingCharacters(in: .whitespacesAndNewlines),
            sideEffects: sideEffects.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : sideEffects.trimmingCharacters(in: .whitespacesAndNewlines),
            doctorNotes: doctorNotes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : doctorNotes.trimmingCharacters(in: .whitespacesAndNewlines),
            lastModified: Date()
        )
        
        onSave(updatedReference)
        dismiss()
    }
}

struct ReferenceDetailView: View {
    @State private var reference: MedicineReference
    let onUpdate: (MedicineReference) -> Void
    let onDelete: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    init(reference: MedicineReference, onUpdate: @escaping (MedicineReference) -> Void, onDelete: @escaping () -> Void) {
        self._reference = State(initialValue: reference)
        self.onUpdate = onUpdate
        self.onDelete = onDelete
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Medicine Name")
                                .font(AppFonts.callout())
                                .fontWeight(.medium)
                                .foregroundColor(AppColors.cardSecondaryText)
                            
                            Text(reference.name)
                                .font(AppFonts.title2())
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.cardText)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        .concaveCard(color: AppColors.cardBackground)
                        
                        if !reference.purpose.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Purpose")
                                    .font(AppFonts.callout())
                                    .fontWeight(.medium)
                                    .foregroundColor(AppColors.cardSecondaryText)
                                
                                Text(reference.purpose)
                                    .font(AppFonts.body())
                                    .foregroundColor(AppColors.cardText)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            .concaveCard(color: AppColors.cardBackground)
                        }
                        
                        if !reference.recommendations.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Recommendations")
                                    .font(AppFonts.callout())
                                    .fontWeight(.medium)
                                    .foregroundColor(AppColors.cardSecondaryText)
                                
                                Text(reference.recommendations)
                                    .font(AppFonts.body())
                                    .foregroundColor(AppColors.cardText)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            .concaveCard(color: AppColors.cardBackground)
                        }
                        
                        if let sideEffects = reference.sideEffects, !sideEffects.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Side Effects")
                                    .font(AppFonts.callout())
                                    .fontWeight(.medium)
                                    .foregroundColor(AppColors.cardSecondaryText)
                                
                                Text(sideEffects)
                                    .font(AppFonts.body())
                                    .foregroundColor(AppColors.cardText)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            .concaveCard(color: AppColors.cardBackground)
                        }
                        
                        if let doctorNotes = reference.doctorNotes, !doctorNotes.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notes")
                                    .font(AppFonts.callout())
                                    .fontWeight(.medium)
                                    .foregroundColor(AppColors.cardSecondaryText)
                                
                                Text(doctorNotes)
                                    .font(AppFonts.body())
                                    .foregroundColor(AppColors.cardText)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            .concaveCard(color: AppColors.cardBackground)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Reference Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Edit") {
                            showingEditSheet = true
                        }
                        
                        Button("Delete", role: .destructive) {
                            showingDeleteAlert = true
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(AppColors.primaryText)
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditReferenceView(reference: reference) { updatedReference in
                reference = updatedReference
                onUpdate(updatedReference)
            }
        }
        .alert("Delete Reference", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this reference?")
        }
    }
}

#Preview {
    ReferenceView()
}
