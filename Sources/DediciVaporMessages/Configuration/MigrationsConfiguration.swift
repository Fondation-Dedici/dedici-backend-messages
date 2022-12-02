//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import FluentMySQLDriver
import Foundation
import DediciVaporToolbox
import Vapor

internal struct MigrationsConfiguration: AppConfiguration {
    func configure(_ application: Application) throws {
        let migrations: [Migration] = [
            MessagesCreate(),
        ]

        migrations.forEach { application.migrations.add($0) }
    }
}
