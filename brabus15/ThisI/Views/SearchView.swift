import SwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel: DecisionViewModel
    @State private var selectedDecisionId: UUID?
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Search")
                        .font(DesignSystem.Typography.largeTitle)
                        .foregroundColor(DesignSystem.Colors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(DesignSystem.Colors.yellow)
                    
                    TextField("Enter word or phrase to search", text: $viewModel.searchText)
                        .font(DesignSystem.Typography.body)
                        .foregroundColor(DesignSystem.Colors.primaryText)
                        .focused($isSearchFocused)
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    if !viewModel.searchText.isEmpty {
                        Button(action: {
                            viewModel.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(DesignSystem.Colors.secondaryText)
                        }
                    }
                }
                .padding(DesignSystem.Spacing.md)
                .background(DesignSystem.Colors.cardBackground)
                .cornerRadius(DesignSystem.CornerRadius.medium)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                        .stroke(DesignSystem.Colors.yellow.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal, DesignSystem.Spacing.lg)
                .padding(.vertical, 10)
                
                if viewModel.searchText.isEmpty {
                    VStack(spacing: DesignSystem.Spacing.lg) {
                        Spacer()
                        
                        Image(systemName: "magnifyingglass.circle")
                            .font(.system(size: 60))
                            .foregroundColor(DesignSystem.Colors.yellow.opacity(0.7))
                        
                        Text("Enter word or phrase to search")
                            .font(DesignSystem.Typography.body)
                            .foregroundColor(DesignSystem.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                } else if viewModel.filteredDecisions.isEmpty {
                    VStack(spacing: DesignSystem.Spacing.lg) {
                        Spacer()
                        
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(DesignSystem.Colors.yellow.opacity(0.7))
                        
                        Text("No matches found")
                            .font(DesignSystem.Typography.body)
                            .foregroundColor(DesignSystem.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                        
                        Text("Try different keywords or check your spelling")
                            .font(DesignSystem.Typography.callout)
                            .foregroundColor(DesignSystem.Colors.placeholderText)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: DesignSystem.Spacing.md) {
                            ForEach(viewModel.filteredDecisions) { decision in
                                SearchResultRowView(
                                    decision: decision,
                                    searchText: viewModel.searchText
                                ) {
                                    selectedDecisionId = decision.id
                                }
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.lg)
                        .padding(.vertical, DesignSystem.Spacing.lg)
                    }
                }
            }
        }
        .sheet(item: Binding(
            get: { selectedDecisionId.map { IdentifiableUUID(id: $0) } },
            set: { selectedDecisionId = $0?.id }
        )) { item in
            DecisionDetailView(decisionId: item.id)
                .environmentObject(viewModel)
        }
        .onTapGesture {
            isSearchFocused = false
        }
    }
}

struct SearchResultRowView: View {
    let decision: Decision
    let searchText: String
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                HStack {
                    Text(decision.formattedDate)
                        .font(DesignSystem.Typography.caption)
                        .foregroundColor(DesignSystem.Colors.yellow)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.right")
                        .font(.caption)
                        .foregroundColor(DesignSystem.Colors.secondaryText)
                }
                
                HighlightedText(
                    text: decision.situation,
                    searchText: searchText,
                    font: DesignSystem.Typography.body,
                    primaryColor: DesignSystem.Colors.primaryText,
                    highlightColor: DesignSystem.Colors.yellow
                )
                .lineLimit(3)
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text("Choice:")
                        .font(DesignSystem.Typography.caption)
                        .foregroundColor(DesignSystem.Colors.secondaryText)
                    
                    HighlightedText(
                        text: decision.chosenOption,
                        searchText: searchText,
                        font: DesignSystem.Typography.callout,
                        primaryColor: DesignSystem.Colors.secondaryText,
                        highlightColor: DesignSystem.Colors.yellow
                    )
                    .lineLimit(2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.cardBackground)
            .cornerRadius(DesignSystem.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                    .stroke(DesignSystem.Colors.yellow.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HighlightedText: View {
    let text: String
    let searchText: String
    let font: Font
    let primaryColor: Color
    let highlightColor: Color
    
    var body: some View {
        if searchText.isEmpty {
            Text(text)
                .font(font)
                .foregroundColor(primaryColor)
        } else {
            let parts = text.components(separatedBy: searchText)
            let highlightedText = parts.joined(separator: "|||HIGHLIGHT|||")
            
            Text(attributedString(from: highlightedText))
        }
    }
    
    private func attributedString(from text: String) -> AttributedString {
        var attributedString = AttributedString(text)
        
        let highlightedText = text.replacingOccurrences(of: "|||HIGHLIGHT|||", with: searchText)
        attributedString = AttributedString(highlightedText)
        
        let searchRange = highlightedText.range(of: searchText, options: .caseInsensitive)
        if let range = searchRange {
            let nsRange = NSRange(range, in: highlightedText)
            if let attributedRange = Range(nsRange, in: attributedString) {
                attributedString[attributedRange].backgroundColor = highlightColor.opacity(0.3)
                attributedString[attributedRange].foregroundColor = highlightColor
            }
        }
        
        attributedString.font = font
        attributedString.foregroundColor = primaryColor
        
        return attributedString
    }
}

#Preview {
    SearchView()
        .environmentObject(DecisionViewModel())
}
