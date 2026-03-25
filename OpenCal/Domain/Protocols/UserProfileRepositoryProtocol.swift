import Foundation

protocol UserProfileRepositoryProtocol {
    func saveProfile(_ profile: UserProfile) async
    func loadProfile() async -> UserProfile?
    func saveProfileImage(_ data: Data) async
    func loadProfileImage() async -> Data?
}
