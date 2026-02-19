import SwiftUI

struct WordDetailView: View {
    let word: WordEntry
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
            ZStack {
                ColorManager.backgroundGradient
                    .ignoresSafeArea()
                
                FloatingBubblesView()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        headerView
                        
                        VStack(spacing: 25) {
                            wordSection
                            
                            if !word.meaning.isEmpty {
                                meaningSection
                            }
                            
                            if !word.association.isEmpty {
                                associationSection
                            }
                            
                            metadataSection
                        }
                        .padding(.horizontal, 20)
                        
                        actionButtons
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.top, 20)
                }
            }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: onDismiss) {
                HStack(spacing: 5) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                    Text("Back")
                        .font(.playfairDisplay(16, weight: .medium))
                }
                .foregroundColor(ColorManager.textBlue)
            }
            
            Spacer()
            
            Text("Word Details")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(ColorManager.textBlue)
            
            Spacer()
            
            Button {
                
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                    Text("Back")
                        .font(.playfairDisplay(16, weight: .medium))
                }
                .foregroundColor(ColorManager.textBlue)
            }
            .opacity(0)
            .disabled(true)
        }
        .padding(.horizontal, 20)
    }
    
    private var wordSection: some View {
        VStack(spacing: 15) {
            Text(word.word)
                .font(.playfairDisplay(28, weight: .bold))
                .foregroundColor(ColorManager.textBlue)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity)
        .padding(25)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(ColorManager.cardGradient)
                .shadow(color: ColorManager.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var meaningSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(ColorManager.primaryYellow)
                    .font(.system(size: 18))
                
                Text("My Meaning")
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(ColorManager.textBlue)
                
                Spacer()
            }
            
            Text(word.meaning)
                .font(.playfairDisplay(16, weight: .regular))
                .foregroundColor(ColorManager.darkGray)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.7))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                    .stroke(ColorManager.primaryYellow.opacity(0.3), lineWidth: 1)
                }
        )
    }
    
    private var associationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "link")
                    .foregroundColor(ColorManager.accentPurple)
                    .font(.system(size: 18))
                
                Text("Association")
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(ColorManager.textBlue)
                
                Spacer()
            }
            
            Text(word.association)
                .font(.playfairDisplay(16, weight: .regular))
                .foregroundColor(ColorManager.darkGray)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.7))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorManager.accentPurple.opacity(0.3), lineWidth: 1)
                }
        )
    }
    
    private var metadataSection: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Created:")
                    .font(.playfairDisplay(14, weight: .medium))
                    .foregroundColor(ColorManager.darkGray.opacity(0.7))
                
                Spacer()
                
                Text(formatDate(word.dateCreated))
                    .font(.playfairDisplay(14, weight: .regular))
                    .foregroundColor(ColorManager.darkGray.opacity(0.7))
            }
            
            if word.dateModified != word.dateCreated {
                HStack {
                    Text("Modified:")
                        .font(.playfairDisplay(14, weight: .medium))
                        .foregroundColor(ColorManager.darkGray.opacity(0.7))
                    
                    Spacer()
                    
                    Text(formatDate(word.dateModified))
                        .font(.playfairDisplay(14, weight: .regular))
                        .foregroundColor(ColorManager.darkGray.opacity(0.7))
                }
            }
        }
        .padding(.horizontal, 5)
    }
    
    private var actionButtons: some View {
        HStack(spacing: 20) {
            Button(action: onEdit) {
                HStack(spacing: 8) {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Edit")
                        .font(.playfairDisplay(16, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 25)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        colors: [ColorManager.primaryBlue, ColorManager.accentPurple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            
            Button(action: onDelete) {
                HStack(spacing: 8) {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Delete")
                        .font(.playfairDisplay(16, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 25)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        colors: [ColorManager.accentOrange, Color.red],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    WordDetailView(
        word: WordEntry(
            word: "Serendipity",
            meaning: "The occurrence and development of events by chance in a happy or beneficial way",
            association: "Finding something wonderful when you weren't looking for it"
        ),
        onEdit: { },
        onDelete: { },
        onDismiss: { }
    )
}
