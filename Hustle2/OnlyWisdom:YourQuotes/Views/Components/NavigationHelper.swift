import SwiftUI

struct NavigationHelper {
    static func navigateToQuoteDetail(_ quote: Quote, quoteStore: QuoteStore) -> some View {
        QuoteDetailView(quoteStore: quoteStore, quote: quote)
    }
    
    static func navigateToAddQuote(quoteStore: QuoteStore, editingQuote: Quote? = nil) -> some View {
        AddEditQuoteView(quoteStore: quoteStore, editingQuote: editingQuote)
    }
    
    static func navigateToCategoryQuotes(categoryName: String, quoteStore: QuoteStore) -> some View {
        CategoryQuotesView(quoteStore: quoteStore, categoryName: categoryName)
    }
}

struct NavigationDestinationWrapper<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .navigationBarBackButtonHidden(false)
    }
}

struct CustomNavigationLink<Destination: View, Label: View>: View {
    let destination: Destination
    let label: Label
    
    init(destination: Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination
        self.label = label()
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
            label
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SheetPresenter<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content
    
    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }
    
    var body: some View {
        EmptyView()
            .sheet(isPresented: $isPresented) {
                content
            }
    }
}
