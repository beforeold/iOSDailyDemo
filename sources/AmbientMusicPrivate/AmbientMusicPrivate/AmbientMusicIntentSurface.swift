import Foundation

struct AmbientMusicIntentSurface: Equatable {
    var moods: [Mood]
    var actions: [Action]
    var queries: [String]
    var autoShortcutCount: Int
    var notes: [String]

    struct Mood: Identifiable, Equatable {
        var id: String
        var titleKey: String
        var title: String
        var configurationIntent: String?
        var isPublicScene: Bool
    }

    struct Action: Identifiable, Equatable {
        var id: String
        var titleKey: String
        var title: String
        var openAppWhenRun: Bool
        var supportedModes: Int?
        var parameters: [Parameter]
    }

    struct Parameter: Identifiable, Equatable {
        var id: String { name }
        var name: String
        var titleKey: String
        var title: String
        var typeDescription: String
        var isOptional: Bool
        var hasDynamicOptions: Bool
    }
}

enum AmbientMusicIntentSurfaceAnalyzer {
    private static let frameworkPath = "/System/Library/PrivateFrameworks/AdaptiveMusic.framework"
    private static let metadataPath = frameworkPath + "/Metadata.appintents/extract.actionsdata"

    static func analyze() throws -> AmbientMusicIntentSurface {
        let data: Data
        do {
            data = try Data(contentsOf: URL(fileURLWithPath: metadataPath))
        } catch {
            return fallbackSurface(readError: error)
        }

        guard let root = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw AnalyzerError.invalidMetadata
        }

        let bundle = Bundle(path: frameworkPath)
        let actions = parseActions(from: root, bundle: bundle)
        let moods = parseMoods(from: root, bundle: bundle)
        let queries = ((root["queries"] as? [String: Any]) ?? [:]).keys.sorted()
        let autoShortcutCount = (root["autoShortcuts"] as? [Any])?.count ?? 0
        let actionNames = Set(actions.map(\.id))

        let notes = baselineNotes(
            autoShortcutCount: autoShortcutCount,
            actionNames: actionNames,
            queries: queries
        )

