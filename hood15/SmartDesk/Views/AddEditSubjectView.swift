import SwiftUI

struct AddEditSubjectView: View {
    @ObservedObject var subjectStore: SubjectStore
    @Environment(\.dismiss) private var dismiss
    
    let editingSubject: Subject?
    @State private var subjectName = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    
    init(subjectStore: SubjectStore, editingSubject: Subject? = nil) {
        self.subjectStore = subjectStore
        self.editingSubject = editingSubject
        _subjectName = State(initialValue: editingSubject?.name ?? "")
    }
    
    private var isFormValid: Bool {
        !subjectName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var navigationTitle: String {
        editingSubject != nil ? "Edit Subject" : "New Subject"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 30) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Subject Name")
                            .font(.appSubheadline)
                            .foregroundColor(.appText)
                        
                        TextField("e.g., Mathematics", text: $subjectName)
                            .font(.appBody)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.lightBlue, lineWidth: 1)
                                    )
                            )
                            .foregroundColor(.appText)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    
                    Spacer()
                    
                    Button(action: saveSubject) {
                        Text("Save")
                            .font(.appSubheadline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(isFormValid ? AppColors.primaryBlue : AppColors.textSecondary)
                            )
                    }
                    .disabled(!isFormValid)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.appText)
                }
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func saveSubject() {
        let trimmedName = subjectName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            errorMessage = "Please enter a subject name"
            showingError = true
            return
        }
        
        let existingSubject = subjectStore.subjects.first { subject in
            subject.name.lowercased() == trimmedName.lowercased() && 
            subject.id != editingSubject?.id
        }
        
        if existingSubject != nil {
            errorMessage = "A subject with this name already exists"
            showingError = true
            return
        }
        
        if let editingSubject = editingSubject {
            var updatedSubject = editingSubject
            updatedSubject.name = trimmedName
            subjectStore.updateSubject(updatedSubject)
        } else {
            let newSubject = Subject(name: trimmedName)
            subjectStore.addSubject(newSubject)
        }
        
        dismiss()
    }
}

#Preview {
    AddEditSubjectView(subjectStore: SubjectStore())
}
