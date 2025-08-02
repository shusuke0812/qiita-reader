package com.shusuke.qiitareader.presentation

sealed class UiState<out Success, out Failure : Throwable> {
    data object Standby : UiState<Nothing, Nothing>()
    data object Loading : UiState<Nothing, Nothing>()
    data class Success<out T>(val data: T) : UiState<T, Nothing>()
    data class Failure<out E : Throwable>(val error: E) : UiState<Nothing, E>()

    val value: Success?
        get() = when (this) {
            is UiState.Success -> this.data
                else -> null
        }

    val isLoading: Boolean
        get() = this is Loading

    val hasError: Boolean
        get() = this is UiState.Failure
}