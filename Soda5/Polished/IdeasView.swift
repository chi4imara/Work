import SwiftUI

struct IdeasView: View {
    @EnvironmentObject var ideaStore: IdeaStore
    @State private var showingAddIdea = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("My Ideas")
                        .font(.playfairDisplay(28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button(action: { showingAddIdea = true }) {
                        Image(systemName: "plus")
                            .font(.playfairDisplay(28, weight: .bold))
                            .foregroundColor(AppColors.yellowAccent)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if ideaStore.ideas.isEmpty {
                    emptyStateView
                } else {
                    ideasList
                }
            }
        }
        .sheet(isPresented: $showingAddIdea) {
            AddIdeaView()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "lightbulb")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("No ideas yet")
                    .font(.playfairDisplay(22, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add a note so you don't forget your favorite color combinations or designs.")
                    .font(.playfairDisplay(16))
                    .foregroundColor(AppColors.blueText)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            
            Button(action: { showingAddIdea = true }) {
                Text("Add Idea")
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(AppColors.contrastText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(AppColors.purpleGradient)
                    .cornerRadius(25)
            }
            .padding(.horizontal, 60)
            
            Spacer()
        }
    }
    
    private var ideasList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(ideaStore.ideas.sorted { $0.createdAt > $1.createdAt }) { idea in
                    IdeaCardView(idea: idea) {
                        ideaStore.deleteIdea(idea)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }
}

struct IdeaCardView: View {
    let idea: Idea
    let onDelete: () -> Void
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(idea.title)
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Button(action: { showingDeleteAlert = true }) {
                    Image(systemName: "trash")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            if !idea.note.isEmpty {
                Text(idea.note)
                    .font(.playfairDisplay(14))
                    .foregroundColor(AppColors.blueText)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(16)
        .background(AppColors.backgroundWhite.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 4, x: 0, y: 2)
        .alert("Delete Idea", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete this idea?")
        }
    }
}

struct AddIdeaView: View {
    @EnvironmentObject var ideaStore: IdeaStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var note = ""
    
    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Idea Title *")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("e.g., Milk with gold tips", text: $title)
                                .font(.playfairDisplay(16))
                                .padding(12)
                                .background(AppColors.backgroundGray.opacity(0.5))
                                .cornerRadius(8)
                        }
                        .padding(16)
                        .background(AppColors.backgroundWhite.opacity(0.8))
                        .cornerRadius(16)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Try with Maria in January...", text: $note, axis: .vertical)
                                .font(.playfairDisplay(16))
                                .lineLimit(3...6)
                                .padding(12)
                                .background(AppColors.backgroundGray.opacity(0.5))
                                .cornerRadius(8)
                        }
                        .padding(16)
                        .background(AppColors.backgroundWhite.opacity(0.8))
                        .cornerRadius(16)
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Add Idea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.blueText)
                    .font(.playfairDisplay(16))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveIdea()
                    }
                    .disabled(!canSave)
                    .foregroundColor(canSave ? AppColors.yellowAccent : AppColors.secondaryText)
                    .font(.playfairDisplay(16, weight: .semibold))
                }
            }
        }
    }
    
    private func saveIdea() {
        let newIdea = Idea(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            note: note.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        ideaStore.addIdea(newIdea)
        dismiss()
    }
}
