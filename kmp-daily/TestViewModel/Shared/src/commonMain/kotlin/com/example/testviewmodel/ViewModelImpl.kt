package com.example.testviewmodel

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

internal class ViewModelImpl(
    private val coroutineScope: CoroutineScope
): ViewModel {
    private val _state = MutableStateFlow(
        ViewState(false)
    )
    override val state = _state.common()

    override fun onButtonRClicked() {
        _state.update { it.copy(buttonIsLoading = true) }
        coroutineScope.launch {
            callToServer()
            _state.update { it.copy(buttonIsLoading = false) }
        }
    }

    private suspend fun callToServer() {
        // simulate a 3s sever call
        delay(3000)
    }

}