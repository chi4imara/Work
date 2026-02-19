import SwiftUI

struct NewRitualView: View {
    @ObservedObject var viewModel: RitualViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var isRepeating = false
    
    var isSaveEnabled: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                Form {
                    Section {
                        TextField("Title", text: $title)
                            .font(.appBody())
                            .foregroundColor(AppColors.textWhite)
                        
                        TextEditor(text: $description)
                            .font(.appBody())
                            .foregroundColor(AppColors.textWhite)
                            .frame(minHeight: 120)
                    } header: {
                        Text("Ritual Details")
                            .font(.appCaption())
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .listRowBackground(AppColors.cardBackground)
                    
                    Section {
                        Toggle("This is a repeating ritual", isOn: $isRepeating)
                            .font(.appBody())
                            .foregroundColor(AppColors.textWhite)
                    } header: {
                        Text("Settings")
                            .font(.appCaption())
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .listRowBackground(AppColors.cardBackground)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("New Ritual")
            .navigationBarTitleDisplayMode(.inline)
            .font(.appHeadline())
            .foregroundColor(AppColors.textWhite)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textWhite)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let ritual = Ritual(
                            title: title,
                            description: description,
                            isRepeating: isRepeating
                        )
                        viewModel.addRitual(ritual)
                        dismiss()
                    }
                    .foregroundColor(isSaveEnabled ? AppColors.accentPurple : AppColors.textSecondary)
                    .disabled(!isSaveEnabled)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct EditRitualView: View {
    @ObservedObject var viewModel: RitualViewModel
    let ritualId: UUID
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var isRepeating: Bool = false
    
    private var ritual: Ritual? {
        viewModel.getRitual(by: ritualId)
    }
    
    var isSaveEnabled: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        Group {
            if let ritual = ritual {
                editRitualContent(ritual: ritual)
            } else {
                Text("Ritual not found")
                    .font(.appBody())
                    .foregroundColor(AppColors.textWhite)
            }
        }
        .onAppear {
            if let ritual = ritual {
                title = ritual.title
                description = ritual.description
                isRepeating = ritual.isRepeating
            }
        }
    }
    
    private func editRitualContent(ritual: Ritual) -> some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                Form {
                    Section {
                        TextField("Title", text: $title)
                            .font(.appBody())
                            .foregroundColor(AppColors.textWhite)
                        
                        TextEditor(text: $description)
                            .font(.appBody())
                            .foregroundColor(AppColors.textWhite)
                            .frame(minHeight: 120)
                    } header: {
                        Text("Ritual Details")
                            .font(.appCaption())
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .listRowBackground(AppColors.cardBackground)
                    
                    Section {
                        Toggle("This is a repeating ritual", isOn: $isRepeating)
                            .font(.appBody())
                            .foregroundColor(AppColors.textWhite)
                    } header: {
                        Text("Settings")
                            .font(.appCaption())
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .listRowBackground(AppColors.cardBackground)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Edit Ritual")
            .navigationBarTitleDisplayMode(.inline)
            .font(.appHeadline())
            .foregroundColor(AppColors.textWhite)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textWhite)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if var updatedRitual = self.ritual {
                            updatedRitual.title = title
                            updatedRitual.description = description
                            updatedRitual.isRepeating = isRepeating
                            viewModel.updateRitual(updatedRitual)
                            dismiss()
                        }
                    }
                    .foregroundColor(isSaveEnabled ? AppColors.accentPurple : AppColors.textSecondary)
                    .disabled(!isSaveEnabled)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
