package com.shusuke.qiitareader.presentation

import android.content.Context
import android.content.res.Configuration
import androidx.annotation.StringRes
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import com.shusuke.qiitareader.data.repository.language.LanguageRepository
import com.shusuke.qiitareader.presentation.screen.setting.AppLanguage

class ResourceProvider(
    private val context: Context,
    private val languageRepository: LanguageRepository
) {
    @Composable
    fun getString(@StringRes resId: Int): String {
        val language by languageRepository.currentLanguage.collectAsState()
        return getString(resId, language)
    }

    fun getString(@StringRes resId: Int, language: AppLanguage): String {
        val config = Configuration(context.resources.configuration).apply {
            setLocale(language.toLocale())
        }
        return context.createConfigurationContext(config).getString(resId)
    }
}
