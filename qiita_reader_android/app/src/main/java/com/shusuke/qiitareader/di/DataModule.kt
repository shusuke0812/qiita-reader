package com.shusuke.qiitareader.di

import com.shusuke.qiitareader.data.infrastructure.qiitaapi.QiitaApiClient
import com.shusuke.qiitareader.data.infrastructure.qiitaapi.QiitaApiService
import com.shusuke.qiitareader.data.repository.items.ItemsRepository
import com.shusuke.qiitareader.data.repository.items.ItemsRepositoryImpl
import org.koin.dsl.module

val dataModule = module {

    single<QiitaApiService> { QiitaApiClient.qiitaApiService }

    single<ItemsRepository> { ItemsRepositoryImpl(get()) }
}
