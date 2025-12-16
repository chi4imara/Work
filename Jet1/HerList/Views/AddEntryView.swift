import SwiftUI

struct AddEntryView: View {
    @ObservedObject var viewModel: WomenViewModel
    let existingWoman: Woman?
    
    @State private var name = ""
    @State private var profession = ""
    @State private var quote = ""
    @State private var personalNote = ""
    @State private var isFavorite = false
    
    private var selectedTab: Binding<Int>?
    
    private var isPresented: Binding<Bool>?
    
    init(viewModel: WomenViewModel, selectedTab: Binding<Int>, existingWoman: Woman? = nil) {
        self.viewModel = viewModel
        self.selectedTab = selectedTab
        self.isPresented = nil
        self.existingWoman = existingWoman
        
        if let woman = existingWoman {
            self._name = State(initialValue: woman.name)
            self._profession = State(initialValue: woman.profession)
            self._quote = State(initialValue: woman.quote)
            self._personalNote = State(initialValue: woman.personalNote)
            self._isFavorite = State(initialValue: woman.isFavorite)
        }
    }
    
    init(viewModel: WomenViewModel, isPresented: Binding<Bool>, existingWoman: Woman? = nil, onSave: @escaping () -> Void = {}) {
        self.viewModel = viewModel
        self.selectedTab = nil
        self.isPresented = isPresented
        self.existingWoman = existingWoman
        
        if let woman = existingWoman {
            self._name = State(initialValue: woman.name)
            self._profession = State(initialValue: woman.profession)
            self._quote = State(initialValue: woman.quote)
            self._personalNote = State(initialValue: woman.personalNote)
            self._isFavorite = State(initialValue: woman.isFavorite)
        }
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !profession.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("New Entry")
                        .font(FontManager.ubuntu(28, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Spacer()
                    
                    Button("Save") {
                        saveWoman()
                    }
                    .font(FontManager.ubuntu(28, weight: .bold))
                    .foregroundColor(isFormValid ? Color.theme.primaryText : Color.theme.secondaryText)
                    .disabled(!isFormValid)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 20) {
                            CustomTextField(
                                title: "Name",
                                text: $name,
                                placeholder: "e.g., Coco Chanel"
                            )
                            
                            CustomTextField(
                                title: "Profession",
                                text: $profession,
                                placeholder: "Designer, actress, writer, blogger..."
                            )
                            
                            CustomTextEditor(
                                title: "Quote",
                                text: $quote,
                                placeholder: "Enter an inspiring quote..."
                            )
                            
                            CustomTextEditor(
                                title: "Personal Note",
                                text: $personalNote,
                                placeholder: "Why does she inspire you?"
                            )
                            
                            HStack {
                                Text("Favorite Person")
                                    .font(FontManager.ubuntu(16, weight: .medium))
                                    .foregroundColor(Color.theme.primaryText)
                                
                                Spacer()
                                
                                Toggle("", isOn: $isFavorite)
                                    .toggleStyle(SwitchToggleStyle(tint: Color.theme.favoriteHeart))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.theme.cardBackground.opacity(0.2))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private func saveWoman() {
        if let existing = existingWoman {
            var updatedWoman = existing
            updatedWoman.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedWoman.profession = profession.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedWoman.quote = quote.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedWoman.personalNote = personalNote.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedWoman.isFavorite = isFavorite
            viewModel.updateWoman(updatedWoman)
        } else {
            let woman = Woman(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                profession: profession.trimmingCharacters(in: .whitespacesAndNewlines),
                quote: quote.trimmingCharacters(in: .whitespacesAndNewlines),
                personalNote: personalNote.trimmingCharacters(in: .whitespacesAndNewlines),
                isFavorite: isFavorite
            )
            viewModel.addWoman(woman)
        }
        
        if let selectedTab = selectedTab {
            selectedTab.wrappedValue = 0
        } else if let isPresented = isPresented {
            isPresented.wrappedValue = false
        }
    }
}
