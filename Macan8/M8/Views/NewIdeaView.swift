import SwiftUI

struct NewIdeaView: View {
    @ObservedObject var viewModel: NailIdeasViewModel
    @Binding var selectedTab: Int
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var mainColor = ""
    @State private var additionalColors = ""
    @State private var selectedDesignType = DesignType.minimalism
    @State private var selectedSeasonEvent = SeasonEvent.spring
    @State private var comment = ""
    @State private var selectedStatus = IdeaStatus.inspiration
    
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("New Idea")
                        .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button("Save") {
                        saveIdea()
                    }
                    .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(isFormValid ? AppColors.accentYellow : AppColors.secondaryText)
                    .disabled(!isFormValid)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
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
                                        .foregroundColor(.white)
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
                                        .foregroundColor(.white)
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
                    .padding(.bottom ,120)
                }
            }
        }
    }
    
    private func saveIdea() {
        let newIdea = NailIdea(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            mainColor: mainColor.trimmingCharacters(in: .whitespacesAndNewlines),
            additionalColors: additionalColors.trimmingCharacters(in: .whitespacesAndNewlines),
            designType: selectedDesignType,
            seasonEvent: selectedSeasonEvent,
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines),
            status: selectedStatus
        )
        
        viewModel.addIdea(newIdea)
        presentationMode.wrappedValue.dismiss()
        
        withAnimation {
            selectedTab = 0
        }
    }
}
