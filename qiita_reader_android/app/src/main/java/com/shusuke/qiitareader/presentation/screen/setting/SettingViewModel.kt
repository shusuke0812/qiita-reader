package com.shusuke.qiitareader.presentation.screen.setting

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.shusuke.qiitareader.data.repository.language.LanguageRepository
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.stateIn

class SettingViewModel(
    private val languageRepository: LanguageRepository
) : ViewModel() {

    val uiState: StateFlow<SettingUiState> = languageRepository.currentLanguage
        .map { SettingUiState(selectedLanguage = it) }
        .stateIn(
            scope = viewModelScope,
            started = SharingStarted.Eagerly,
            initialValue = SettingUiState()
        )

    fun setLanguage(language: AppLanguage) {
        languageRepository.setLanguage(language)
    }
}
