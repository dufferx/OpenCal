import SwiftUI

struct ProfileView: View {
    var body: some View {
        Text("Profile")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
