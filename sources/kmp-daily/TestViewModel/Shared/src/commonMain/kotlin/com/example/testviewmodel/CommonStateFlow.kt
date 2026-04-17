package com.example.testviewmodel

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.FlowCollector
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

class CommonStateFlow<T>(
    private val underlyingStateFlow: StateFlow<T>
) : StateFlow<T> {
    override val replayCache: List<T>
        get() = underlyingStateFlow.replayCache


    override val value: T
        get() = underlyingStateFlow.value

    override suspend fun collect(collector: FlowCollector<T>): Nothing {
        underlyingStateFlow.collect(collector)
    }

    fun startCollect(onEach: (T) -> Unit, onCancel: () -> Unit): CommonCancallable {
        val scope = CoroutineScope(Dispatchers.Main)
        val job = scope.launch {
            try {
                collect(collector = { onEach(it) })
            } catch (e: Exception) {
                onCancel()
                println("on cancel job" + e)
                throw e
            }
        }
        return CommonCancallable { job.cancel() }
    }

}

fun <T: Any>StateFlow<T>.common(): CommonStateFlow<T> = CommonStateFlow(this)

class CommonCancallable(val onCancel: () -> Unit) {
    fun cancel() {
        onCancel()
    }
}