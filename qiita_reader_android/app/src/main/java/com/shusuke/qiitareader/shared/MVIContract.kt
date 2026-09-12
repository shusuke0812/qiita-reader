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
    val sideEffect: Flow<SideEffect>

    fun onAction(action: Action)
    suspend fun update(block: suspend  (State) -> State)
    suspend fun sideEffect(effect: SideEffect)
}

abstract class MVIContractDelegate<State: MVIState, Action: MVIAction, SideEffect: MVISideEffect>(
    initialState: State
) : MVI<State, Action, SideEffect>, ViewModel() {
    private val _state = MutableStateFlow(initialState)
    override val state: StateFlow<State> = _state.asStateFlow()
    override val currentState: State
        get() = _state.value

    private val _sideEffect by lazy { Channel<SideEffect>() }
    override val sideEffect: Flow<SideEffect> by lazy { _sideEffect.receiveAsFlow() }

    override fun onAction(action: Action) {}
    override suspend fun sideEffect(effect: SideEffect) {
        coroutineScope { _sideEffect.send(effect) }
    }
    override suspend fun update(block: suspend (State) -> State) {
        _state.update { block(it) }
    }
}
