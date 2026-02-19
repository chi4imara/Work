import SwiftUI

struct LookDetailView: View {
    @EnvironmentObject var viewModel: MakeupLookViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let lookId: UUID
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var look: MakeupLook? {
        viewModel.getLook(by: lookId)
    }
    
    var body: some View {
        Group {
            if let look = look {
                detailContent(for: look)
            } else {
                errorView
            }
        }
    }
    
    private func detailContent(for look: MakeupLook) -> some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        headerSection(for: look)
                        colorPaletteSection(for: look)
                        stepsSection(for: look)
                        productsSection(for: look)
                        notesSection(for: look)
                        actionButtons
                    }
                }
            }
            .navigationTitle("Look Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            AddEditLookView(isPresented: $showingEditView, lookToEdit: look)
                .environmentObject(viewModel)
        }
        .alert("Delete Look", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteMakeupLook(by: lookId)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete \"\(look.name)\"? This action cannot be undone.")
        }
    }
    
    private func headerSection(for look: MakeupLook) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(look.name)
                        .font(.playfairDisplay(28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    HStack(spacing: 8) {
                        Image(systemName: look.category.icon)
                            .foregroundColor(AppColors.primaryBlue)
                        Text(look.category.displayName)
                            .font(.playfairDisplay(16, weight: .medium))
                            .foregroundColor(AppColors.primaryBlue)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.toggleFavorite(by: lookId)
                }) {
                    Image(systemName: look.isFavorite ? "star.fill" : "star")
                        .foregroundColor(look.isFavorite ? AppColors.primaryYellow : AppColors.secondaryText)
                        .font(.title2)
                }
            }
            
            Text("Created on \(look.dateCreated, style: .date)")
                .font(.playfairDisplay(14))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func colorPaletteSection(for look: MakeupLook) -> some View {
        if !look.colors.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Color Palette")
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                    .padding(.horizontal, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(look.colors, id: \.self) { colorHex in
                            colorCircle(colorHex: colorHex)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
    
    private func colorCircle(colorHex: String) -> some View {
        VStack(spacing: 6) {
            Circle()
                .fill(ColorPalette.colorFromHex(colorHex))
                .frame(width: 50, height: 50)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
            
            Text(colorHex)
                .font(.playfairDisplay(10, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
        }
    }
    
    @ViewBuilder
    private func stepsSection(for look: MakeupLook) -> some View {
        if !look.steps.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Makeup Steps")
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(look.steps.enumerated()), id: \.offset) { index, step in
                        stepRow(index: index, step: step)
                    }
                }
                .padding(16)
                .background(AppColors.backgroundWhite.opacity(0.9))
                .cornerRadius(12)
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func stepRow(index: Int, step: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(index + 1)")
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(AppColors.primaryYellow)
                .frame(width: 24, height: 24)
                .background(Circle().fill(AppColors.primaryYellow.opacity(0.2)))
            
            Text(step)
                .font(.playfairDisplay(16))
                .foregroundColor(AppColors.contrastText)
                .lineLimit(nil)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private func productsSection(for look: MakeupLook) -> some View {
        if !look.products.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Products Used")
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(look.products)
                    .font(.playfairDisplay(16))
                    .foregroundColor(AppColors.contrastText)
                    .lineLimit(nil)
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(AppColors.backgroundWhite.opacity(0.9))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
        }
    }
    
    @ViewBuilder
    private func notesSection(for look: MakeupLook) -> some View {
        if !look.notes.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Notes & Comments")
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(look.notes)
                    .font(.playfairDisplay(16))
                    .foregroundColor(AppColors.contrastText)
                    .lineLimit(nil)
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(AppColors.backgroundWhite.opacity(0.9))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: { showingEditView = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "pencil")
                    Text("Edit Look")
                }
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(AppColors.contrastText)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.primaryBlue)
                .cornerRadius(25)
            }
            
            Button(action: { showingDeleteAlert = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "trash")
                    Text("Delete Look")
                }
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.backgroundWhite.opacity(0.9))
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.red.opacity(0.3), lineWidth: 1)
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
    }
    
    private var errorView: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 24) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(AppColors.primaryBlue.opacity(0.6))
                    
                    VStack(spacing: 12) {
                        Text("Look Not Found")
                            .font(.playfairDisplay(24, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("The makeup look you're looking for could not be found. Please return to the main screen and try again.")
                            .font(.playfairDisplay(16))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                            .lineSpacing(2)
                            .padding(.horizontal, 40)
                    }
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Go Back")
                            .font(.playfairDisplay(16, weight: .semibold))
                            .foregroundColor(AppColors.contrastText)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 12)
                            .background(AppColors.primaryBlue)
                            .cornerRadius(25)
                    }
                }
            }
            .navigationTitle("Error")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
        }
    }
}

#Preview {
    let sampleLook = MakeupLook(
        name: "Golden Glow Look",
        category: .evening,
        steps: ["Apply primer", "Bronze eyeshadow", "Highlight cheekbones"],
        colors: ["#FFD700", "#CD853F", "#F4A460"],
        products: "NARS Blush, Urban Decay Eyeshadow",
        notes: "Perfect for evening events",
        isFavorite: true
    )
    let viewModel = MakeupLookViewModel()
    viewModel.addMakeupLook(sampleLook)
    
    return LookDetailView(lookId: sampleLook.id)
        .environmentObject(viewModel)
}
