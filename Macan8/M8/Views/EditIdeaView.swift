import SwiftUI

struct EditIdeaView: View {
    let idea: NailIdea
    @ObservedObject var viewModel: NailIdeasViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var mainColor: String
    @State private var additionalColors: String
    @State private var selectedDesignType: DesignType
    @State private var selectedSeasonEvent: SeasonEvent
    @State private var comment: String
    @State private var selectedStatus: IdeaStatus
    
    init(idea: NailIdea, viewModel: NailIdeasViewModel) {
        self.idea = idea
        self.viewModel = viewModel
        
        _name = State(initialValue: idea.name)
        _mainColor = State(initialValue: idea.mainColor)
        _additionalColors = State(initialValue: idea.additionalColors)
        _selectedDesignType = State(initialValue: idea.designType)
        _selectedSeasonEvent = State(initialValue: idea.seasonEvent)
        _comment = State(initialValue: idea.comment)
        _selectedStatus = State(initialValue: idea.status)
    }
    
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var hasChanges: Bool {
        name != idea.name ||
        mainColor != idea.mainColor ||
        additionalColors != idea.additionalColors ||
        selectedDesignType != idea.designType ||
        selectedSeasonEvent != idea.seasonEvent ||
        comment != idea.comment ||
        selectedStatus != idea.status
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Idea Name *")
                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter idea name", text: $name)
                                .font(FontManager.playfairDisplay(size: 16))
                                .foregroundColor(AppColors.primaryText)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(AppColors.cardBorder, lineWidth: 1)
                                        )
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Main Color")
                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("e.g., Powder pink, Beige with glitter", text: $mainColor)
                                .font(FontManager.playfairDisplay(size: 16))
                                .foregroundColor(AppColors.primaryText)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(AppColors.cardBorder, lineWidth: 1)
                                        )
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Additional Colors")
                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("e.g., White, gold accents", text: $additionalColors, axis: .vertical)
                                .font(FontManager.playfairDisplay(size: 16))
                                .foregroundColor(AppColors.primaryText)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(AppColors.cardBorder, lineWidth: 1)
                                        )
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Design Type")
                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Picker("Design Type", selection: $selectedDesignType) {
                                ForEach(DesignType.allCases, id: \.self) { type in
                                    Text(type.rawValue)
                                        .tag(type)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .foregroundColor(AppColors.primaryText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.cardBorder, lineWidth: 1)
                                    )
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Season / Event")
                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Picker("Season / Event", selection: $selectedSeasonEvent) {
                                ForEach(SeasonEvent.allCases, id: \.self) { event in
                                    Text(event.rawValue)
                                        .tag(event)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .foregroundColor(AppColors.primaryText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.cardBorder, lineWidth: 1)
                                    )
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment")
                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Add matte top coat, avoid rhinestones", text: $comment, axis: .vertical)
                                .font(FontManager.playfairDisplay(size: 16))
                                .foregroundColor(AppColors.primaryText)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(AppColors.cardBorder, lineWidth: 1)
                                        )
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Status")
                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            HStack(spacing: 12) {
                                ForEach(IdeaStatus.allCases, id: \.self) { status in
                                    Button(action: {
                                        selectedStatus = status
                                    }) {
                                        HStack(spacing: 6) {
                                            Image(systemName: status.icon)
                                                .font(.system(size: 14))
                                            Text(status.rawValue)
                                                .font(FontManager.playfairDisplay(size: 14, weight: .medium))
                                        }
                                        .foregroundColor(selectedStatus == status ? AppColors.primaryBlue : AppColors.primaryText)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(selectedStatus == status ? AppColors.accentYellow : AppColors.cardBackground)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(selectedStatus == status ? AppColors.accentYellow : AppColors.cardBorder, lineWidth: 1)
                                                )
                                        )
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
            .navigationTitle("Edit Idea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save Changes") {
                        saveChanges()
                    }
                    .foregroundColor(isFormValid && hasChanges ? AppColors.accentYellow : AppColors.secondaryText)
                    .disabled(!isFormValid || !hasChanges)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private func saveChanges() {
        var updatedIdea = idea
        updatedIdea.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedIdea.mainColor = mainColor.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedIdea.additionalColors = additionalColors.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedIdea.designType = selectedDesignType
        updatedIdea.seasonEvent = selectedSeasonEvent
        updatedIdea.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedIdea.status = selectedStatus
        
        viewModel.updateIdea(updatedIdea)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditIdeaView(
        idea: NailIdea(
            name: "Golden Autumn",
            mainColor: "Warm golden",
            additionalColors: "Beige, orange",
            designType: .gradient,
            seasonEvent: .autumn,
            comment: "Add glossy top coat"
        ),
        viewModel: NailIdeasViewModel()
    )
}
