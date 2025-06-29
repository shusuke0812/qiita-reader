package com.shusuke.qiitareader.shared.config

import com.shusuke.qiitareader.BuildConfig

object Env {
    private const val FLAVOR_NAME = BuildConfig.FLAVOR

    enum class Flavor {
        PROD,
        STAGING
    }

    val flavor: Flavor
        get() = when (FLAVOR_NAME.lowercase()) {
            "prod" -> Flavor.PROD
            "staging" -> Flavor.STAGING
            else -> throw  IllegalArgumentException("Unknown flavor: $FLAVOR_NAME")
        }

    object Qiita {
        val clientId: String
            get() = when(flavor) {
                Flavor.PROD -> BuildConfig.QIITA_CLIENT_ID
                Flavor.STAGING -> BuildConfig.STG_QIITA_CLIENT_ID
            }

        val clientSecret: String
            get() = when(flavor) {
                Flavor.PROD -> BuildConfig.QIITA_CLIENT_SECRET
                Flavor.STAGING -> BuildConfig.STG_QIITA_CLIENT_SECRET
            }

        val scope: String
            get() = "read_qiita write_qiita"

        val accessTokenStorageKey: String
            get() = when(flavor) {
                Flavor.PROD -> BuildConfig.ACCESS_TOKEN_STORAGE_KEY
                Flavor.STAGING -> BuildConfig.STG_ACCESS_TOKEN_STORAGE_KEY
            }
    }
}