        return AmbientMusicIntentSurface(
            moods: moods,
            actions: actions,
            queries: queries,
            autoShortcutCount: autoShortcutCount,
            notes: notes
        )
    }

    private static func fallbackSurface(readError: Error) -> AmbientMusicIntentSurface {
        let moods = [
            fallbackMood(
                id: "productivity",
                titleKey: "PRODUCTIVITY_NAME",
                title: "Productivity",
                configurationIntent: "SelectProductivityPlaylistIntent"
            ),
            fallbackMood(
                id: "chill",
                titleKey: "CHILL_NAME",
                title: "Chill",
                configurationIntent: "SelectChillPlaylistIntent"
            ),
            fallbackMood(
                id: "sleep",
                titleKey: "SLEEP_NAME",
                title: "Sleep",
                configurationIntent: "SelectSleepPlaylistIntent"
            ),
            fallbackMood(
                id: "wellbeing",
                titleKey: "WELLBEING_NAME",
                title: "Wellbeing",
                configurationIntent: "SelectWellbeingPlaylistIntent"
            ),
            fallbackMood(
                id: "custom",
                titleKey: "CUSTOM_NAME",
                title: "Custom",
                configurationIntent: nil,
                isPublicScene: false
            )
        ]

        let actions = [
            fallbackAction(
                id: "MultipleMoodsWidgetConfigurationIntent",
                titleKey: "CONFIGURE_MULTIPLE_MOODS",
                title: "Configure Multiple Moods",
                parameters: [
                    fallbackParameter(name: "sleepPlaylist"),
                    fallbackParameter(name: "chillPlaylist"),
                    fallbackParameter(name: "productivityPlaylist"),
                    fallbackParameter(name: "wellbeingPlaylist")
                ]
            ),
            fallbackAction(
                id: "SelectChillPlaylistIntent",
                titleKey: "SELECT_CHILL_PLAYLIST",
                title: "Select Chill Playlist",
                parameters: [fallbackParameter(name: "selectedPlaylist")]
            ),
            fallbackAction(
                id: "SelectProductivityPlaylistIntent",
                titleKey: "SELECT_PRODUCTIVITY_PLAYLIST",
                title: "Select Productivity Playlist",
                parameters: [fallbackParameter(name: "selectedPlaylist")]
            ),
            fallbackAction(
                id: "SelectSleepPlaylistIntent",
                titleKey: "SELECT_SLEEP_PLAYLIST",
                title: "Select Sleep Playlist",
                parameters: [fallbackParameter(name: "selectedPlaylist")]
            ),
            fallbackAction(
                id: "SelectWellbeingPlaylistIntent",
                titleKey: "SELECT_WELLBEING_PLAYLIST",
                title: "Select Wellbeing Playlist",
                parameters: [fallbackParameter(name: "selectedPlaylist")]
            ),
            fallbackAction(
                id: "SingleMoodWidgetConfigurationIntent",
                titleKey: "CONFIGURE_SINGLE_MOOD",
                title: "Configure Single Mood",
                parameters: [
                    AmbientMusicIntentSurface.Parameter(
                        name: "moodID",
                        titleKey: "MOOD",
                        title: "Mood",
                        typeDescription: "Enum.Mood.ID",
                        isOptional: true,
                        hasDynamicOptions: false
                    ),
                    fallbackParameter(name: "playlist")
                ]
            ),
            fallbackAction(
                id: "ToggleMusicIntent",
                titleKey: "TOGGLE_MUSIC",
                title: "Toggle Music",
                parameters: [
                    AmbientMusicIntentSurface.Parameter(
                        name: "value",
                        titleKey: "VALUE",
                        title: "Value",
                        typeDescription: "Bool",
                        isOptional: false,
                        hasDynamicOptions: false
                    ),
                    fallbackParameter(name: "playlist")
                ]
            )
        ]

        let queries = ["SuggestedPlaylistQuery"]
        let notes = [
            "Runtime metadata file is not readable in this process; showing the iOS 26.4 extracted signature instead. \(readError.localizedDescription)"
        ] + baselineNotes(
            autoShortcutCount: 0,
            actionNames: Set(actions.map(\.id)),
            queries: queries
        )

        return AmbientMusicIntentSurface(
            moods: moods,
            actions: actions,
            queries: queries,
            autoShortcutCount: 0,
            notes: notes
        )
    }

    private static func fallbackMood(
        id: String,
        titleKey: String,
        title: String,
        configurationIntent: String?,
        isPublicScene: Bool = true
    ) -> AmbientMusicIntentSurface.Mood {
        AmbientMusicIntentSurface.Mood(
            id: id,
            titleKey: titleKey,
            title: title,
            configurationIntent: configurationIntent,
            isPublicScene: isPublicScene
        )
    }

    private static func fallbackAction(
        id: String,
        titleKey: String,
        title: String,
        parameters: [AmbientMusicIntentSurface.Parameter]
    ) -> AmbientMusicIntentSurface.Action {
        AmbientMusicIntentSurface.Action(
            id: id,
            titleKey: titleKey,
            title: title,
            openAppWhenRun: false,
            supportedModes: 1,
            parameters: parameters
        )
    }

    private static func fallbackParameter(name: String) -> AmbientMusicIntentSurface.Parameter {
        AmbientMusicIntentSurface.Parameter(
            name: name,
            titleKey: name,
            title: readableName(name),
            typeDescription: "Playlist",
            isOptional: true,
            hasDynamicOptions: true
        )
    }

    private static func baselineNotes(
        autoShortcutCount: Int,
        actionNames: Set<String>,
        queries: [String]
    ) -> [String] {
        var notes: [String] = []
        if autoShortcutCount == 0 {
            notes.append("No App Shortcuts are exported, so Shortcuts/Siri cannot discover a direct Ambient Music action.")
        }
        if actionNames.contains("ToggleMusicIntent") {
            notes.append("ToggleMusicIntent is the playback intent, but it needs an internal Playlist entity.")
        }
        if actionNames.contains("SelectSleepPlaylistIntent") {
            notes.append("Select*PlaylistIntent entries configure Widget/Control playlists; they are not direct play actions.")
        }
        if queries.contains("SuggestedPlaylistQuery") {
            notes.append("SuggestedPlaylistQuery is the likely source for internal Playlist entities.")
        }
        return notes
    }

    private static func parseActions(
        from root: [String: Any],
        bundle: Bundle?
    ) -> [AmbientMusicIntentSurface.Action] {
        let rawActions = root["actions"] as? [String: Any] ?? [:]

        return rawActions.keys.sorted().compactMap { key in
            guard let rawAction = rawActions[key] as? [String: Any] else { return nil }
            let titleKey = localizedKey(from: rawAction["title"])
            let parameters = (rawAction["parameters"] as? [[String: Any]] ?? []).compactMap {
                parseParameter(from: $0, bundle: bundle)
            }

            return AmbientMusicIntentSurface.Action(
                id: key,
                titleKey: titleKey,
                title: localizedString(for: titleKey, fallback: readableName(key), bundle: bundle),
                openAppWhenRun: rawAction["openAppWhenRun"] as? Bool ?? false,
                supportedModes: rawAction["supportedModes"] as? Int,
                parameters: parameters
            )
        }
    }

    private static func parseParameter(
        from rawParameter: [String: Any],
        bundle: Bundle?
    ) -> AmbientMusicIntentSurface.Parameter? {
        guard let name = rawParameter["name"] as? String else { return nil }

        let titleKey = localizedKey(from: rawParameter["title"])
        let dynamicOptions = (rawParameter["dynamicOptionsSupport"] as? Int ?? 0) != 0

        return AmbientMusicIntentSurface.Parameter(
            name: name,
            titleKey: titleKey,
            title: localizedString(for: titleKey, fallback: readableName(name), bundle: bundle),
            typeDescription: valueTypeDescription(rawParameter["valueType"]),
            isOptional: rawParameter["isOptional"] as? Bool ?? false,
            hasDynamicOptions: dynamicOptions
        )
    }

    private static func parseMoods(
        from root: [String: Any],
        bundle: Bundle?
    ) -> [AmbientMusicIntentSurface.Mood] {
        let rawEnums = root["enums"] as? [[String: Any]] ?? []
        let moodEnum = rawEnums.first {
            $0["fullyQualifiedTypeName"] as? String == "AdaptiveMusic.Mood.ID"
        }
        let rawCases = moodEnum?["cases"] as? [[String: Any]] ?? []

        return rawCases.compactMap { rawCase in
            guard let id = rawCase["identifier"] as? String else { return nil }
            let display = rawCase["displayRepresentation"] as? [String: Any]
            let titleKey = localizedKey(from: display?["title"])

            return AmbientMusicIntentSurface.Mood(
                id: id,
                titleKey: titleKey,
                title: localizedString(for: titleKey, fallback: readableName(id), bundle: bundle),
                configurationIntent: configurationIntent(for: id),
                isPublicScene: id != "custom"
            )
        }
    }

    private static func configurationIntent(for moodID: String) -> String? {
        switch moodID {
        case "sleep":
            "SelectSleepPlaylistIntent"
        case "chill":
            "SelectChillPlaylistIntent"
        case "productivity":
            "SelectProductivityPlaylistIntent"
        case "wellbeing":
            "SelectWellbeingPlaylistIntent"
        default:
            nil
        }
    }

    private static func localizedKey(from value: Any?) -> String {
        (value as? [String: Any])?["key"] as? String ?? ""
    }

    private static func localizedString(
        for key: String,
        fallback: String,
        bundle: Bundle?
    ) -> String {
        guard !key.isEmpty else { return fallback }
        guard let bundle else { return fallback }

        let localized = bundle.localizedString(forKey: key, value: fallback, table: nil)
        return localized == key ? fallback : localized
    }

    private static func valueTypeDescription(_ value: Any?) -> String {
        guard let dictionary = value as? [String: Any] else { return "Unknown" }

        if let primitive = dictionary["primitive"] as? [String: Any],
           let wrapper = primitive["wrapper"] as? [String: Any] {
            switch wrapper["typeIdentifier"] as? Int {
            case 1:
                return "Bool"
            default:
                return "Primitive"
            }
        }

        if let entity = dictionary["entity"] as? [String: Any],
           let wrapper = entity["wrapper"] as? [String: Any],
           let typeName = wrapper["typeName"] as? String {
            return typeName
        }

        if let enumeration = dictionary["linkEnumeration"] as? [String: Any],
           let wrapper = enumeration["wrapper"] as? [String: Any],
           let identifier = wrapper["identifier"] as? String {
            return "Enum.\(identifier)"
        }

        return "Unknown"
    }

    private static func readableName(_ value: String) -> String {
        let spaced = value
            .replacingOccurrences(of: "Intent", with: " Intent")
            .replacingOccurrences(of: "Playlist", with: " Playlist")
        return spaced.prefix(1).uppercased() + spaced.dropFirst()
    }

    enum AnalyzerError: LocalizedError {
        case invalidMetadata

        var errorDescription: String? {
            switch self {
            case .invalidMetadata:
                "AdaptiveMusic metadata is not a JSON object."
            }
        }
    }
}
