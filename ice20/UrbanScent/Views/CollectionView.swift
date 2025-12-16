import SwiftUI

struct CollectionView: View {
    @ObservedObject var viewModel: ScentViewModel
    @State private var showingAddScent = false
    @State private var newScentName = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                if viewModel.entries.isEmpty {
                    emptyStateSection
                } else {
                    discoveryStatsSection
                    
                    scentCollectionSection
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .padding(.bottom, 80)
        }
        .sheet(isPresented: $showingAddScent) {
            AddScentSheet(
                scentName: $newScentName,
                onSave: addManualScent,
                onCancel: { showingAddScent = false }
            )
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Scent Collection")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(.appTextPrimary)
            
            Text("Your personal aroma library")
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(.appTextSecondary)
        }
    }
    
    private var discoveryStatsSection: some View {
        VStack(spacing: 16) {
            Text("You have described \(viewModel.getUniqueScents().count) different scents.")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(.appTextPrimary)
                .multilineTextAlignment(.center)
            
            Text("Your city smells like stories. Keep recording.")
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(.appTextSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.appCardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.appCardBorder, lineWidth: 1)
                )
        )
    }
    
    private var scentCollectionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Your Scents")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(.appTextPrimary)
                
                Spacer()
                
                Button(action: { showingAddScent = true }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                        Text("Add Manually")
                    }
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(.appPrimaryYellow)
                }
            }
            
            LazyVStack(spacing: 12) {
                ForEach(viewModel.getUniqueScents(), id: \.scent) { item in
                    ScentCollectionRow(
                        scent: item.scent,
                        count: item.count,
                        dominantEmotion: item.dominantEmotion
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.appCardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.appCardBorder, lineWidth: 1)
                )
        )
    }
    
    private var emptyStateSection: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.appTextTertiary)
            
            Text("Scents you've encountered will appear here. Make your first entry, and the collection will start growing.")
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(.appTextSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            
            CustomButton(title: "Add First Scent", action: { showingAddScent = true })
        }
        .padding(40)
    }
    
    private func addManualScent() {
        guard !newScentName.isEmpty else { return }
        
        viewModel.addEntry(
            scent: newScentName,
            location: "Added manually",
            emotion: .calm
        )
        
        newScentName = ""
        showingAddScent = false
    }
}

struct ScentCollectionRow: View {
    let scent: String
    let count: Int
    let dominantEmotion: Emotion
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(emotionColor)
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(scent)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.appTextPrimary)
                
                HStack(spacing: 8) {
                    Image(systemName: dominantEmotion.icon)
                        .font(.system(size: 12))
                        .foregroundColor(.appTextTertiary)
                    
                    Text(dominantEmotion.rawValue)
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(.appTextTertiary)
                }
            }
            
            Spacer()
            
            Text("\(count)")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(.appPrimaryYellow)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.appPrimaryYellow.opacity(0.2))
                )
        }
        .padding(.vertical, 8)
    }
    
    private var emotionColor: Color {
        switch dominantEmotion {
        case .calm:
            return .appAccentGreen
        case .cozy:
            return .appPrimaryYellow
        case .sad:
            return .appPrimaryBlue
        case .energetic:
            return .appAccentRed
        case .fresh:
            return .appPrimaryBlue.opacity(0.8)
        }
    }
}

struct AddScentSheet: View {
    @Binding var scentName: String
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Scent Name")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(.appTextPrimary)
                        
                        TextField("Enter scent name...", text: $scentName)
                            .font(.ubuntu(16, weight: .regular))
                            .foregroundColor(.appTextPrimary)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.appCardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.appCardBorder, lineWidth: 1)
                                    )
                            )
                    }
                    
                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle("Add Scent")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", action: onCancel)
                        .foregroundColor(.appTextSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save", action: onSave)
                        .foregroundColor(.appPrimaryYellow)
                        .disabled(scentName.isEmpty)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        AnimatedBackground()
        CollectionView(viewModel: ScentViewModel())
    }
}
