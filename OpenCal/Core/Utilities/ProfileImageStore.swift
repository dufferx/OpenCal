import Foundation

struct ProfileImageStore {

    static let shared = ProfileImageStore()
    private init() {}

    private var fileURL: URL? {
        FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("profile_image.jpg")
    }

    func save(_ data: Data) async {
        guard let url = fileURL else { return }
        await Task.detached(priority: .utility) {
            do {
                let directory = url.deletingLastPathComponent()
                try FileManager.default.createDirectory(
                    at: directory,
                    withIntermediateDirectories: true
                )
                try data.write(to: url, options: .atomic)
            } catch {
                // Non-fatal — image simply won't persist this session
            }
        }.value
    }

    func load() async -> Data? {
        guard let url = fileURL else { return nil }
        return await Task.detached(priority: .utility) {
            try? Data(contentsOf: url)
        }.value
    }
}
