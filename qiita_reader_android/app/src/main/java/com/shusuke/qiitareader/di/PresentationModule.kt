package com.shusuke.qiitareader.di

import com.shusuke.qiitareader.presentation.ResourceProvider
import com.shusuke.qiitareader.presentation.screen.articlesearch.ArticleSearchViewModel
import com.shusuke.qiitareader.presentation.screen.setting.SettingViewModel
import org.koin.android.ext.koin.androidContext
import org.koin.core.module.dsl.viewModelOf
import org.koin.dsl.module

val presentationModule = module {

    viewModelOf(::ArticleSearchViewModel)
    viewModelOf(::SettingViewModel)

    single { ResourceProvider(androidContext()) }
}
