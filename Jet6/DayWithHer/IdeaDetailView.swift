import SwiftUI

struct IdeaDetailItem: Identifiable {
    let id: UUID
}

struct IdeaDetailView: View {
    let ideaId: UUID
    @ObservedObject var viewModel: IdeaViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var showingMemoryEditor = false
    @State private var memoryText = ""
    
    private var idea: Idea? {
        viewModel.ideas.first { $0.id == ideaId }
    }
    
    var body: some View {
        Group {
            if let idea = idea {
                detailContent(for: idea)
            } else {
                EmptyView()
            }
        }
    }
    
    @ViewBuilder
    private func detailContent(for idea: Idea) -> some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerCard(for: idea)
                        
                        detailsCard(for: idea)
                        
                        memorySection(for: idea)
                        
                        actionButtons(for: idea)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(idea.title)
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Edit") {
                    showingEditView = true
                }
            )
        }
        .sheet(isPresented: $showingEditView) {
            if let currentIdea = self.idea {
                AddEditIdeaView(viewModel: viewModel, editingIdea: currentIdea)
            }
        }
        .sheet(isPresented: $showingMemoryEditor) {
            MemoryEditorView(
                memoryText: $memoryText,
                onSave: { memory in
                    if let currentIdea = self.idea {
                        viewModel.addMemoryToIdea(currentIdea, memory: memory)
                    }
                    showingMemoryEditor = false
                }
            )
        }
        .alert("Delete Idea", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let currentIdea = self.idea {
                    viewModel.deleteIdea(currentIdea)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this idea? This action cannot be undone.")
        }
        .onAppear {
            if let currentIdea = self.idea {
                memoryText = currentIdea.memory ?? ""
            }
        }
    }
    
    @ViewBuilder
    private func headerCard(for idea: Idea) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: idea.category.icon)
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.blueText)
                        
                        Text(idea.category.rawValue)
                            .font(.playfair(size: 16, weight: .medium))
                            .foregroundColor(AppColors.blueText)
                    }
                    
                    Text(idea.title)
                        .font(.playfair(size: 24, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: idea.status.icon)
                            .font(.system(size: 14))
                            .foregroundColor(idea.status == .completed ? AppColors.mintGreen : AppColors.yellowAccent)
                        
                        Text(idea.status.rawValue)
                            .font(.playfair(size: 14, weight: .semibold))
                            .foregroundColor(idea.status == .completed ? AppColors.mintGreen : AppColors.yellowAccent)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        (idea.status == .completed ? AppColors.mintGreen : AppColors.yellowAccent)
                            .opacity(0.2)
                    )
                    .cornerRadius(15)
                }
            }
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    @ViewBuilder
    private func detailsCard(for idea: Idea) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Details")
                .font(.playfair(size: 20, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.blueText)
                        .frame(width: 24)
                    
                    Text("Date:")
                        .font(.playfair(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Text(idea.dateString)
                        .font(.playfair(size: 16))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Divider()
                    .background(AppColors.lightPurple)
                
                if !idea.description.isEmpty {
                    HStack(alignment: .top) {
                        Image(systemName: "text.alignleft")
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.blueText)
                            .frame(width: 24)
                        
                        Text("Description:")
                            .font(.playfair(size: 16, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                    }
                    
                    Text(idea.description)
                        .font(.playfair(size: 16))
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(2)
                        .padding(.leading, 24)
                }
            }
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    @ViewBuilder
    private func memorySection(for idea: Idea) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Memory")
                    .font(.playfair(size: 20, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Button(action: {
                    showingMemoryEditor = true
                }) {
                    Text(idea.memory?.isEmpty == false ? "Edit" : "Add")
                        .font(.playfair(size: 14, weight: .medium))
                        .foregroundColor(AppColors.blueText)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(AppColors.lightPurple)
                        .cornerRadius(15)
                }
            }
            
            if let memory = idea.memory, !memory.isEmpty {
                Text(memory)
                    .font(.playfair(size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(2)
            } else {
                Text("No memories yet. After the meeting, add a short comment to remember the moment.")
                    .font(.playfair(size: 16))
                    .foregroundColor(AppColors.lightText)
                    .italic()
                    .multilineTextAlignment(.leading)
                    .lineSpacing(2)
            }
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    @ViewBuilder
    private func actionButtons(for idea: Idea) -> some View {
        VStack(spacing: 12) {
            Button(action: {
                viewModel.toggleIdeaStatus(idea)
            }) {
                HStack {
                    Image(systemName: idea.status == .planned ? "checkmark.circle" : "arrow.counterclockwise.circle")
                        .font(.system(size: 18))
                    
                    Text(idea.status == .planned ? "Mark as Completed" : "Mark as Planned")
                        .font(.playfair(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColors.purpleGradient)
                .cornerRadius(25)
                .shadow(color: AppColors.primaryPurple.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack {
                    Image(systemName: "trash")
                        .font(.system(size: 16))
                    
                    Text("Delete Idea")
                        .font(.playfair(size: 16, weight: .medium))
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.red.opacity(0.1))
                .cornerRadius(25)
            }
        }
    }
}

struct MemoryEditorView: View {
    @Binding var memoryText: String
    let onSave: (String) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Add your memory about this moment")
                        .font(.playfair(size: 18, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    TextEditor(text: $memoryText)
                        .font(.playfair(size: 16))
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(AppColors.cardBackground)
                        .cornerRadius(12)
                        .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 5, x: 0, y: 2)
                        .frame(minHeight: 200)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("Memory")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    onSave(memoryText)
                }
            )
        }
    }
}

#Preview {
    let sampleIdea = Idea(
        title: "Picnic by the lake",
        date: Date(),
        category: .walk,
        description: "Bring basket, lemonade and camera.",
        status: .completed
    )
    
    return IdeaDetailView(ideaId: sampleIdea.id, viewModel: IdeaViewModel())
}
