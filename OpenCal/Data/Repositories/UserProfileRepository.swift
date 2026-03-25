import Foundation

struct UserProfileRepository: UserProfileRepositoryProtocol {

    private let defaultsKey = "userProfile"
    private let imageStore = ProfileImageStore.shared

    func saveProfile(_ profile: UserProfile) async {
        guard let data = try? JSONEncoder().encode(profile) else { return }
        UserDefaults.standard.set(data, forKey: defaultsKey)
    }

    func loadProfile() async -> UserProfile? {
        guard let data = UserDefaults.standard.data(forKey: defaultsKey),
              let profile = try? JSONDecoder().decode(UserProfile.self, from: data)
        else { return nil }
        return profile
    }

    func saveProfileImage(_ data: Data) async {
        await imageStore.save(data)
    }

    func loadProfileImage() async -> Data? {
        await imageStore.load()
    }
}
