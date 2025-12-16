import SwiftUI

struct AddInspirationView: View {
    @ObservedObject var viewModel: InspirationViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var description = ""
    @State private var tagsText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            TextField("Winter knitting ideas...", text: $title)
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
                            Text("Description")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            ZStack(alignment: .topLeading) {
                                if description.isEmpty {
                                    Text("Describe your inspiration...")
                                        .font(.playfairDisplay(16))
                                        .foregroundColor(Color.theme.secondaryText.opacity(0.5))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 16)
                                }
                                
                                TextEditor(text: $description)
                                    .font(.playfairDisplay(16))
                                    .foregroundColor(Color.theme.primaryText)
                                    .frame(minHeight: 120)
                                    .scrollContentBackground(.hidden)
                                    .padding(8)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.theme.cardBackground)
                                    .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tags")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            TextField("knitting, winter, gift (comma separated)", text: $tagsText)
                                .font(.playfairDisplay(16))
                                .foregroundColor(Color.theme.primaryText)
                                .padding(16)
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
            .navigationTitle("New Inspiration")
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
                        saveInspiration()
                    }
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(Color.theme.primaryYellow)
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveInspiration() {
        let tags = tagsText
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        let inspiration = Inspiration(title: title, description: description, tags: tags)
        viewModel.addInspiration(inspiration)
        presentationMode.wrappedValue.dismiss()
    }
}

struct InspirationDetailItem: Identifiable {
    let id: UUID
}

struct InspirationDetailView: View {
    let inspirationId: UUID
    @ObservedObject var viewModel: InspirationViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var inspiration: Inspiration? {
        viewModel.inspirations.first { $0.id == inspirationId }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        Group {
            if let inspiration = inspiration {
                NavigationView {
                    ZStack {
                        Color.theme.backgroundGradient
                            .ignoresSafeArea()
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 24) {
                                if !inspiration.tags.isEmpty {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 8) {
                                            ForEach(inspiration.tags, id: \.self) { tag in
                                                Text(tag)
                                                    .font(.playfairDisplay(14, weight: .semibold))
                                                    .foregroundColor(Color.theme.primaryPurple)
                                                    .padding(.horizontal, 16)
                                                    .padding(.vertical, 8)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 16)
                                                            .fill(Color.theme.lightPurple.opacity(0.3))
                                                    )
                                            }
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                    .padding(.horizontal, -20)
                                }
                                
                                if !inspiration.description.isEmpty {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("Description")
                                            .font(.playfairDisplay(20, weight: .bold))
                                            .foregroundColor(Color.theme.primaryText)
                                        
                                        Text(inspiration.description)
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
                                    Text("Created")
                                        .font(.playfairDisplay(14, weight: .semibold))
                                        .foregroundColor(Color.theme.secondaryText)
                                    
                                    Text(dateFormatter.string(from: inspiration.dateCreated))
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
                                            Text("Edit Inspiration")
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
                                            Text("Delete Inspiration")
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
                    .navigationTitle(inspiration.title)
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
                    .alert("Delete Inspiration", isPresented: $showingDeleteAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            if let inspiration = self.inspiration {
                                viewModel.deleteInspiration(inspiration)
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    } message: {
                        Text("Are you sure you want to delete this inspiration? This action cannot be undone.")
                    }
                    .sheet(isPresented: $showingEditView) {
                        if let inspiration = self.inspiration {
                            EditInspirationView(inspiration: inspiration, viewModel: viewModel)
                        }
                    }
                }
            }
        }
    }
}

struct EditInspirationView: View {
    let inspiration: Inspiration
    @ObservedObject var viewModel: InspirationViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String
    @State private var description: String
    @State private var tagsText: String
    
    init(inspiration: Inspiration, viewModel: InspirationViewModel) {
        self.inspiration = inspiration
        self.viewModel = viewModel
        
        _title = State(initialValue: inspiration.title)
        _description = State(initialValue: inspiration.description)
        _tagsText = State(initialValue: inspiration.tags.joined(separator: ", "))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            TextField("Winter knitting ideas...", text: $title)
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
                            Text("Description")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            ZStack(alignment: .topLeading) {
                                if description.isEmpty {
                                    Text("Describe your inspiration...")
                                        .font(.playfairDisplay(16))
                                        .foregroundColor(Color.theme.secondaryText.opacity(0.5))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 16)
                                }
                                
                                TextEditor(text: $description)
                                    .font(.playfairDisplay(16))
                                    .foregroundColor(Color.theme.primaryText)
                                    .frame(minHeight: 120)
                                    .scrollContentBackground(.hidden)
                                    .padding(8)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.theme.cardBackground)
                                    .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tags")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            TextField("knitting, winter, gift (comma separated)", text: $tagsText)
                                .font(.playfairDisplay(16))
                                .foregroundColor(Color.theme.primaryText)
                                .padding(16)
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
            .navigationTitle("Edit Inspiration")
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
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveChanges() {
        let tags = tagsText
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        var updatedInspiration = inspiration
        updatedInspiration.title = title
        updatedInspiration.description = description
        updatedInspiration.tags = tags
        
        viewModel.updateInspiration(updatedInspiration)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddInspirationView(viewModel: InspirationViewModel())
}
