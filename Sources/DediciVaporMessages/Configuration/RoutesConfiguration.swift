//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import DediciVaporToolbox
import Vapor

internal struct RoutesConfiguration: AppConfiguration {
    func configure(_ application: Application) throws {
        let collections: [RouteCollection] = [
            MessagesController(),
        ]

        try collections.forEach(application.register(collection:))
    }
}
