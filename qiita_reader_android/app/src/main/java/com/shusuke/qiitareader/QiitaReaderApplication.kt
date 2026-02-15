package com.shusuke.qiitareader

import android.app.Application
import com.shusuke.qiitareader.di.dataModule
import com.shusuke.qiitareader.di.domainModule
import com.shusuke.qiitareader.di.presentationModule
import com.shusuke.qiitareader.shared.config.Env
import io.sentry.android.core.SentryAndroid
import org.koin.android.ext.koin.androidContext
import org.koin.core.context.startKoin

class QiitaReaderApplication : Application() {

    override fun onCreate() {
        super.onCreate()
        val sentryDsn = Env.Qiita.sentryDns
        if (sentryDsn.isNotBlank()) {
            SentryAndroid.init(this) { options ->
                options.dsn = sentryDsn
            }
        }
        startKoin {
            androidContext(this@QiitaReaderApplication)
            modules(dataModule, domainModule, presentationModule)
        }
    }
}
