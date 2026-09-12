package com.shusuke.qiitareader.shared

import androidx.lifecycle.ViewModel
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.flow.update

interface MVIState
interface MVIAction
interface MVISideEffect

interface MVI<State: MVIState, Action: MVIAction, SideEffect: MVISideEffect> {
    val state: StateFlow<State>
    val currentState: State
    suspend fun update(block: suspend  (State) -> State)

    val sideEffect: Flow<SideEffect>
    suspend fun sideEffect(effect: SideEffect)

    fun onAction(action: Action)
}

abstract class MVIContractDelegate<State: MVIState, Action: MVIAction, SideEffect: MVISideEffect>(
    initialState: State
) : MVI<State, Action, SideEffect>, ViewModel() {
    // 画面の状態
    private val _state = MutableStateFlow(initialState)
    override val state: StateFlow<State> = _state.asStateFlow()
    override val currentState: State
        get() = _state.value
    override suspend fun update(block: suspend (State) -> State) {
        _state.update { block(it) }
    }

    // 画面遷移、ダイアログ表示などワンショットで終わるイベントを通知
    private val _sideEffect by lazy { Channel<SideEffect>() }
    override val sideEffect: Flow<SideEffect> by lazy { _sideEffect.receiveAsFlow() }
    override suspend fun sideEffect(effect: SideEffect) {
        coroutineScope { _sideEffect.send(effect) }
    }

    // ユーザーからのアクション操作
    override fun onAction(action: Action) {}
}
