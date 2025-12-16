import SwiftUI

struct ProgramsView: View {
    @ObservedObject var programsViewModel: ProgramsViewModel
    @State private var showingCreateProgram = false
    @State private var programToDelete: BreathingProgram?
    @State private var showingDeleteAlert = false
    @State private var showingDeleteError = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if programsViewModel.programs.isEmpty {
                    emptyStateView
                } else {
                    programsListView
                }
            }
        }
        .sheet(isPresented: $showingCreateProgram) {
            CreateProgramView(programsViewModel: programsViewModel)
        }
        .alert("Delete Program", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                withAnimation {
                    if let program = programToDelete {
                        let success = programsViewModel.deleteProgram(program)
                        if !success {
                            showingDeleteError = true
                        }
                    }
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            if let program = programToDelete {
                if !program.isCustom {
                    Text("This is a default program. You cannot delete all default programs. At least one must remain.")
                } else {
                    Text("Are you sure you want to delete \"\(program.name)\"? This action cannot be undone.")
                }
            } else {
                Text("Are you sure you want to delete this program?")
            }
        }
        .alert("Cannot Delete", isPresented: $showingDeleteError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You cannot delete all default programs. At least one default program must remain in the app.")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Breathing Programs")
                .font(.playfairDisplay(size: 28, weight: .bold))
                .foregroundColor(AppColors.darkText)
            
            Spacer()
            
            Button(action: { showingCreateProgram = true }) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(AppColors.purpleGradient)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var programsListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(programsViewModel.programs) { program in
                    ProgramCardView(
                        program: program,
                        isActive: programsViewModel.activeProgram?.id == program.id,
                        onTap: {
                            programsViewModel.setActiveProgram(program)
                        },
                        onDelete: {
                            programToDelete = program
                            showingDeleteAlert = true
                        }
                    )
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        if program.isCustom {
                            Button(role: .destructive) {
                                programToDelete = program
                                showingDeleteAlert = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
            .padding(.top, 10)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "list.bullet")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryPurple.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("No Programs Yet")
                    .font(.playfairDisplay(size: 24, weight: .semibold))
                    .foregroundColor(AppColors.darkText)
                
                Text("Create your first breathing program to get started")
                    .font(.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(AppColors.mediumText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingCreateProgram = true }) {
                Text("Create First Program")
                    .font(.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 48)
                    .background(AppColors.purpleGradient)
                    .cornerRadius(24)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct ProgramCardView: View {
    let program: BreathingProgram
    let isActive: Bool
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                VStack {
                    Circle()
                        .fill(isActive ? AppColors.yellowAccent : AppColors.lightGray)
                        .frame(width: 12, height: 12)
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top) {
                        Text(program.name)
                            .font(.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(AppColors.darkText)
                        
                        Spacer()
                        
                        if !program.isCustom {
                            Text("Default")
                                .font(.playfairDisplay(size: 12, weight: .medium))
                                .foregroundColor(AppColors.primaryPurple)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(AppColors.lightPurple)
                                .cornerRadius(8)
                        } else {
                            Button(action: {
                                onDelete()
                            }) {
                                Image(systemName: "trash")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.red)
                                    .frame(width: 28, height: 28)
                                    .background(Color.red.opacity(0.1))
                                    .clipShape(Circle())
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    Text(program.phaseDescription)
                        .font(.playfairDisplay(size: 14, weight: .regular))
                        .foregroundColor(AppColors.mediumText)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Label("\(program.cycleCount) cycles", systemImage: "repeat")
                        Spacer()
                        Label(program.formattedDuration, systemImage: "clock")
                    }
                    .font(.playfairDisplay(size: 12, weight: .medium))
                    .foregroundColor(AppColors.lightText)
                }
                
                Spacer()
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .shadow(
                        color: isActive ? AppColors.primaryPurple.opacity(0.3) : AppColors.darkText.opacity(0.1),
                        radius: isActive ? 15 : 5,
                        x: 0,
                        y: isActive ? 8 : 2
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isActive ? AppColors.primaryPurple : Color.clear,
                        lineWidth: 2
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .contextMenu {
            if program.isCustom {
                Button(role: .destructive, action: onDelete) {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }
}

#Preview {
    ProgramsView(programsViewModel: ProgramsViewModel())
}
