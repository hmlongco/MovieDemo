import SwiftUI

struct ProfilePaymentMethodsView: View {
    var body: some View {
        ProfileStubView(title: "Payment Methods", icon: "creditcard")
    }
}

#if DEBUG
#Preview {
    ProfilePaymentMethodsView()
        .preferredColorScheme(.dark)
}
#endif
