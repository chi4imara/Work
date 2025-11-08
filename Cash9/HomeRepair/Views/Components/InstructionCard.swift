import SwiftUI

struct InstructionCard: View {
    let instruction: RepairInstruction
    let onTap: () -> Void
    let onFavoriteToggle: () -> Void
    let onArchive: () -> Void
    
    @State private var dragOffset = CGSize.zero
    @State private var showingArchiveConfirmation = false
    @State private var isFavorite: Bool
    
    init(instruction: RepairInstruction, onTap: @escaping () -> Void, onFavoriteToggle: @escaping () -> Void, onArchive: @escaping () -> Void) {
        self.instruction = instruction
        self.onTap = onTap
        self.onFavoriteToggle = onFavoriteToggle
        self.onArchive = onArchive
        self._isFavorite = State(initialValue: instruction.isFavorite)
    }
    
    var body: some View {
        ZStack {
            HStack {
                if dragOffset.width > 0 {
                    Button(action: {
                        isFavorite.toggle()
                        onFavoriteToggle()
                    }) {
                        VStack {
                            Image(systemName: isFavorite ? "star.slash.fill" : "star.fill")
                                .font(.title2)
                            Text(isFavorite ? "Remove" : "Favorite")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                        .frame(width: 80)
                    }
                    .frame(maxHeight: .infinity)
                    .background(Color.accentOrange)
                    .cornerRadius(12)
                }
                
                Spacer()
                
                if dragOffset.width < 0 {
                    Button(action: { showingArchiveConfirmation = true }) {
                        VStack {
                            Image(systemName: "archivebox.fill")
                                .font(.title2)
                            Text("Archive")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                        .frame(width: 80)
                    }
                    .frame(maxHeight: .infinity)
                    .background(Color.accentRed)
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 20)
            
            Button(action: onTap) {
                HStack(spacing: 15) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(instruction.category.icon == "drop.fill" ? Color.primaryBlue.opacity(0.2) : 
                                  instruction.category.icon == "bolt.fill" ? Color.accentOrange.opacity(0.2) :
                                  instruction.category.icon == "chair.fill" ? Color.accentGreen.opacity(0.2) :
                                  instruction.category.icon == "paintbrush.fill" ? Color.accentRed.opacity(0.2) :
                                  instruction.category.icon == "leaf.fill" ? Color.accentGreen.opacity(0.2) :
                                  Color.textSecondary.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: instruction.category.icon)
                            .font(.title2)
                            .foregroundColor(instruction.category.icon == "drop.fill" ? Color.primaryBlue : 
                                           instruction.category.icon == "bolt.fill" ? Color.accentOrange :
                                           instruction.category.icon == "chair.fill" ? Color.accentGreen :
                                           instruction.category.icon == "paintbrush.fill" ? Color.accentRed :
                                           instruction.category.icon == "leaf.fill" ? Color.accentGreen :
                                           Color.textSecondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(instruction.title)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.textPrimary)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            if isFavorite {
                                Image(systemName: "star.fill")
                                    .font(.caption)
                                    .foregroundColor(.accentOrange)
                            }
                        }
                        
                        Text(instruction.category.rawValue)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        Text(instruction.shortDescription)
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                }
                .padding(16)
                .background(Color.cardBackground)
                .cornerRadius(12)
                .shadow(color: Color.cardShadow, radius: 5, x: 0, y: 2)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .onAppear {
            isFavorite = instruction.isFavorite
        }
        .alert("Archive Instruction", isPresented: $showingArchiveConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Archive", role: .destructive) {
                onArchive()
            }
        } message: {
            Text("This instruction will be moved to the archive and removed from the handbook.")
        }
    }
}

#Preview {
    VStack {
        InstructionCard(
            instruction: RepairInstruction(
                title: "Fix Leaking Faucet",
                category: .plumbing,
                shortDescription: "How to repair a dripping tap in your kitchen or bathroom",
                imageName: "faucet",
                tools: ["Wrench", "Screwdriver"],
                steps: [],
                tips: []
            ),
            onTap: { },
            onFavoriteToggle: { },
            onArchive: { }
        )
        .padding()
    }
    .background(AppColors.background)
}

