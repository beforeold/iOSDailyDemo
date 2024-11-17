package com.example.testviewmodel

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.cancel

class IOSHelper {
    fun createCoroutineScope() = CoroutineScope(Dispatchers.Default)

    fun cancelCoroutineScope(scope: CoroutineScope) {
        scope.cancel()
    }

    fun provdeViewModel(scope: CoroutineScope): ViewModel = ViewModelImpl(scope)
}