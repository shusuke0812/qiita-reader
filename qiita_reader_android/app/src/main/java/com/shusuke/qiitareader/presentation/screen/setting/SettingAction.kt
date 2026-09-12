package com.shusuke.qiitareader.presentation.screen.setting

sealed class SettingAction {
    data class LanguageSelected(val language: AppLanguage) : SettingAction()
}
