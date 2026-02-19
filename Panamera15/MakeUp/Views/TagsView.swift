import SwiftUI

struct TagsView: View {
    @EnvironmentObject var makeupStore: MakeupStore
    @Binding var selectedTab: TabItem
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if makeupStore.allTags.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    tagsList
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Tags")
                .font(.bauhausBold(28))
                .foregroundColor(AppColors.white)
            
            Spacer()
            
            if makeupStore.selectedTag != nil || !makeupStore.searchText.isEmpty {
                Button(action: {
                    makeupStore.clearSearch()
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = .ideas
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                        Text("Clear Filter")
                            .font(.bauhausMedium(14))
                    }
                    .foregroundColor(AppColors.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.purple.opacity(0.8))
                    )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "tag")
                .font(.system(size: 60))
                .foregroundColor(AppColors.white.opacity(0.6))
            
            Text("No tags added yet.")
                .font(.bauhausMedium(18))
                .foregroundColor(AppColors.white)
                .multilineTextAlignment(.center)
            
            Text("Tags will appear here when you add them to your makeup ideas.")
                .font(.bauhausLight(14))
                .foregroundColor(AppColors.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var tagsList: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 16) {
                ForEach(makeupStore.allTags, id: \.id) { tag in
                    TagCard(tag: tag) {
                        makeupStore.filterByTag(tag.name)
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = .ideas
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120) 
        }
    }
}

struct TagCard: View {
    let tag: Tag
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "tag.fill")
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.purple)
                    
                    Spacer()
                    
                    Text("\(tag.count)")
                        .font(.bauhausBold(16))
                        .foregroundColor(AppColors.purple)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AppColors.purple.opacity(0.1))
                        )
                }
                
                Text(tag.name)
                    .font(.bauhausMedium(18))
                    .foregroundColor(AppColors.darkGray)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                Text(tag.count == 1 ? "1 idea" : "\(tag.count) ideas")
                    .font(.bauhausLight(14))
                    .foregroundColor(AppColors.mediumGray)
                
                Spacer()
            }
            .padding(16)
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .shadow(color: AppColors.darkGray.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TagsView_Previews: PreviewProvider {
    static var previews: some View {
        TagsView(selectedTab: .constant(.tags))
            .environmentObject(MakeupStore())
    }
}
