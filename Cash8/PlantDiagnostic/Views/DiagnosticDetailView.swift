import SwiftUI

struct DiagnosticDetailView: View {
    let cause: PossibleCause
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            AppGradients.backgroundGradient
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                
                Button(action: {
                   presentationMode.wrappedValue.dismiss()
               }) {
                   Image(systemName: "chevron.left")
                       .font(.system(size: 18, weight: .medium))
                       .foregroundColor(.accentGreen)
               }
               .padding(.horizontal, 16)
               .padding(.top, 16)
               .padding(.bottom, 8)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        headerView
                        
                        symptomsSection
                        
                        treatmentSection
                        
                        preventionSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.accentOrange)
                
                Spacer()
            }
            
            Text(cause.name)
                .font(.titleLarge)
                .foregroundColor(.primaryText)
            
            Text(cause.description)
                .font(.bodyLarge)
                .foregroundColor(.secondaryText)
                .multilineTextAlignment(.leading)
        }
        .padding(20)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.cardShadow, radius: 4, x: 0, y: 2)
    }
    
    private var symptomsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "eye.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.accentBlue)
                
                Text("Symptoms to Look For")
                    .font(.titleMedium)
                    .foregroundColor(.primaryText)
            }
            
            Text(cause.symptoms)
                .font(.bodyMedium)
                .foregroundColor(.primaryText)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
    
    private var treatmentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "cross.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.accentGreen)
                
                Text("Treatment Steps")
                    .font(.titleMedium)
                    .foregroundColor(.primaryText)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(parseTreatmentSteps(cause.treatment), id: \.self) { step in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.accentGreen)
                            .padding(.top, 2)
                        
                        Text(step)
                            .font(.bodyMedium)
                            .foregroundColor(.primaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
    
    private var preventionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "shield.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.accentPurple)
                
                Text("Prevention Tips")
                    .font(.titleMedium)
                    .foregroundColor(.primaryText)
            }
            
            Text(cause.prevention)
                .font(.bodyMedium)
                .foregroundColor(.primaryText)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
    
    private func parseTreatmentSteps(_ treatment: String) -> [String] {
        let sentences = treatment.components(separatedBy: ". ")
        return sentences.map { sentence in
            let trimmed = sentence.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.hasSuffix(".") ? trimmed : trimmed + "."
        }.filter { !$0.isEmpty && $0 != "." }
    }
}

#Preview {
    NavigationView {
        DiagnosticDetailView(
            cause: DiagnosticDataManager.shared.getAllSymptoms().first!.possibleCauses.first!
        )
    }
}


