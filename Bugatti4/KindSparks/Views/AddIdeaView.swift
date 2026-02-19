import SwiftUI

struct AddIdeaView: View {
    let personId: UUID
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var dataManager = DataManager.shared
    @State private var ideaText = ""
    
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
                    
                    Text("New gift idea")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(.appTextPrimary)
                    
                    Spacer()
                    
                    Button("Save") {
                        if !ideaText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            let newIdea = GiftIdea(
                                text: ideaText.trimmingCharacters(in: .whitespacesAndNewlines),
                                personId: personId
                            )
                            dataManager.addIdea(newIdea, to: personId)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ideaText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .appTextSecondary : .appAccent)
                    .disabled(ideaText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Gift idea")
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(.appTextSecondary)
                        
                        TextField("Enter your gift idea", text: $ideaText, axis: .vertical)
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
                            .lineLimit(5...10)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

#Preview {
    AddIdeaView(personId: UUID())
}
