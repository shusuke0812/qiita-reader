package com.shusuke.qiitareader

import android.app.Application
import com.shusuke.qiitareader.di.dataModule
import com.shusuke.qiitareader.di.domainModule
import com.shusuke.qiitareader.di.presentationModule
import org.koin.android.ext.koin.androidContext
import org.koin.core.context.startKoin

class QiitaReaderApplication : Application() {

    override fun onCreate() {
        super.onCreate()
        startKoin {
            androidContext(this@QiitaReaderApplication)
            modules(dataModule, domainModule, presentationModule)
        }
    }
}
