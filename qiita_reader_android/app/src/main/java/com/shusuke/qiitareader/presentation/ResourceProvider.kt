package com.shusuke.qiitareader.presentation

import android.content.Context
import android.content.res.Configuration
import androidx.annotation.StringRes
import com.shusuke.qiitareader.presentation.screen.setting.AppLanguage

class ResourceProvider(private val context: Context) {

    fun getString(@StringRes resId: Int, language: AppLanguage): String {
        val config = Configuration(context.resources.configuration).apply {
            setLocale(language.toLocale())
        }
        return context.createConfigurationContext(config).getString(resId)
    }
}
