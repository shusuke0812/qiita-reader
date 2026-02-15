package com.shusuke.qiitareader.di

import com.shusuke.qiitareader.domain.reporterror.ReportErrorUseCase
import com.shusuke.qiitareader.domain.reporterror.ReportErrorUseCaseImpl
import com.shusuke.qiitareader.domain.searcharticles.SearchArticlesUseCase
import com.shusuke.qiitareader.domain.searcharticles.SearchArticlesUseCaseImpl
import org.koin.dsl.module

val domainModule = module {

    factory<SearchArticlesUseCase> { SearchArticlesUseCaseImpl(get()) }
    factory<ReportErrorUseCase> { ReportErrorUseCaseImpl(get()) }
}
