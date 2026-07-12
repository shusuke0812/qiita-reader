package com.shusuke.qiitareader.data.repository.language

import com.shusuke.qiitareader.presentation.screen.setting.AppLanguage
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

class LanguageRepository {

    private val _currentLanguage = MutableStateFlow(AppLanguage.JAPANESE)
    val currentLanguage: StateFlow<AppLanguage> = _currentLanguage.asStateFlow()

    fun setLanguage(language: AppLanguage) {
        _currentLanguage.value = language
    }
}
