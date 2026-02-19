import SwiftUI

struct AddPersonView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var dataManager = DataManager.shared
    @State private var personName = ""
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.ubuntu(16))
                    .foregroundColor(.appTextSecondary)
                    
                    Spacer()
                    
                    Text("New person")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(.appTextPrimary)
                    
                    Spacer()
                    
                    Button("Save") {
                        if !personName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            let newPerson = Person(name: personName.trimmingCharacters(in: .whitespacesAndNewlines))
                            dataManager.addPerson(newPerson)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(personName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .appTextSecondary : .appAccent)
                    .disabled(personName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Name")
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(.appTextSecondary)
                        
                        TextField("Enter person's name", text: $personName)
                            .font(.ubuntu(16))
                            .foregroundColor(.appTextPrimary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.appCard)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.appAccent.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

#Preview {
    AddPersonView()
}
