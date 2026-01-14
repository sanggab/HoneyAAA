import ProjectDescription

let project = Project(
    name: "HoneyAAA",
    targets: [
        .target(
            name: "HoneyAAA",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.tuist.HoneyAAA",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            buildableFolders: [
                "HoneyAAA/Sources",
                "HoneyAAA/Resources",
            ],
            dependencies: []
        ),
        .target(
            name: "HoneyAAATests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.tuist.HoneyAAATests",
            infoPlist: .default,
            buildableFolders: [
                "HoneyAAA/Tests"
            ],
            dependencies: [.target(name: "HoneyAAA")]
        ),
    ]
)
