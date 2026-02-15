package com.shusuke.qiitareader.di

import com.shusuke.qiitareader.presentation.screen.articlesearch.ArticleSearchViewModel
import org.koin.core.module.dsl.viewModelOf
import org.koin.dsl.module

val presentationModule = module {

    viewModelOf(::ArticleSearchViewModel)
}
