import SwiftUI

struct PracticeDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataManager: DataManager
    let practiceId: UUID
    
    @State private var showingDeleteAlert = false
    @State private var showingEditView = false
    
    private var practice: Practice? {
        dataManager.practices.first { $0.id == practiceId }
    }
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            if let practice = practice {
                detailContent(practice: practice)
            } else {
                emptyState
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(ColorTheme.textColor)
                }
            }
            
            if practice != nil {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Edit") {
                            showingEditView = true
                        }
                        
                        Button("Delete", role: .destructive) {
                            showingDeleteAlert = true
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(ColorTheme.textColor)
                    }
                }
            }
        }
        .alert("Delete Practice", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let p = practice {
                    dataManager.deletePractice(p)
                }
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this practice? This action cannot be undone.")
        }
        .sheet(isPresented: $showingEditView) {
            if practiceId != UUID() {
                EditPracticeView(practiceId: practiceId)
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Text("Practice not found")
                .font(.playfair(18, weight: .medium))
                .foregroundColor(ColorTheme.secondaryColor)
            Button("Back") {
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(ColorTheme.accentColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func detailContent(practice: Practice) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 20) {
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(ColorTheme.accentColor.opacity(0.1))
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: practice.type.icon)
                                .font(.system(size: 32))
                                .foregroundColor(ColorTheme.accentColor)
                        }
                        
                        VStack(spacing: 8) {
                            Text(practice.name)
                                .font(.playfair(24, weight: .bold))
                                .foregroundColor(ColorTheme.textColor)
                                .multilineTextAlignment(.center)
                            
                            Text(practice.type.rawValue)
                                .font(.playfair(16))
                                .foregroundColor(ColorTheme.secondaryColor)
                        }
                    }
                    
                    HStack(spacing: 40) {
                        VStack(spacing: 4) {
                            Text("\(practice.duration)")
                                .font(.playfair(20, weight: .bold))
                                .foregroundColor(ColorTheme.textColor)
                            Text("minutes")
                                .font(.playfair(14))
                                .foregroundColor(ColorTheme.secondaryColor)
                        }
                        VStack(spacing: 4) {
                            Text("\(practice.streak)")
                                .font(.playfair(20, weight: .bold))
                                .foregroundColor(ColorTheme.accentColor)
                            Text("day streak")
                                .font(.playfair(14))
                                .foregroundColor(ColorTheme.secondaryColor)
                        }
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(ColorTheme.cardGradient)
                .cornerRadius(16)
                .shadow(color: ColorTheme.shadowColor, radius: 8, x: 0, y: 4)
                
                if !practice.note.isEmpty {
                    CardView {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Benefits")
                                .font(.playfair(18, weight: .medium))
                                .foregroundColor(ColorTheme.textColor)
                            Text(practice.note)
                                .font(.playfair(16))
                                .foregroundColor(ColorTheme.secondaryColor)
                                .lineSpacing(4)
                        }
                    }
                }
                
                CardView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Practice History")
                            .font(.playfair(18, weight: .medium))
                            .foregroundColor(ColorTheme.textColor)
                        
                        if let lastCompleted = practice.lastCompleted {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Last completed:")
                                    .font(.playfair(14))
                                    .foregroundColor(ColorTheme.secondaryColor)
                                Text(formatDate(lastCompleted))
                                    .font(.playfair(16, weight: .medium))
                                    .foregroundColor(ColorTheme.textColor)
                            }
                        } else {
                            Text("Not completed yet")
                                .font(.playfair(16))
                                .foregroundColor(ColorTheme.secondaryColor)
                        }
                        
                        HStack {
                            ForEach(0..<7, id: \.self) { day in
                                Circle()
                                    .fill(day < practice.streak ? ColorTheme.accentColor : ColorTheme.secondaryColor.opacity(0.3))
                                    .frame(width: 32, height: 32)
                                    .overlay(
                                        Text("\(day + 1)")
                                            .font(.playfair(12, weight: .medium))
                                            .foregroundColor(day < practice.streak ? .white : ColorTheme.secondaryColor)
                                    )
                            }
                        }
                    }
                }
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationView {
        PracticeDetailView(practiceId: UUID())
    }
    .environmentObject(DataManager.shared)
}
