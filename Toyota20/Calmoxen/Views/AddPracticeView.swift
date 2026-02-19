import SwiftUI

struct AddPracticeView: View {
    @ObservedObject var practiceViewModel: PracticeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var selectedType = PracticeType.breathing
    @State private var duration = 5
    @State private var selectedFrequency = Frequency.daily
    @State private var comment = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var practiceToEdit: Practice?
    
    init(practiceViewModel: PracticeViewModel, practiceToEdit: Practice? = nil) {
        self.practiceViewModel = practiceViewModel
        self.practiceToEdit = practiceToEdit
        
        if let practice = practiceToEdit {
            _name = State(initialValue: practice.name)
            _selectedType = State(initialValue: practice.type)
            _duration = State(initialValue: practice.duration)
            _selectedFrequency = State(initialValue: practice.frequency)
            _comment = State(initialValue: practice.comment)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        InputSection(title: "Practice Name") {
                            TextField("Enter practice name", text: $name)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        InputSection(title: "Type") {
                            VStack(spacing: 12) {
                                ForEach(PracticeType.allCases, id: \.self) { type in
                                    TypeSelectionRow(
                                        type: type,
                                        isSelected: selectedType == type,
                                        onTap: { selectedType = type }
                                    )
                                }
                            }
                        }
                        
                        InputSection(title: "Duration (minutes)") {
                            HStack {
                                Stepper(value: $duration, in: 1...60) {
                                    HStack {
                                        Text("\(duration) minutes")
                                            .font(.bodyText)
                                            .foregroundColor(AppColors.primaryNavy)
                                        Spacer()
                                    }
                                }
                                .accentColor(AppColors.primaryOrange)
                            }
                            .padding(16)
                            .background(AppColors.cardGradient)
                            .cornerRadius(12)
                        }
                        
                        InputSection(title: "Frequency") {
                            VStack(spacing: 12) {
                                ForEach(Frequency.allCases, id: \.self) { frequency in
                                    FrequencySelectionRow(
                                        frequency: frequency,
                                        isSelected: selectedFrequency == frequency,
                                        onTap: { selectedFrequency = frequency }
                                    )
                                }
                            }
                        }
                        
                        InputSection(title: "Comment (Optional)") {
                            TextField("Add any notes about this practice", text: $comment, axis: .vertical)
                                .textFieldStyle(CustomTextFieldStyle())
                                .lineLimit(3...6)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
            .navigationTitle(practiceToEdit != nil ? "Edit Practice" : "Add Practice")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryNavy)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        savePractice()
                    }
                    .foregroundColor(AppColors.primaryOrange)
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func savePractice() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            alertMessage = "Please enter a practice name"
            showingAlert = true
            return
        }
        
        if let existingPractice = practiceToEdit {
            var updatedPractice = existingPractice
            updatedPractice.name = trimmedName
            updatedPractice.type = selectedType
            updatedPractice.duration = duration
            updatedPractice.frequency = selectedFrequency
            updatedPractice.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
            
            practiceViewModel.updatePractice(updatedPractice)
        } else {
            let newPractice = Practice(
                name: trimmedName,
                type: selectedType,
                duration: duration,
                frequency: selectedFrequency,
                comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            
            practiceViewModel.addPractice(newPractice)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct InputSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.cardTitle)
                .foregroundColor(AppColors.primaryNavy)
            
            content
        }
    }
}

struct TypeSelectionRow: View {
    let type: PracticeType
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                Image(systemName: type.icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .white : AppColors.primaryOrange)
                    .frame(width: 30)
                
                Text(type.rawValue)
                    .font(.bodyText)
                    .foregroundColor(isSelected ? .white : AppColors.primaryNavy)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .padding(16)
            .background(
                isSelected ? AnyShapeStyle(AppColors.primaryOrange) : AnyShapeStyle(AppColors.cardGradient)
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? AppColors.primaryOrange : AppColors.mediumGray.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FrequencySelectionRow: View {
    let frequency: Frequency
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(frequency.rawValue)
                    .font(.bodyText)
                    .foregroundColor(isSelected ? .white : AppColors.primaryNavy)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .padding(16)
            .background(
                isSelected ? AnyShapeStyle(AppColors.primaryOrange) : AnyShapeStyle(AppColors.cardGradient)
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? AppColors.primaryOrange : AppColors.mediumGray.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.bodyText)
            .foregroundColor(AppColors.primaryNavy)
            .padding(16)
            .background(AppColors.cardGradient)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.mediumGray.opacity(0.3), lineWidth: 1)
            )
    }
}

struct AddPracticeView_Previews: PreviewProvider {
    static var previews: some View {
        AddPracticeView(practiceViewModel: PracticeViewModel())
    }
}
