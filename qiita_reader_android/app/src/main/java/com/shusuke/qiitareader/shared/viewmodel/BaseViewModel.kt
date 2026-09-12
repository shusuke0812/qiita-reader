package com.shusuke.qiitareader.shared.viewmodel

import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.StateFlow

/**
 * UiStateとActionの宣言を型引数で必須にするための基底クラス
 * 不要な場合は[NoState]/[NoAction]を型引数に指定する
 */
abstract class BaseViewModel<UiState, Action> : ViewModel() {
    abstract val uiState: StateFlow<UiState>
    abstract fun onAction(action: Action)
}

object NoState

object NoAction
