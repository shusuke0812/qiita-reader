package com.shusuke.qiitareader.presentation.screen.setting

import androidx.lifecycle.viewModelScope
import com.shusuke.qiitareader.data.repository.language.LanguageRepository
import com.shusuke.qiitareader.shared.viewmodel.BaseViewModel
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.stateIn

class SettingViewModel(
    private val languageRepository: LanguageRepository
) : BaseViewModel<SettingUiState, SettingAction>() {

    override val uiState: StateFlow<SettingUiState> = languageRepository.currentLanguage
        .map { SettingUiState(selectedLanguage = it) }
        .stateIn(
            scope = viewModelScope,
            started = SharingStarted.Eagerly,
            initialValue = SettingUiState()
        )

    override fun onAction(action: SettingAction) {
        when (action) {
            is SettingAction.LanguageSelected -> languageRepository.setLanguage(action.language)
        }
    }
}
